@echo off
rem
rem  Uses SED to generate the module definition file for linking into
rem  a DLL, and the rsxdll.h header that tricks DLL variable references
rem  into working with RSXNT.
rem

echo *** Warning !!!
echo  Using this script to generate the DLL export definition files may break
echo  binary compatibility with the latest release. Use misc/fixdll.sh instead.
echo ***

echo Scanning for API symbols...
gcc -E -I. -I./include -DSCAN_EXPORT -DALLEGRO_API -o _apidef.tmp misc/scanexp.c
sed -n -e "s/^ *allexp[fi][un][nl]  *\**\(.*\)_sym.*/    \1/p" _apidef.tmp > _apidef1.tmp
sed -n -e "s/^ *allexp[vfa][apr][rtr]  *\**\(.*\)_sym.*/    \1 DATA/p" _apidef.tmp >> _apidef1.tmp
sort _apidef1.tmp > _apidef2.tmp

echo Scanning for WINAPI symbols...
gcc -E -I. -I./include -DSCAN_EXPORT -DALLEGRO_WINAPI -o _wapidef.tmp misc/scanexp.c
sed -n -e "s/^ *allexp[fi][un][nl]  *\**\(.*\)_sym.*/    \1/p" _wapidef.tmp > _wapidef1.tmp
sed -n -e "s/^ *allexp[vfa][apr][rtr]  *\**\(.*\)_sym.*/    \1 DATA/p" _wapidef.tmp >> _wapidef1.tmp
sort _wapidef1.tmp > _wapidef2.tmp

echo Scanning for internal symbols...
gcc -E -I. -I./include -DSCAN_EXPORT -DALLEGRO_INTERNALS -o _intdef.tmp misc/scanexp.c
sed -n -e "s/^ *allexp[fi][un][nl]  *\**\(.*\)_sym.*/    \1/p" _intdef.tmp > _intdef1.tmp
sed -n -e "s/^ *allexp[vfa][apr][rtr]  *\**\(.*\)_sym.*/    \1 DATA/p" _intdef.tmp >> _intdef1.tmp
sort _intdef1.tmp > _intdef2.tmp

copy _apidef2.tmp + _wapidef2.tmp + _intdef2.tmp _alldef2.tmp > nul

echo ; generated by fixdll.bat > _all.def
echo EXPORTS >> _all.def
sed -e "p" -e "=" -e "d" _alldef2.tmp > _alldef3.tmp
sed -e "N" -e "s/\n/ @/" -e "s/DATA \(.*\)/\1 DATA/" _alldef3.tmp >> _all.def

echo Generating...
echo  lib\msvc\allegro.def
copy _all.def lib\msvc\allegro.def > nul

echo  lib\mingw32\allegro.def
copy _all.def lib\mingw32\allegro.def > nul

echo  include\allegro\rsxdll.h
echo /* generated by fixdll.bat for RSXNT */ > include\allegro\rsxdll.h
sed -n -e "s/^allexp[vf][ap][rt] *\**\(.*\)_sym.*/#define \1 (*\1)/p" _apidef.tmp >> include\allegro\rsxdll.h
sed -n -e "s/^allexp[vf][ap][rt] *\**\(.*\)_sym.*/#define \1 (*\1)/p" _wapidef.tmp >> include\allegro\rsxdll.h
sed -n -e "s/^allexp[vf][ap][rt] *\**\(.*\)_sym.*/#define \1 (*\1)/p" _intdef.tmp >> include\allegro\rsxdll.h

del _*def*.tmp
del _all.def

echo Done!
