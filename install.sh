#!/bin/sh
CRYPT_HOME="$HOME/GitCrypt"
PYTHON_LOCATION="bin/python3"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "=======Installing GitCrypt======="


if [ -d $CRYPT_HOME ]; then
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
  git config --global --unset alias.initEncrypt
fi

echo "moving files to $CRYPT_HOME"

if [ ! -d $CRYPT_HOME ]; then
	mkdir $CRYPT_HOME
fi

cp -r . $CRYPT_HOME

read -p "encryption key password: " password </dev/tty
key=$($CRYPT_HOME/$PYTHON_LOCATION key_generator.py $password)

if [ -f ~/.zshrc ]; then
  echo "exporting key to zshell"  
  echo "export ENCRYPTION_TOOLS_KEY=$key" >> ~/.zshrc
fi

if [ -f ~/.bash_profile ]; then
  echo "exporting key to bash_profile"
  echo "export ENCRYPTION_TOOLS_KEY=$key" >> ~/.bash_profile
fi

echo "setting aliases"
git config --global alias.hide "!$CRYPT_HOME/$PYTHON_LOCATION /etc/GitCrypt/crypter.py"
git config --global alias.reveal "!$CRYPT_HOME/$PYTHON_LOCATION /etc/GitCrypt/decrypt.py"
git config --global alias.initEncrypt "!$CRYPT_HOME/$PYTHON_LOCATION /etc/GitCrypt/initEncrypt.py"

echo ""
echo ""
echo "--------------------------------------------"
echo "| Install Complete!                        |"
echo "| Initialize dir: git initEncrypt          |"         
echo "| To encrypt use: git hide                 |"
echo "| To decrypt use: git reveal.              |"
echo "--------------------------------------------"
echo ""
echo ""
