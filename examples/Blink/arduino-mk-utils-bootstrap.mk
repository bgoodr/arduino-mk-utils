# Provide an (un)reasonable default for the ARD_MK_UTILS_DIR if not
# set in the environment by the user:
ifeq "$(ARD_MK_UTILS_DIR)" ""
  ARD_MK_UTILS_DIR = $(HOME)/arduino-mk-utils
endif

# Verify ARD_MK_UTILS_DIR exists:
ifeq "$(wildcard $(ARD_MK_UTILS_DIR))" ""
  $(error ARD_MK_UTILS_DIR at $(ARD_MK_UTILS_DIR) does not exist)
endif

# Define the first rule to allow the user to simply execute "make" and
# it will execute the first rule in $(ARD_MK_UTILS_DIR) which will
# install any required dependencies, set some environment such as
# ARDMK_DIR, and then invoke make again in this directory:
all:
%:
	make ARD_MK_UTILS_SKETCH_DIR=$(PWD) ARD_MK_UTILS_SKETCH_TARGETS="$@" -C $(ARD_MK_UTILS_DIR)
