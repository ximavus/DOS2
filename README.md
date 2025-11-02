# DOS2<br/>
A boot sector OS that I'm working on.<br/>
# To run<br/>
Dependencies: qemu (to run on a virtual machine either), dd (to run on a physical machine), nasm (to compile)<br/>
Build (optional the repo has the prebuilt binary): `make`<br/>
Run: `qemu-system-x86_64 -drive format=raw,file=boot.bin,index=0,if=floppy, -m 1M`
Run on a physical machine by a USB stick: `nasm boot.asm -o boot.bin`<br/>`sudo dd if=boot.bin of=/dev/sda && sync`<br/>
# Attention! The sda device may not be correct so you want to check which it is. It is always /dev/sd and a USB drive letter<br/>
## PC requirements:<br/>
CPU: Any 16-bit or more CPU that supports BIOS interrupts 0x10 for printing characters, 0x16 for keyboard input and 0x15 for poweroff<br/>
RAM: About 1 Megabyte (actual minimum is 1032193 bytes from qemu testing)<br/>
Storage: atleast 512-bytes (its a bootsector OS, duh)<br/>
GPU: None :)<br/>
Display: Any display that supports VGA text mode 0x03<br/>
