terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project     = "gothic-sled-472317-e1"
  region      = "us-central1"
  credentials = file("~/terraform-key.json")
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name = "my-vpc"
  auto_create_subnetworks = false
 
}

# create a subnet 
resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_router" "router" {
  name    = "my-router"
  region  = "us-central1"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow SSH from anywhere (use cautiously)
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-vm"
  machine_type = "e2-micro" 
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.public_subnet.id

    # Assign an external IP
    access_config {}
  }

  metadata = {
    ssh-keys = "your-username:${file("~/.ssh/id_rsa.pub")}"
  }
}