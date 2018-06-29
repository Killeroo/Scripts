@ECHO off

::AuditScan.bat v1.0
::Written by Matthew Carney - 12/2017
::matthewcarney64@gmail.com =^-^=

SETLOCAL ENABLEDELAYEDEXPANSION

:Main
::CALL :ProcessFirewallRules
::PAUSE

ECHO --Scan started--
CALL :Setup
CALL :GenerateLog
CALL :Cleanup
ECHO --Scan complete--
ECHO.
PAUSE
GOTO:eof

:Setup
:: Save starting path
SET ORIGINAL_PATH=%~dp0

:: Make sure we are in root C:
C: 
GOTO:eof

:Cleanup
:: Restore to original path
CD %ORIGINAL_PATH%
GOTO:eof

:GenerateLog
:: Get pc name
ECHO Fetching PC name...
FOR /f "skip=1 delims=" %%A IN (
  'wmic computersystem get name'
) DO FOR /f "delims=" %%B IN ("%%A") DO SET "PCName=%%A"

:: Generate log file name
SET LOG_NAME=%PCName%_Log.txt
SET "LOG_NAME=%LOG_NAME: =%"

:: Get current date and time
ECHO Getting local time...
FOR /F "usebackq tokens=1,2 delims==" %%i IN (`wmic os get LocalDateTime /VALUE 2^>NUL`) DO IF '.%%i.'=='.LocalDateTime.' SET ldt=%%j
SET ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%

:: Test internet connection
ECHO Testing internet connection...
PING 8.8.8.8 -n 1 -w 1000 >nul
IF %ERRORLEVEL% EQU 1 (
	SET InternetStatus=DISCONNECTED
) ELSE (
	SET InternetStatus=CONNECTED
)

:: Get processor info
ECHO Fetching processor details...
for /f "delims=" %%a IN (' powershell -C "Get-Wmiobject win32_processor | Foreach {$_.name}" ') DO SET "processor_name=%%a"

:: Get RAM info
ECHO Getting avaliable RAM...
for /f "delims=" %%a IN (' powershell -C "Get-Wmiobject win32_computersystem | Foreach {[math]::truncate($_.totalphysicalmemory / 1gb)}" ') DO SET "avaliable_ram=%%a"

:: Get video card info 
ECHO Fetching video card details...
FOR /f "delims=" %%a IN (' powershell -C "Get-Wmiobject win32_videocontroller | Foreach {$_.name}" ') DO SET "videocard_name=%%a"

:: Get OS info 
ECHO Obtaining OS version...
FOR /f "delims=" %%a IN (' powershell -C "Get-Wmiobject win32_operatingsystem | Foreach {$_.caption + \" v\" + $_.version}" ') DO SET "os_version=%%a"

:: Head of log file
ECHO PC Scan Log > %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO %PCName% @ [%ldt%] >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Internet [%InternetStatus%] >> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Hardware details
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Hardware Specifications >> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Operating System: %os_version% >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Architecture: %PROCESSOR_ARCHITECTURE% >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Processor: %processor_name% >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Physical Memory: %avaliable_ram%GB >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Graphics Card: %videocard_name% >> %ORIGINAL_PATH%%LOG_NAME%
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Drive info
ECHO Getting drive info...
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Drive Information >> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
:: Get-Wmiobject win32_logicaldisk | Format-List * For all options
powershell -C "get-wmiobject win32_logicaldisk | Foreach {\"[\" + $_.DeviceID + \"] [\" + $_.description  + \"] [\" + $_.filesystem +  \"] free/size [\" + [math]::truncate($_.freespace / 1GB) + \"GB/\" + [math]::truncate($_.size / 1GB) + \"GB] type[\" + $_.drivetype + \"] name [\" + $_.volumename + \"]\"}" >> %ORIGINAL_PATH%%LOG_NAME%
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Get list of programs 
ECHO Scanning installed programs...
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME% 
ECHO Installed Programs >> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------->> %ORIGINAL_PATH%%LOG_NAME%
CD "C:\Program Files"
DIR /b >> %ORIGINAL_PATH%%LOG_NAME%
CD "C:\Program Files (x86)"
DIR /b >> %ORIGINAL_PATH%%LOG_NAME%
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Get powershell script policy
ECHO Getting PowerShell script policy...
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO PowerShell >> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
:: Get-Wmiobject win32_logicaldisk | Format-List * For all options
FOR /f "delims=" %%a IN (' powershell -C Get-ExecutionPolicy') DO SET "script_policy=%%a"
ECHO Execution Policy: %script_policy% >> %ORIGINAL_PATH%%LOG_NAME%
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Get list of services
ECHO Gathering services...
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Services >> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------->> %ORIGINAL_PATH%%LOG_NAME%
wmic service get name, state, caption | find /v "" >> %ORIGINAL_PATH%%LOG_NAME% 
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Get network adapter configurations
ECHO Gathering network info...
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Network Adapter Configuration >> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------->> %ORIGINAL_PATH%%LOG_NAME%
IPCONFIG /all >> %ORIGINAL_PATH%%LOG_NAME% 
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Firewall status
ECHO Obtaining firewall information...
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME%
ECHO Firewall Status>> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------->> %ORIGINAL_PATH%%LOG_NAME%
netsh firewall show state >> %ORIGINAL_PATH%%LOG_NAME%
ECHO. >> %ORIGINAL_PATH%%LOG_NAME%

:: Get list of firewall rules
ECHO -------------------------------- >> %ORIGINAL_PATH%%LOG_NAME% 
ECHO Firewall Rules>> %ORIGINAL_PATH%%LOG_NAME%
ECHO -------------------------------->> %ORIGINAL_PATH%%LOG_NAME%
netsh advfirewall firewall show rule name=all dir=in type=dynamic >> %ORIGINAL_PATH%%LOG_NAME%

:: Display basic results
ECHO.
ECHO -------------------------------- 
ECHO %PCName% @ [%ldt%]
ECHO Internet [%InternetStatus%] 
ECHO -------------------------------- 
ECHO.

:: Declare location of log
ECHO Full log saved @ %ORIGINAL_PATH%%LOG_NAME%

GOTO:eof

:ProcessFirewallRules
netsh advfirewall firewall show rule name=all dir=in type=dynamic | findstr "Protocol:"
GOTO:eof