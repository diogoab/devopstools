provider "google" {
    project = "numeric-mote-205417"
    region  = "us-east1"
    zone    = "us-east1-b"
    version = "~> 1.19"
}

resource "google_compute_instance" "vm_instance" {
    name    = "node1"
    machine_type = "f1-micro"

    boot_disk {
        initialize_params {
            image = "ubuntu-minimal-1604-lts"
        }
    }

    network_interface {
        network       = "default"
        access_config = {

        }
    }
}

