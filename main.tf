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
    machine_type = "custom-2-8192"
    zone = "asia-southeast1-b"
    allow_stopping_for_update = true
    service_account {
        scopes = ["cloud-platform"]
    }

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

#====
resource "google_compute_address" "intdlapp" {
    name = "intdlapp"
    address_type = "INTERNAL"
    subnetwork = "postgres"
    address = "10.30.70.210"
}

resource "google_compute_address" "extdlapp" {
    name = "extdlapp"
    address_type = "EXTERNAL"
    address = ""
}

resource "google_compute_instance" "dlapp" {
    name = "dl-app-demo"
    machine_type = "custom-8-16384"
    zone = "asia-southeast1-b"
    allow_stopping_for_update = true
    service_account {
        scopes = ["cloud-platform"]
    }

    metadata = {
        ssh-keys = "quang.tong:${file("~/.ssh/id_ed25519.pub")}"
    }
    boot_disk {
        initialize_params {
            image = "centos-7-v20200403"
            size = "300"
        }
    }
    network_interface {
        network_ip = google_compute_address.intdlapp.address
        network = "dl-network-new"
        subnetwork = "postgres"
        access_config {
            nat_ip = google_compute_address.extdlapp.address
        }
    }
}

#==
resource "google_compute_address" "intdldb" {
    name = "intdldb"
    address_type = "INTERNAL"
    subnetwork = "postgres"
    address = "10.30.70.211"
}

resource "google_compute_address" "extdldb" {
    name = "extdldb"
    address_type = "EXTERNAL"
    address = ""
}

resource "google_compute_instance" "dldb" {
    name = "dl-db-demo"
    machine_type = "custom-16-32768"
    zone = "asia-southeast1-b"
    allow_stopping_for_update = true
    service_account {
        scopes = ["cloud-platform"]
    }

    metadata = {
        ssh-keys = "quang.tong:${file("~/.ssh/id_ed25519.pub")}"
    }
    boot_disk {
        initialize_params {
            image = "centos-7-v20200403"
            type = "pd-ssd"
            size = "500"
        }
    }
    network_interface {
        network_ip = google_compute_address.intdldb.address
        network = "dl-network-new"
        subnetwork = "postgres"
        access_config {
            nat_ip = google_compute_address.extdldb.address
        }
    }
}