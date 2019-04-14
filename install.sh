#!/bin/sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "=======Installing EncryptionTools======="

echo "Installing cryptography library"
pip install cryptography

cd /etc
if [ -d "JoeysEncryptionTools" ]; then
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
  rm -rf JoeysEncryptionTools

  echo "unsetting git aliases"
  git config --global --unset alias.hide
  git config --global --unset alias.reveal
fi

echo "cloning repository"
git clone https://github.com/josephp27/JoeysEncryptionTools.git && cd JoeysEncryptionTools

read -p "Encryption key password: " password
key=$(python key_generator.py $password)

if [ -f ~/.zshrc ]; then
  echo "exporting key to zshell"  
  echo "export ENCRYPTION_TOOLS_KEY=$key" >> ~/.zshrc
fi

if [ -f ~/.bash_profile ]; then
  echo "exporting key to bash_profile"
  echo "export ENCRYPTION_TOOLS_KEY='$key" >> ~/.bash_profile
fi

echo "setting aliases"
git config --global alias.hide '!python /etc/EncryptionTools/crypter.py'
git config --global alias.reveal '!python /etc/EncryptionTools/decrypt.py'

echo ""
echo ""
echo "-------------------------------"
echo "| Install successful          |"         
echo "| To encrypt use: git hide    |"
echo "| To decrypt use: git reveal. |"
echo "-------------------------------"
echo ""
echo ""

echo "PLEASE RESTART TERMINAL FOR CHANGES TO TAKE EFFECT"