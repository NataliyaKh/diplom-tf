terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.156.0"
    }
  }

  backend "s3" {
    bucket     = "tf-state-nkh-d"
    region     = "ru-central1"
    endpoints  = {
      s3 = "https://storage.yandexcloud.net"
    }
    key                         = "infrastructure.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    use_path_style              = true
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key_path
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

# VPC Network
resource "yandex_vpc_network" "main" {
  name = "diplom-vpc"
}

# Subnets
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.20.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.30.0.0/24"]
}

# Internet Gateway
resource "yandex_vpc_gateway" "internet" {
  name = "internet-gateway"
  shared_egress_gateway {}
}

# Route Table (default route to Internet)
resource "yandex_vpc_route_table" "rt" {
  name       = "main-rt"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.internet.id
  }
}

# Security Group
resource "yandex_vpc_security_group" "k8s" {
  name       = "k8s-cluster-sg"
  network_id = yandex_vpc_network.main.id

  # SSH
  ingress {
    protocol       = "TCP"
    description    = "Allow SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal traffic
  ingress {
    protocol       = "ANY"
    description    = "Allow internal node-to-node traffic"
    v4_cidr_blocks = ["10.10.0.0/16"]
  }

  # Kubernetes API Server
  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API Server"
    port           = 6443
    v4_cidr_blocks = ["10.10.0.0/16"]
  }

  # Egress
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

provider "vault" {
  address         = "https://127.0.0.1:8200"
  skip_tls_verify = true
}
