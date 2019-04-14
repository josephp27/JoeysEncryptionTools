# JoeysEncryptionTools

A very lightweight encryption tool used for encrypting application- files pushed to github.

## Install
```
curl -fsSL https://raw.githubusercontent.com/josephp27/JoeysEncryptionTools/master/install.sh | sudo sh
```

## Encrypt
```
git hide
```

Output will look something like this: 
```
Using key: <your-key>
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
- Will ignore base application file
- Will abort if encrypting already encrypted file
- Will abort if decrypting non encrypted file

## TODO
- Add feature where user specifies file of all extensions wanted encrypted

## Uninstall
```
curl -s https://raw.githubusercontent.com/josephp27/JoeysEncryptionTools/master/uninstall.sh | sudo sh
```
