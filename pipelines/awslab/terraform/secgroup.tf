resource "aws_security_group" "bosh" {
  name        = "${var.default_sg_name}"
  description = "BOSH Lite SG"
  vpc_id      = "${aws_vpc.bosh-lite-vpc.id}"
  
  ingress {
    cidr_blocks = ["${var.my_publicip}"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    self        = true
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}