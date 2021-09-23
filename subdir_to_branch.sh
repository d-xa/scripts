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


# -------------------------------------
# Functions
# -------------------------------------

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
	check_param_branchname
	check_param__remoterepo
}

#   check if local directory exists
check_subdir_exist () {
    if [ -d $(pwd)/$BRANCHNAME ]; then 
		echo "${GREEN}local subdir $BRANCHNAME exists ${NC}"; 
		return 0;
	else \
		echo "${YELLOW}local subdir $BRANCHNAME does not exist ${NC}" ; 
		return 1;
	fi
}

#   check if remote branch exists
check_remote_branch_exist () {
	if [ "$(git ls-remote --heads $REMOTEREPO $BRANCHNAME | wc -l)" -eq "1" ]; then 
		echo "remote branch exist"; 
		return 0; 
	else \
		echo "remote branch does not exist"; 
		return 1;
	fi 

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