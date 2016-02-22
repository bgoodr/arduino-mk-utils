#!/bin/bash

if [ -f /etc/issue  ]
then

  if [[ "$(cat /etc/issue)" =~ Ubuntu|Debian ]]
  then
    echo "$0: Note: Debian or Ubuntu platform detected."

    # --------------------------------------------------------------------------------
    # Refer to "Install dependencies" section at
    # http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile
    # --------------------------------------------------------------------------------
    if [ "$ARD_MK_UTILS_SKIP_SYSTEM_PACKAGES" != 1 ]
    then
      set -x -e
      sudo apt-get -y install libdevice-serialport-perl
      sudo apt-get -y install libyaml-perl
      # Don't do this: it removes stuff from the system that a user may want:
      # sudo apt-get -y autoremove
      set +x +e
    fi

    # --------------------------------------------------------------------------------
    # Update touch file:
    # --------------------------------------------------------------------------------
    touch $1

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
