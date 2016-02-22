#!/bin/bash

if [ -z "$ARD_MK_UTILS_SKETCH_DIR" ]
then
  echo "ASSERTION FAILED: $0: ARD_MK_UTILS_SKETCH_DIR should have been set in the environment by now"
  exit 1
fi

# Get the BOARD_TAG out of the environment (We do this because we
# don't want to have to force the user to add an "export" keyword in
# their Makefile):
BOARD_TAG=$(sed -n 's/BOARD_TAG *= *\([^ ]*\) *$/\1/gp' $ARD_MK_UTILS_SKETCH_DIR/Makefile)
echo "BOARD_TAG==\"${BOARD_TAG}\""


if [[ "$(cat /etc/issue)" =~ Ubuntu|Debian ]]
then
  echo "$0: Note: Debian or Ubuntu platform detected."

  # --------------------------------------------------------------------------------
  # Apply board hacks for teensy:
  # --------------------------------------------------------------------------------
  if [[ $BOARD_TAG =~ teensy ]]
  then
    # Per Arduino-Makefile/README.md we have:
    #
    #    For Teensy 3.x support you must first install [Teensyduino](http://www.pjrc.com/teensy/teensyduino.html).
    #
    # and later on in http://www.pjrc.com/teensy/td_download.html we see:
    #
    #    Linux: Teensyduino only works with Arduino from www.arduino.cc. The modified version provided by Ubuntu is not (yet) supported.
    #
    echo "$0: Note: BOARD_TAG specifies a teensy board"
    #
    if [ "$(uname -m)" = "x86_64" ]
    then

      # --------------------------------------------------------------------------------
      # Download Teensyduino:
      # --------------------------------------------------------------------------------
      installer_base=teensyduino.64bit
      url="http://www.pjrc.com/teensy/td_127/$installer_base"
      if [ ! -f $installer_base ]
      then
        curl \
          --header 'Host: www.pjrc.com' \
          --header 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:44.0) Gecko/20100101 Firefox/44.0' \
          --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
          --header 'Accept-Language: en-US,en;q=0.5' \
          --header 'Referer: http://www.pjrc.com/teensy/td_download.html' \
          --header 'Connection: keep-alive' \
          "$url" \
          -o "$installer_base" \
          -L
        if [ ! -f $installer_base ]
        then
          echo "ERROR: Failed to download URL: $url"
          exit 1
        fi        
      fi

      # --------------------------------------------------------------------------------
      # Install Teensyduino:
      # --------------------------------------------------------------------------------
      echo "$0: Note: Installing Teensyduino"
      chmod a+x $installer_base
      ./$installer_base --help

    fi
    exit 1
  fi
  
else
  echo "$0: ERROR: /etc/issue exists but is currently not supported"
  exit 1
fi
# TODO: Update above logic for other platforms, notably the Mac.


touch $1
