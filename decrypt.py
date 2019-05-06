#!/bin/env/python

import os
from cryptography.fernet import Fernet
from glob import glob
from find_files import find_all_files, load_git_crypt

key = os.environ['ENCRYPTION_TOOLS_KEY']

def decrypt(path):
	print('Decrypting: ' + path)

	fernet = Fernet(key)
	with open(path, 'rb+') as file:
		data = file.read()
		header = data[:10]

		if b'ENCRYPTED_' not in header:
			print('File already decrypted aborting..')
			return 

		decrypt = fernet.decrypt(data[10:])
		
		file.seek(0)
		file.write(decrypt)
		file.truncate()

specifiedFiles = load_git_crypt()

for file in specifiedFiles:
	for location in glob(file):
		if os.path.isdir(location):
			find_all_files(location, decrypt)
		else:
			decrypt(location)
