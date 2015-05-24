arduino-mk-utils
================

This packages supplies utilities and helper wrappers around the
Arduino-Makefile package. The following makefile commands are
implemented.

1. make (or just make all): Compiles the sketch given by
   ARD_MK_UTILS_SKETCH_DIR env variable which must be set by the user
   (or more typically, automatically set by the sketch Makefile; see
   [Examples](#Examples) section). Dependencies are downloaded and
   installed (see the [Dependencies](#Dependencies) section).

1. make clean: Deletes the files created by get-dependencies.sh.

Dependencies
============
<a name="Dependencies"></a>

1. Checks out sudar/Arduino-Makefile into a subdirectory.

1. Updates any required system dependencies via sudo apt-get
   etc.

1. Updates the env.sh file for any environment needed by
   Arduino-Makefile (e.g., ARDUINO_DIR) or any other environment
   required by the Arduino software itself.

Examples
========
<a name="Examples"></a>

Examples are under the [examples](examples) subdirectory. The examples
show a sketch Makefile that works just like the Arduino-Makefile
sketch Makefiles (is a child Makefile), but of course with the
addition of dependency management via including a
arduino-mk-utils-bootstrap.mk helper file.  You may or may not have to
set certain variables required by Arduino-Makefile such as
MONITOR_PORT (see the [Finding the
MONITOR_PORT](#Finding_the_MONITOR_PORT) section below for details).

To compile, upload, and run a blink sketch (set ARD_MK_UTILS_DIR to
the directory where you downloaded this package into):

    cd examples/Blink
    ARD_MK_UTILS_DIR=$HOME/bgoodr/arduino-mk-utils make
    ARD_MK_UTILS_DIR=$HOME/bgoodr/arduino-mk-utils make upload

If you have some local Python installed into your PATH that
doesn'thave the "serial" module, you can set the path to the
system-installed Python via:

    PATH=/usr/bin:$PATH ARD_MK_UTILS_DIR=$HOME/bgoodr/arduino-mk-utils make upload

Finding the MONITOR_PORT
========================
<a name="Finding_the_MONITOR_PORT"></a>

For instance, on Ubuntu or Debian Linux, commonly MONITOR_PORT turns
out to be /dev/ttyACM0. When the "upload" rule is executed, this
package attempts to determine the MONITOR_PORT by using the underlying
Arduino-Makefile/Arduino.mk "help" rule to identify it (processing
done inside
[fix-monitor-port-permissions.sh](fix-monitor-port-permissions.sh)). The
USB cable has to be plugged in for this to work.

On Linux, you can also determine this device path via the following
procedure:

1. Before connecting the arduino USB cable to the computer execute: find /dev/ >/tmp/dev.1

1. Connect the USB cable and then execute : find /dev/ >/tmp/dev.2

1. Then execute: diff -u /tmp/dev.1 /tmp/dev.2 | grep -e '+/dev/tty'

1. You will then see something like:

    +/dev/ttyACM0

1. The /dev/ttyACM0 line in the diff output is the value to set to MONITOR_PORT.

