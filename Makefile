# Define the dependencies downloaded or created by the
# get-dependencies.sh script:
deps = Arduino-Makefile env.sh

# Define the first rule to allow the user to run make from within this
# directory, with the requirement that the user must set
# ARD_MK_UTILS_SKETCH_DIR in the environment prior to invoking
# make. ARD_MK_UTILS_SKETCH_DIR is what each child Makefile for each
# sketch will set before running make in this directory.
# ARD_MK_UTILS_SKETCH_TARGETS is set by the bootstrap rule in each
# sketch Makefile so as to forward the targets provided by the
# Arduino-Makefile/Arduino.mk, such as make upload, make monitor, make
# clean (note that the clean rule here applies only to cleaning
# arduino-mk-utils):
all: $(deps)
	@if [ -z "$(ARD_MK_UTILS_SKETCH_DIR)" ]; then \
		echo "ERROR: ARD_MK_UTILS_SKETCH_DIR was not set in the environment"; \
		echo "       Set it to the path to a directory containing the child sketch Makefile."; \
		false; \
	fi
	@. ./env.sh; if [ "$(filter upload,$(ARD_MK_UTILS_SKETCH_TARGETS))" = "upload" ]; then ARD_MK_UTILS_SKETCH_DIR="$(ARD_MK_UTILS_SKETCH_DIR)" ./fix-monitor-port-permissions.sh; fi
	. ./env.sh; unset MAKELEVEL; $(MAKE) -C $(ARD_MK_UTILS_SKETCH_DIR) $(ARD_MK_UTILS_SKETCH_TARGETS)

clean:
	rm -rf $(deps)

# From Location: http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile
# Install dependencies section. Here we are creating the env.sh
$(deps) : get-dependencies.sh
	./get-dependencies.sh

