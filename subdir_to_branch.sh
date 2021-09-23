#!/usr/bin/env bash
# script to upload a subdirectory to a remote branch

# -------------------------------------
# Variables and Config
# -------------------------------------

# Colors
NC='\033[0;30m'
RED=$(tput setaf 1) #RED='\033[0;31m'
GREEN=$(tput setaf 2) #GREEN='\033[0;32m'
YELLOW=$(tput setaf 3) #YELLOW='\033[0;33m'
NC=$(tput setaf 7) #RED='\033[0;31m'

CURRENTDIR=$(pwd)

# -------------------------------------
# Functions
# -------------------------------------

# 	to confirm
confirm() {
	read -r -p "are you sure? [y/N]" response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		return 0;
	else
		echo "ok - nothing happened"
		return 1;
	fi
}

#   check script parameters
check_param_branchname () {
    if [ -z $BRANCHNAME  ]; then 
		echo "${RED}please set branchname with --branch or -b${NC}" ; 
		return 1;
	fi
}

check_param_remoterepo () {
    if [ -z $REMOTEREPO  ]; then 
		echo "${RED}please set remote repo with --remote or -r${NC}" ; 
		return 1;
	fi
}

check_all_script_params () {
	check_param_branchname && check_param_remoterepo
}

#   check if local directory exists
check_subdir_exist () {
    if [ -d $CURRENTDIR/$BRANCHNAME ]; then 
		echo "${GREEN}local subdir $BRANCHNAME exists ${NC}"; 
		return 0;
	else \
		echo "${YELLOW}local subdir $BRANCHNAME does not exist - please create it first ${NC}" ; 
		return 1;
	fi
}

#   check if remote branch exists
check_remote_branch_exist () {
	if [ "$(git ls-remote --heads $REMOTEREPO $BRANCHNAME | wc -l)" -eq "1" ]; then 
		echo "${GREEN}remote branch already exists${NC}"; 
		return 0; 
	else \
		echo "${YELLOW}remote branch does not exist${NC}";
		echo "about to create a new remote branch $BRANCHNAME";
		confirm && create_remote_branch;
	fi 
}

create_remote_branch () {
	# create new remote branch
	git checkout -b $BRANCHNAME
	git push -u $REMOTEREPO $BRANCHNAME

	# initialize new branch
	initialize_remote_branch
	return 0
}

initialize_remote_branch () {
	# clone to _branches
	mkdir -p $CURRENTDIR/_branches
	cd $CURRENTDIR/_branches \
	&& git clone -b $BRANCHNAME $REMOTEREPO $BRANCHNAME

	# initialize 
	cd $CURRENTDIR/_branches/$BRANCHNAME \
	&& $(ls | grep -v .git | xargs rm -rf) \
	&& git add . \
	&& git commit -m "initialize $BRANCHNAME" \
	&& git push
	echo "${GREEN}remote branch $BRANCHNAME created${NC}"
	return 0
}

check_all() {
	check_subdir_exist && check_remote_branch_exist
}


#   copy and push branch
update_remote_branch () {
	cp $CURRENTDIR/$BRANCHNAME/* $CURRENTDIR/_branches/$BRANCHNAME
	cd $CURRENTDIR/_branches/$BRANCHNAME \
	&& git add . \
	&& git commit -m "update $BRANCHNAME" \
	&& git push
	echo "${GREEN}updated remote branch $BRANCHNAME${NC}"
	return 0;
}

check_and_update () {
	check_all && update_remote_branch
}

# -------------------------------------
# To parse script arguments provided by user
# -------------------------------------
for i in "$@" 
do
	case $i in 
		-h|--help)
		OPERATION=print_help
		shift
		;;

		# OPTIONS
		-b=*|--branch=*)
		BRANCHNAME="${i#*=}"
		shift
		;;
		-r=*|--remote=*)
		REMOTEREPO="${i#*=}"
		shift
		;;

		# OPERATION
		help)
		OPERATION=print_help
		shift
		;;
		check-local-subdir)
		OPERATION=check_subdir_exist
		shift
		;;
		check-remote-branch)
		OPERATION=check_remote_branch_exist
		shift
		;;
		check)
		OPERATION=check_all
		shift
		;;
		update)
		OPERATION=check_and_update
		shift
		;;
		
		test)
		OPERATION=initialize_remote_branch
		shift
		;;

		# WRONG USAGE
		*)
		echo "${RED}Wrong script usage ${NC}"
		print_help
		exit 1
		;;
	esac
done 

# -------------------------------------
# Main
# -------------------------------------
eval check_all_script_params && $OPERATION