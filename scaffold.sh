#!/usr/bin/env bash
# script to setup a new project scaffold

# -------------------------------------
# Variables and Config
# -------------------------------------
PROJECTNAME="TEST"

# Colors
NC='\033[0;30m'
RED=$(tput setaf 1) #RED='\033[0;31m'
GREEN=$(tput setaf 2) #GREEN='\033[0;32m'
YELLOW=$(tput setaf 3) #YELLOW='\033[0;33m'
NC=$(tput setaf 7) #RED='\033[0;31m'

# -------------------------------------
# Help
# -------------------------------------
# script usage bash scaffold create -s=simple-python-venv-project -n=my-project
print_help () {
	printf '%s\n' "Script to create new project"
	printf '%s\n' "Usage ${GREEN}sh $0 OPERATION ${YELLOW}[OPTIONS]${NC}"
	printf '%s\n' "------------------------------"
	printf '%s\n' "${GREEN}OPERATIONS${NC}"
	printf '%s\n' "------------------------------"
	printf '%s\n' "$0 create				to create a new project"
	printf '%s\n' "$0 help 					to print help"
	printf '%s\n' "------------------------------"
	printf '%s\n' "${YELLOW}OPTIONS${NC}"
	printf '%s\n' "------------------------------"
	printf '%s\n' "-h|--help				to print help"
	printf '%s\n' "$0 help 					to print help"
	printf '%s\n' "------------------------------"
	printf '%s\n' "EXAMPLES"
	printf '%s\n' "------------------------------"
	printf '%s\n' "create -t=python				example"
}

# -------------------------------------
# Functions
# -------------------------------------
# to list available scaffolds
list_scaffolds () {
	SCAFFOLD_LIST=$(git ls-remote --heads https://github.com/d-xa/project-scaffolds.git | awk -F'refs/heads/' '{print $2}' | grep -v main)
	for s in $SCAFFOLD_LIST; do echo $s; done 
	return 0
}


# to create scaffold
create_scaffold () {
	if [-z $SCAFFOLD]; then echo "please specify scaffold with --scaffold or -s"; exit 1; fi 
	if [-z $PROJECTNAME]; then echo "please specify project name with --name or -n"; exit 1; fi 
	mkdir $PROJECTNAME && curl -L https://github.com/d-xa/project-scaffolds/tarball/$SCAFFOLD | tar -xzv --strip-components=1 -C $PROJECTNAME
	return 0
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
		-s=*|--scaffold=*)
		SCAFFOLD="${i#*=}"
		shift
		;;
		-n=*|--name=*)
		PROJECTNAME="${i#*=}"
		shift
		;;

		# OPERATION
		help)
		OPERATION=print_help
		shift
		;;
		list)
		OPERATION=list_scaffolds
		shift
		;;
		create)
		OPERATION=create_scaffold
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
eval $OPERATION