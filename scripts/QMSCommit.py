from git import Repo, GitCommandError
import datetime
from pprint import pprint

repo = Repo(r"..")
git = repo.git

workdir = git.working_dir

status = git.status("-bs").split("\n")

changes = ""
if len(status) > 1:
    changes = ". Working space with changes"
    
try:
    actlocal, actremote = status[0].split()[1].split("...")
    addstatus = ""
    
except ValueError:
        actlocal = status[0].split()[1].split("...")[0]
        actremote = None
        addstatus = ". No tracked remote branch/repo"
        
last_commit = git.log((actlocal, -1, '--format=format:%h, Author: %an, Date: %ai, Subject: %s')).split("\n")

if actremote:
    last_commit_rem = git.log((actremote, -1, '--format=format:%h, Author: %an, Date: %ai, Subject: %s')).split("\n")

    remrepo, rembranch = actremote.split("/")[-2:]

    repofork = git.remote(("show", remrepo)).split("\n")

outp = [    f'Logfile created:     {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}\n']
outp.append(f"QMS directory:       {workdir}")
outp.append(f"Used local branch:   {actlocal}")
outp.append("Last local commit:   " + last_commit[0]) 
outp.append(f'Status:              {git.status("-bsuno").split("\n")[0]}{addstatus}{changes}') 

if actremote:
    outp.append("Remote repo:         " + repofork[1].split()[-1])
    outp.append(f"Used remote branch:  {actremote}")
    outp.append( "Remote commit:       " + last_commit_rem[0])

with open("QMSCommit.log", "w") as fp:
    for lne in outp:
        fp.write(f"{lne}\n")

    