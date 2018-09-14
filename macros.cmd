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
CALL :locate_executables
CALL :setup_macros
CALL :print_windows_logo
CALL :print_pc_info

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
DOSKEY reset=color 07
DOSKEY a=dir /o:d
DOSKEY ls=dir /a:h
DOSKEY open=start .
DOSKEY drives=type %TEMP%\tempDriveInfo.txt :: BUG: variable is being overwritten with each line in the text file, HACK: Just type out the text file?

:: Only load program and script macros if utility memory stick
:: has been found
IF NOT "%usb%"=="" (
	:: Programs
	DOSKEY git=%usb%\GitPortable\bin\git.exe
	DOSKEY powerping=%usb%\PowerPing.exe
	DOSKEY httpping=%usb%\HttpPing.exe
	DOSKEY gobackitup=%usb%\gobackitup.exe
	DOSKEY skimmer=%usb%\skimmer.exe
	DOSKEY stitcher=%usb%\stitcher.exe
	DOSKEY basictransfer=%usb%\BasicTransfer.exe
	DOSKEY clock=%usb%\ConsoleClock.exe
	DOSKEY xsv=%usb%\xsv.exe
	DOSKEY micro=%usb%\micro.exe
	DOSKEY lua=%usb%\lua53.exe
	DOSKEY taskmanager=START %usb%\procexp64.exe
	DOSKEY tcpview=START %usb%\tcpview.exe

	:: Scripts
	DOSKEY networktest=START %usb%\NetworkTests\NetworkTest\NetworkTest.bat
	DOSKEY colouredping=START %usb%\Scripts\colour_ping.bat
	DOSKEY scrape=Powershell.exe -f %usb%\Scripts\scrape-files.ps1
	DOSKEY update=START %usb%\Scripts\update_repos.bat
	DOSKEY scan=START %usb%\Scripts\AuditScan.ps1
	DOSKEY rain=Powershell.exe -f %usb%\Scripts\rain.ps1

	:: Example of passing arguments through to doskey macro
	::doskey s=if $1. equ . ("C:\Program Files (x86)\Git\bin\sh.exe" --login) else "C:\Program Files (x86)\Git\bin\sh.exe" --login -c "$*"
)
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
powershell -c "Write-Host(\"\\\\\") -nonewline;Write-Host((Get-WmiObject win32_computersystem).Domain) -ForegroundColor DarkGreen -nonewline;Write-Host(\"\\\") -nonewline;Write-Host((Get-WmiObject win32_computersystem).Name + \" \") -ForegroundColor Green -nonewline ; Write-Host([math]::Round((Get-WmiObject win32_computersystem).TotalPhysicalMemory/1GB)) -ForegroundColor red -nonewline; Write-Host(\"GB \") -ForegroundColor red -nonewline; Write-Host((Get-WmiObject win32_processor).Name + \" \") -ForegroundColor yellow -nonewline; Write-Host((Get-WmiObject win32_videocontroller).Name) -ForegroundColor cyan; Write-Host ((gwmi Win32_NetworkAdapterConfiguration|?{$_.ipenabled}).IPAddress) -ForegroundColor Magenta"
ECHO.
GOTO:eof
::-replace "`t|`n|`r",""

:locate_executables
:: Find memory stick with label 'UTILS'
:: Source: https://stackoverflow.com/a/9066394
for /f %%D in ('wmic volume get DriveLetter^, Label ^| find "UTILS"') do set usb=%%D
IF "%usb%"=="" (
	ECHO Could not find utility drive.
	ECHO Executables and additional scripts will not be loaded.
	ECHO Please insert usb with label 'UTILS' to load from
	:: TODO: add option to specify utility memory stick
	GOTO:eof
) ELSE (
	ECHO Utility drive found.
)
GOTO:eof