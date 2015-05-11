# arduino-mk-utils Makefile. Refer to https://github.com/bgoodr/arduino-mk-utils

# ================================================================================
# Bootstrap when ARDMK_DIR is not set (the default when the user just
# types "make" in this directory):
# ================================================================================
ifeq "$(ARDMK_DIR)" ""


include arduino-mk-utils-bootstrap.mk


# ================================================================================
# When ARDMK_DIR is now set by the callback from $(ARD_MK_UTILS_DIR)/Makefile
# ================================================================================
else



# This section is very similar to the Arduino-Makefile/examples/Blink/Makefile example:
BOARD_TAG     = uno
MONITOR_PORT  = /dev/ttyACM0
include $(ARDMK_DIR)/Arduino.mk



endif

