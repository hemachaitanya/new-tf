resource "aws_security_group" "sg" {
  name        = var.security_group_info.name
  description = var.security_group_info.description
  vpc_id      = var.security_group_info.vpc_id
  tags = {
    Name = var.security_group_info.name
  }

}

# inbound rules
resource "aws_vpc_security_group_ingress_rule" "sg" {
  count             = length(var.security_group_info.inbound_rules)
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.security_group_info.inbound_rules[count.index].cidr
  from_port         = var.security_group_info.inbound_rules[count.index].port
  to_port           = var.security_group_info.inbound_rules[count.index].port
  ip_protocol       = var.security_group_info.inbound_rules[count.index].protocol
  description       = var.security_group_info.inbound_rules[count.index].description

  depends_on = [aws_security_group.sg]
}

resource "aws_vpc_security_group_egress_rule" "sg" {
  count             = length(var.security_group_info.outbound_rules)
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.security_group_info.outbound_rules[count.index].cidr
  description       = var.security_group_info.outbound_rules[count.index].description
  from_port         = var.security_group_info.outbound_rules[count.index].from_port
  to_port           = var.security_group_info.outbound_rules[count.index].to_port
  ip_protocol       = var.security_group_info.outbound_rules[count.index].protocol
  depends_on        = [aws_security_group.sg]

}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  count             = var.security_group_info.allow_all_egress ? 1 : 0
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  depends_on        = [aws_security_group.sg]
}