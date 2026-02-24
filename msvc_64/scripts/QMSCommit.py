
"""

Assumptions for repo state when compiling

* Always commit local changes 
* Always push local changes to `wthaem` ==> Always work with local branch saved in `wthaem` (or some other) repo
* Never push to remote repo other than `wthaem`
* Never make changes to branch contained in remote repo other than `wthaem`

Case: **Use branch of remote repo without changes**

* Create local branch from remote one
* Never make changes

Case **Use branch of remote repo with changes**

* Create local branch from remote one
* Push to `wthaem` as new branch
* Make changes
* Commit changes
* Push to `wthaem`

* Find list of all local and remote branches with last commit
* Find active local branch and its last commit
* Find remote repos with same last commit

Report:

* local branch
* last commit on local branch
* remote repo with same local commit
* last commit message

Procedure:

* check for unstaged changes
    * CLI: `git status` ==> `Changes not staged for commit:` or `nothing to commit, working tree clean`
    
    ~~~
    git status --branch --short --untracked=all --porcelain=2 --show-stash
    # branch.oid b615e5692f8d3afe2b51d0ff8aa9da0d7cec5723
    # branch.head porting_qt6_cache
    
    git status --branch  --untracked=all --porcelain=2 --show-stash
    # branch.oid b615e5692f8d3afe2b51d0ff8aa9da0d7cec5723
    # branch.head porting_qt6_cache
    1 .M N... 100644 100644 100644 43ac838aa1fa9ae8872cec5b1ec3e3531a498166 43ac838aa1fa9ae8872cec5b1ec3e3531a498166 qmapshack.1
    ? guest(1)
    
    
    git status --branch  --untracked=all --porcelain=1 --show-stash
    ## porting_qt6_cache
    M qmapshack.1
    ?? guest(1)
   
    ~~~
* Save branch name and last commit
* If necessary: Commit changes
* If necessary: Push changes to `wthaem`: `git push wthaem porting_qt6_cache`
* Get all known remote branches: `git branch -rvv`
* Find the remote repo and branch equal to local one: 

~~~
git branch -r --contains b615e5692f8d3afe2b51d0ff8aa9da0d7cec5723
wthaem/porting_qt6_cache
~~~
* Save remote repo name
* Get GitHub location of remote repo

~~~
git remote get-url wthaem
https://github.com/wthaem/qmapshack.git
~~~

~~~
git rev-parse --show-toplevel
D:/QtProjects/QMS/QMS4Qt6
~~~

"""




from git import Repo, GitCommandError, Head, TagReference, RemoteReference

import datetime
from pprint import pprint
import os
import sys

if len(sys.argv) < 2:
    print(f"Usage: {sys.argv[0]} <branch_to_compile>")
    sys.exit(1)

param = sys.argv[1]
print(f"Branch to compile: {param}")

if param.startswith("dev_"):
    basebranch = "dev"
elif param.startswith("master_"):
    basebranch = "master"
else:
    print("*** Wrong name of branch to compile!")    


