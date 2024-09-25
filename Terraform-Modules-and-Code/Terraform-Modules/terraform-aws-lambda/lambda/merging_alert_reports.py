import os
import json
import boto3
import csv
import tempfile
from botocore.exceptions import ClientError
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication

aws_access_key_id = os.getenv("aws_access_key_id")
aws_secret_access_key = os.getenv("aws_secret_access_key")

regions_list = ["ap-southeast-1", "us-west-2", "ap-northeast-1"]

TO_ADDRESSES = ['DXC-Infra-Operation@sony.com']
FROM_ADDRESS = ['DXC-Infra-Operation@sony.com']
SUBJECT = 'Instance Alerts Details Report'

def send_email(sender, recipients, subject, file_name):
    BODY_TEXT = "Hello,\r\nPlease find the attached file."
    BODY_HTML = f"""\
    <html>
    <head></head>
    <body>
    <p>Hi,</p>
    <p>Please find the attached Instance details report.</p>
    </body>
    </html>
    """
    CHARSET = "utf-8"
    client = boto3.client('ses')
    msg = MIMEMultipart('mixed')
    msg['Subject'] = subject
    msg['From'] = ', '.join(sender)
    msg['To'] = ', '.join(recipients)
    msg_body = MIMEMultipart('alternative')
    textpart = MIMEText(BODY_TEXT.encode(CHARSET), 'plain', CHARSET)
    htmlpart = MIMEText(BODY_HTML.encode(CHARSET), 'html', CHARSET)
    msg_body.attach(textpart)
    msg_body.attach(htmlpart)
    att = MIMEApplication(open(file_name, 'rb').read())
    att.add_header('Content-Disposition', 'attachment', filename=os.path.basename(file_name))
    msg.attach(msg_body)
    msg.attach(att)
    response = client.send_raw_email(
        Source=msg['From'],
        Destinations=recipients,
        RawMessage={
            'Data': msg.as_string(),
        }
    )
    return response

def lambda_handler(event, context):
    instance_details = {}
    for region in regions_list:
        ec2_client = boto3.client('ec2', region_name=region)
        cloudwatch = boto3.client('cloudwatch', region_name=region)

        paginator = ec2_client.get_paginator('describe_instances')
        for response in paginator.paginate():
            for reservation in response.get('Reservations', []):
                for instance in reservation.get('Instances', []):
                    instance_id = instance['InstanceId']
                    region_name = region
                    termination_protection_status = ec2_client.describe_instance_attribute(
                        InstanceId=instance_id, Attribute='disableApiTermination'
                    )['DisableApiTermination']['Value']
                    subnet_type = "N/A"
                    for interface in instance.get('NetworkInterfaces', []):
                        if interface.get('SubnetId'):
                            subnet_id = interface['SubnetId']
                            subnet_response = ec2_client.describe_subnets(SubnetIds=[subnet_id])
                            if subnet_response['Subnets']:
                                subnet = subnet_response['Subnets'][0]
                                subnet_type = "Public" if subnet['MapPublicIpOnLaunch'] else "Private"
                                break
                    namespace = "N/A"
                    # Fetch namespace details from CloudWatch
                    paginator = cloudwatch.get_paginator('list_metrics')
                    for response in paginator.paginate(Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}]):
                        for metric in response.get('Metrics', []):
                            if metric['Namespace']:
                                namespace = metric['Namespace']
                                break

                    instance_details[instance_id] = {
                        "Region Name": region_name,
                        "Termination Protection Status": "Enabled" if termination_protection_status else "Disabled",
                        "Subnet Type": subnet_type,
                        "Alarm Name": "N/A",  # Placeholder for now
                        "Metric Name": "N/A",  # Placeholder for now
                        "Namespace": namespace
                    }

        paginator = cloudwatch.get_paginator('describe_alarms')
        for response in paginator.paginate():
            for metric_alarm in response.get('MetricAlarms', []):
                for dimension in metric_alarm.get('Dimensions', []):
                    if dimension['Name'] == 'InstanceId' and dimension['Value'] in instance_details:
                        instance_id = dimension['Value']
                        instance_details[instance_id].update({
                            "Alarm Name": metric_alarm['AlarmName'],
                            "Metric Name": metric_alarm['MetricName']
                        })

    tempdir = tempfile.mkdtemp()
    csv_path = os.path.join(tempdir, 'instance_details_report.csv')
    header = ["Instance ID", "Region Name", "Termination Protection Status", "Subnet Type", "Alarm Name", "Metric Name", "Namespace"]
    with open(csv_path, 'w') as file:
        writer = csv.DictWriter(file, fieldnames=header)
        writer.writeheader()
        for instance_id, details in instance_details.items():
            details["Instance ID"] = instance_id
            writer.writerow(details)

    try:
        response = send_email(FROM_ADDRESS, TO_ADDRESSES, SUBJECT, csv_path)
    except ClientError as e:
        return {
            'statusCode': e.response['Error']['Code'],
            'body': json.dumps(e.response['Error']['Message'])
        }
    else:
        return {
            'statusCode': 200,
            'body': json.dumps(f"Email sent! Message ID: {response['MessageId']}")
        }