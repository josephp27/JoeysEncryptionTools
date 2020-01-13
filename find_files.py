import os

def load_git_crypt():
    try:
        file = open('.gitCrypt', 'r')
    except IOError:
        print('Cannot find .gitCrypt file. Aborting')
        exit(1)

    with open('.gitCrypt') as file:
        lines = file.readlines()
        return  [line.strip() for line in lines]
