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
	nasm -g -f $(format) -l .build/primes.list -o .build/primes.o main.asm
	gcc .build/primes.o -o .build/primes

.build:
	mkdir -p .build
