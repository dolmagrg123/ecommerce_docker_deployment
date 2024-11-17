#! /bin/bash

#i. install docker and docker-compose;

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Download the latest version of Docker Compose
echo "Downloading Docker Compose..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K[^"]*')
sudo curl -L "https://github.com/docker/compose/releases/download/${LATEST_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the binary
echo "Setting permissions..."
sudo chmod +x /usr/local/bin/docker-compose

# Verify the installation
echo "Verifying Docker Compose installation..."
docker-compose --version

# Set Docker Hub credentials
DOCKER_USERNAME= $docker_user
DOCKER_PASSWORD= $docker_pass

# ii. log into DockerHub;

# Log in to Docker Hub
echo "Logging in to Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Check login status
if [ $? -eq 0 ]; then
    echo "Login successful."
else
    echo "Login failed."
fi

# iii. create the docker-compose.yaml with the following code:

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating app directory..."
mkdir -p /app
cd /app
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Created and moved to /app"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating docker-compose.yml..."
cat > docker-compose.yml <<EOF
${docker_compose}
EOF
echo "[$(date '+%Y-%m-%d %H:%M:%S')] docker-compose.yml created"

#iv. run docker-compose pull

docker-compose pull

# v. run docker-compose up -d --force-recreate

docker-compose up -d --force-recreate

# vi. Clean the server by running a docker system prune and logging out of dockerhub.
docker system prune -af
docker logout




