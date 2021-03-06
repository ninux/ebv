#!/bin/bash

echo "compile $1"
bfin-uclinux-gcc -c -std=gnu99 -I../../leanXcam/oscar/include -DOSC_TARGET -O2 -elf2flt="-s 1048576" $1.c

echo "link $1 to file app"
bfin-uclinux-gcc -elf2flt="-s 1048576" $1.o ../../leanXcam/oscar/library/libosc_target.a -o app

echo "transfer application"
scp app root@192.168.1.10:/mnt/app/.

echo "transfer index.html"
scp index.html file1.txt file2.txt root@192.168.1.10:/home/httpd/.