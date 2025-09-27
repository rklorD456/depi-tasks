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
    network = google_compute_network.vpc_network.self_link
    access_config {} # needed for external IP
  }
}
