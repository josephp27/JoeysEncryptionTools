def find_all_files(path, callback):

	for type_ in os.listdir(path):

		full_path = path + '/' + type_

		if os.path.isdir(full_path):
			find_all_files(full_path)
		else:
			callback(full_path)

def load_git_crypt():
	try:
		file = open('.gitCrypt', 'r')
	except IOError:
		print('Cannot find .gitCrypt file. Aborting')
		exit(1)

	with open('.gitCrypt') as file:
		lines = file.readlines()
		return  [line.strip() for line in lines]