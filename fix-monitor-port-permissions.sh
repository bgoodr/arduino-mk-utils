#!/bin/bash

# This script adds the user to the UNIX group owned by the device referred to
# by MONITOR_PORT.

if [ -z "$ARDMK_DIR" ]
then
  echo "ASSERTION FAILED: ARDMK_DIR should have been set in the environment via the env.sh script by now."
  exit 1
fi

if [ -z "$ARD_MK_UTILS_SKETCH_DIR" ]
then
  echo "ASSERTION FAILED: ARD_MK_UTILS_SKETCH_DIR should have been set in the environment in the Arduino-Makefile/Arduino.mk rule by now."
  exit 1
fi


# Automatically determine the MONITOR_PORT if it was not already set
# in the environment:
if [ -z "$MONITOR_PORT" ]
then
  # Use the Makefile in ARD_MK_UTILS_SKETCH_DIR to call the standard
  # help rule defined by the arduino-mk-utils makefiles. Unset the
  # MAKELEVEL to force it to dump out its derived value of DEVICE_PATH
  # using its heuristics and not duplicate that code here as it is
  # subject to change. Pull out the value and set it to be the
  # MONITOR_PORT for later use:
  MONITOR_PORT=$(unset MAKELEVEL; make -C $ARD_MK_UTILS_SKETCH_DIR help | sed -n 's%- \[[^]]*\] *DEVICE_PATH *= *\([^ ]*\) *$%\1%gp')
  if [ -z "$MONITOR_PORT" ]
  then
    echo "ERROR: The Arduino-Makefile/Arduino.mk file could not automatically determine the MONITOR_PORT. Do you have the USB cable plugged in?"
    exit 1
  fi
fi

# Get the group of the MONITOR_PORT device:
monitor_port_group=$(find $MONITOR_PORT -printf "%g\n")

# Check if the user is in the group
user_is_in_monitor_port_group=0

for group in $(groups)
do
  if [ "$group" = "$monitor_port_group" ]
  then
    user_is_in_monitor_port_group=1
    break
  fi
done

if [ "$user_is_in_monitor_port_group" = 0 ]
then
  # Add the user to the group. Refer to http://playground.arduino.cc/Linux/Debian#wikitext for details:
  if [ -z "$USER" ]
  then
    echo "ASSERTION FAILED: USER environment variable is an empty string!"
    exit 1
  fi
  echo "Note: Adding $USER to the $monitor_port_group group so that the $MONITOR_PORT can be used."
  sudo usermod -a -G dialout $USER

  echo "Unfortunately, you have to log out and back in again for the groups settings to be realized."
  exit 1

fi

exit 0
