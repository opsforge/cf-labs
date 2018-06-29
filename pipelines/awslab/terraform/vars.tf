# Provider vars
variable "aws_access_key"            { default = "NOPE" }
variable "aws_secret_key"            { default = "NAY" }
variable "myregion"                  { default = "eu-west-1" }

# EC2 vars
variable "ec2_key_pair_name"         { default = "boshaccess" }
variable "ec2_key_pair_pub"          { default = "PUBLICKEYHERE" }

# VPC vars
variable "bosh_vpc_ip_pool"          { default = "172.10.0.0/16" }

variable "bosh_subnet_ip_pool"       { default = "172.10.1.0/24" }
variable "bosh_subnet_az"            { default = "eu-west-1a" }

variable "dhcp_opt_domain"           { default = "eu-west-1.compute.internal" }
variable "dhcp_opt_dnshosts"         { default = [ "AmazonProvidedDNS" ] }

variable "default_sg_name"           { default = "bosh" }
variable "my_publicip"               { default = "0.0.0.0/0" }
variable "bosh_director_name"        { default = "bosh-lite-director" }


