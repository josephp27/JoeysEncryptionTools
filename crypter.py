import os
from cryptography.fernet import Fernet
from glob import glob
from find_files import load_git_crypt

key = os.environ['ENCRYPTION_TOOLS_KEY']

def encrypt(path):
	print('Encrypting: ' + path)

	fernet = Fernet(key)
	with open(path, 'rb+') as file:

		data = file.read()

		if b'ENCRYPTED_' in data:
			print('File already encrypted aborting..')
			return 

		encrypted = fernet.encrypt(data)

		file.seek(0)
		file.write(b'ENCRYPTED_')
		file.write(encrypted)
		file.truncate()

specifiedFiles = load_git_crypt()

for file in specifiedFiles:
    for location in glob(file, recursive=True):
        encrypt(location)
