
resource "libvirt_network" "k8s-net" {
  name = "k8s-network"
  mode = "nat"
  addresses = [ var.network_address ]
  dns {
    enabled = true
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each = var.nodes
  name = "commoninit-${each.key}.iso"
  user_data = templatefile("${path.module}/cloud_init.cfg", {
    hostname = each.key
    fqdn   = "${each.value.name}.${var.domain}"
  })
  network_config = templatefile("${path.module}/network_config.cfg", {
    interface = var.interface
    ip_addr   = each.value.ip_addr
  })
}

locals {
  dyski_mapa = {for node, values in var.nodes: node => [for nr in range(var.liczba_dyskow): "dysk-${node}-${nr}"]}
  dyski_nazwy = flatten(
    concat([], [
      for node in local.dyski_mapa: [
        for nazwa in node:
          nazwa
      ]
    ])
  )
}

resource "libvirt_volume" "dane" {
  for_each = toset(local.dyski_nazwy)
  pool     = "default"
  format = "qcow2"
  size   = 10737418240
  name   = "dane-${each.value}"
}

resource "libvirt_volume" "cloudimg" {
  for_each = var.nodes
  name     = "cloudimg-${each.key}"
  pool = "default"
  source = var.img_path
  format = "qcow2"
}

resource "libvirt_domain" "node" {
  for_each   = var.nodes
  name       = each.value.name
  memory     = each.value.memory
  vcpu       = each.value.vcpu
  qemu_agent = "true"

  network_interface {
    network_id = libvirt_network.k8s-net.id
    addresses    = [each.value.ip_addr]
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.cloudimg[each.key].id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[each.key].id

  dynamic "disk" {
    for_each = local.dyski_mapa[each.key]
    content {
      volume_id = libvirt_volume.dane[disk.value].id
    }
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
