import os

print('Creating .gitCrypt file at: ' + os.getcwd())
os.open(".gitCrypt", "w+").close()
