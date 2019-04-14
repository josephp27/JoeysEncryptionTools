#!/bin/env/python

import os
from cryptography.fernet import Fernet

key = os.environ['ENCRYPTION_TOOLS_KEY']
print('Using key: ' + key)

def encrypt(path):
	print('Encrypting: ' + path)

	fernet = Fernet(key)
	with open(path, 'rb+') as file:

		data = file.read()

		if b'ENCRYPTED_' in data:
			raise Exception()

		encrypted = fernet.encrypt(data)

		file.seek(0)
		file.write(b'ENCRYPTED_')
		file.write(encrypted)
		file.truncate()
	

def encrypt_all_yml(path):

	for type_ in os.listdir(path):

		full_path = path + '/' + type_

		try:
			if 'application-' in type_:
				encrypt(full_path)
		except:
			print('File already encrypted aborting...MF')


		if os.path.isdir(full_path):
			encrypt_all_yml(full_path)



encrypt_all_yml(os.getcwd())