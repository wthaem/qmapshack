
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




from git import Repo, GitCommandError
import datetime
from pprint import pprint
import os

class RepoStatus():
    
    def __init__(self):
                   
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
                    
        changed_files = [item.a_path for item in repo.index.diff(None)]  # Modified but unstaged

        if changed_files != []:
            print("*** There are changed files!")
            return
            
        staged_files = [item.a_path for item in repo.index.diff("HEAD")]  # Staged for commit
        if staged_files != []:
            print("*** There are staged not commited files!")
            return

        untracked_files = repo.untracked_files  # Untracked files
        if untracked_files != []:
            print("*** There are untracked files!")
            return

        # Get the current branch
        self.current_branch = repo.active_branch.name

        # Get the last commit on the current branch
        self.last_commit = repo.head.commit

        self.branches_with_commit = []
        
        for branch in repo.refs:  
            if repo.is_ancestor(self.last_commit, branch.commit) and branch.name != self.current_branch:
                self.branches_with_commit.append(branch.name)

        remotenames = tuple(x.split("/")[0] for x in self.branches_with_commit)
       
        self.remote_urls = {remote.name: remote.url for remote in repo.remotes if remote.name in remotenames} #if remote.name == remoterepo }

        return
        
    def PrepareReport(self):

        outp = [    f'Logfile created:     {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} with QMSCommit.py\n']
        outp.append(f"QMS directory:       {self.workdir}")
        outp.append(f"QMS basis version:   {self.qms_version}")
        outp.append(f"Used local branch:   {self.current_branch}")

        outp.append(f"Last commit hash:    {rs.last_commit.hexsha}")
        outp.append(f"Last commit message: {rs.last_commit.message.strip()}")
        outp.append(f"Last commit author:  {rs.last_commit.author.name}")
        outp.append(f"Last commit date:    {rs.last_commit.committed_datetime}")

        outp.append(f"Remote QMS repos:    {self.branches_with_commit}")
        outp.append(f"Remote repo URLs:    {self.remote_urls}")

        with open(os.path.join(self.UserCfgDir,"QMSCommit.log"), "w") as fp:
            for lne in outp:
                fp.write(f"{lne}\n")
 
        return    


rs = RepoStatus()

if hasattr(rs, "current_branch"):
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
    
else:
    print("*** Stop of run!")
    
