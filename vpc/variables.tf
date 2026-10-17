variable "name" {
  description = "Base name for all VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR ranges"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR ranges"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "Availability zones for public subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_availability_zones" {
  description = "Availability zones for private subnets"
  type        = list(string)
  default     = []
}

variable "public_nacl_ingress_rules" {
  description = "Ingress rules for the public NACL"
  type = list(object({
    rule_no    = number
    action     = string
    protocol   = string
    from_port  = number
    to_port    = number
    cidr_block = string
  }))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      protocol   = "tcp"
      from_port  = 22
      to_port    = 22
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 110
      action     = "allow"
      protocol   = "tcp"
      from_port  = 80
      to_port    = 80
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no    = 120
      action     = "allow"
      protocol   = "tcp"
      from_port  = 443
      to_port    = 443
      cidr_block = "0.0.0.0/0"
    }
  ]
}

variable "public_nacl_egress_rules" {
  description = "Egress rules for the public NACL"
  type = list(object({
    rule_no    = number
    action     = string
    protocol   = string
    from_port  = number
    to_port    = number
    cidr_block = string
  }))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      protocol   = "-1"
      from_port  = 0
      to_port    = 0
      cidr_block = "0.0.0.0/0"
    }
  ]
}

variable "private_nacl_ingress_rules" {
  description = "Ingress rules for the private NACL"
  type = list(object({
    rule_no    = number
    action     = string
    protocol   = string
    from_port  = number
    to_port    = number
    cidr_block = string
  }))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      protocol   = "tcp"
      from_port  = 443
      to_port    = 443
      cidr_block = "0.0.0.0/0"
    }
  ]
}

variable "private_nacl_egress_rules" {
  description = "Egress rules for the private NACL"
  type = list(object({
    rule_no    = number
    action     = string
    protocol   = string
    from_port  = number
    to_port    = number
    cidr_block = string
  }))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      protocol   = "-1"
      from_port  = 0
      to_port    = 0
      cidr_block = "0.0.0.0/0"
    }
  ]
}

variable "tags" {
  description = "Tags to apply to the VPC resources"
  type        = map(string)
  default     = {}
}
