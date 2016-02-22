#!/bin/bash

if [ -f /etc/issue  ]
then

  if [[ "$(cat /etc/issue)" =~ Ubuntu|Debian ]]
  then
    echo "$0: Note: Debian or Ubuntu platform detected."

    # --------------------------------------------------------------------------------
    # Clone Arduino-Makefile as needed:
    # --------------------------------------------------------------------------------
    if [ -z "$ARDMK_DIR" ]
    then
      if [ ! -d Arduino-Makefile ]
      then
        echo "$0: Note: Cloning Arduino-Makefile from GitHub ..."
        # See https://help.github.com/articles/which-remote-url-should-i-use/
        # why we don't use git@github.com:sudar/Arduino-Makefile.git
        # mainly because it requires a ssh username and password which
        # we don't typically want in most cases (e.g., we aren't
        # pushing changes back into the sudar/Arduino-Makefile.git
        # repo)
        #
        #    git clone git@github.com:sudar/Arduino-Makefile.git
        #
        # instead we do this:
        git clone https://github.com/sudar/Arduino-Makefile.git
        if [ $? != 0 -o ! -d Arduino-Makefile ]
        then
          echo "$0: ERROR: Failed to clone Arduino-Makefile from GitHub"
          exit 1
        fi
      fi
      ARDMK_DIR=$(pwd)/Arduino-Makefile
      echo "$0: Note: Found ARDMK_DIR: $ARDMK_DIR"
    fi
    
    # --------------------------------------------------------------------------------
    # Update env file with ARDMK_DIR so that the Makefile can
    # communicate it to the sketch upon run target:
    # --------------------------------------------------------------------------------
    echo "export ARDMK_DIR=$ARDMK_DIR" > $1

  else
    echo "$0: ERROR: /etc/issue exists but is currently not supported"
    exit 1
  fi
  # TODO: Update above logic for other platforms, notably the Mac.

else
  echo "$0: ERROR: Current platform currently not supported"
  exit 1
fi

exit 0
