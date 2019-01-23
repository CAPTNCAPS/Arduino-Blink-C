# -c = compile, assemble, don't link
# -g = generate debug symbols
# -Os = Optimize for space
# -w = hide all warnings
# -std=... = use c++xx standard
# -x c++ = use C++ as language
# -E = preprocess only
# -I... = Include Directory
# -L... = Library Directory
# -l... = link with library

# -Wl,xxx = pass comma seperated list xxx to ld (linker)

# -MMD = output make rule for c files of included headers (creates *.d file)

# -f...
# -fpermissive = Downgrade some diagnostics about nonconformant code from errors to warnings. (don't use!)
# -fno-exceptions = remove automagically generate "try/catch" stuff
# -ffunction-section -fdata-sections = use seperate code and data sections
# -fno-threadsafe-statics = reduce codesize by not being threadsafe (we only have 1 thread, no need for those, but we need every byte we can get)
# -flto = link time optimization
# -fno-devirtualize = do not convert calls to virtual functions to direct calls
# -fno-use-cxa-atexit = use non standard compliant destructor for static objects

# -mmcu=atmega328p  = define instruction set
# -D... = DEFINE ...
# -DF_CPU=16000000L = Frequency_CPU = 16MHz
# -DARDUINO=10808 = ???
# -DARDUINO_AVR_UNO = define board ???
# -DARDUINO_ARCH_AVR = ???


#!! an "Arduino Core" is NOT needed, it's what helps compile sketches to actual C code
# not needed cuz we already use plain c

# commands and options have been taken right from the Arduino IDE compilation log.
# commands were slightly changed to not include a "core" and a few flags were omitted

# === COMPILE ===
#NECESSARY!
#optional pass -g flag
C_FLAGS = -c -Os -w -std=gnu++11 -MMD
C_WARNINGS = -Wno-error=narrowing
C_PROCESSOR = -mmcu=atmega328p -DF_CPU=16000000L 
C_INPUT = "blink.c"
C_OUTPUT = "blink.o"

#extra
C_OPTIMIZE = -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -flto -fno-devirtualize -fno-use-cxa-atexit

#maybe not needed because we don't use a core
#tested: still worked without
C_ARDUINO = -DARDUINO=10808 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR

#probably not needed because we don't use a core
#tested: still worked without
C_INCLUDE = -I/usr/share/arduino/hardware/archlinux-arduino/avr/cores/arduino -I/usr/share/arduino/hardware/archlinux-arduino/avr/variants/standard

C_OPTIONS = ${C_FLAGS} ${C_OPTIMIZE} ${C_WARNINGS} ${C_PROCESSOR}

compile:
	/usr/bin/avr-gcc ${C_OPTIONS} ${C_INPUT} -o ${C_OUTPUT}


# === LINKING ===
L_FLAGS = -w -Os -g
L_OPTIMIZE = -flto -fuse-linker-plugin
L_WARNINGS = -Wl,--gc-sections
L_CPU = -mmcu=atmega328p
L_OPTIONS = ${L_FLAGS} ${L_OPTIMIZE} ${L_WARNINGS} ${L_CPU}

L_INPUT = ${C_OUTPUT}
L_OUTPUT = "blink.elf"

L_LIBS = -lm

link: compile
	/usr/bin/avr-gcc ${L_OPTIONS} ${L_LIBS} ${L_INPUT} -o ${L_OUTPUT}  


# === CONVERTING ===
# -O ... = output target
# -R ... = remove section
# -j ... = use only this section

CONV_IN = ${L_OUTPUT}
CONV_OUT = "blink.hex"

#probably not needed, just rescues the eeprom section (and what is that?)
#/usr/bin/avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0  ${CONV_IN} ${CONV_OUT}.eep

convert: link
	/usr/bin/avr-objcopy -O ihex -R .eeprom ${CONV_IN} ${CONV_OUT}

# === UPLOAD ===
# -C... = load config file
# -V = do NOT verify
# -v = verbose
# -p... = AVR device
# -c... = programmer type
# -P... = connection Port
# -b... = Baud rate (bits per second?)
# -D = disable auto erase for flash mem
# -F = override invalid sig. check (= force?)
# -U<memtype>:<r|w|v>:<file>:<filetype>
# -Uflash:w:file.hex:i  = write "file.hex" of type intelHEX to flash memory

UP_INPUT = ${CONV_OUT}

upload: convert
	/bin/avrdude -C/etc/avrdude.conf -v -patmega328p -carduino -P/dev/ttyACM0 -b115200 -D -Uflash:w:${UP_INPUT}:i 


.PHONY: clean all
all: upload

clean:
	rm blink.d blink.elf blink.hex blink.o
