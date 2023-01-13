resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id
  name   = "${var.dynamodb_table_name}_history_recorder"
}

resource "aws_security_group_rule" "sg-allow-egress" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg.id
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}