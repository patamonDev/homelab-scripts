#!/bin/bash

# This script will install my most commonly used packages on any new VMs or containers I create
read -p "Linux Distro? Accepted values: Debian, Ubuntu, Fedora, RHEL: " linux_distro

if [[ ${linux_distro,,} == "rhel" || ${linux_distro,,} == "fedora" ]]; then
    installer_var="dnf"
elif [[ ${linux_distro,,} == "debian" || ${linux_distro,,} == "ubuntu" ]]; then
    installer_var="apt"
else
    echo "Non-accepted Linux distro input or no input was received. Exiting."
    exit 1
fi

echo "Updating packages and upgrading packages"
$installer_var update && $installer_var upgrade -y
echo "Packages are updated and upgraded. Installing Vim, Git, and Curl."
$installer_var install -y vim git curl
if [[ $? -eq "0" ]]; then
    echo "Successfully installed Vim, Git, and Curl. Installing Terraform and Ansible Navigator next."
else
    echo "Did not successfully install one of the programs. Moving on."
fi
terraform_install
ansible_navigator_install

# Run Docker installer script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh --dry-run
if command -v docker > /dev/null 2>&1; then
    echo "Docker was successfully installed. Ensuring docker group is created."
    if getent group "docker" > /dev/null 2>&1; then
        echo "Docker group is created. Adding docker group to $USER"
        usermod -aG docker $USER
        newgrp docker
    else
        echo "Docker group is not created. Creating group and adding group to $USER"
        groupadd docker
        echo "Docker group is created. Adding docker group to $USER"
        usermod -aG docker $USER
        newgrp docker
    fi
else
    echo "Docker was not successfully installed. Check logs."
fi

terraform_install() {
    if [[ $installer_var == "apt "]]; then
        $installer_var install -y gnupg software-properties-common

        # Install HashiCorp's GPG Key
        wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

        # Add HashiCorp repo into system
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | \ 
        sudo tee /etc/apt/sources.list.d/hashicorp.list

        # Update apt to download package from HashiCorp repo and install terraform
        apt update && apt install -y terraform
    else
        # Install Terraform for RHEL/Fedora/CentOS distros
        $installer_var -y dnf-plugins-core
        $installer_var config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
        $installer_var -y terraform
    fi
}

ansible_navigator_install(){
    # Installs pip and then pip installs Ansible Navigator
    $installer_var install -y python3-pip
    python3 -m pip install ansible-navigator
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.profile
    source ~/.profile
}


printf "\nLinux Distro: $linux_distro\nPackage: $installer_var\n"