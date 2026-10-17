resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.public[*].id

  tags = merge(var.tags, {
    Name = "${var.name}-public-nacl"
  })

  dynamic "ingress" {
    for_each = var.public_nacl_ingress_rules
    content {
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      protocol   = ingress.value.protocol
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
      cidr_block = ingress.value.cidr_block
    }
  }

  dynamic "egress" {
    for_each = var.public_nacl_egress_rules
    content {
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      protocol   = egress.value.protocol
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
      cidr_block = egress.value.cidr_block
    }
  }
}

resource "aws_network_acl" "private" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private[*].id

  tags = merge(var.tags, {
    Name = "${var.name}-private-nacl"
  })

  dynamic "ingress" {
    for_each = var.private_nacl_ingress_rules
    content {
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      protocol   = ingress.value.protocol
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
      cidr_block = ingress.value.cidr_block
    }
  }

  dynamic "egress" {
    for_each = var.private_nacl_egress_rules
    content {
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      protocol   = egress.value.protocol
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
      cidr_block = egress.value.cidr_block
    }
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${count.index + 1}"
  })
}

resource "aws_eip" "nat" {
  count = length(var.private_subnets) > 0 ? 1 : 0
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-nat-gateway"
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = length(var.private_availability_zones) > 0 ? var.private_availability_zones[count.index] : var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-private-${count.index + 1}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt"
  })
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-private-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}
