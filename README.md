# DOS2
A boot sector OS that I'm working on.
# To run
Dependencies: qemu (to run on a virtual machine), dd (to run on a physical machine), nasm (optional for making changes)
Run on qemu: `qemu-system-x86_64 -drive format=raw,file=boot.bin,index=0,if=floppy, -m 1024K`
Run on a physical machine by a USB stick: `sudo dd if=boot.bin of=/dev/sda && sync`
# Attention! The sda device may not be correct so you want to check which it is. It is always /dev/sd and a USB drive letter
## PC requirements:
CPU: Any 16-bit or more CPU that supports BIOS interrupts 0x10 for printing characters, 0x16 for keyboard input and 0x15 for poweroff
RAM: atleast 1009 Kilobytes (from testing in qemu)
Storage: atleast 512-bytes (its a bootsector OS, duh)
GPU: None :)
Display: Any display that supports VGA text mode 0x03
