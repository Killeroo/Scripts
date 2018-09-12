rem build_vs_project.bat
rem Uses msbuild to build a Visual Studio project
@echo off

:: Arguments check
if [%~1]==[] (
    echo.
    echo ERROR: Not enough Arguments
    echo USAGE: build_vs_project.bat [C:\path\to\project.sln]
    exit /b 1
)
set projectPath=%~f1

:: Set .NET 4.6 framework path
set msbuildPath="%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\"

:: Save starting directory
set origDir=%~dp0

:: Goto msbuild dir
cd %msbuildPath%

:: Run build command
msbuild.exe %projectPath% /p:configuration=release

pause