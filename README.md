# AWS Modules

This directory contains reusable Terraform modules for AWS infrastructure provisioning.

The goal is to keep infrastructure logic modular and reusable so a parent repository such as an app repo or an IaC repo can call these modules to provision resources consistently.

## Structure

- `vpc/` - VPC, public subnets, and route tables
- `security-group/` - Security group definitions
- `ec2/` - EC2 instance resources
- `examples/` - Example usage patterns

## Example usage from another repo

```hcl
module "vpc" {
  source = "git::https://github.com/olajidenurudeenrasaq-dotcom/AWS-Modules.git//vpc?ref=main"

  name                    = "app-vpc"
  vpc_cidr                = "10.0.0.0/16"
  public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets         = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones      = ["us-east-1a", "us-east-1b"]
  private_availability_zones = ["us-east-1a", "us-east-1b"]
  tags                    = { Environment = "dev" }
}

module "web_security_group" {
  source = "git::https://github.com/olajidenurudeenrasaq-dotcom/AWS-Modules.git//security-group?ref=main"

  name        = "web-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
  ]
}

module "app_instance" {
  source = "git::https://github.com/olajidenurudeenrasaq-dotcom/AWS-Modules.git//ec2?ref=main"

  name                       = "app-server"
  instance_type              = "t3.micro"
  subnet_id                  = module.vpc.public_subnet_ids[0]
  security_group_ids         = [module.web_security_group.security_group_id]
  associate_public_ip_address = true
  tags                       = { Environment = "dev", Project = "app" }
}
```

## Notes

- The modules are now referenced from the GitHub `main` branch.
- Use `?ref=main` for the branch version, or replace it with a tag/commit SHA for fixed releases.
- The VPC module supports both public and private subnets, including optional private NAT routing.
- Keep modules small, single-purpose, and reusable.
