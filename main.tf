
# Main configuration block for Terraform
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.36.0"
    }
  }
}

#Configure the Google Cloud provider
# Make sure to set the GOOGLE_CREDENTIALS environment variable
# with the content of your service account JSON key file
# Terraform will use this to authenticate with GCP
provider "google" {
  # Insert your GCP project ID here
  # You can find it in the GCP Console
  project = "cybernetic-zoo-472210-q2"

  # You can choose any region, but for the free tier,
  # it's recommended to use one of the free tier regions
  region  = "us-central1"
}


# This is the "recipe" to create a virtual server (called VM Instance in GCP)
resource "google_compute_instance" "vm_instance" {
  name         = "my-first-terraform-vm"
  machine_type = "e2-micro" # Free tier eligible machine type
  zone         = "us-central1-a" # Random free tier eligible zone

  # Define the boot disk with a Debian image
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Configure the network interface with a public IP
  network_interface {
    network = "default"
    access_config {
      // If you leave this block empty, GCP will assign a public IP
    }
  }

  metadata_startup_script = file("startup_script.sh")

  # The file() function reads the content of the specified file
  metadata = {
    "ssh-keys" = "superuser:${file("~/.ssh/id_rsa.pub")}" # Modo più pulito per leggere la chiave
  }
}

output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
  