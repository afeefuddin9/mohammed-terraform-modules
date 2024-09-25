resource "aws_launch_template" "tfer--DXPFPlatformPortal-20210518080118621000000002" {
  default_version         = "1"
  description             = "Attaching AMI"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  iam_instance_profile {
    name = "DXPFPlatformPortal-ec2-instance-profile"
  }

  image_id      = "ami-0eaa7ee496cbe81f0"
  instance_type = "t2.micro"
  key_name      = "DXInfra"

  monitoring {
    enabled = "false"
  }

  name = "DXPFPlatformPortal-20210518080118621000000002"

  network_interfaces {
    associate_public_ip_address = "false"
    delete_on_termination       = "true"
    device_index                = "0"
    ipv4_address_count          = "0"
    ipv6_address_count          = "0"
    security_groups             = ["sg-0d2aebd6362d7d24f"]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Billing = "dxplatform"
      Name    = "DXPFPlatformPortal"
      Owner   = "dxplatform"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Billing = "dxplatform"
      Name    = "DXPFPlatformPortal"
      Owner   = "dxplatform"
    }
  }

  tags = {
    application = "dxplatform-portal"
  }

  user_data = "IyEgL2Jpbi9iYXNoDQoNCnN1ZG8gdGltZWRhdGVjdGwgc2V0LXRpbWV6b25lIEFzaWEvS29sa2F0YQ0KDQojIE1ha2Ugc3VyZSB3ZSBoYXZlIGFsbCB0aGUgbGF0ZXN0IHVwZGF0ZXMgd2hlbiB3ZSBsYXVuY2ggdGhpcyBpbnN0YW5jZQ0Kc3VkbyB5dW0gdXBkYXRlIC15DQoNCnN1ZG8gY3VybCBodHRwczovL3MzLmFtYXpvbmF3cy5jb20vYXdzLWNsb3Vkd2F0Y2gvZG93bmxvYWRzL2xhdGVzdC9hd3Nsb2dzLWFnZW50LXNldHVwLnB5IC1PDQoNCnN1ZG8geXVtIGluc3RhbGwgLXkgYW1hem9uLWNsb3Vkd2F0Y2gtYWdlbnQNCg0KIyBVc2UgY2xvdWR3YXRjaCBjb25maWcgZnJvbSBTU00NCnN1ZG8gL29wdC9hd3MvYW1hem9uLWNsb3Vkd2F0Y2gtYWdlbnQvYmluL2FtYXpvbi1jbG91ZHdhdGNoLWFnZW50LWN0bCAtYSBmZXRjaC1jb25maWcgLW0gZWMyIC1jIHNzbTovY2xvdWR3YXRjaC1hZ2VudC9jd19hZ2VudF9jb25maWcgLXMNCmVjaG8gJ0RvbmUgaW5pdGlhbGl6YXRpb24nDQoNCmF3cyBzMyBjcCBzMzovL2R4cGYtaW5mcmEtb3BzL2VjMl91c2VyX2RhdGFfdGVzdC9jaXNfdXNlcmRhdGEuc2ggL2hvbWUvZWMyLXVzZXIvY2lzX3VzZXJkYXRhLnNoDQpjZCAvaG9tZS9lYzItdXNlci8NCnN1ZG8gY2htb2QgK3ggY2lzX3VzZXJkYXRhLnNoIA0Kc3VkbyB5dW0gaW5zdGFsbCBkb3MydW5peCAteQ0KZG9zMnVuaXggY2lzX3VzZXJkYXRhLnNoDQpzdWRvIHNoIGNpc191c2VyZGF0YS5zaA0KDQpleGVjID4gPih0ZWUgL3Zhci9sb2cvdXNlci1kYXRhLmxvZ3xsb2dnZXIgLXQgdXNlci1kYXRhIC1zIDI+L2Rldi9jb25zb2xlKSAyPiYxDQoNCg=="
}

