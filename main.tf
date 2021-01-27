

resource "google_compute_instance_template" "my_template" {
  project      = var.project_id
  name         = "mytemplate"
  machine_type = "e2-micro"

  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork         = var.subnet
    subnetwork_project = var.project_id
  }

  metadata_startup_script = "sudo apt-get update; sudo apt-get install apache2 -y; sudo service start apache;"

}


resource "google_compute_instance_group_manager" "my_mig" {
  project = var.project_id
  name    = "my-mig"

  base_instance_name = "apache"
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.my_template.id
  }

  target_size = 3
}

resource "google_service_account" "default" {
  account_id   = "service_account_id"
  display_name = "Service Account"
  project      = var.project_id
}