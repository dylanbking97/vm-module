

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

  tags = ["allow-ssh", "lb-backend"]

  #metadata_startup_script = "sudo apt-get update; sudo apt-get install apache2 -y; sudo service start apache;"
  metadata_startup_script = <<EOT
  apt-get update; 
  apt-get install apache2 -y; 
  a2ensite default-ssl; 
  a2enmod ssl; 
  vm_hostname="$(curl -H "Metadata-Flavor:Google" http://169.254.169.254/computeMetadata/v1/instance/name)";
  echo "Page served from: $vm_hostname" | tee /var/www/html/index.html ;
  systemctl restart apache2;
  EOT
}


resource "google_compute_instance_group_manager" "my_mig" {
  provider = google-beta
  project = var.project_id
  name    = "my-mig"

  base_instance_name = "apache"
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.my_template.id
  }

  target_size = 3

  named_port {
    name = "http"
    port = 80
  }
}