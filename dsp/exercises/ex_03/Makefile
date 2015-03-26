CPP_COMPILER = bfin-uclinux-g++
BIN_FORMAT = elf2flt="-s 1048576"
BIN_NAME = app
OBJ_PATH = ./obj

C_PROGRAM = main.cpp

.PHONY: all clean

all:
	$(CPP_COMPILER) -$(BIN_FORMAT) $(C_PROGRAM) -o $(BIN_NAME)
	mv $(BIN_NAME) $(OBJ_PATH)/.
	mv $(BIN_NAME).gdb $(OBJ_PATH)/.
clean:
	rm -f $(OBJ_PATH)/$(BIN_NAME)
	rm -f $(OBJ_PATH)/$(BIN_NAME).gdb
