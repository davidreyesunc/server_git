#_____________________________________________________________________________________________________________________________
# Updates
sudo apt update
sudo apt full-upgrade -y

#_____________________________________________________________________________________________________________________________
# Git y GitHub Cli
sudo apt install git gh

#_____________________________________________________________________________________________________________________________
# Utils
sudo apt install jq

#_____________________________________________________________________________________________________________________________
# Install Docker Engine
https://docs.docker.com/engine/install/ubuntu/
# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Install the latest version
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Verify that the installation is successful by running the hello-world image:
sudo docker run hello-world
# Agregar el usuario al grupo docker (para evitar usar sudo)
sudo usermod -aG docker $USER
# Refrescar grupo (reiniciar la sesión)
newgrp docker  
# Test the instalation (without sudo)
docker run hello-world

#_____________________________________________________________________________________________________________________________
# hostname
# Se establece explícitamente el hostname de servidor ya que se utiliza en la autenticación del servidor 
# por parte de las estaciones meteorológicas
sudo hostnamectl set-hostname Meteo-Data-Server