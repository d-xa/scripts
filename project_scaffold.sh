#!/usr/bin/env bash
# script to setup a new project scaffold

# -------------------------------------
# Variables and Config
# -------------------------------------
PROJECTNAME="TEST"
TYPE="python" 

# Colors
NC='\033[0;30m'
RED=$(tput setaf 1) #RED='\033[0;31m'
GREEN=$(tput setaf 2) #GREEN='\033[0;32m'
YELLOW=$(tput setaf 3) #YELLOW='\033[0;33m'
NC=$(tput setaf 7) #RED='\033[0;31m'

# -------------------------------------
# Help
# -------------------------------------
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

# scaffold1 
#	python project with virtual environment
create_python_project () {
	mkdir $(pwd)/$PROJECTNAME
	echo "$PROJECTNAME" >> $(pwd)/$PROJECTNAME/README.md
	echo "pylint\npytest" >> $(pwd)/$PROJECTNAME/requirements.txt
	echo "print('Hello Python')" >> $(pwd)/$PROJECTNAME/hello.py
	touch $(pwd)/$PROJECTNAME/Makefile
	python3 -m venv $(pwd)/$PROJECTNAME/.$PROJECTNAME

	echo "${GREEN}Project ${PROJECTNAME} created succesfully! Activate environment with command below: ${NC}"
	echo "${YELLOW}. $(pwd)/$PROJECTNAME/.$PROJECTNAME/bin/activate${NC}"
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
		-n=*|--name=*)
		PROJECTNAME="${i#*=}"
		shift
		;;

		# OPERATION
		help)
		OPERATION=print_help
		shift
		;;
		create)
		OPERATION=create_python_project
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