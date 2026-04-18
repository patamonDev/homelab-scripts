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
apt update && apt upgrade -y
echo "Packages are updated and upgraded. Installing Terraform."
terraform_install() {
    
}

printf "\nLinux Distro: $linux_distro\nPackage: $installer_var\n"