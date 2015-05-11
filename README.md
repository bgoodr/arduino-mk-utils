arduino-mk-utils
================

This packages supplies utilities and helper wrappers around the
Arduino-Makefile package. The following makefile commands are
implemented.

1. make (or just make all): Compiles the sketch given by
   ARD_MK_UTILS_SKETCH_DIR env variable which must be set by the user
   (or more typically, automatically set by the sketch Makefile; see
   Example(s) below). Dependencies are downloaded and installed; see the
   Dependencies section.

1. make clean: Deletes the files created by get-dependencies.sh.

Dependencies
============

1. Checks out sudar/Arduino-Makefile into a subdirectory.

1. Updates any required system dependencies via sudo apt-get
   etc.

1. Updates the env.sh file for any environment needed by
   Arduino-Makefile (e.g., ARDUINO_DIR) or any other environment
   required by the Arduino software itself.

Example
=======

Example(s) are under the ./sketches subdirectory. The examples show a
sketch Makefile that works just like the Arduino-Makefile sketch
makefiles, but of course with the addition of dependency management.
You still have to set certain variables required by Arduino-Makefile
such as MONITOR_PORT.

To compile, upload, and run a blink sketch:

    cd sketches/blink
    make
    make upload

