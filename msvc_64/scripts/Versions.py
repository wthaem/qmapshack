
# Purpose: Find version numbers of software packages used in QMapShack and for its building and deploying

# Information about these packages is collected in the table `Packages` of a SQLite3 database

# Meaning of the table fields:
#    * name:         name of package used in the output
#    * location:     typically location/path of the software package, in some cases part of call to get software version
#    * description:  description of software package composed of 2 parts separated by `|`:
#        * QMS:      software used in QMapShack
#        * Tool:     software used to build and deploy QMapShack
#    * call:         type of action to find version number of package. Supported actions:
#        * call:     call package directly using the value of field `parameter` as parameter in the command line
#        * ctypes:   use ctypes to call exposed internal method given in the `parameter` field for getting version number
#        * ctypes_const: use ctypes to call exposed internal constant given in the `parameter` field for getting version number
#        * location: find version number from location=path of package
#        * sigcheck: use `sigcheck` to get version number
#    * parameter:    parameter added to call for version number, called internal method for ctypes
#    * mask:         regular expression used to isolate version number from other text
#    * comment:      comments

# Output sort order:
#    * packages used in QMS
#    * packages used for building and deploying


# Remarks: 

# * Script requires installed sigcheck64.exe
# * Trying to get Routino version number with ctypes fails with access violation

# ---------------------------------------------------------------------

import subprocess
import sqlite3
import os
import re
import ctypes
import sys

# ---------------------------------------------------------------------
class Cfg():

    PACKAGESDB = r"Versions.db"
    SIGCHECK = [r"c:\uti\Nirsoft\SysInternals\sigcheck64.exe", "-n", "-nobanner"]
    SETTINGSF = "built_qms_add.bat"

    OUTF = open(r"UsedVersions.txt", "w", encoding="utf-8")
    
    HEADERS = {"QMS": "Versions of software used in QMS:\n",
              "Tool": "\nVersions of used tools and system software:\n"} 
              
    RMASK = re.compile(r'-G\s+([^-]+)-', re.S)
              
# ---------------------------------------------------------------------
class DBPackages():

    def __init__(self, cfg):
        con = sqlite3.connect(cfg.PACKAGESDB)
        cur = con.cursor()
        con.row_factory = sqlite3.Row
                
        cur = con.execute("SELECT MAX(LENGTH(name)) AS max_length FROM Packages")                
        r = cur.fetchall()
        len = dict(r[0])["max_length"]   
        cfg.len = len        
                
        cursor = con.execute("select * from Packages order by LOWER(description), LOWER(name)")
        colnames0 = [description[0] for description in cursor.description]
        #print(colnames0)      
              
        rows = cursor.fetchall()        
        con.close()
        
        print(cfg.HEADERS["QMS"], file=cfg.OUTF)
        
        swtchTool = False
        
        for j, r in enumerate(rows):
            d = dict(r)
            
            if not swtchTool and d["description"].startswith("Tool"):
                swtchTool = True
                print(cfg.HEADERS["Tool"], file=cfg.OUTF)
            
            if os.path.isfile(d["location"]):

                match [d["call"], d["mask"]]:
                    case ["sigcheck",_]: 
                        #print("sigcheck", d)
                        run = cfg.SIGCHECK + [d["location"]]
                        proc = subprocess.run(run, capture_output=True, check=False)
                        print(d["name"].rjust(len+1), ":" , proc.stdout.decode("utf-8").rstrip(), file=cfg.OUTF)
                        
                    case ["call", None]:
                        #print("Call", d)
                        run = [d["location"],
                               d["parameter"],
                               ]
                        proc = subprocess.run(run, capture_output=True, check=False)
                        print(d["name"].rjust(len+1), ":" , proc.stdout.decode("utf-8").rstrip(), file=cfg.OUTF)                               
                               
                    case ["call", m] if m is not None:
                        #print("Callm", d)
                        run = [d["location"],
                               d["parameter"],
                               ]
                        
                        proc = subprocess.run(run, capture_output=True, check=False)
                        outp = proc.stdout.decode("utf-8").rstrip() + proc.stderr.decode("utf-8").rstrip()
                        #print(1111, outp)
                        rmask = re.search(m, outp, re.S)[0]
                        print(d["name"].rjust(len+1), ":" , rmask, file=cfg.OUTF)       

                    case ["location", m]:
                        rmask = re.search(m, d["location"])[0]
                        print(d["name"].rjust(len+1), ":" , rmask, file=cfg.OUTF)       
                        
                    case ["ctypes", None]:
                        lib = ctypes.CDLL(d["location"])

                        func = getattr(lib, d["parameter"])
                        func.restype = ctypes.c_char_p
                        func.argtypes = []
                        
                        result = func()
                        print(d["name"].rjust(len+1), ":" , result.decode(), file=cfg.OUTF)

                    case ["ctypes_const", _]:
                        
                        lib = ctypes.CDLL(d["location"])
                        result = ctypes.c_char_p.in_dll(lib, d["parameter"]).value
                       
                        print(d["name"].rjust(len+1), ":" , result.decode(), file=cfg.OUTF)

                    case ["ctypes", m] if m is not None:
                        lib = ctypes.CDLL(d["location"])

                        func = getattr(lib, d["parameter"])
                        func.restype = ctypes.c_char_p

                        result = func().decode()
                        rmask = re.search(m, result)[0]
                        print(d["name"].rjust(len+1), ":" , rmask, file=cfg.OUTF)      
                        
            elif d["location"] and d["call"] == "sigcheck":            
                proc = subprocess.run(["cmd.exe", "/c", d["location"]], capture_output=True, check=False)
                outp = proc.stdout.decode("utf-8").rstrip()
                rmask = re.search(d["mask"], outp, re.S)[0]
                print(d["name"].rjust(len+1), ":" , rmask, file=cfg.OUTF)

            elif d["location"] and d["call"] == "call":
                run = d["location"].split() + [d["parameter"]]
                run = [x.replace("&", " ") for x in run]
                proc = subprocess.run(run, capture_output=True, check=False)
                outp = proc.stdout.decode("utf-8").rstrip()
                rmask = re.search(d["mask"], outp, re.S)[0]
                print(d["name"].rjust(len+1), ":" , rmask, file=cfg.OUTF)
                
            else:
                print("*** Not handled :" , d["name"])
                
        return   
        
class Generator():
    
    def __init__(self, cfg):
        
        with open(cfg.SETTINGSF) as inpf:
            txt = inpf.read()

        print("Used generator".rjust(cfg.len+1), ":" , cfg.RMASK.search(txt).group(1).strip(' "'), file=cfg.OUTF)        
        
        return
        
# ---------------------------------------------------------------------
class DoIt():

    def __init__(self, cfg):
    
        DBPackages(cfg)
        Generator(cfg)
        
        return

# ---------------------------------------------------------------------

if __name__ == "__main__":
    
    
    cfg = Cfg()
    DoIt(cfg)
    
    print("\nEnd of run.")
    
