resource "google_compute_address" "static_ip" {
  count = var.with_public_ip ? 1 : 0
  name  = "${var.basename}-${var.vm_name}-ip-${var.owner}"
}

resource "google_compute_instance" "gcp-vm-linux" {
  name         = "${var.basename}-${var.vm_name}-${var.owner}"
  machine_type = var.available_vm_size[var.vm_size]
  tags         = var.tags
  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }
  network_interface {
    subnetwork = var.subnet_link
    dynamic "access_config" {
      for_each = var.with_public_ip ? [1] : []
      content {
        nat_ip = google_compute_address.static_ip[0].address
      }
    }

  }
  labels = merge(var.env.tags, { name = "${var.vm_name}" })
  metadata = {
    ssh-keys = "${var.ssh_username}:${var.ssh_publickey}"
  }
  metadata_startup_script = var.startup_script
  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}