resource "aws_launch_template" "tfer--DXPlatformPortal-Prod" {
  default_version         = "1"
  #description             = "OS-Remd" #Matchnig state
  description             = "10"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  iam_instance_profile {
    arn = "arn:aws:iam::768502287836:instance-profile/DXPFPlatformPortal-ec2-instance-profile"
  }

  #image_id      = "ami-0e972b01b8a96cc57" #Commenting new AMI ID
  image_id = "ami-0edcc2d262778be0f" #Matchnig with existing AMI ID
  instance_type = "t2.micro"
  key_name      = "DXInfra"
  name          = "DXPlatformPortal-Prod"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Billing = "dxplatform"
      Owner   = "dxplatform"
    }
  }

  tags = {
    Billing     = "dxplatform"
    Owner       = "dxplatform"
    Usage       = "arn:aws:ec2:ap-southeast-1:768502287836:launch-template/lt-0f18053009bb2df15"
    application = "dxplatform-portal"
  }

  user_data              = "IyEgL2Jpbi9iYXNoCgpzdWRvIHRpbWVkYXRlY3RsIHNldC10aW1lem9uZSBBc2lhL0tvbGthdGEKCiMgTWFrZSBzdXJlIHdlIGhhdmUgYWxsIHRoZSBsYXRlc3QgdXBkYXRlcyB3aGVuIHdlIGxhdW5jaCB0aGlzIGluc3RhbmNlCnN1ZG8geXVtIHVwZGF0ZSAteQoKeXVtIGluc3RhbGwgZ2l0IC15IAp5dW0gLXkgaW5zdGFsbCBydWJ5Cnl1bSAteSBpbnN0YWxsIHdnZXQKd2dldCBodHRwczovL2F3cy1jb2RlZGVwbG95LWFwLXNvdXRoLTEuczMuYXAtc291dGhlYXN0LTEuYW1hem9uYXdzLmNvbS9sYXRlc3QvaW5zdGFsbApjaG1vZCAreCAuL2luc3RhbGwKLi9pbnN0YWxsIGF1dG8KeXVtIGluc3RhbGwgLXkgcHl0aG9uLXBpcApwaXAzIGluc3RhbGwgYXdzY2xpCnl1bSBpbnN0YWxsIGphdmEgLXkKCnN1ZG8gY3VybCBodHRwczovL3MzLmFtYXpvbmF3cy5jb20vYXdzLWNsb3Vkd2F0Y2gvZG93bmxvYWRzL2xhdGVzdC9hd3Nsb2dzLWFnZW50LXNldHVwLnB5IC1PCgpzdWRvIHl1bSBpbnN0YWxsIC15IGFtYXpvbi1jbG91ZHdhdGNoLWFnZW50CgojIFVzZSBjbG91ZHdhdGNoIGNvbmZpZyBmcm9tIFNTTQpzdWRvIC9vcHQvYXdzL2FtYXpvbi1jbG91ZHdhdGNoLWFnZW50L2Jpbi9hbWF6b24tY2xvdWR3YXRjaC1hZ2VudC1jdGwgLWEgZmV0Y2gtY29uZmlnIC1tIGVjMiAtYyBzc206L2Nsb3Vkd2F0Y2gtYWdlbnQvY3dfYWdlbnRfY29uZmlnIC1zCmVjaG8gJ0RvbmUgaW5pdGlhbGl6YXRpb24nCgphd3MgczMgY3AgczM6Ly9keHBmLWluZnJhLW9wcy9lYzJfdXNlcl9kYXRhX3Rlc3QvY2lzX3VzZXJkYXRhLnNoIC9ob21lL2VjMi11c2VyL2Npc191c2VyZGF0YS5zaApjZCAvaG9tZS9lYzItdXNlci8Kc3VkbyBjaG1vZCAreCBjaXNfdXNlcmRhdGEuc2ggCnN1ZG8geXVtIGluc3RhbGwgZG9zMnVuaXggLXkKZG9zMnVuaXggY2lzX3VzZXJkYXRhLnNoCnN1ZG8gc2ggY2lzX3VzZXJkYXRhLnNoCgpleGVjID4gPih0ZWUgL3Zhci9sb2cvdXNlci1kYXRhLmxvZ3xsb2dnZXIgLXQgdXNlci1kYXRhIC1zIDI+L2Rldi9jb25zb2xlKSAyPiYx"
  vpc_security_group_ids = ["sg-0d2aebd6362d7d24f"]
}

