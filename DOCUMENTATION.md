# Project Documentation: Automated GCP Server Provisioning with Terraform

### 1. Project Overview

This project utilizes Terraform to implement the principles of Infrastructure as Code (**IaC**). Its primary goal is to *automatically* provision and configure a Debian virtual machine (**VM**) on Google Cloud Platform (**GCP**).

The process is *fully automated*, from the creation of the server and its network configuration to the installation of necessary software like Docker via a startup script. This ensures a consistent, repeatable, and version-controlled infrastructure setup, which is a foundational practice in modern Systems Engineering and DevOps.

## 2. Architecture and Components

The architecture is composed of three main parts, all managed within this Terraform project:

## 2.1. Cloud Provider: Google Cloud Platform (GCP)

**Service**: Compute Engine

**Instance Type**: e2-micro (part of GCP's "Always Free" tier in specific regions)

**Operating System**: Debian 11 "Bullseye"

**Networking**: A default VPC network is used, and the VM is configured with a temporary public IP address for external access.

## 2.2. Infrastructure as Code: Terraform

**Provider**: 

    hashicorp/google is used to interact with the GCP API.

**Resources**:

    google_compute_instance: The core resource that defines the virtual machine, its machine type, boot disk, and network interface.

**Authentication**: 

    Terraform authenticates with GCP using a Service Account JSON key, which must be provided via an environment variable for security.

## 2.3. Automated Configuration: Startup Script
**File**: 

    startup_script.sh

**Function**: 
    
    This Bash script is passed to the VM's metadata. GCP automatically executes it as the root user on the machine's first boot.

**Tasks Performed**:

        Updates the system's package list (apt-get update).

        Installs necessary dependencies (curl, ca-certificates, etc.).

        Adds the official Docker GPG key and repository.

        Installs Docker Engine, Docker CLI, and Docker Compose.

## 3. The Terraform Workflow

This project follows the standard, declarative Terraform workflow, which consists of three main commands:

## terraform init
**Purpose**: Initializes the working directory.

**Actions**:

        Downloads and installs the required provider plugins (in this case, the Google Cloud provider).

        Sets up the backend for storing the state file.

        Creates a .terraform.lock.hcl file to lock provider versions for consistent runs.

## terraform plan

**Purpose**: Creates an execution plan.

**Actions**:

        Reads the current state of the managed infrastructure.

        Compares the current state with the desired state defined in the .tf configuration files.

        Shows a preview of the changes Terraform will make (create, update, or destroy) without actually performing them. This is a critical step for validation and safety.

### terraform apply

**Purpose**: Executes the plan and builds the infrastructure.

**Actions**:

        Prompts the user for confirmation.

        Makes the necessary API calls to the cloud provider to create, update, or delete resources to match the desired state.

### terraform destroy

**Purpose**: Tears down all managed infrastructure.

**Actions**:

        Scans the state file for all resources created by this configuration.

        Deletes all of those resources from the cloud provider. This is a crucial command for managing costs and cleaning up environments.

## 4. Security Considerations

**Authentication**: The GCP Service Account key (.json file) is highly sensitive. It is never committed to the Git repository and is explicitly listed in the .gitignore file. Authentication is handled securely by exporting its path to the GOOGLE_APPLICATION_CREDENTIALS environment variable, which is only available for the current terminal session.

**SSH Access**: Password-based authentication is disabled by default on GCP VMs for security. Access is granted only via SSH keys. The user's public SSH key is automatically added to the server's authorized_keys file during creation, ensuring secure and passwordless access.