# QMSRemoveObjects.py called from CopyFilesGis.bat script and from Files directory
#   with ..\scripts\QMSRemoveObjects.py

# use for tests: .\QMSRemoveObjects.py <Files_dir>

# qmsbasedir: location of QMS files

import shutil
import os
import sys
import configparser

if len(sys.argv) == 2:
    qmsbasedir = sys.argv[-1]
else:
    qmsbasedir = "."

qmsbasedir = os.path.abspath(qmsbasedir)

print(f"\nUsing qmsbasedir {qmsbasedir}")

ignores = os.path.abspath(os.path.join(qmsbasedir, r"..\scripts\QMS_ignore.txt"))

if not os.path.exists(ignores):
    print("*** Can't find file QMS_ignore.txt! Wrong start directory?")
    print(f"    Start dir: {os.path.abspath(qmsbasedir)}")
    print( "    Should be: Files!")
    sys.exit(1)

print(f"Using ignore file {ignores}.\n")

config = configparser.ConfigParser(allow_no_value=True)
config.read(ignores)

for key in config['dirs']:  
    #print(key,)
    f = os.path.join(qmsbasedir, key)
    if os.path.exists(f):
        shutil.rmtree(f)
        print(f"Folder {key} removed")
    else:
        print(f"Folder {key} missing")        

print("")


for key in config['files']:  
    #print(key,)
    f = os.path.join(qmsbasedir, key)
    if os.path.exists(f):    
        os.remove(os.path.join(qmsbasedir, key))
        print(f"File {key} removed")
    else:
        print(f"File {key} missing")        

print("\nEnd of QMSRemoveObjects.py run.")