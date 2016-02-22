# arduino-mk-utils Makefile. Refer to https://github.com/bgoodr/arduino-mk-utils

ifeq "$(ARDMK_DIR)" ""
  # ================================================================================
  # Bootstrap when ARDMK_DIR is not set (the default when the user just
  # types "make" in this directory):
  # ================================================================================
  include arduino-mk-utils-bootstrap.mk
else

# Define the usual variable values as defined by the
# Arduino-Makefile/examples/BlinkTeensy/Makefile example, but changed
# BOARD_TAG to teensy32:
BOARD_TAG    = teensy32
include $(ARDMK_DIR)/Teensy.mk
ARDUINO_LIBS =

endif

