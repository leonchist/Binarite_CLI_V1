# Quark Infrastructure Automation

This repository contains the infrastructure as code (IaC) and configuration management setup for deploying and managing the Quark application, utilizing Terraform for infrastructure provisioning and Ansible for configuration management.

## Structure

- `terraform/`: Contains Terraform modules for provisioning AWS resources.
    - `environment/`: Specific environment module configurations (e.g., network, agents).
- `ansible/`: Contains Ansible playbooks and roles for configuring provisioned resources.
- `scripts/`: Startup and utility scripts.
- `setup.sh`: Installs CLI globally.
- `manager.sh`: A script to manage Terraform modules and run Ansible playbooks.
- `.env.template`: Template for environment variables needed by `manager.sh` (save as `.env`). 

## CLI name
You can set CLI command name by setting `COMMAND_NAME` variable in `.env` file.

## Setup

1. **Install Dependencies**: Ensure you have Terraform and Ansible installed on your system. This project was tested with Terraform v0.14.7 and Ansible 2.9.10, but newer versions should also be compatible.

2. **Configure Environment Variables**:
    - Copy `.env.template` to `.env`.
    - Fill in your AWS credentials and desired command name for the manager script in `.env`.

    ```bash
    cp .env.template .env
    # Edit .env with your preferred editor
    ```

3. **Install CLI**: Run the following command to initialize Terraform modules:

    ```bash
    chmod +x ./setup.sh 
    ./setup.sh
    ```

4. **Help**: Run the following command to check available commands:

    ```bash
    quark-cli help
    ```

5. **Terraform Initialization**: Run the following command to initialize Terraform modules:

    ```bash
    quark-cli init all
    ```

6. **Infrastructure Provisioning**: To provision all infrastructure components, run:

    ```bash
    quark-cli apply all
    ```

7. **Infrastructure Destruction**: To destroy all provisioned infrastructure, use:

    ```bash
    quark-cli destroy all
    ```

8. **Configuration Management**: After infrastructure provisioning, Ansible playbooks can be run to configure software on the provisioned resources:

    ```bash
    ansible-playbook -i inventory ansible/playbooks/setup-your-service.yml
    ```

## Key Files and Directories

- `manager.sh`: Main script for managing infrastructure lifecycle.
- `terraform/`: Directory containing Terraform configurations for provider resources.
- `ansible/`: Ansible playbooks and roles for software configuration.
- `.env`: Environment variable file storing AWS credentials and configuration for `manager.sh`.

## Contributing

Contributions to this project are welcome! Please submit pull requests or issues to improve the infrastructure code or documentation.


