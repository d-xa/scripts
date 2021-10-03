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

> subdir_to_branch.sh
```
# push or update a subdirectory (e.g. sample-subdir-name) into a branch with the exact same name 
bash subdir_to_branch.sh update -b=sample-subdir-name -r=https://github.com/d-xa/project-scaffolds.git
```



## Call scripts remotely
In case you want to call the scripts remotely

> scafffold.sh list
```
wget -O - https://raw.githubusercontent.com/d-xa/scripts/master/scaffold.sh | bash -s list
```

> scaffold.sh create
```
wget -O - https://raw.githubusercontent.com/d-xa/scripts/master/scaffold.sh | bash -s create -s=simple-python-venv-project -n=my-new-project
```




