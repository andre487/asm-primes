UNAME_S = $(shell uname -s)
$(info UNAME_S: $(UNAME_S))

ifeq ($(UNAME_S), Darwin)
	platform = MacOS
	format = macho64
else ifeq ($(UNAME_S), Linux)
	platform = Linux
	format = elf64
else
	$(error Unsupported platform)
endif

all: .build
	nasm -f $(format) main.asm -o .build/primes.o
	$(GCC) .build/primes.o -o .build/primes

.build:
	mkdir -p .build
