ASM=nasm
SRC_DIR=src
BUILD_DIR=build
KERNEL_DIR= src/kernel
BOOT_DIR = src/bootloader

.PHONY: floppy_image, bootloader, kernel, clean, hej


floppy_image: $(BUILD_DIR)/bootloader_floppy.img

$(BUILD_DIR)/bootloader_floppy.img: bootloader kernel
	cp $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/bootloader_floppy.img
	truncate -s 1400k $(BUILD_DIR)/bootloader_floppy.img


bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: $(BOOT_DIR)/bootloader.asm
	$(ASM) $(BOOT_DIR)/bootloader.asm -f bin -o $(BUILD_DIR)/bootloader.bin


kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: $(KERNEL_DIR)/kernel.asm
	$(ASM) $(KERNEL_DIR)/kernel.asm -f bin -o $(BUILD_DIR)/kernel.bin


clean:
	rm -rf $(BUILD_DIR)/*