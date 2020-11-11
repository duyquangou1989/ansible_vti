provider "google" {
    project = "vti-dl"
    region = "asia-southeast1"
}

resource "google_compute_address" "intelas" {
    name = "intelas"
    address_type = "INTERNAL"
    subnetwork = "pre-dl"
    address = "10.30.50.210"
}

resource "google_compute_address" "extelas" {
    name = "extelas"
    address_type = "EXTERNAL"
    address = ""
}

resource "google_compute_instance" "dlelas" {
    name = "predl-elastic-demo"
    machine_type = "custom-4-8192"
    zone = "asia-southeast1-b"
    allow_stopping_for_update = true
    service_account {
        scopes = ["cloud-platform"]
    }

     metadata = {
         ssh-keys = "ansible:${file("./jenkins.pub")}"
     }
    boot_disk {
        initialize_params {
            image = "centos-7-v20200403"
            type = "pd-ssd"
            size = "100"
        }
    }
    network_interface {
        network_ip = google_compute_address.intelas.address
        network = "pre-dl"
        subnetwork = "pre-dl"
        access_config {
            nat_ip = google_compute_address.extelas.address
        }
    }
}

#====
resource "google_compute_address" "intdlapp" {
    name = "intdlapp"
    address_type = "INTERNAL"
    subnetwork = "pre-dl"
    address = "10.30.50.211"
}

resource "google_compute_address" "extdlapp" {
    name = "extdlapp"
    address_type = "EXTERNAL"
    address = ""
}

resource "google_compute_instance" "dlapp" {
    name = "predl-app-demo"
    machine_type = "custom-8-16384"
    zone = "asia-southeast1-b"
    allow_stopping_for_update = true
    service_account {
        scopes = ["cloud-platform"]
    }

     metadata = {
        ssh-keys = "ansible:${file("./jenkins.pub")}"
     }
    boot_disk {
        initialize_params {
            image = "centos-7-v20200403"
            size = "300"
        }
    }
    network_interface {
        network_ip = google_compute_address.intdlapp.address
        network = "pre-dl"
        subnetwork = "pre-dl"
        access_config {
            nat_ip = google_compute_address.extdlapp.address
        }
    }
}

#==
resource "google_compute_address" "intdldb" {
    name = "intdldb"
    address_type = "INTERNAL"
    subnetwork = "pre-dl"
    address = "10.30.50.212"
}

resource "google_compute_address" "extdldb" {
    name = "extdldb"
    address_type = "EXTERNAL"
    address = ""
}

resource "google_compute_instance" "dldb" {
    name = "predl-db-demo"
    machine_type = "custom-8-32768"
    zone = "asia-southeast1-b"
    allow_stopping_for_update = true
    service_account {
        scopes = ["cloud-platform"]
    }

     metadata = {
    #     ssh-keys = "quang.tong:${file("~/.ssh/id_ed25519.pub")}"
        ssh-keys = "ansible:${file("./jenkins.pub")}"
     }
    boot_disk {
        initialize_params {
            image = "centos-7-v20200403"
            type = "pd-ssd"
            size = "300"
        }
    }
    network_interface {
        network_ip = google_compute_address.intdldb.address
        network = "pre-dl"
        subnetwork = "pre-dl"
        access_config {
            nat_ip = google_compute_address.extdldb.address
        }
    }
}
