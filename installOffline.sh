#!/bin/sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "=======Installing EncryptionTools======="

echo "Installing cryptography library"
pip install cryptography


if [ -d /etc/JoeysEncryptionTools ]; then
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
  git config --global --unset alias.initEncrypt
fi

if [ ! -d /etc/JoeysEncryptionTools ]; then
	mkdir /etc/JoeysEncryptionTools
fi

cp -r . /etc/JoeysEncryptionTools

read -p "Encryption key password: " password </dev/tty
key=$(python key_generator.py $password)

if [ -f ~/.zshrc ]; then
  echo "exporting key to zshell"  
  echo "export ENCRYPTION_TOOLS_KEY=$key" >> ~/.zshrc
fi

if [ -f ~/.bash_profile ]; then
  echo "exporting key to bash_profile"
  echo "export ENCRYPTION_TOOLS_KEY=$key" >> ~/.bash_profile
fi

echo "setting aliases"
git config --global alias.hide '!python /etc/JoeysEncryptionTools/crypter.py'
git config --global alias.reveal '!python /etc/JoeysEncryptionTools/decrypt.py'
git config --global alias.initEncrypt '!python /etc/JoeysEncryptionTools/initEncrypt.py'

echo ""
echo ""
echo "-------------------------------"
echo "| Install successful          |"         
echo "| To encrypt use: git hide    |"
echo "| To decrypt use: git reveal. |"
echo "-------------------------------"
echo ""
echo ""