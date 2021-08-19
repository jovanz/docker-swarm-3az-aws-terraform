##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.aws_region
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.namespace}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.namespace}-internet_gateway"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.namespace}-route_table"
  }
}

resource "aws_subnet" "main" {
  count             = 3
  cidr_block        = "10.0.${count.index + 1}.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.namespace}-subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "main" {
  count          = 3
  route_table_id = aws_route_table.main.id
  subnet_id      = element(aws_subnet.main.*.id, count.index)
}

# Security Group
resource "aws_security_group" "default" {
  name   = "sgswarmcluster"
  vpc_id = aws_vpc.main.id

  # Allow all inbound
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all inbound
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Enable ICMP
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances
resource "aws_key_pair" "default" {
  key_name   = "clusterkp"
  public_key = file("${var.key_path}")
}

resource "aws_instance" "manager1" {
  ami                    = var.ami
  instance_type          = var.manager_instance_type
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.main.0.id
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    Name = "manager 1"
  }
}

resource "aws_instance" "manager2" {
  ami                    = var.ami
  instance_type          = var.manager_instance_type
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.main.1.id
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    Name = "manager 2"
  }
}

resource "aws_instance" "manager3" {
  ami                    = var.ami
  instance_type          = var.manager_instance_type
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.main.2.id
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    Name = "manager 3"
  }
}

resource "aws_instance" "worker1" {
  ami                    = var.ami
  instance_type          = var.worker_instance_type
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.main.0.id
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    Name = "worker 1"
  }
}

resource "aws_instance" "worker2" {
  ami                    = var.ami
  instance_type          = var.worker_instance_type
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.main.1.id
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    Name = "worker 2"
  }
}

resource "aws_instance" "worker3" {
  ami                    = var.ami
  instance_type          = var.worker_instance_type
  key_name               = aws_key_pair.default.id
  subnet_id              = aws_subnet.main.2.id
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags = {
    Name = "worker 3"
  }
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      manager1-dns     = aws_instance.manager1.public_dns,
      manager1-ip      = aws_instance.manager1.public_ip,
      manager1-priv-ip = aws_instance.manager1.private_ip,
      manager1-id      = aws_instance.manager1.id,
      manager2-dns     = aws_instance.manager2.public_dns,
      manager2-ip      = aws_instance.manager2.public_ip,
      manager2-priv-ip = aws_instance.manager2.private_ip,
      manager2-id      = aws_instance.manager2.id,
      manager3-dns     = aws_instance.manager3.public_dns,
      manager3-ip      = aws_instance.manager3.public_ip,
      manager3-priv-ip = aws_instance.manager3.private_ip,
      manager3-id      = aws_instance.manager3.id,
      worker1-dns      = aws_instance.worker1.public_dns,
      worker1-ip       = aws_instance.worker1.public_ip,
      worker1-priv-ip  = aws_instance.worker1.private_ip,
      worker1-id       = aws_instance.worker1.id,
      worker2-dns      = aws_instance.worker2.public_dns,
      worker2-ip       = aws_instance.worker2.public_ip,
      worker2-priv-ip  = aws_instance.worker2.private_ip,
      worker2-id       = aws_instance.worker2.id
      worker3-dns      = aws_instance.worker3.public_dns,
      worker3-ip       = aws_instance.worker3.public_ip,
      worker3-priv-ip  = aws_instance.worker3.private_ip,
      worker3-id       = aws_instance.worker3.id
    }
  )
  filename = "inventory"
}
