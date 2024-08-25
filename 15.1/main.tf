data "template_file" "cloud_init" {
  template = file("cloud_init_config.tpl")
  vars = {
    user    = var.user
  }
}

resource "yandex_vpc_network" "yc-vpc" {
  name = "yc_vpc_network"
}

resource "yandex_vpc_subnet" "yc-subnet-a" {
  name           = "public"
  description    = "public-net"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yandex_zone
  network_id     = yandex_vpc_network.yc-vpc.id
}

resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"
  zone = var.yandex_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size     = 20
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.yc-subnet-a.id
    nat        = true
    ip_address = "192.168.10.254"
  }
  metadata = {
    user-data = data.template_file.cloud_init.rendered
  }
}

resource "yandex_compute_instance" "test-vm-pub" {
  name = "test-vm-pub"
  zone = var.yandex_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = var.iso_id
      size     = 20
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.yc-subnet-a.id
    nat       = true
  }
  metadata = {
    ssh-keys   = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_subnet" "yc-subnet-b" {
  name           = "private"
  description    = "private-net"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.yandex_zone
  network_id     = yandex_vpc_network.yc-vpc.id
  route_table_id = yandex_vpc_route_table.yc-rt.id
}

resource "yandex_vpc_route_table" "yc-rt" {
  name       = "yc-rt"
  network_id = yandex_vpc_network.yc-vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

resource "yandex_compute_instance" "test-vm-priv" {
  name = "test-vm-priv"
  zone = var.yandex_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = var.iso_id
      size     = 20
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.yc-subnet-b.id
  }
  metadata = {
    ssh-keys  = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }
}