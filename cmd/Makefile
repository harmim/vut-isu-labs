TARGET_DIR = bin
TARGET_FILE = $(TARGET_DIR)/$(arg)

.PHONY: clean

$(TARGET_FILE): $(TARGET_DIR) $(TARGET_FILE).o
	gcc -m32 -g -o $(TARGET_FILE) $(TARGET_FILE).o

$(TARGET_DIR):
	mkdir -p $(TARGET_DIR)

$(TARGET_FILE).o:
	nasm -f elf32 -g -o $(TARGET_FILE).o $(arg).asm

clean:
	rm -rf $(TARGET_DIR)
