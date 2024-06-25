@echo off
SET THEFILE=E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp
echo Linking %THEFILE%
E:\Lazarus_IDE\cross\bin\x86_64-linux\x86_64-linux-gnu-ld.exe -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2     -L. -o E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp -T E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\link22864.res -e _start
if errorlevel 1 goto linkend
SET THEFILE=E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp
echo Linking %THEFILE%
E:\Lazarus_IDE\cross\bin\x86_64-linux\x86_64-linux-gnu-objcopy.exe --only-keep-debug E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp.dbg
if errorlevel 1 goto linkend
SET THEFILE=E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp
echo Linking %THEFILE%
E:\Lazarus_IDE\cross\bin\x86_64-linux\x86_64-linux-gnu-objcopy.exe "--add-gnu-debuglink=E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp.dbg" E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp
if errorlevel 1 goto linkend
SET THEFILE=E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp
echo Linking %THEFILE%
E:\Lazarus_IDE\cross\bin\x86_64-linux\x86_64-linux-gnu-strip.exe --strip-unneeded E:\Lazarus\OpenTef\publica\binarios\opentef\linux64\opentefapp
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
