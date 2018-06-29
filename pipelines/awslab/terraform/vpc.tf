############### VPC #################



# VPC for the platform
resource "aws_vpc" "bosh-lite-vpc" {
  cidr_block           = "${var.bosh_vpc_ip_pool}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags {
    Name               = "bosh-lite-vpc"
  }
}

# Management subnet
resource "aws_subnet" "bosh-lite-public-subnet" {
  vpc_id               = "${aws_vpc.bosh-lite-vpc.id}"
  cidr_block           = "${var.bosh_subnet_ip_pool}"
  availability_zone    = "${var.bosh_subnet_az}"
  tags {
    Name = "bosh-lite-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "bosh-lite-igw" {
  vpc_id = "${aws_vpc.bosh-lite-vpc.id}"
  tags {
    Name = "bosh-lite-igw"
  }
}

# DHCP Options set
resource "aws_vpc_dhcp_options" "bosh-lite-dhcpopts" {
  domain_name          = "${var.dhcp_opt_domain}"
  domain_name_servers  = "${var.dhcp_opt_dnshosts}"
  tags {
    Name = "bosh-lite-dhcp"
  }
}
resource "aws_vpc_dhcp_options_association" "dhcp_assoc" {
  vpc_id          = "${aws_vpc.bosh-lite-vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.bosh-lite-dhcpopts.id}"
}

# Routes
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.bosh-lite-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.bosh-lite-igw.id}"
}

resource "aws_eip" "bosh_eip" {
  vpc      = true
}