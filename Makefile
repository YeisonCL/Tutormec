dev = /dev/sdb
dataFile = -f bin


all:bootloader os about version help exit tutormec install
	cpy $(dev) bootloader os about version help exit tutormec
	@echo "Finalizado... Dispositivo USB listo."
	

bootloader:bootloader.asm
	nasm $(dataFile) bootloader.asm

os:os.asm
	nasm $(dataFile) os.asm

version:version.asm
	nasm $(dataFile) version.asm

tutormec:tutormec.asm
	nasm $(dataFile) tutormec.asm

about:about.asm
	nasm $(dataFile) about.asm

help:help.asm
	nasm $(dataFile) help.asm

exit:exit.asm
	nasm $(dataFile) exit.asm


install:cpy.c
	cc cpy.c -o cpy
	cp cpy /bin/cpy
