#!/bin/bash
#
# Bash script to install and configure Docker and Kubernetes (Microk8s) on Ubuntu
# Tested on Ubuntu 20.04.3 LTS
#

function fail() {
    echo "Error: " $@
    exit 100
}

function installDocker() {
    # From https://docs.docker.com/engine/install/ubuntu/

    # Display executed commands
    set -x

    # Update the apt package index and install packages to allow apt to use a repository over HTTPS:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg -y

    # Add Docker’s official GPG key:
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    #Set up the repository:
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    sudo docker run hello-world || 
    if [ $? -eq 0 ]; then
        echo "Docker was successfully installed!"
    else
        echo "ERROR! Failed to install Docker!"
        EXIT_CODE=1
    fi

    # Stop displaying executed commands
    set +x
}

function installMicroK8s() {
    # Display executed commands
    set -x
    sudo snap refresh

    # From https://microk8s.io/docs/getting-started
    sudo snap install microk8s --classic --channel=1.27
    if [ $? -eq 0 ]; then
        echo "MicroK8s installed successfully"
    else
        echo "Failed to install MicroK8s"
        EXIT_CODE=2
    fi
     

    sudo microk8s status --wait-ready

    sudo microk8s enable dns
    sudo microk8s enable metrics-server prometheus
    sudo microk8s enable dashboard
    sudo microk8s enable storage
    sudo microk8s enable registry
    echo '{ "insecure-registries" : ["localhost:32000"] }' > /etc/docker/daemon.json
    
    sudo microk8s status --wait-ready

    echo "Checking local registry"
    curl --retry 10 --retry-delay 1 --retry-max-time 20 --retry-connrefused http://localhost:32000/v2/_catalog
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR! Cannot access local image catalog"
        EXIT_CODE=3
    fi

    sudo systemctl restart docker
    
    # Stop displaying executed commands
    set +x
}

function checkSupportedOS() {
    echo "Checking if running on Ubuntu..."
    cat /etc/os-release | grep NAME=\"Ubuntu > /dev/null
    if ! [ $? -eq 0 ]; then
        fail "Unsupported OS. This script has only been validated on Ubuntu (Ubuntu 20.04.3)"
    else
        echo "Yes"
    fi
}

EXIT_CODE=0
checkSupportedOS
installDocker
installMicroK8s

exit "${EXIT_CODE}"