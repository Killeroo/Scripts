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
CALL :print_windows_logo
CALL :print_pc_info
CALL :locate_executables
:: Download executables?

ECHO Welcome to [%computername%] Matthew . . . 
GOTO:eof

:check_if_admin
NET SESSION >nul 2>&1r
if %errorLevel% == 0 (
	ECHO Running as Administrator 
) else (
	ECHO Not Running as Administrator
	CHOICE /M "Would you like to elevate cmd "
	ECHO %errorlevel%
	IF %errorlevel% EQU 0 (
		ECHO %~dp0 | clip
		ECHO I've copied this location to your clipboard,
		ECHO See you soon.
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
:: ADD POWERPING
GOTO:eof

:print_windows_logo
:: Witness me.
ECHO.
ECHO.
powershell -c "$r=\"red\";$g=\"green\";$c=\"cyan\";$y=\"yellow\";@(((\" \"*9+\",.=:^^!^^!t3Z3z.,`n\"),$r), ((\" \"*8+\":tt:::tt333EE3`n\"),$r),((\" \"*8+\"Et:::ztt33EEE\"),$r),(\"  @Ee.,      ..,`n\",$g),((\" \"*7+\";tt:::tt333EE7\"),$r),(\" ;EEEEEEttttt33#`n\",$g),((\" \"*6+\":Et:::zt333EEQ.\"),$r),(\" SEEEEEttttt33QL`n\",$g),((\" \"*6+\"it::::tt333EEF\"),$r),(\" @EEEEEEttttt33F`n\",$g),(\"     ;3=*^``````'*4EEV\",$r),(\" :EEEEEEttttt33@.`n\",$g),(\"     ,.=::::it=.,\",$c),(\" ``\",$r),(\" @EEEEEEtttz33QF`n\",$g),(\"    ;::::::::zt33)\",$c),(\"   '4EEEtttji3P*`n\",$g),(\"   :t::::::::tt33.\",$c),(\":Z3z..\",$y),(\"  ````\",$g),(\" ,..g.`n\",$y),(\"   i::::::::zt33F\",$c),(\" AEEEtttt::::ztF`n\",$y),(\"  ;:::::::::t33V\",$c),(\" ;EEEttttt::::t3`n\",$y),(\"  E::::::::zt33L\",$c),(\" @EEEtttt::::z3F`n\",$y),(\" {3=*^``````'*4E3)\",$c),(\" ;EEEtttt:::::tz```n\",$y),((\" \"*13+\"``\"),$c),(\" :EEEEtttt::::z7`n\",$y),((\" \"*18+\"'VEzj;;z^>*```n\"),$y),((\" \"*22+\"````\"),$y)) | Foreach-Object {Write-Host $_[0] -ForegroundColor $_[1] -NoNewline}"
ECHO.
ECHO.
GOTO:eof

:print_pc_info
powershell -c "Write-Host(\"\\\\\") -nonewline;Write-Host((Get-WmiObject win32_computersystem).Domain) -ForegroundColor DarkGreen -nonewline;Write-Host(\"\\\") -nonewline;Write-Host((Get-WmiObject win32_computersystem).Name + \" \") -ForegroundColor Green -nonewline ; Write-Host([math]::Round((Get-WmiObject win32_computersystem).TotalPhysicalMemory/1GB)) -ForegroundColor red -nonewline; Write-Host(\"GB \") -ForegroundColor red -nonewline; Write-Host((Get-WmiObject win32_processor).Name + \" \") -ForegroundColor yellow -nonewline; Write-Host((Get-WmiObject win32_videocontroller).Name) -ForegroundColor cyan"
ECHO.
GOTO:eof

:: Source: https://stackoverflow.com/a/9066394
:locate_executables
:: Find memory stick with label 'UTILS'
for /f %%D in ('wmic volume get DriveLetter^, Label ^| find "UTILS"') do set usb=%%D
IF "%usb%"=="" (
	ECHO Not Found
	PAUSE
) ELSE (
	ECHO Found
	PAUSE
)

GOTO:eof

rem SET command=/k `"%~dp0macros.cmd`"
rem SET command=/s /k %~dp0macros.cmd
rem powershell.exe -Command "&{ start-process \"%cd%\test.bat\" -verb runas }
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList `"%command%`""
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList "%command%""
rem powershell.exe -command "Start-Process cmd.exe %command% -verb RunAs"
rem powershell.exe -command "Start-Process cmd.exe -verb RunAs -ArgumentList `"%command%`""