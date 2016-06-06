@echo off
::settings
setlocal EnableDelayedExpansion
mkdir export
::cleaning up links #1
for /F "tokens=*" %%A in (Links.txt) do (
   echo %%A | bin\grep -ao ".*\/.*[0-9]\/">>links.tmp
)
::cleaning up links #2
for /F "tokens=*" %%B in (links.tmp) do (
   SET /A vidz=!vidz! + 1
   title processing link !vidz! 
   bin\wget -qO "!vidz!a.txt" "https://500px.com/oembed?url=%%B&format=json"
   bin\grep -ao "https:\/\/d.[a-z0-9].*,.w" "!vidz!a.txt" | bin\sed -f cleanup.sed>>parselinks.txt
   bin\rm !vidz!*
)
::download data from links
for /F "tokens=*" %%c in (parselinks.txt) do (
    title downloading photo %%c
	wget -q "%%c"
)
FOR /F %%i in ('dir /b/s/A-d') DO (
  if "%%~xi" == "" rename "%%~fi" "%%~ni.jpg"
)
bin\cp *.jpg export\
bin\rm parselinks.* links.tmp *.jpg
title done
::copy NUL Links.txt