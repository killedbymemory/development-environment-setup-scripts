## Update packages then upgrade
echo "Update Ubuntu packages and followed by upgrading"
sudo apt update
sudo apt upgrade -y
sudo apt -y install curl


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


## Vundle && Vim && Install plugins from CLI
## See: https://github.com/VundleVim/Vundle.vim
echo "Setting up Vundle"
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Setting up Vim configuration ~/.vimrc"
## -s for silent
## -L for following redirect
## -o for output file
curl -sLo ~/.vimrc https://gist.githubusercontent.com/killedbymemory/c1b8825c55c0551ed0f273400318a1ca/raw/2506a01be24cb5f0fbca5de62a180477609fbeba/.vimrc

# Install plugins from CLI.
# Unfortunately unavailable colorscheme prompt user response ;(
vim +PluginInstall +qall

## Docker
## See: https://docs.docker.com/install/linux/docker-ce/ubuntu/
## Remove existing Docker
echo "Setting up Docker"
echo "Remove existing Docker installation"
sudo apt -y remove docker docker-engine docker.io containerd runc

## To ensure package installations done over https
echo "Ensure Docker installation done over https"
sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

## Add Docker's official GPG and then verify
echo "Add Docker's official GPG and verify"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

## Add Docker's stable repository to apt repo
echo "Add Docker's stable repo"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

## Install Docker Community Edition (without specifying specific version)
echo "Installing (latest) Docker CE"
sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io

## Allow non-root user to run Docker
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
curl -sLo ~/.tmux.conf https://gist.github.com/killedbymemory/6b474c113ab420985191222ce51f0265/raw/017423c0714b4886c6566face4cbb095e7b398b5/.tmux.conf
