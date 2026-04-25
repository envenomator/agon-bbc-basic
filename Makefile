# Project name
NAME = bbcbasic

# Emulator SDcard destination defaults to /bin if not set by the user
FAE_DEST ?= /bin

# verbosity - comment next line to show all output
#V = @

# Link project
LINK = 1

# project directories
SRCDIR=src
OBJDIR=obj
BINDIR=bin
INCLUDEDIR=./include
LINKERCONFIG=./config/linker.conf

# Architecture
ARCH=ez80+full
TARGET=ez80-none-elf

# Tools and flags
## Assembler
ASM=ez80-none-elf-as
ASMFLAGS=-march=$(ARCH) -I $(INCLUDEDIR)
## Linker
LINKER=ez80-none-elf-ld
LINKERFLAGS=$(LINKER_ARG) $(LINKER_EXIT) -Map=$(BINDIR)/$(NAME).map -T $(LINKERCONFIG) --oformat binary -o 

# Final binary
BINARY=$(BINDIR)/$(NAME).bin

# Automatically get all object names from sourcefiles
OBJS=$(patsubst $(SRCDIR)/%.asm, $(OBJDIR)/%.o, $(shell find $(SRCDIR) -name '*.asm')) \
     $(patsubst $(SRCDIR)/%.s,   $(OBJDIR)/%.o, $(shell find $(SRCDIR) -name '*.s')) \

# Default rule
all: $(BINDIR) $(BINARY)
	@echo [Done]

# Final binary
$(BINARY): $(BINDIR) $(OBJS)
	@echo [Linking $(BINARY)]
ifeq ($(LINK),1)
	$(V)$(LINKER) $(LINKERFLAGS)$@ $(OBJS)
else
	@echo Skipping linker stage
endif

# Assemble each .s file into .o file
$(OBJDIR)/%.o: $(SRCDIR)/%.s
	@echo [assembling $<]
	@mkdir -p $(dir $@)
	$(V)$(ASM) $(ASMFLAGS) $< -o $@
# Assemble each .asm file into .o file
$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@echo [assembling $<]
	@mkdir -p $(dir $@)
	$(V)$(ASM) $(ASMFLAGS) $< -o $@

upload: $(BINDIR) $(BINARY)
ifeq ($(SERIALPORT),)
	@echo [No SERIALPORT in Makefile - autodetect]
	@SERIALPORT=auto
endif
	@echo [Starting hexload-send]
	@hexload-send $(BINARY) $(SERIALPORT) $(BAUDRATE)

.PHONY: emulator emu em
emu: emulator
em: emulator
emulator: copy
	@echo [Starting emulator]
	@cd $(FAE_HOME) && ./fab-agon-emulator $(FAE_ARGS)

.PHONY: copy cp cp2em
cp: copy
cp2em: copy
copy: all
	@if [ -z "$(FAE_HOME)" ]; then \
		echo "ERROR: FAE_HOME is not set!"; \
		exit 1; \
	fi
	@echo [Copying $(BINARY) to emulator sdcard:$(FAE_DEST)]
	@cp -f $(BINARY) $(FAE_HOME)/sdcard$(FAE_DEST)
	@echo [Done]

# Directories to create
$(BINDIR):
	@mkdir $(BINDIR)

clean:
	@$(RM) -r $(BINDIR) $(OBJDIR) 
