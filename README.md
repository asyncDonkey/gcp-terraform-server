# gcp-terraform-server

# GCP Server Provisioning with Terraform

This project uses Terraform to automatically provision and configure a virtual machine (VM) in Google Cloud Platform (GCP).

## Features

-   **Infrastructure as Code:** The entire server configuration is defined in code using Terraform.
-   **Automated Setup:** A startup script (`startup_script.sh`) is automatically executed on the first boot of the VM.
-   **Docker Pre-installed:** The startup script updates the server and installs Docker and Docker Compose, making it ready for containerized applications.
-   **Secure Access:** SSH access is configured using a public key provided in the configuration.

## Technology Stack

-   **Terraform:** For Infrastructure as Code.
-   **Google Cloud Platform (GCP):** As the cloud provider.
-   **Bash Scripting:** For the automated server configuration.

## How to Use

### Prerequisites

1.  [Terraform](https://developer.hashicorp.com/terraform/downloads) installed.
2.  A Google Cloud Platform account with an active project.
3.  The "Compute Engine API" enabled in your GCP project.
4.  A GCP Service Account JSON key file.

### Instructions

1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/asyncDonkey/gcp-terraform-server.git](https://github.com/asyncDonkey/gcp-terraform-server.git)
    cd gcp-terraform-server
    ```

2.  **Configure Authentication**
    Set the following environment variable to point to your GCP service account key:
    ```bash
    export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/gcp-key.json"
    ```

3.  **Customize the Configuration**
    Open `main.tf` and update the `project` variable with your GCP Project ID. You can also change the `zone` or `machine_type` if needed.

4.  **Deploy the Infrastructure**
    ```bash
    # Initialize Terraform (downloads the Google provider)
    terraform init

    # Preview the changes
    terraform plan

    # Apply the changes to create the server
    terraform apply
    ```

5.  **Access the Server**
    Once the apply is complete, get the server's IP address:
    ```bash
    terraform output -raw instance_ip
    ```
    And connect via SSH:
    ```bash
    ssh your-username@$(terraform output -raw instance_ip)
    ```

6.  **Destroy the Infrastructure**
    When you are finished, run the following command to delete all created resources and avoid costs:
    ```bash
    terraform destroy
    ```