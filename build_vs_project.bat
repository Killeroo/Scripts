@echo off

:: build_vs_project.bat
:: Uses msbuild to build a Visual Studio project

:: Arguments check
if [%~1]==[] (
    echo.
    echo ERROR: Not enough Arguments
    echo USAGE: build_vs_project.bat [C:\path\to\project.sln]
    exit /b 1
)

:: Setup paths and variables
set dotnet_framework_version=v4.0.30319
set build_configuration=debug
set build_verbosity=normal
set project_path=%~f1
set msbuild_path="%WINDIR%\Microsoft.NET\Framework64\%dotnet_framework_version%\msbuild.exe"

:: Check paths exist
IF NOT EXIST %source_file_path% (
	echo ERROR: source file not found at:
	echo %source_file_path%
	exit /b 1
)

:: Run build command
%msbuild_path% %project_path% /p:configuration=%build_configuration% /verbosity:%build_verbosity%
