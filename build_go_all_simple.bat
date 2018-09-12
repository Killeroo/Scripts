@echo off
:: Based off https://github.com/zyedidia/micro/blob/master/tools/cross-compile.sh

set build_name=
set version=

echo Linux 64
set GOARCH=amd64
set GOOS=linux
go build
echo Build finished
gobackitup --source %cd%\%build_name% --destination %cd% --zip --name %build_name%-%version%-linux64

echo Linux 32
set GOARCH=386
set GOOS=linux
go build
echo Build finished
gobackitup --source %cd%\%build_name% --destination %cd% --zip --name %build_name%-%version%-linux32

echo Linux arm
set GOARCH=arm
set GOOS=linux
go build
echo Build finished
gobackitup --source %cd%\%build_name% --destination %cd% --zip --name %build_name%-%version%-linux-arm

echo OSX 64
set GOARCH=amd64
set GOOS=darwin
go build
echo Build finished
gobackitup --source %cd%\%build_name% --destination %cd% --zip --name %build_name%-%version%-osx

echo Windows 64
set GOARCH=amd64
set GOOS=windows
go build
echo Build finished
gobackitup --source %cd%\%build_name%.exe --destination %cd% --zip --name %build_name%-%version%-win64

echo Windows 32
set GOARCH=386
set GOOS=windows
go build
echo Build finished
gobackitup --source %cd%\%build_name%.exe --destination %cd% --zip --name %build_name%-%version%-win32

pause