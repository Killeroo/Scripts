@ECHO OFF
:: check if git is installed

SET origin=%CD%

FOR /d %%i in (%origin%\*) DO (
	cd "%%i"
	cd
	
	git pull
	
	CALL :msbuild

)
cd %origin%

pause

:main

GOTO:eof

:msbuild
GOTO:eof

:netcorebuild
GOTO:eof

:gobuild
GOTO:eof

:copyBuildFiles

:sendBuildFiles
GOTO:eof