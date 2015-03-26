C_COMPILER = bfin-uclinux-gcc
C_LIBRARY = ../../../leanx/oscar/include
C_STATIC_LIBS = ../../../leanx/oscar/library/libosc_target.a
C_OPTIONS = -c -std=gnu99
C_FLAGS = -DOSC_TARGET
C_OPT = -O2

TARGET_LOCATION = root@192.168.1.10:/mnt/app

BIN_FORMAT = -elf2flt="-s 1048576"
BIN_NAME = app

OBJ_PATH = ./obj

C_PROGRAM = main

.PHONY: all install clean

all:
	$(C_COMPILER) $(C_OPTIONS) -I$(C_LIBRARY) $(C_FLAGS) $(C_OPT) $(BIN_FORMAT) $(C_PROGRAM).c

	$(C_COMPILER) $(BIN_FORMAT) $(C_PROGRAM).o $(C_STATIC_LIBS) -o $(BIN_NAME)
	mkdir -p $(OBJ_PATH)
	mv $(BIN_NAME) $(OBJ_PATH)/.
	mv $(BIN_NAME).gdb $(OBJ_PATH)/.

install:
	scp $(OBJ_PATH)/$(BIN_NAME) $(TARGET_LOCATION)

clean:
	rm -f $(OBJ_PATH)/$(BIN_NAME)
	rm -f $(OBJ_PATH)/$(BIN_NAME).gdb
