output "bosh_name" {
  value = "${var.bosh_director_name}"
}

output "bosh_eip" {
  value = "${aws_eip.bosh_eip.public_ip}"
}

output "base_cidr" {
  value = "${aws_subnet.bosh-lite-public-subnet.cidr_block}"
}

output "base_subnet" {
  value = "${aws_subnet.bosh-lite-public-subnet.id}"
}

output "gw_ip" {
  value = "${cidrhost(aws_subnet.bosh-lite-public-subnet.cidr_block, 1)}"
}

output "bosh_ip" {
  value = "${cidrhost(aws_subnet.bosh-lite-public-subnet.cidr_block, 6)}"
}

output "region" {
  value = "${var.myregion}"
}

output "az" {
  value = "${var.myregion}a"
}

output "ec2_keyname" {
  value = "${aws_key_pair.boshec2key.key_name}"
}

output "ec2_secgroup" {
  value = "${aws_security_group.bosh.name}"
}