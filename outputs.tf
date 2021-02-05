output "mig_id" {
  value = google_compute_instance_group_manager.my_mig.instance_group
}

output "mig_port" {
  value = "HTTP"
}