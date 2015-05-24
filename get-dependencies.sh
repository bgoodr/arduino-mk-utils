#!/bin/bash

# --------------------------------------------------------------------------------
# get_arduino_dir: Detect ARDUINO_DIR, else automatically download and extract it.
# --------------------------------------------------------------------------------
get_arduino_dir () {
  while true
  do
    echo "$0: Note: Attempting autodetection of arduino software in current working directory."
    arduino_dirs=$(ls -1 | sed -n '/arduino-[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*$/p')
    num_arduino_dirs=$(echo $arduino_dirs | wc -w)
    if [ "$num_arduino_dirs" -gt 1 ]
    then
      echo "$0: ERROR: Detected more than one arduino version in the current working directory:"
      echo "$arduino_dirs"
      echo "$0:        Delete old ones or pick one by setting ARDUINO_DIR environment variable."
      exit 1
    elif [ "$num_arduino_dirs" = 1 ]
    then
      ARDUINO_DIR=$(pwd)/$arduino_dirs
      echo "$0: Note: Found ARDUINO_DIR: $ARDUINO_DIR"
      break
    else
      # --------------------------------------------------------------------------------
      # Download the Arduino software:
      # --------------------------------------------------------------------------------
      echo "$0: Note: Downloading latest version of Arduino software now ..."
      if [ "$(uname -m)" = "x86_64" ]
      then
        main_arduino_page="http://www.arduino.cc/en/Main/Software"
        [ -f download.page ] || curl $main_arduino_page -o download.page
        url1=$(sed -n '/download_handler.*linux64.tar.xz/{ s%^.*"\(http://arduino.*linux64.tar.xz\)".*$%\1%gp; }' download.page)
        if [ -z "$url1" ]
        then
          echo "$0: ERROR: Could not determine download tarball from $main_arduino_page"
          exit 1
        fi
        echo "$0: Note: Download URL: ${url1}"
        tarball_base=$(basename "$url1")
        echo "$0: Note: Tarball basename: ${tarball_base}"
        if [ -z "$tarball_base" ]
        then
          echo "$0: ERROR: Could not determine tarball basename from $url1"
          exit 1
        fi
        if [ -f "$tarball_base" ]
        then
          echo "$0: Note: Found existing $tarball_base so skipping download."
        else
          echo "$0: Note: Downloading $tarball_base ..."
          curl \
            --header 'Host: downloads.arduino.cc' \
            --header 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0' \
            --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
            --header 'Accept-Language: en-US,en;q=0.5' \
            --header 'Referer: http://www.arduino.cc/en/Main/Donate' \
            --header 'Connection: keep-alive' \
            "http://downloads.arduino.cc/$tarball_base" \
            -o "$tarball_base" \
            -L
        fi
        echo "$0: Note: Extracting $tarball_base ..."
        tar Jxvf $tarball_base
        # No break here. Continue with autodetection at the top of the while loop.
      fi
    fi
  done
}

# --------------------------------------------------------------------------------
# Nullify env.sh so that we can append variable export statements to it:
# --------------------------------------------------------------------------------
cat /dev/null > env.sh

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
      sudo apt-get -y autoremove
      set +x +e
    fi

    # --------------------------------------------------------------------------------
    # Install Arduino software as required:
    # --------------------------------------------------------------------------------
    if [ -z "$ARDUINO_DIR" ]
    then
      get_arduino_dir
    elif [ ! -d "$ARDUINO_DIR"  ]
    then
      echo "ERROR: ARDUINO_DIR was specified in the environment but does not exist as a directory: $ARDUINO_DIR"
      exit 1
    fi

    # --------------------------------------------------------------------------------
    # Update env.sh with ARDUINO_DIR so that the Makefile can
    # communicate it to the sketch upon run target:
    # --------------------------------------------------------------------------------
    echo "export ARDUINO_DIR=$ARDUINO_DIR" >> env.sh
    
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
    fi
    touch $ARDMK_DIR # has to be more recent than get-dependencies.sh
    
    # --------------------------------------------------------------------------------
    # Update env.sh with ARDMK_DIR so that the Makefile can
    # communicate it to the sketch upon run target:
    # --------------------------------------------------------------------------------
    echo "export ARDMK_DIR=$ARDMK_DIR" >> env.sh

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
