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
   cd repo-directory```


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
    ```bash
    source $HOME/.profile
    ```

## Usage

After installation, you can use the commands to manage your infrastructure:

- **Initialize Modules**
  ```bash
  mg init
   ```

- **Destroy Resources**
  ```bash
  mg destroy [module_name|all]
   ```

- **List Environments**
  ```bash
  mg list_envs
   ```

- **Destroy Specific Environment**
  ```bash
   mg destroy_env [eu|us]
   ```  

- **Help**
  ```bash
   mg help
   ```


## Contributing

Contributions to this project are welcome! Please submit pull requests or issues to improve the infrastructure code or documentation.


