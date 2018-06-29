rem macros.cmd version 2
@ECHO OFF
GOTO :Setup
ECHO ON
EXIT

:Setup
ECHO.
ECHO Welcome to %computername% Matthew. . . 
CALL :check_if_admin
CALL :load_values
CALL :setup_macros
GOTO:eof

:check_if_admin
NET SESSION >nul 2>&1r
if %errorLevel% == 0 (
	ECHO Running as Administrator 
) else (
	ECHO Not Running as Administrator
	CHOICE /M "Would you like to elevate cmd? "
	IF %errorlevel% EQU 0 (
		ECHO Attempting to Elevate Command Prompt. . . 
		powershell.exe -Command "Start-Process cmd.exe -verb RunAs" >nul 2>&1 && EXIT
		ECHO Elevation failed.
	)
)
GOTO:eof

:load_values
ECHO Prebaking some vars...
FOR /f %%i in ('powershell -C "get-wmiobject win32_logicaldisk | Foreach {\"[\" + $_.DeviceID + \"] [\" + $_.description  + \"] [\" + $_.filesystem +  \"] free/size [\" + [math]::truncate($_.freespace / 1GB) + \"GB/\" + [math]::truncate($_.size / 1GB) + \"GB] type[\" + $_.drivetype + \"] name [\" + $_.volumename + \"]\"}"') DO SET "other=%%i"
powershell -C "get-wmiobject win32_logicaldisk | Foreach {\"[\" + $_.DeviceID + \"] [\" + $_.description  + \"] [\" + $_.filesystem +  \"] free/size [\" + [math]::truncate($_.freespace / 1GB) + \"GB/\" + [math]::truncate($_.size / 1GB) + \"GB] type[\" + $_.drivetype + \"] name [\" + $_.volumename + \"]\"}" > %TEMP%\tempDriveInfo.txt
set /p drive_list=< %TEMP%\tempDriveInfo.txt
set pc_info=
GOTO:eof

:setup_macros
DOSKEY ?=doskey /macros
DOSKEY p=powershell
DOSKEY c=start %CD%Code\NetworkTest\ConnectionPing.bat
DOSKEY reset=color 07
DOSKEY a=dir /o:d
DOSKEY ls=dir /a:h
DOSKEY open=start .
DOSKEY networktest=%~dp0Code\NetworkTest\NetworkTest.bat
DOSKEY backup=%CD%gobackitup.exe
DOSKEY info=
DOSKEY edit=%~dp0micro.exe
DOSKEY rain=powershell.exe %CD%Code\Powershell\rainbow.ps1
DOSKEY drives=echo %drive_list%
DOSKEY something=ECHO %other%
GOTO:eof

rem SET command=/k `"%~dp0macros.cmd`"
rem SET command=/s /k %~dp0macros.cmd
rem powershell.exe -Command "&{ start-process \"%cd%\test.bat\" -verb runas }
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList `"%command%`""
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList "%command%""
rem powershell.exe -command "Start-Process cmd.exe %command% -verb RunAs"
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList `"%command%`""