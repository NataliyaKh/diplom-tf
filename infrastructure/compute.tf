# Compute Instances
resource "yandex_compute_instance" "master" {
  name        = "master"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd84r85b4etr9gmnukb5"   #centos-stream-8-v20231120
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    security_group_ids = [yandex_vpc_security_group.kubespray_sg.id]
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("/home/vboxuser/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: centos
          ssh-authorized-keys:
            - ${file("/home/vboxuser/.ssh/id_rsa.pub")}
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          groups: wheel
          shell: /bin/bash
      EOF
  }
}

resource "yandex_compute_instance" "worker1" {
  name        = "worker1"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd84r85b4etr9gmnukb5"   #centos-stream-8-v20231120           
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_b.id
    security_group_ids = [yandex_vpc_security_group.kubespray_sg.id]
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("/home/vboxuser/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: centos
          ssh-authorized-keys:
            - ${file("/home/vboxuser/.ssh/id_rsa.pub")}
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          groups: wheel
          shell: /bin/bash
      EOF
  }
}

resource "yandex_compute_instance" "worker2" {
  name        = "worker2"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd84r85b4etr9gmnukb5"   #centos-stream-8-v20231120           
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_d.id
    security_group_ids = [yandex_vpc_security_group.kubespray_sg.id]
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("/home/vboxuser/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: centos
          ssh-authorized-keys:
            - ${file("/home/vboxuser/.ssh/id_rsa.pub")}
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          groups: wheel
          shell: /bin/bash
      EOF
  }
}
