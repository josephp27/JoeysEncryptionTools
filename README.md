# GitCrypt

A very lightweight encryption tool used for encrypting user-specified files pushed to github.

## Install
```
curl -fsSL https://raw.githubusercontent.com/josephp27/GitCrypt/master/install.sh | sudo sh
```
NOTE: if the above install doesn't work because of curl, run:
```
sudo sh installOffline.sh
```
## Initialize
The tool looks for a specified file called .gitCrypt in the base directory. This file is very similar to a .gitignore file. It takes wildcards (*) as well as any other Unix glob
```
git initencrypt
```
After running the above command, the .gitCrypt file will automatically be generated. Creating the .gitCrypt file yourself will also work if you don't want to run the above command (or forget like we all do)

## Encrypt
```
git hide
```

Output will look something like this: 
```
Encrypting: .../resources/application-uat.txt
Encrypting: .../resources/application-test.yml
Encrypting: .../resources/application-local.yml
Encrypting: .../resources/application-dev.txt
Encrypting: .../resources/application-staging.txt
Encrypting: .../resources/application-uat.txt
Encrypting: .../resources/application-test.yml
Encrypting: .../resources/application-local.yml
```

Encrypted files will have a header: ENCRYPTED_gAAAAABcspU...

## Decrypt
```
git reveal
```
Output will be similar to above, listing key and all files decrypting.

## Features
- Will abort if encrypting already encrypted file
- Will abort if decrypting non encrypted file
- User specified .gitCrypt file will search based on user input

## TODO
- None. Submit an issue if you have an idea for a feature!

## Uninstall
```
curl -s https://raw.githubusercontent.com/josephp27/JoeysEncryptionTools/master/uninstall.sh | sudo sh
```
