#*
#***********************************************************************************************
#	Function  	: Makefile
#	Parameter 	: all clean debug flash
#	Author    	: Lyu Yang
#	Date      	: 2014
#	Description : Makefile for MicroBlaze
#***********************************************************************************************
#*

PROJECT = main

INC_DIRS = -I./

LIB_DIRS = -L./

CC = mb-gcc
CFLAGS = $(INC_DIRS) -c -mxl-soft-div -msoft-float -mxl-barrel-shift -mno-xl-soft-mul -Wall

CXX = mb-gcc
CXXFLAGS = $(INC_DIRS) -c -mxl-soft-div -msoft-float -mxl-barrel-shift -mno-xl-soft-mul -Wall

AS = mb-gcc
ASFLAGS = $(INC_DIRS) -c -mxl-soft-div -msoft-float -mxl-barrel-shift -mno-xl-soft-mul -Wall

LD = mb-gcc
LDFLAGS = $(LIB_DIRS) -mcpu=v5.0 -mxl-mode-executable -Wl,-defsym -Wl,_STACK_SIZE=0x400 -Wl,-defsym -Wl,_HEAP_SIZE=0x0 \
					  -Wl,-Map,$(PROJECT).map
	# -Wl,-defsym -Wl,_TEXT_START_ADDR=0x50  -T./microblaze.lds

OBJCP = mb-objcopy
OBJCPFLAGS = -O binary -R .note -R .comment -R .note.gnu.build-id
			# -j .text -j .rodata -j .rwdata -j .bss

DUMP = mb-objdump
DUMPFLAG = --disassemble --syms --all-header

# User should list all object files  
OBJS  := main.o

.PHONY: all clean
all: $(CRT0) $(PROJECT).elf $(PROJECT).asm $(PROJECT).bin
	mb-size $(PROJECT).elf
	./bin2fpga/bin2fpga 2048 $(PROJECT).bin
	
$(PROJECT).elf: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^
	
%.o: %.c
	$(CC) $(CFLAGS) -o $@ $^
	
%.o: %.S
	$(AS) $(ASFLAGS) -o $@ $^
	
$(PROJECT).asm: $(PROJECT).elf
	$(DUMP) $(DUMPFLAG) $(PROJECT).elf > $(PROJECT).asm
	
$(PROJECT).bin: $(PROJECT).elf
	$(OBJCP) $(OBJCPFLAGS) $< $@ 

clean:
	@-rm -f $(PROJECT).elf $(PROJECT).hex $(PROJECT).asm *.log *.map *.bin *.mif  *.coe *.o
	
