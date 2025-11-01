default:
	nasm boot.asm -o boot.bin
	qemu-system-x86_64 -no-reboot -drive format=raw,file=boot.bin,index=0,if=floppy, -m 1009K
size:
	python3 size.py
