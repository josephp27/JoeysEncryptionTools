#!/bin/env/python

import os
from cryptography.fernet import Fernet
from glob import glob

key = os.environ['ENCRYPTION_TOOLS_KEY']
print('Using key: ' + key)

specifiedFiles = []
with open('.gitCrypt') as file:
	lines = file.readlines()

	specifiedFiles = [line.strip() for line in lines]

def encrypt(path):
	print('Encrypting: ' + path)

	fernet = Fernet(key)
	with open(path, 'rb+') as file:

		data = file.read()

		if b'ENCRYPTED_' in data:
			raise ValueError

		encrypted = fernet.encrypt(data)

		file.seek(0)
		file.write(b'ENCRYPTED_')
		file.write(encrypted)
		file.truncate()
	

def encrypt_all_yml(path):

	for type_ in os.listdir(path):

		full_path = path + '/' + type_

		try:
			for file in specifiedFiles:
				if type_ in glob(file):
					encrypt(full_path)

		except ValueError:
			print('File already encrypted aborting..')


		if os.path.isdir(full_path):
			encrypt_all_yml(full_path)


encrypt_all_yml(os.getcwd())
