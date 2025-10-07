terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.99"
    }
  }

  backend "s3" {
    bucket     = "tf-state-nkh-d"   
    region     = "ru-central1"
    endpoints  = {
    s3 = "https://storage.yandexcloud.net"
    }
    key        = "infrastructure.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key_path
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

resource "yandex_vpc_network" "main" {
  name = "diplom-vpc"
}

resource "yandex_vpc_security_group" "ssh" {
  name       = "allow-ssh"
  network_id = yandex_vpc_network.main.id
}

resource "yandex_vpc_security_group_rule" "ssh_inbound" {
  security_group_binding = yandex_vpc_security_group.ssh.id
  direction              = "ingress"
  protocol               = "TCP"
  port                   = 22
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.20.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet-d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.30.0.0/24"]
}

provider "vault" {
  address         = "https://127.0.0.1:8200"
  skip_tls_verify = true
}
