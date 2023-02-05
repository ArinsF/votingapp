resource "google_container_cluster" "primary" {
  name               = "arouna-cluster"
  location           = "us-east4-a"
  initial_node_count = 1

  #node_locations = [
  #  "us-east4-a",
  #]

  #node_config {
    
  #  guest_accelerator {
  #    type  = "nvidia-tesla-k80"
  #    count = 1
  #  }
  #}

  # Removes the default node pool
  remove_default_node_pool = true
  
  network = google_compute_network.vpc_arouna.id
  subnetwork = google_compute_subnetwork.subnet.id

}

resource "google_container_node_pool" "arouna_gke_node_pool" {
  name       = "arouna-gke-node-pool"
  cluster    = google_container_cluster.primary.name
  project    = "cloud-gke-arouna"
  location           = "us-east4-a"
  node_config {
    machine_type    = "e2-standard-2"
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_size_gb = 30

  }

  node_count = 2

}


