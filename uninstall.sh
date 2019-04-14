#!/bin/sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

cd /etc  
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
