# Projekt Parameter
TARGET=main
MCU=attiny88
PROGRAMMER=dragon_isp

#auskommentieren für automatische Wahl, avrdude option (-P, -B) vor Variable schreiben!
PORT=-P usb
BAUD=-B 2400

#Subfolder name for build files
BUILD_DIR := build

#Ab hier nichts verändern
SRCS := $(wildcard *.c)
SRCS_BASE := $(patsubst %.c,%,$(SRCS))
BUILD_BASE := $(addprefix $(BUILD_DIR)/, $(notdir $(SRCS_BASE)))
DEPS := $(addsuffix .d,$(BUILD_BASE))
OBJS := $(addsuffix .o,$(BUILD_BASE))

CFLAGS=-c -Os -std=c99 -Wall
LDFLAGS=

all: echo_dep $(DEPS) echo_build hex echo_size size

hex: $(TARGET).hex

eeprom: $(TARGET)_eeprom.hex

#Create Dependencies
$(BUILD_DIR)/%.d: %.c | build
	@echo ""
	@echo "Create dependency of $<"
	avr-gcc $(CFLAGS) -mmcu=$(MCU) -MM -o $@ $<  

#Compile Sources
$(BUILD_DIR)/%.o: %.c | build 
	@echo ""
	@echo "Compiling $<"
	avr-gcc $(CFLAGS) -mmcu=$(MCU) -c $< -o $@

#create hex file
$(TARGET).hex: $(TARGET).elf
	avr-objcopy -O ihex -j .data -j .text $(TARGET).elf $(TARGET).hex

#create eeprom
$(TARGET)_eeprom.hex: $(TARGET).elf
	avr-objcopy -O ihex -j .eeprom --change-section-lma .eeprom=1 $(TARGET).elf $(TARGET)_eeprom.hex

#link
$(TARGET).elf: $(OBJS)
	avr-gcc $(LDFLAGS) -mmcu=$(MCU) $(OBJS) -o $(TARGET).elf


.PHONY: size  program build clean_tmp clean

#Display the size of the program
size: 
	avr-size --mcu=$(MCU) -C $(TARGET).elf

#Program the Controller with avrdude
program:
	avrdude -p $(MCU) $(PORT) $(BAUD) -c $(PROGRAMMER) -Uflash:w:$(TARGET).hex

build:
	mkdir -p $@

clean_tmp:
	rm -rf *.o
	rm -rf *.d
	rm -rf *.elf

clean:
	rm -rf *.elf
	rm -rf *.hex
	rm -rf $(BUILD_DIR)

# helper dependencies for nice text output
echo_dep:
	@echo ""
	@echo ""
	@echo "     ======== Building Dependencies ========"
echo_build:
	@echo ""
	@echo ""
	@echo "     ======== Compiling Sources ========"
echo_size:
	@echo ""
	@echo ""
	@echo "     ======== Size ========"
