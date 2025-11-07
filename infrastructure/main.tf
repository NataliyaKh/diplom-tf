terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.156.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
  }

  backend "s3" {
    bucket                      = "tf-state-nkh-d"
    key                         = "infrastructure/terraform.tfstate"
    region                      = "ru-central1"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key_path
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

data "terraform_remote_state" "sa_bucket" {
  backend = "local"
  config = {
    path = "/home/vboxuser/git/diplom/diplom-tf/sa_bucket/terraform.tfstate"
  }
}

# VPC
resource "yandex_vpc_network" "main" {
  name = "diplom-network"
}

# Service Accounts
resource "yandex_iam_service_account" "k8s_cluster_sa" {
  name      = "k8s-cluster-sa"
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "k8s_node_sa" {
  name      = "k8s-node-sa"
  folder_id = var.folder_id
}

resource "yandex_container_registry" "diplom_registry" {
  name = "diplom-registry"
}

#Security group
resource "yandex_vpc_security_group" "my_sg" {
  name       = "my-security-group"
  network_id = yandex_vpc_network.main.id

  # Allow SSH
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow SSH access"
  }

  # Allow ICMP (ping)
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow ping"
  }

  # Allow all intra-cluster traffic
  ingress {
    description = "Allow all intra-cluster traffic"
    protocol    = "ANY"
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  # Allow kube-apiserver
  ingress {
    description = "Allow kube-apiserver"
    protocol    = "TCP"
    port        = 6443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all egress (outbound)
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow all outbound"
  }
}

