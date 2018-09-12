@ECHO OFF
SET origin=%~dp0
set msbuildPath="%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\"

:main
FOR /d %%i in (%origin%\*) DO (
	cd "%%i"
	cd
	
	git pull
	
	CALL :msbuild

)
cd %origin%
GOTO:eof

:msbuild
:: Set .NET 4.6 framework path

SET projectpath=
:: Save starting directory
set origDir=%~dp0

:: Goto msbuild dir
cd %msbuildPath%

:: Run build command
msbuild.exe %projectpath% /p:configuration=release

GOTO:eof

:netcorebuild
GOTO:eof

:gobuild
:: https://golang.org/doc/install/source#environment
set GOARCH=amd64
set GOOS=windows
go tool dist install -v pkg/runtime
go install -v -a std
GOTO:eof

:copyBuildFiles
GOTO:eof

:sendBuildFiles
BasicTransfer --send
GOTO:eof