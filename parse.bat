@echo off
setlocal EnableDelayedExpansion
IF NOT EXIST export mkdir export

bin\wc -l links.txt | bin\grep -ao "[0-9]*">no
set /p no=<no
title Total images: %no%

for /F "tokens=*" %%A in (Links.txt) do (
   echo %%A | bin\grep -ao ".*\/.*[0-9]\/">>links.tmp
)


for /F "tokens=*" %%B in (links.tmp) do (
   SET /A vidz=!vidz! + 1
   echo processing link !vidz!/%no% 
   bin\wget -qO "!vidz!a.txt" "https://500px.com/oembed?url=%%B&format=json"
   bin\grep -ao "https:\/\/d.[a-z0-9].*,.w" "!vidz!a.txt" | bin\sed -f cleanup.sed>>parselinks.txt
   bin\rm !vidz!*
   cls
)


for /F "tokens=*" %%c in (parselinks.txt) do (
    echo downloading photo %%c/%no% 
	wget -q "%%c"
	cls
)


FOR /F %%i in ('dir /b/s/A-d') DO (
  if "%%~xi" == "" rename "%%~fi" "%%~ni.jpg"
)
bin\cp *.jpg export\
bin\rm parselinks.* links.tmp *.jpg *.1
echo done.
copy NUL Links.txt