resource "aws_launch_template" "tfer--DXPlatformPortal-Staging" {
  default_version         = "11"
  description             = "12"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  iam_instance_profile {
    arn = "arn:aws:iam::768502287836:instance-profile/DXPFPlatformPortal-ec2-instance-profile"
  }

  image_id      = "ami-083fa692c03b5b587"
  instance_type = "t2.micro"
  key_name      = "DXInfra"
  name          = "DXPlatformPortal-Staging"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Billing = "dxplatform"
      Owner   = "dxplatform"
    }
  }

  tags = {
    Billing     = "dxplatform"
    Owner       = "dxplatform"
    Usage       = "arn:aws:ec2:ap-southeast-1:768502287836:launch-template/lt-0e0d76f61423e908c"
    application = "dxplatform-portal"
  }

  user_data              = "IyEgL2Jpbi9iYXNoCgpzdWRvIHl1bS1jb25maWctbWFuYWdlciAtLWRpc2FibGUgYW16bjJleHRyYS1lcGVsCgpzdWRvIHl1bSB1cGRhdGUgLS1zZWN1cml0eQoKc3VkbyB5dW0tY29uZmlnLW1hbmFnZXIgLS1lbmFibGUgYW16bjJleHRyYS1lcGVsCgpzdWRvIHRpbWVkYXRlY3RsIHNldC10aW1lem9uZSBBc2lhL0tvbGthdGEKCiMgTWFrZSBzdXJlIHdlIGhhdmUgYWxsIHRoZSBsYXRlc3QgdXBkYXRlcyB3aGVuIHdlIGxhdW5jaCB0aGlzIGluc3RhbmNlCnN1ZG8geXVtIHVwZGF0ZSAteQoKeXVtIGluc3RhbGwgZ2l0IC15IAp5dW0gLXkgaW5zdGFsbCBydWJ5Cnl1bSAteSBpbnN0YWxsIHdnZXQKd2dldCBodHRwczovL2F3cy1jb2RlZGVwbG95LWFwLXNvdXRoLTEuczMuYXAtc291dGhlYXN0LTEuYW1hem9uYXdzLmNvbS9sYXRlc3QvaW5zdGFsbApjaG1vZCAreCAuL2luc3RhbGwKLi9pbnN0YWxsIGF1dG8KeXVtIGluc3RhbGwgLXkgcHl0aG9uLXBpcApwaXAzIGluc3RhbGwgYXdzY2xpCnl1bSBpbnN0YWxsIGphdmEgLXkKCnN1ZG8gY3VybCBodHRwczovL3MzLmFtYXpvbmF3cy5jb20vYXdzLWNsb3Vkd2F0Y2gvZG93bmxvYWRzL2xhdGVzdC9hd3Nsb2dzLWFnZW50LXNldHVwLnB5IC1PCgpzdWRvIHl1bSBpbnN0YWxsIC15IGFtYXpvbi1jbG91ZHdhdGNoLWFnZW50CgojIFVzZSBjbG91ZHdhdGNoIGNvbmZpZyBmcm9tIFNTTQpzdWRvIC9vcHQvYXdzL2FtYXpvbi1jbG91ZHdhdGNoLWFnZW50L2Jpbi9hbWF6b24tY2xvdWR3YXRjaC1hZ2VudC1jdGwgLWEgZmV0Y2gtY29uZmlnIC1tIGVjMiAtYyBzc206L2Nsb3Vkd2F0Y2gtYWdlbnQvY3dfYWdlbnRfY29uZmlnIC1zCmVjaG8gJ0RvbmUgaW5pdGlhbGl6YXRpb24nCgphd3MgczMgY3AgczM6Ly9keHBmLWluZnJhLW9wcy9lYzJfdXNlcl9kYXRhX3Rlc3QvY2lzX3VzZXJkYXRhLnNoIC9ob21lL2VjMi11c2VyL2Npc191c2VyZGF0YS5zaApjZCAvaG9tZS9lYzItdXNlci8Kc3VkbyBjaG1vZCAreCBjaXNfdXNlcmRhdGEuc2ggCnN1ZG8geXVtIGluc3RhbGwgZG9zMnVuaXggLXkKZG9zMnVuaXggY2lzX3VzZXJkYXRhLnNoCnN1ZG8gc2ggY2lzX3VzZXJkYXRhLnNoCgpleGVjID4gPih0ZWUgL3Zhci9sb2cvdXNlci1kYXRhLmxvZ3xsb2dnZXIgLXQgdXNlci1kYXRhIC1zIDI+L2Rldi9jb25zb2xlKSAyPiYx"
  vpc_security_group_ids = ["sg-0d2aebd6362d7d24f"]
}