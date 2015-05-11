arduino-mk-utils
================

This packages supplies utilities and helper wrappers around the
Arduino-Makefile package. The following makefile commands are
implemented.

1. make (or just make all): Compiles the sketch given by
   ARD_MK_UTILS_SKETCH_DIR env variable which must be set by the
   user. Dependencies are downloaded and installed; see the
   Dependencies section.

1. make clean: Deletes the files downloaded by make setup.

Dependencies
==========

1. Checks out sudar/Arduino-Makefile into a subdirectory.

1. Updates any required system dependencies via sudo apt-get
   etc.

1. Updates the env.sh file for any environment needed by
   Arduino-Makefile (e.g., ARDUINO_DIR) or any other environment
   required by the Arduino software itself.

Example
=======

Example(s) are under the ./sketches subdirectory.

To compile, upload, and run a blink sketch:

    cd sketches/blink
    make


