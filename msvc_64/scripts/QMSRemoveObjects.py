# QMSRemoveObjects.py qmsbasedir

# qmsbasedir: location of QMS files

# remove start batches and their use!!!!!!!!

import shutil
import os
import sys
import configparser

qmsbasedir = "."   # sys.argv[-1]

ignores = r"..\scripts\QMS_ignore.txt"

config = configparser.ConfigParser(allow_no_value=True)

config.read(ignores)
#print(config.sections())

for key in config['dirs']:  
    #print(key,)
    f = os.path.join(qmsbasedir, key)
    if os.path.exists(f):
        os.remove(f)
        print(f"Folder {key} removed")
    else:
        print(f"Folder {key} missing")        

print("")

for key in config['files']:  
    #print(key,)
    f = os.path.join(qmsbasedir, key)
    if os.path.exists(f):    
        shutil.rmtree(os.path.join(basedir, key))
        print(f"File {key} removed")
    else:
        print(f"File {key} missing")        
