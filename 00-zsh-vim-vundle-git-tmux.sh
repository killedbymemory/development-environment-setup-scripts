#!/bin/env bash
## Update packages then upgrade
echo "Update Ubuntu packages and followed by upgrading"
sudo apt update
sudo apt upgrade -y
sudo apt -y install curl software-properties-common


## SSH Public Key
echo "Setting up ~/.ssh and ~/.ssh/authorized_keys"
cd ~
mkdir .ssh
chmod 700 .ssh
## -s for silent
## -L for following redirect
## -o for output file
curl -sLo ~/.ssh/authorized_keys https://gist.githubusercontent.com/killedbymemory/26243a397d9b2366540502e967a9622c/raw/60ee88b559b7a1a8b078a7acbe0740543cd4202c/id_rsa.pub
chmod 600 ~/.ssh/authorized_keys 


## Figure out how to configure SSH daemon to enable login by public key
## See: https://www.thegeekstuff.com/2011/05/openssh-options
echo "Setting up some SSH daemon configurations"
echo "TODO: push custom sshd config"
sudo service ssh status
sudo service ssh reload


## Git
echo "Installing Git"
sudo apt -y install git

echo "Setting up Git configuration"
## -s for silent
## -L for following redirect
## -o for output file
curl -sLo ~/.gitconfig https://gist.githubusercontent.com/killedbymemory/753b50bd053808936fa18516e0b6f44f/raw/58887028007dd4f539abef8221dbdbf334332679/.gitconfig


## Neovim
echo "TODO: Installing Neovim"
sudo apt install ripgrep fd-find


echo "TODO: set Neovim configuration in ~/.config/nvim/"
## -s for silent
## -L for following redirect
## -o for output file
#curl -sLo ~/.config/nvim.vimrc https://gist.githubusercontent.com/killedbymemory/c1b8825c55c0551ed0f273400318a1ca/raw/2506a01be24cb5f0fbca5de62a180477609fbeba/.vimrc


## Docker
## See: https://docs.docker.com/install/linux/docker-ce/ubuntu/
## Remove existing Docker
echo "Setting up Docker"
echo "Remove existing Docker installation"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
	sudo apt-get remove $pkg;
done

## To ensure package installations done over https
echo "Ensure Docker installation done over https"
sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

## Add Docker's official GPG and then verify
echo "Add Docker's official GPG and verify"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

## Add Docker's stable repository to apt repo
echo "Add Docker's stable repo"
echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## Install Docker Community Edition (without specifying specific version)
echo "Installing (latest) Docker CE"
sudo apt update && \
sudo apt -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

## Allow non-root user to run Docker
## See: https://docs.docker.com/engine/install/linux-postinstall/
echo "Creating the docker group"
sudo groupadd docker

echo "Allow non-root current user to run Docker"
sudo usermod -aG docker $USER

## Test docker installation
echo "Test Docker installation"
sudo docker run --rm hello-world && echo "Docker successfully installed and tested"


## ZSH
echo "Installing ZSH"
sudo apt -y install zsh

## oh-my-zsh (should be installed last since it change shell to zsh and stop the bash script execution)
## See: https://github.com/robbyrussell/oh-my-zsh#basic-installation
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Remember to enable oh-my-zsh plugins in ~/.zshrc!"


## tmux
echo "Setting up tmux configuration ~/.tmux.conf"
## -s for silent
## -L for following redirect
## -o for output file
##curl -sLo ~/.tmux.conf https://gist.github.com/killedbymemory/6b474c113ab420985191222ce51f0265/raw/017423c0714b4886c6566face4cbb095e7b398b5/.tmux.conf
git clone --depth=1 git@github.com:gpakosz/.tmux.git ~/.config/tmux
cp ./tmux/tmux.conf.local ~/.config/tmux/tmux.conf.local

## Golang
## gvm to manage Golang installation and versioning
## See: https://github.com/moovweb/gvm#installing
echo "Installing gvm (Go installation version manager)"
curl -s -S -L -o- https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
echo "source $(echo $HOME)/.gvm/scripts/gvm" >> ~/.zshrc

## See: A note on compiling Go 1.15+
##      https://github.com/moovweb/gvm#a-note-on-compiling-go-15
#source $(echo $HOME)/.gvm/scripts/gvm
#gvm install go1.4 -B
#gvm use go1.4

echo "TODO: Installing direnv"
#curl -sfL https://direnv.net/install.sh | bash
#echo "eval \"$(direnv hook zsh)\"" >> ~/.zshrc


## Node.js (JavaScript and TypeScript)
## nvm manage Node.js installation and versioning
## See: https://github.com/nvm-sh/nvm#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash



