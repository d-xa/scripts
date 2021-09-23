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
check_script_params () {
    if [ -z $BRANCHNAME ]; then 
		echo "${RED}please set branchname with --branch or -b${NC}" ; 
		exit 1;
	fi
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

		# OPERATION
		help)
		OPERATION=print_help
		shift
		;;
		check)
		OPERATION=check_subdir_exist
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
eval check_script_params && $OPERATION