class RepoStatus():
    
    def __init__(self, basebranch):
                   
        self.UserCfgDir = os.path.abspath(".") # inp.split(":")[1]
        #print(f"User config dir: {self.UserCfgDir}")
        

        repo = Repo(r"..\..")
        git = repo.git

        self.workdir = git.working_dir

        with open(os.path.join(self.workdir, "CMakeLists.txt")) as inpf:
            for lne in inpf:
                if lne.startswith("project(QMapShack VERSION"):
                    self.qms_version = lne.split()[2]
                    
                    break
                    
        # Get the current branch
        self.current_branch = repo.active_branch.name
        
        changed_files = [item.a_path for item in repo.index.diff(None)]  # Modified but unstaged

        if changed_files != []:
            print(f"*** There are changed files in branch {self.current_branch}!")
            #return
            
        staged_files = [item.a_path for item in repo.index.diff("HEAD")]  # Staged for commit
        if staged_files != []:
            print(f"*** There are staged not commited files in branch {self.current_branch}!")
            #return

        untracked_files = repo.untracked_files  # Untracked files
        if untracked_files != []:
            print(f"*** There are untracked files in branch {self.current_branch}!")
            #return

        

        # Get the last commit on the current branch
        self.last_commit = repo.head.commit

        self.branches_with_commit = []
        
        for branch in repo.refs:  
            if repo.is_ancestor(self.last_commit, branch.commit) and branch.name != self.current_branch:
                self.branches_with_commit.append(branch.name)

        remotenames = tuple(x.split("/")[0] for x in self.branches_with_commit)
       
        self.remote_urls = {remote.name: remote.url for remote in repo.remotes if remote.name in remotenames} #if remote.name == remoterepo }

        branch = repo.branches[basebranch]
        self.basebranch = basebranch
        
        # Get the last commit on that branch
        self.last_basecommit = branch.commit

        # Print commit info
        #print(f"\nInfo for base branch {self.basebranch}:")
        #print(f"  Commit SHA: {self.last_basecommit.hexsha}")
        #print(f"  Author:     {self.last_basecommit.author}")
        #print(f"  Message:    {self.last_basecommit.message.strip(' \n'}")
        #print(f"  Date:       {self.last_basecommit.committed_datetime}")

        self.branches_with_lastcommit = []
        
        for branch0 in repo.refs:  
            if repo.is_ancestor(self.last_basecommit, branch0.commit) and branch0.name != basebranch and isinstance(branch0, RemoteReference) and "HEAD" not in branch0.name and "upstream" not in branch0.name:
                self.branches_with_lastcommit.append(branch0.name)

        #print("  Remote branches with same commit:", self.branches_with_lastcommit)

        baseremotenames = tuple(x.split("/")[0] for x in self.branches_with_lastcommit)
       
        self.baseremote_urls = {remote.name: remote.url for remote in repo.remotes if remote.name in baseremotenames} #if remote.name == remoterepo }

        #print(f"  Remote URLs: {self.baseremote_urls}")
        
        return
        
    def PrepareReport(self):

        outp = [    f'Logfile created:             {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} with QMSCommit.py\n']
        outp.append(f"QMS directory:               {self.workdir}")
        outp.append(f"QMS basis version:           {self.qms_version}")
        outp.append(f"Current local branch:        {self.current_branch}")
        outp.append(f"Branch used for compilation: {self.basebranch}")

        outp.append("\nInfo about last commit on compilation branch:")
        outp.append(f"  Hash:                      {self.last_basecommit.hexsha}")
        outp.append(f"  Message:                   {self.last_basecommit.message.strip(' \n')}")
        outp.append(f"  Author:                    {self.last_basecommit.author.name}")
        outp.append(f"  Date:                      {self.last_basecommit.committed_datetime}")

        outp.append(f"  Branches with same commit: {self.branches_with_lastcommit}")
        outp.append(f"  Remote repo URLs:          {self.baseremote_urls}")

        with open(os.path.join(self.UserCfgDir,"QMSCommit.log"), "w") as fp:
            for lne in outp:
                fp.write(f"{lne}\n")
                print(lne)
        return    


rs = RepoStatus(basebranch)

rs.PrepareReport()

print("\nEnd of run.")

if 0: #hasattr(rs, "current_branch"):
    print("QMS directory:", rs.workdir)
    print("QMS basis version:", rs.qms_version)


    print(f"Current branch: {rs.current_branch}")
    print(f"Last commit hash: {rs.last_commit.hexsha}")
    print(f"Last commit message: {rs.last_commit.message.strip()}")
    print(f"Last commit author: {rs.last_commit.author.name}")
    print(f"Last commit date: {rs.last_commit.committed_datetime}")

    print("Branches with same commit:", rs.branches_with_commit)

    print("Repo URLs:", rs.remote_urls)

    print()

    rs.PrepareReport()

    print("\nEnd of run.")
    
#else:
#    print("*** Stop of run!")
    
