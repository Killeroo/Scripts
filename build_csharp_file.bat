@echo off

:: build_netframework_cs.bat
:: Build script for building C# applications using the C# Compiler thats
:: included in the .NET Framework installation
:: Source: https://stackoverflow.com/a/553155

:: Arguments check
if [%~1]==[] (
    echo.
    echo ERROR: Not enough Arguments
    echo USAGE: build_netframework_cs.bat [C:\path\to\cs\file.cs]
    exit /b 1
)

:: Setup paths
set dotnet_framework_version=v4.0.30319
set csc_path=%WINDIR%\Microsoft.NET\Framework\%dotnet_framework_version%\csc.exe
set source_file_path=%~f1
set source_file_name=%~sn1

:: Check paths exist
IF NOT EXIST %csc_path% (
	echo ERROR: csc.exe not found at:
	echo %csc_path%
	exit /b 1
)
IF NOT EXIST %source_file_path% (
	echo ERROR: source file not found at:
	echo %source_file_path%
	exit /b 1
)

:: Build the source files
:: NOTE: If you want to compile more files just add them onto the command
%csc_path% /t:exe /out:%~dp0%source_file_name% %source_file_path%