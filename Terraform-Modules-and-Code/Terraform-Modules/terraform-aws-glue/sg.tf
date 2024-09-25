# Security Group for Glue Job to Connect to Athena
resource "aws_security_group" "sg_for_glue_job" {
  name        = "${var.envPrefix}-sg-for-glue-job"
  description = "SecurityGroup for Glue job"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.envPrefix}-sg-for-glue-job"
  }
}
resource "aws_vpc_security_group_egress_rule" "self_referencing_rule_egress" {
  security_group_id            = aws_security_group.sg_for_glue_job.id
  referenced_security_group_id = aws_security_group.sg_for_glue_job.id
  ip_protocol                  = "tcp"
  from_port                    = "0"
  to_port                      = "65535"
  description                  = "Self Referencing Rule"
}

resource "aws_vpc_security_group_ingress_rule" "sg_for_glue_job_ingress" {
  security_group_id            = aws_security_group.sg_for_glue_job.id
  referenced_security_group_id = aws_security_group.sg_for_glue_job.id
  from_port                    = "0"
  ip_protocol                  = "tcp"
  to_port                      = "65535"
  description                  = "Self Referencing Rule"
}