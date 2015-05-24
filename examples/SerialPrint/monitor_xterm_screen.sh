#!/bin/bash

# Example method to build, upload, and run this script as the monitor program:

# MONITOR_CMD=./monitor_xterm_screen.sh PATH=/usr/bin:$PATH ARD_MK_UTILS_DIR=$HOME/bgoodr/arduino-mk-utils make upload monitor

# Reference: http://playground.arduino.cc/Interfacing/LinuxTTY
MONITOR_PORT="$1"
MONITOR_BAUDRATE="$2"

if [ -z "$MONITOR_PORT" -o -z "$MONITOR_BAUDRATE" ]
then
  echo "Usage: $0 MONITOR_PORT MONITOR_BAUDRATE"
  exit 1
fi

xterm -e /bin/bash -c "screen $MONITOR_PORT $MONITOR_BAUDRATE"
