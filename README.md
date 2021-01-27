# Managed Instance Group Module

### Inputs

project_id = The ID of the GCP project in which the resources belong

zone = The zone that the machines should be created in

subnet = VPC subnet that will contain the machines


#### Example

```
module "mig" {
  source     = "github.com/dylanbking97/vm-module"
  project_id = google_project.tf_practice.project_id
  zone       = "us-central1"
  subnet     = google_compute_subnetwork.my_subnet.name
}
```


### Resources Created

Instance Template: defines the VM type, OS, network interface, startup script (install & start Apache)

MIG: define the VM zone, # of machines

### Outputs

mig_id = reference to the MIG

