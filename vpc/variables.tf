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

variable "tags" {
  description = "Tags to apply to the VPC resources"
  type        = map(string)
  default     = {}
}
