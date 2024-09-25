import sys, boto3, ast
import hashlib, hmac
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql import SQLContext
from awsglue.context import GlueContext
from awsglue.job import Job
import pandas as pd
from awsglue import DynamicFrame
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'columns', 'opco_name', 'dbtable'])
sc = SparkContext()
glueContext = GlueContext(sc)
sqlContext = SQLContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)


# Get Secrets from secret manager
def get_secret(secret_name, region_name):
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=region_name)
    secret_value_response = client.get_secret_value(SecretId=secret_name)
    secret = eval(secret_value_response['SecretString'])  # Convert secret string to dictionary
    return secret

# sample code
