#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf64-x86-64 -m elf_x86_64  -rpath ./ -rpath $$ORIGIN --dynamic-linker=/lib64/ld-linux-x86-64.so.2     -L. -o /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp -T /root/Documentos/opentef/publica/binarios/opentef/linux64/link22651.res -e _start
if [ $? != 0 ]; then DoExitLink /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp; fi
IFS=$OFS
echo Linking /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp
OFS=$IFS
IFS="
"
/usr/bin/objcopy --only-keep-debug /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp.dbg
if [ $? != 0 ]; then DoExitLink /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp; fi
IFS=$OFS
echo Linking /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp
OFS=$IFS
IFS="
"
/usr/bin/objcopy "--add-gnu-debuglink=/root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp.dbg" /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp
if [ $? != 0 ]; then DoExitLink /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp; fi
IFS=$OFS
echo Linking /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp
OFS=$IFS
IFS="
"
/usr/bin/strip --strip-unneeded /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp
if [ $? != 0 ]; then DoExitLink /root/Documentos/opentef/publica/binarios/opentef/linux64/opentefapp; fi
IFS=$OFS
