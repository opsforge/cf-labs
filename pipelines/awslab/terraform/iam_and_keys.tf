################ EC2 ################

# Key Pair Creation (primary)
resource "aws_key_pair" "boshec2key" {
  key_name   = "${var.ec2_key_pair_name}"
  public_key = "${var.ec2_key_pair_pub}"
}
