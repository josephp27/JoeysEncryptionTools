#!/bin/sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "=======Installing GitCrypt======="

echo "Installing cryptography library"
pip install cryptography

cd /etc
if [ -d "GitCrypt" ]; then
  echo "encryption tools already exists, removing..."
  
  if [ -f ~/.zshrc ]; then
  	echo "removing key inside zshell"
    sed -i ".bak" '/ENCRYPTION_TOOLS_KEY/d' ~/.zshrc
  fi

  if [ -f ~/.bash_profile ]; then
  	echo "removing key inside bash_profile"
    sed -i ".bak" '/ENCRYPTION_TOOLS_KEY/d' ~/.bash_profile
  fi

  echo "removing files"
  rm -rf GitCrypt

  echo "unsetting git aliases"
  git config --global --unset alias.hide
  git config --global --unset alias.reveal
fi

echo "cloning repository"
git clone https://github.com/josephp27/GitCrypt.git && cd GitCrypt

read -p "Encryption key password: " password </dev/tty
key=$(python key_generator.py $password)

if [ -f ~/.zshrc ]; then
  echo "exporting key to zshell"  
  echo "export ENCRYPTION_TOOLS_KEY=$key" >> ~/.zshrc
  zsh &
fi

if [ -f ~/.bash_profile ]; then
  echo "exporting key to bash_profile"
  echo "export ENCRYPTION_TOOLS_KEY=$key" >> ~/.bash_profile
  source ~/.bash_profile
fi

echo "setting aliases"
git config --global alias.hide '!python /etc/GitCrypt/crypter.py'
git config --global alias.reveal '!python /etc/GitCrypt/decrypt.py'

echo ""
echo ""
echo "-------------------------------"
echo "| Install successful!         |"         
echo "| To encrypt use: git hide    |"
echo "| To decrypt use: git reveal. |"
echo "-------------------------------"
echo ""
echo ""
