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

# VPC and subnets
resource "yandex_vpc_network" "main" {
  name = "diplom-network"
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.2.0/24"]
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
}

