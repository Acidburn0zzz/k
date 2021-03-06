PROJ    := k
TARGET  := $(PROJ)
OBJS    := kernel.o \
    arch/loader.o \
    arch/x86.o \
    arch/arch.o \
    arch/process.o \
    arch/paging.o \
    arch/screen.o \
    arch/multitask.o \
    lib/lib.o \
    lib/memory.o \
    lib/kprintf.o

CC      := gcc
LD      := ld
AS      := nasm

CFLAGS  := -std=c99 -m32 -nostdlib -nostartfiles -nodefaultlibs -nostdinc -fno-builtin -fno-stack-protector -I. -Ilib
LDFLAGS := -melf_i386 -T linker.ld
ASFLAGS := -f elf

.PHONY : build clean

all: image

build: $(TARGET).bin

$(TARGET).bin : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

.s.o:
	$(AS)  $(ASFLAGS) $<

image: $(TARGET).img

$(TARGET).img: $(TARGET).bin
	cat grub/stage1 grub/stage2 grub/pad $(TARGET).bin > $(TARGET).img

clean :
	@rm -fv *.img
	@rm -fv *.bin
	@rm -fv $(OBJS)
