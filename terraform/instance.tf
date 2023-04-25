resource "vkcs_compute_instance" "webserver" {
  count             = 1
  name              = "nginx-web-01"
  flavor_name       = "Basic-1-1-10"
  key_pair          = "molecule"
  availability_zone = "GZ1"
  security_groups   = ["default","ssh","www"]
  config_drive      = true

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "high-iops"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    name = "ext-net"
  }
}

resource "vkcs_compute_instance" "db" {
  count             = 1
  name              = "mysql-01"
  flavor_name       = "Basic-1-1-10"
  key_pair          = "molecule"
  availability_zone = "GZ1"
  security_groups   = ["default","ssh"]
  config_drive      = true

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "high-iops"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    name = "ext-net"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      webserver_cfg = vkcs_compute_instance.webserver.*.network.0.fixed_ip_v4,
      db_cfg =  vkcs_compute_instance.db.*.network.0.fixed_ip_v4
    }
  )
  filename = "../ansible/inventory.ini"
}