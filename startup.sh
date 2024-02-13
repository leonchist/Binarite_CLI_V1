#!/bin/bash
set -e

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
DOCKER_IMAGE_URL=

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# 1. Setup the ulimit

echo 'fs.file-max = 65536' > /etc/sysctl.conf
sysctl -p
echo '* soft nproc 65535' > /etc/security/limits.conf
echo '* hard nproc 65535' >> /etc/security/limits.conf
echo '* soft nofile 65535' >> /etc/security/limits.conf
echo '* hard nofile 65535' >> /etc/security/limits.conf

# 2. Install docker ( https://docs.docker.com/engine/install/ubuntu/ )

# Add Docker's official GPG key:
apt-get -q update
apt-get -yq install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -q update
apt-get -yq install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

docker run hello-world

# 3. Setup AWS ECR

apt-get -yq install awscli amazon-ecr-credential-helper

mkdir -p ~/.docker/
cat > ~/.docker/config.json <<EOF
{
	"credsStore": "ecr-login"
}
EOF

AWS_CONFIG_FILE=~/.aws/config
AWS_CREDENTIAL_FILE=~/.aws/credentials
mkdir -p ~/.aws/
cat > $AWS_CONFIG_FILE <<EOF
[default]
region = us-east-2
output = json
EOF

cat > $AWS_CREDENTIAL_FILE <<EOF
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
EOF

chmod 600 $AWS_CONFIG_FILE
chmod 600 $AWS_CREDENTIAL_FILE

aws ecr get-login-password --region us-east-2

# 4. Run the container

docker pull $DOCKER_IMAGE_URL
