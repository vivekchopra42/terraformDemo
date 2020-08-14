provider "google" {
  project     = "concoursedemo"
  region      = "us-central1"
  credentials = file("../secrets/concoursedemo-f68287dbfc4c.json")
}


resource "google_compute_network" "vpc" {
  name                    = "dang-secure-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "dang-secure-vpc-public-subnet-1"
  ip_cidr_range = "10.10.1.0/24"
  network       = google_compute_network.vpc.name
  region        = "us-central1"
}

# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name    = "dang-secure-vpc-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}
# allow https traffic
resource "google_compute_firewall" "allow-https" {
  name    = "dang-secure-vpc-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}
# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "dang-secure-vpc-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}
# allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  name    = "dang-secure-vpc-fw-allow-rdp"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags = ["rdp"]
}


# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}
# Create VM #1
resource "google_compute_instance" "vm_instance_public" {
  name         = "dang-secure-vm-${random_id.instance_id.hex}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  hostname     = "dang-secure-vm-${random_id.instance_id.hex}.com"
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  metadata_startup_script = file("startup-script.sh")
  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name

    access_config {}
  }
}
