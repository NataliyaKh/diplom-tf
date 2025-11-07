# Security Group
resource "yandex_vpc_security_group" "kubespray_sg" {
  name        = "kubespray-security-group"
  description = "Security group for Kubespray cluster"
  network_id  = yandex_vpc_network.main.id

ingress {
    protocol       = "TCP"
    port           = 22
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 6443
    description    = "Kubernetes API"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "TCP"
    port           = 8000
    description    = "Kubernetes API"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "TCP"
    port           = 8080
    description    = "Kubernetes API"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "TCP"
    port           = 8443
    description    = "Kubernetes API"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  

  ingress {
    protocol       = "TCP"
    from_port      = 30000
    to_port        = 32767
    description    = "NodePort services"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "Internal cluster communication"
    v4_cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
