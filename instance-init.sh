#
# Oracle Linux 9 (RHEL)

# Docker
sudo dnf install -y dnf-utils zip unzip
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce --nobest
sudo systemctl start docker
sudo systemctl enable docker

# From https://certbot.eff.org/instructions?ws=nginx&os=centosrhel8
# Certbot 1
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf upgrade

# Snap
sudo yum install snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# Certbot 2
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --nginx

#
# Ubuntu 22

sudo apt update
sudo apt install ripgrep lynx zsh # Utils

# zsh

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Nginx
# https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview
sudo apt install nginx unzip

# Check iptables rules with `sudo iptables -S`
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save

# Certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Node -- No, we're going to use Docker
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# nvm install 20.10.0
# npm install pm2 -g
# pm2 start --name familypics pigallery2-dist/src/backend/index.js
# pm2 startup # and then run the command it produces

# Docker
# Follow instructions here: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04

# Docker Compose
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-aarch64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
