@ECHO OFF
:: check if git is installed

SET origin=%CD%

FOR /d %%i in (%origin%\*) DO (
	cd "%%i"
	cd
	git pull
)
cd %origin%

pause