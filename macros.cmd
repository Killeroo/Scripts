rem macros.cmd version 3
:: Sources: https://superuser.com/a/231032


@ECHO OFF
GOTO :Setup
ECHO ON
EXIT

:Setup
ECHO.
CALL :check_if_admin
CALL :load_values
CALL :setup_macros
:: Locate exectuables
:: Add windows logo

ECHO.
ECHO Welcome to [%computername%] Matthew . . . 
GOTO:eof

:check_if_admin
NET SESSION >nul 2>&1r
if %errorLevel% == 0 (
	ECHO Running as Administrator 
) else (
	ECHO Not Running as Administrator
	CHOICE /M "Would you like to elevate cmd "
	IF %errorlevel% EQU 0 (
		ECHO I've copied %dp0~
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
GOTO:eof

:setup_macros
ECHO Setting up macros...
:: ORDER
DOSKEY ?=doskey /macros
DOSKEY p=powershell
DOSKEY c=start %CD%Code\NetworkTest\ConnectionPing.bat :: FIX PATH
DOSKEY reset=color 07
DOSKEY a=dir /o:d
DOSKEY ls=dir /a:h
DOSKEY open=start .
DOSKEY networktest=%~dp0Code\NetworkTest\NetworkTest.bat :: FIX PATH
DOSKEY backup=%CD%gobackitup.exe :: FIX PATH
DOSKEY edit=%~dp0micro.exe :: FIX PATH
DOSKEY rain=powershell.exe %CD%Code\Powershell\rainbow.ps1 :: FIX PATH
DOSKEY drives=type %TEMP%\tempDriveInfo.txt :: BUG: variable is being overwritten with each line in the text file, HACK: Just type out the text file?
:: ADD GIT: Maybe add option to specify utility memory stick
GOTO:eof

:print_windows_logo
:: SHORTEN & ESCAPE
@(("         ,.=:^!^!t3Z3z.,`n","red"), ("        :tt:::tt333EE3`n","red"),("        Et:::ztt33EEE","red"),("  @Ee.,      ..,`n","green"),("       ;tt:::tt333EE7","red"),(" ;EEEEEEttttt33#`n","green"),("      :Et:::zt333EEQ.","red"),(" SEEEEEttttt33QL`n","green"),("      it::::tt333EEF","red"),(" @EEEEEEttttt33F`n","green"),("     ;3=*^``````'*4EEV","red"),(" :EEEEEEttttt33@.`n","green"),("     ,.=::::it=.,","cyan"),(" ``","red"),(" @EEEEEEtttz33QF`n","green"),("    ;::::::::zt33)","cyan"),("   '4EEEtttji3P*`n","green"),("   :t::::::::tt33.","cyan"),(":Z3z..","yellow"),("  ````","green"),(" ,..g.`n","yellow"),("   i::::::::zt33F","cyan"),(" AEEEtttt::::ztF`n","yellow"),("  ;:::::::::t33V","cyan"),(" ;EEEttttt::::t3`n","yellow"),("  E::::::::zt33L","cyan"),(" @EEEtttt::::z3F`n","yellow"),(" {3=*^``````'*4E3)","cyan"),(" ;EEEtttt:::::tz```n","yellow"),("             ``","cyan"),(" :EEEEtttt::::z7`n","yellow"),("                 'VEzjt:;;z>*```n","yellow"),("                      ````","yellow")) | Foreach-Object {Write-Host $_[0] -ForegroundColor $_[1] -NoNewline}


GOTO:eof

rem SET command=/k `"%~dp0macros.cmd`"
rem SET command=/s /k %~dp0macros.cmd
rem powershell.exe -Command "&{ start-process \"%cd%\test.bat\" -verb runas }
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList `"%command%`""
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList "%command%""
rem powershell.exe -command "Start-Process cmd.exe %command% -verb RunAs"
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList `"%command%`""