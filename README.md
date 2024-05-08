# Quark Infrastructure Automation

This repository contains the infrastructure as code (IaC) and configuration management setup for deploying and managing the Quark application, utilizing Terraform for infrastructure provisioning and Ansible for configuration management.

## Overview

This CLI tool automates the management and deployment of infrastructure using Terraform. It simplifies tasks such as initializing, applying, destroying configurations, and managing environments.

## Directory Structure

├── setup.sh # Setup script to configure and install the CLI tool.  
├── app/  
│ ├── cli.sh # Main CLI script to handle commands.  
│ ├── terraform.sh # Script containing Terraform functions.  
│ └── setup/  
│ ├──── install.sh # Script to install the CLI tool system-wide.  
│ ├──── uninstall.sh # Script to uninstall the CLI tool.  
│ └── methods/ # Directory for individual command scripts.  
│ ├──── [method_name].sh # Individual file per each command  
└── .env # Environment variables file. Auto-created on setup if does not exist.


## Installation

To install the CLI tool, follow these steps:

0. **Install Dependencies**:

   Ensure you have [Terraform](https://developer.hashicorp.com/terraform/install) and [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed on your system. This project was tested with Terraform v0.14.7 and Ansible 2.9.10, but newer versions should also be compatible.


1. **Clone the Repository**
   ```bash
   git clone https://yourrepository.com/path/to/repo.git
   cd repo-directory
   ```


2. **Configure Environment Variables**:
    - Copy `.env.template` to `.env`.
    - Fill in your AWS credentials and desired command name for the manager script in `.env`.

    ```bash
    cp .env.template .env
    # Edit .env with your preferred editor
    ```

3. **Set Permissions and Initialize**: Before running the setup script, ensure it has the necessary execution permissions:

    ```bash
    chmod +x ./setup.sh
    ```

4. **Run Setup Script**: Execute the setup script which will configure permissions and install the CLI tool:

    ```bash
    ./setup.sh
    ```

5. **Source links**: Refresh links in current terminal session:

    ```bash
    source ~/.zshrc
    ```
   or
    ```bash
    source ~/.bash_profile
    ```

## Usage

After installation, you can use the commands to manage your infrastructure:

- **Create Command**: Initializes and provisions a new server.
  ```bash
  mg server create [OPTIONS]
   ```
  Options:
    - `project <project_name>`: **[REQUIRED]** Specify the project name for the server.
    - `size <instance_size>`: **[OPTIONAL]** Specify the size of the server instance (Default: 'medium').
    - `count <instance_count>`: **[OPTIONAL]** Specify the number of instances to create (Default: 1).
    - `cloud <cloud_provider>`: **[OPTIONAL]** Specify the cloud provider (e.g., 'aws', 'gcp', 'azure') (Default: 'gcp').
    - `repo <git_repository>`: **[OPTIONAL]** Specify the Git repository URL for configuration.
    - `branch <git_branch>`: **[OPTIONAL]** Specify the branch to use from the Git repository (Default: 'master').
    - `region <region>`: **[OPTIONAL]** Specify the region where the server will be created (Default depends on provider).
    - `label <local_label>`: **[OPTIONAL]** Specify the local label for the server (Default: automatically generated).


- **Destroy Command**: Terminates a server identified by its UUID or applied LABEL.
  ```bash
  mg server destroy -id <UUID>
   ```

- **Show Environment Details**: Displays information about a server identified by its UUID or applied LABEL.
  ```bash
  mg server show -id <UUID>
   ```

- **List Environments**: Lists all available servers.
  ```bash
  mg server list
   ```

- **Help**: Displays this help information.
  ```bash
   mg help
   ```

## Examples
- `mg servier create -project MyProject -size large -count 2 -cloud aws -repo https://github.com/myrepo -branch develop -region us-west-2`
- `mg servier destroy -id 123e4567-e89b-12d3-a456-426614174000`
- `mg servier show -id banan-center-1`

## Contributing

Contributions to this project are welcome! Please submit pull requests or issues to improve the infrastructure code or documentation.


