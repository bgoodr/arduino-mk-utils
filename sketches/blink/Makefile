# arduino-mk-utils Makefile. Refer to https://github.com/bgoodr/arduino-mk-utils

ifeq "$(ARDMK_DIR)" ""
  # ================================================================================
  # Bootstrap when ARDMK_DIR is not set (the default when the user just
  # types "make" in this directory):
  # ================================================================================
  include arduino-mk-utils-bootstrap.mk
else

# Define the usual variable values as defined by the
# Arduino-Makefile/examples/Blink/Makefile example (Note that the
# definition of MONITOR_PORT is Linux specific):
BOARD_TAG     = uno
MONITOR_PORT  = /dev/ttyACM0
include $(ARDMK_DIR)/Arduino.mk

endif

