#!/bin/bash

###
# MISC VARIABLES
###
BOLD='\e[1m'
UNDERLINE='\e[4m'
RESET='\e[0m'
GREEN='\e[32m'
YELLOW='\e[93m'
BLUE='\e[34m'

printf "${YELLOW}${BOLD}\n"
printf " ____  ____  _  _  _____  ____  ___  _   _ \n"
printf "(  _ \( ___)( \( )(  _  )(_  _)/ __)( )_( )\n"
printf " )(_) ))__)  )  (  )(_)(   )( ( (__  ) _ (\n"
printf "(____/(____)(_)\_)(_____) (__) \___)(_) (_)\n\n"
printf "${RESET}"

printf "___________________________________________________\n\n"

printf "* ${BOLD}Version:${RESET} 0.1.0 \n"
printf "* ${BOLD}Docs:${RESET} ${UNDERLINE}https://github.com/lurique/denomon${RESET} \n"
printf "* ${BOLD}Issues:${RESET} ${UNDERLINE}https://github.com/lurique/denomon/issues${RESET} \n"
printf "* ${BOLD}Author:${RESET} Lucas Henrique \n"

printf "___________________________________________________\n\n"

printf "${BOLD}${BLUE}[INFO]${RESET} Starting denotch script at $(date | tr -s '[:lower:]'  '[:upper:]') \n\n"

printf "Command: denomon $1";

###
# VERIFYING PARAM EXISTENCE
###
if [[ -z "$1" ]] ; then
  printf "\nNo params found. Type ${BOLD}denotch --help${RESET}\n\n"
  exit 1
fi

###
# FILE VARIABLES
###
FILE_PATH=$1
LAST_CHANGE=$(md5sum $FILE_PATH)

###
# VERIFYING IF INOTIFY EXISTS, OTHERWISE, INSTALL
###
command -v inotifywait >/dev/null 2>&1 || {
  while true; do
    read -e -p $'\e[1m[WARN]\e[0m Denotch depends from inotify-tools to work. Should install (y/n)? ' yn
    case $yn in
      [Yy]* ) sudo apt install inotify-tools; break;;
      [Nn]* ) "Can't continue without inotify-tools. Sorry :/"; exit;;
      * ) printf "Please, provide a valid answer (y or n)";;
    esac
  done
}

###
# HANDLERS
###
function BuildHandler()
{
  printf "Compiling file $FILE_PATH using Denotch \n\n"
  deno run --allow-write --allow-read --allow-plugin --allow-net --allow-env --unstable $FILE_PATH
  printf "/n"

  if [ $1 == true ] ; then
    LAST_CHANGE=$CURRENT_CHANGE
  fi
}

###
# WATCH LOGIC
###
BuildHandler false

while true
do
  CURRENT_CHANGE=$(md5sum $FILE_PATH)

  if [[ "$CURRENT_CHANGE" != "$LAST_CHANGE" ]] ; then
    BuildHandler true
  fi
done