# Define the dependency env files. These will be touched or created by various rules defined later:
ENV_FILES = env.system-packages.sh env.arduino-software-dir.sh env.arduino-software-hacks.sh env.Arduino-Makefile.sh 

# Define code to check that ARD_MK_UTILS_SKETCH_DIR has been set by
# the child sketch Makefile:
define require_ARD_MK_UTILS_SKETCH_DIR
	if [ -z "$(ARD_MK_UTILS_SKETCH_DIR)" ]; then \
		echo "ERROR: ARD_MK_UTILS_SKETCH_DIR was not set in the environment"; \
		echo "       Set it to the path to a directory containing the child sketch Makefile."; \
		false; \
	fi
endef

# Define the first rule to allow the user to run make from within their sketch
# directory, with the requirement that the user must set
# ARD_MK_UTILS_SKETCH_DIR in the environment prior to invoking
# make. ARD_MK_UTILS_SKETCH_DIR is what each child Makefile for each
# sketch will set before running make in this directory.
# ARD_MK_UTILS_SKETCH_TARGETS is set by the bootstrap rule in each
# sketch Makefile so as to forward the targets provided by the
# Arduino-Makefile/Arduino.mk, such as make upload, make monitor, make
# clean (note that the clean rule here applies only to cleaning
# arduino-mk-utils):
all: $(ENV_FILES) fix-monitor-port-permissions
	@echo EXECUTING RULE: $@
	@$(require_ARD_MK_UTILS_SKETCH_DIR)
	$(foreach env_file,$(ENV_FILES), . $(env_file); ) \
		unset MAKELEVEL; $(MAKE) -C $(ARD_MK_UTILS_SKETCH_DIR) $(ARD_MK_UTILS_SKETCH_TARGETS)

# Run this each time through any target. It will be a no-op unless the
# user specifies the upload target. Thus, this checks the existence of
# the serial device only if it is connected:
.PHONY : fix-monitor-port-permissions
fix-monitor-port-permissions :
	@echo EXECUTING RULE: $@
	@$(require_ARD_MK_UTILS_SKETCH_DIR)
	$(foreach env_file,$(ENV_FILES), . $(env_file); ) \
		if [ "$(filter upload,$(ARD_MK_UTILS_SKETCH_TARGETS))" = "upload" ]; \
		then \
			ARD_MK_UTILS_SKETCH_DIR="$(ARD_MK_UTILS_SKETCH_DIR)" ./fix-monitor-port-permissions.sh; \
		fi

clean:
	@echo EXECUTING RULE: $@
	@echo CLEANING ...
	rm -rf $(ENV_FILES)

# Reference: http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile

env.system-packages.sh :
	@echo EXECUTING RULE: $@
	./get-system-packages.sh $@

env.arduino-software-dir.sh : env.system-packages.sh
	@echo EXECUTING RULE: $@
	./get-arduino-software.sh $@

env.arduino-software-hacks.sh : env.arduino-software-dir.sh
	@echo EXECUTING RULE: $@
	@$(require_ARD_MK_UTILS_SKETCH_DIR)
	ARD_MK_UTILS_SKETCH_DIR=$(ARD_MK_UTILS_SKETCH_DIR) ./apply_board_hacks.sh $@

env.Arduino-Makefile.sh : env.arduino-software-hacks.sh
	@echo EXECUTING RULE: $@
	./get-Arduino-Makefile.sh $@
