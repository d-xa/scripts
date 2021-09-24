# Scripts


## Intro
This is a collection of scripts

| script | description |
| --- | --- |
| scaffold.sh | script to create new project with standard scaffold |
| subdir_to_branch.sh | script to manage subdirectories in remote branches |


## Examples

> scaffold.sh
```
# list all available scaffolds
bash scaffold.sh list

# create a new project with simple-python-venv-project scaffold
bash create -s=simple-python-venv-project -n=my-new-project
```



```
bash subdir_to_branch.sh check-remote-branch -b=main -r=https://github.com/d-xa/project-scaffolds.git
wget -O - https://raw.githubusercontent.com/d-xa/scripts/master/subdir_to_branch.sh | bash -s check-remote-branch -b=main -r=https://github.com/d-xa/project-scaffolds.git
```