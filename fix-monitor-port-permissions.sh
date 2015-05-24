#!/bin/bash

# This script adds the user to the UNIX group owned by the device referred to
# by MONITOR_PORT.

# Error check that MONITOR_PORT was set in the environment:
if [ -z "$MONITOR_PORT" ]
then
  echo "ERROR: MONITOR_PORT must be set in the environment to something like /dev/ttyACM0"
  exit 1
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
