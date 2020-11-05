provider "google" {
    project = "vti-sandbox"
    region = "asia-southeast1"
}

resource "google_compute_address" "intaddr" {
    name = "intdemo"
    address_type = "INTERNAL"
    subnetwork = "postgres"
    address = "10.30.70.200"
}

resource "google_compute_address" "extaddr" {
    name = "extdemo"
    address_type = "EXTERNAL"
    address = ""
}

resource "google_compute_instance" "instancedemo" {
    name = "insdemo"
    machine_type = "f1-micro"
    zone = "asia-southeast1-b"

    metadata = {
        ssh-keys = "quang.tong:${file("~/.ssh/id_ed25519.pub")}"
    }
    boot_disk {
        initialize_params {
            image = "centos-7-v20200403"
            size = "50"
        }
    }
    network_interface {
        network_ip = google_compute_address.intaddr.address
        network = "dl-network-new"
        subnetwork = "postgres"
        access_config {
            nat_ip = google_compute_address.extaddr.address
        }
    }
}