@echo off
::small size 500px photo links parser and downloader
::settings
setlocal ENABLEDELAYEDEXPANSION

::download src files from Links.txt
set vidz=0
for /F "tokens=*" %%A in (Links.txt) do (
    SET /A vidz=!vidz! + 1
	wget -O "%vidz%" "%%A"
	grep -ao ":2048.*store_d" "%vidz%">%vidz%a
	grep -ao "http.*https_" "%vidz%a">%vidz%b
	grep -ao "http.*," "%vidz%b">%vidz%c
	bin\sed -f replace.sed "%vidz%c">%vidz%d
	bin\sed -f cleanup.sed "%vidz%d">>parselinks.txt
	rm %vidz%*
)
::download data from links
for /F "tokens=*" %%i in (parselinks.txt) do (
    SET /A vidy=!vidy! + 1
	cd export
    wget "%%i"
	cd ..
)
cd export
FOR /F %%i in ('dir /b/s/A-d') DO (
  if "%%~xi" == "" rename "%%~fi" "%%~ni.jpg"
)
cd ..
rm parselinks.*
copy NUL Links.txt