from os import system as sh
file = open('boot.asm', 'r')
code = file.read()
code = code[:-32]
file.close()
file = open('tmp.asm', 'w')
file.write(code)
file.close()
sh('nasm tmp.asm')
sh('stat tmp')
sh('rm tmp.asm')
sh('rm tmp')
