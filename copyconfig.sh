#!/bin/bash

# ------------------------------------------------
# Work in progress.
# ------------------------------------------------
# Script used to copy vimrc file to and from
# personal home directory.
# ------------------------------------------------

# ------------------------------------------------
# Handle command line args and set env variables
# ------------------------------------------------

# General argument structure: [SCRIPTS_DIR [HOME_DIR]]

function confirm {
# this function follows a yes/no question
# proceeds upon 'y' and exits upon 'n'
    BAD_INPUT=true
    while [ $BAD_INPUT == true ]
    do
        echo '(y/n)'
        read INPUT
        if [ "$INPUT" == 'y' ]
        then
            BAD_INPUT=false
        elif [ "$INPUT" == 'n' ]
        then
            echo 'Abort.'
            exit 0
        else
            echo 'Please try again.'
        fi
    done
}

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOTFILES="$DIR/dotfiles"
for f in $(ls $DOTFILES); do
  # handle case where we want to write to the repo
  SOURCE="$DOTFILES/$f"
  DESTINATION="$HOME/.$f"

  echo '-----------------------------------------------------------'
  echo 'Create symbolic link of '${SOURCE}' to '${DESTINATION}'?'
  echo '(Run <ln -s '${SOURCE} ${DESTINATION}'>)'
  confirm
  if [ -L ${DESTINATION} ] || [ -e ${DESTINATION} ]
  then
    echo "${DESTINATION} exists. Delete?"
    echo "(Run <rm ${DESTINATION}>)"
    confirm
    rm ${DESTINATION}
  fi
  ln -s ${SOURCE} ${DESTINATION}
  echo "Created symbolic link of ${SOURCE} to ${DESTINATION}."
done
echo '-----------------------------------------------------------'
exit 0
