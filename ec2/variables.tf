variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use. If empty, the latest Amazon Linux 2 AMI is used"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs attached to the instance"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "Optional EC2 user data script"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}
