ASM=nasm
SRC_DIR=src
BUILD_DIR=build
KERNEL_DIR= src/kernel
BOOT_DIR = src/bootloader

.PHONY: floppy_image, bootloader, kernel, clean, build_folder


floppy_image: $(BUILD_DIR)/bootloader_floppy.img

$(BUILD_DIR)/bootloader_floppy.img: build_folder bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc		
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"


bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: $(BOOT_DIR)/bootloader.asm
	$(ASM) $(BOOT_DIR)/bootloader.asm -f bin -o $(BUILD_DIR)/bootloader.bin


kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: $(KERNEL_DIR)/kernel.asm
	$(ASM) $(KERNEL_DIR)/kernel.asm -f bin -o $(BUILD_DIR)/kernel.bin

build_folder:
	mkdir -p build

clean:
	rm -rf $(BUILD_DIR)/*