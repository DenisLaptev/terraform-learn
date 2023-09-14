#-------------------------------PROVIDER-------------------------------
#see MySecretsLocal.txt for access_key and secret_key
provider "aws" {
  region     = "eu-west-3"
  access_key = ""
  secret_key = ""
}

# provider "linode" {
#   # token = "..."
# }



#-------------------------------VARIABLE-------------------------------
# default name for variables file = terraform.tfvars
# otherwise -> terraform apply -var-file terraform-dev.tfvars

variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default     = "10.0.10.0/24" # default makes variable optional
  type        = string         # type constraint
}

variable "cidr_blocks" {
  description = "cidr blocks for vpc and subnets"
  type        = list(string) # type constraint
}

variable "cidr_objects" {
  description = "list of cidr objects"
  # type constraint and validation
  type = list(object({
    cidr_block = string
    name       = string
  }))
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

# provider gives us Resources and Data Sources - (resource and data)

# resource - lets us create new aws resources and conponents. name must be UNIQUE


#-------------------------------RESOURCE-------------------------------
resource "aws_vpc" "development-vpc" {
  #   cidr_block = "10.0.0.0/16" # range of ip addresses
  cidr_block = var.vpc_cidr_block
  tags = {
    Name    = "dev-vpc"
    vpc_env = "dev"
  }
}

resource "aws_subnet" "delevopment-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  #   cidr_block = "10.0.10.0/24"
  cidr_block        = var.subnet_cidr_block
  availability_zone = "eu-west-3a"
  tags = {
    Name = "dev-subnet-1"
  }
}

resource "aws_subnet" "delevopment-subnet-2" {
  vpc_id = aws_vpc.development-vpc.id
  #   cidr_block = "10.0.10.0/24"
  cidr_block        = var.cidr_blocks[2]
  availability_zone = "eu-west-3a"
  tags = {
    Name = "dev-subnet-2"
    Cidr1 = var.cidr_objects[0].cidr_block
    Cidr1Name = var.cidr_objects[0].name
  }
}

#-------------------------------DATA-------------------------------

# data - lets us query the existing aws resources and conponents 

# the result of query is exported under your given name
data "aws_vpc" "existing_vpc" {
  # arguments = filter for query
  default = true # we want to get default vpc
}

resource "aws_subnet" "delevopment-subnet-3" {
  vpc_id            = data.aws_vpc.existing_vpc.id # to reference data, we use prefix data.
  cidr_block        = "172.31.48.0/20"
  availability_zone = "eu-west-3a"
  tags = {
    Name = "dev-subnet-3"
  }
}

#-------------------------------OUTPUT-------------------------------
# we want Terraform to return ids of resources that have been created
# analog of return for methods. 1 value for each output

# Outputs:

# dev-subnet-1-id = "subnet-0620d7f9e123af9ca"
# dev-vpc-id = "vpc-0762081e225ef3f38"

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "dev-subnet-1-id" {
  value = aws_subnet.delevopment-subnet-1.id
}
