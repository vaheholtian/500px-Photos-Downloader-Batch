@echo off
::settings
setlocal EnableDelayedExpansion

::cleaning up links
for /F "tokens=*" %%A in (Links.txt) do (
   SET /A vidz=!vidz! + 1
   title processing link !vidz! 
   bin\wget -qO "!vidz!a.txt" "https://500px.com/oembed?url=%%A&format=json"
   bin\grep -ao "https:\/\/d.[a-z0-9].*,.w" "!vidz!a.txt">!vidz!b.txt
   bin\sed -f cleanup.sed !vidz!b.txt>>parselinks.txt
   rm !vidz!*
)
::bin\rm 1 a b
::download data from links
title downloading photos
for /F "tokens=*" %%i in (parselinks.txt) do (
	cd export
    wget -q "%%i"
	cd ..
)
cd export
FOR /F %%i in ('dir /b/s/A-d') DO (
  if "%%~xi" == "" rename "%%~fi" "%%~ni.jpg"
)
cd ..
rm parselinks.*
title done
::copy NUL Links.txt