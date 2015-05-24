# arduino-mk-utils Makefile. Refer to https://github.com/bgoodr/arduino-mk-utils

ifeq "$(ARDMK_DIR)" ""
  # ================================================================================
  # Bootstrap when ARDMK_DIR is not set (the default when the user just
  # types "make" in this directory):
  # ================================================================================
  include arduino-mk-utils-bootstrap.mk
else

# Define the usual variable values as defined by the
# Arduino-Makefile/examples/SerialPrint/Makefile example:
BOARD_TAG     = uno
include $(ARDMK_DIR)/Arduino.mk

endif

