terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "3.5.0"
        
    }
  }
}

provider "google" {
credentials = file("cloud-gke-arouna-ee710200dc9b.json")

project = "cloud-gke-arouna"
#region  = "us-east4"
zone    = "us-east4-a"
}

resource "google_compute_network" "vpc_arouna" {
    name = "arouna-gke-vpc"
    auto_create_subnetworks = false
    project = "cloud-gke-arouna"

}

resource "google_compute_subnetwork" "subnet" {
    name = "arouna-gke-subnetwork"
    ip_cidr_range ="10.10.0.0/24"
    region = "us-east4"
    network = google_compute_network.vpc_arouna.id
}