ASM=nasm

SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/boot_sect_floppy.img: $(BUILD_DIR)/boot_sect.bin
	cp $(BUILD_DIR)/boot_sect.bin $(BUILD_DIR)/boot_sect_floppy.img
	truncate -s 1400k $(BUILD_DIR)/boot_sect_floppy.img

$(BUILD_DIR)/boot_sect.bin: $(SRC_DIR)/boot_sect.asm
	$(ASM) $(SRC_DIR)/boot_sect.asm -f bin -o $(BUILD_DIR)/boot_sect.bin