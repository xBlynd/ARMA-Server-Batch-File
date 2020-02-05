@echo off

:: SETTINGS
:: MAKE SURE YOU UPDATE ALL OF THESE
:: WHATEVER YOU ENTER HERE WILL BE USED TO AUTOMATICALLY CREATE, INSTALL AND UPDATE FILES FOR YOU
:: *******WHEN YOU ARE DONE RUN THIS FILE AS ADMINISTRATOR********

:: USE YOUR CORRECT USERNAME AND PASSWORD FOR STEAM
set STEAMLOGIN=username password

:: WHERE YOU NEED TO INSTALL MYSQL WHEN PROMPTED
set PROGRAM_DIRECTORY="C:\Program Files"

:: THE LOCATION YOU WANT THE SERVER TO BE INSTALLED
set SERVER_DIRECTORY=C:\ExileServer

:: MYSQL DATABASE INFO
set DATABASE_NAME=Exile
set DATABASE_USERNAME=root
set DATABASE_PASSWORD=test123

:: RCON INFO
set RCON_PASSWORD=test02
set RCON_PORT=2308

:: ARMA SERVER INFO
set ADMIN_PASSWORD=test03
set SERVER_COMMAND_PASSWORD=test04
set SERVER_NAME="Exile Test Server"

:: MISSION FILE YOU WANT TO RUN: Exile.Altis, Exile.Malden, Exile.Tanoa or Exile.Namalsk
set MISSION_FILE="Exile.Altis"

:: PORT THE SERVER WILL RUN ON
set ARMA_3_SERVER_PORT=2302






:: --------------- DO NOT EDIT BELOW THIS POINT --------------- ::

setlocal ENABLEDELAYEDEXPANSION
echo Creating ExileServer directory...
if not exist %PROGRAM_DIRECTORY% mkdir %PROGRAM_DIRECTORY%
if not exist "%SERVER_DIRECTORY%" mkdir %SERVER_DIRECTORY%
if not exist "%SERVER_DIRECTORY%\steamcmd" mkdir %SERVER_DIRECTORY%\steamcmd
if not exist "%SERVER_DIRECTORY%\Downloads" mkdir %SERVER_DIRECTORY%\Downloads
if not exist "%SERVER_DIRECTORY%\@ExileServer" mkdir %SERVER_DIRECTORY%\@ExileServer
if not exist "%SERVER_DIRECTORY%\keys" mkdir %SERVER_DIRECTORY%\keys
if not exist "%SERVER_DIRECTORY%\SC" mkdir %SERVER_DIRECTORY%\SC
if not exist "%SERVER_DIRECTORY%\SC\battleye" mkdir %SERVER_DIRECTORY%\SC\battleye
if not exist "%SERVER_DIRECTORY%\mpmissions" mkdir %SERVER_DIRECTORY%\mpmissions



:: 7-Zip
if exist %PROGRAM_DIRECTORY%\7-Zip goto DownloadSteamCMD
if exist "%SERVER_DIRECTORY%\Downloads\7z.msi" goto Install7Zip
echo Downloading 7-Zip
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.7-zip.org/a/7z1701-x64.msi', '%SERVER_DIRECTORY%\Downloads\7z.msi') }"

:CheckFor7Zip
if exist "%SERVER_DIRECTORY%\Downloads\7z.msi" goto Install7Zip
timeout /T 30 >nul
goto CheckFor7Zip

:Install7Zip
echo Installing 7-Zip

msiexec /i %SERVER_DIRECTORY%\Downloads\7z.msi INSTALLDIR=%PROGRAM_DIRECTORY%"\7-Zip\" /q



:: SteamCMD
:DownloadSteamCMD
if exist "%SERVER_DIRECTORY%\steamcmd\steamcmd.zip" goto InstallSteamCMD
echo Downloading SteamCMD
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip', '%SERVER_DIRECTORY%\steamcmd\steamcmd.zip') }"

:CheckForSteamCMD
if exist "%SERVER_DIRECTORY%\steamcmd\steamcmd.zip" goto InstallSteamCMD
timeout /T 30 >nul
goto CheckForSteamCMD

:InstallSteamCMD
if exist "%SERVER_DIRECTORY%\steamcmd\steamconsole.dll" goto InstallArma3
echo Installing SteamCMD
%PROGRAM_DIRECTORY%\7-Zip\7z.exe x %SERVER_DIRECTORY%\steamcmd\steamcmd.zip -o%SERVER_DIRECTORY%\steamcmd\ -y
%SERVER_DIRECTORY%\steamcmd\steamcmd.exe +quit



:: ARMA 3
:InstallArma3
if exist "%SERVER_DIRECTORY%\arma3server.exe" goto DownloadRedist
echo Installing Arma 3
%SERVER_DIRECTORY%\steamcmd\steamcmd.exe +login %STEAMLOGIN% +force_install_dir %SERVER_DIRECTORY% +"app_update 233780 -beta" validate +quit



:: INSTALL MICROSOFT VCREDIST
:DownloadRedist
echo Downloading and Installing Microsoft vcRedist Packages

powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2008 Redistributable - x86*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2008x86.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2008x86.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2008 Redistributable - x86 already installed - skipping'} "}
powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2008 Redistributable - x64*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2008x64.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2008x64.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2008 Redistributable - x64 already installed - skipping'} "}
powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2012 x86*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2012x86.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2012x86.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2012 x86 already installed - skipping'} "}
powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2012 x64*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2012x64.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2012x64.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2012 x64 already installed - skipping'} "}
powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2013 x86*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2013x86.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2013x86.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2013 x86 already installed - skipping'} "}
powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2013 x64*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2013x64.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2013x64.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2013 x64 already installed - skipping'} "}
powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2015 x86*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2015x86.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2015x86.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2015 x86 already installed - skipping'} "}
powershell -command "& { if (-not (((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue(\"DisplayName\") -like \"*Microsoft Visual C++ 2015 x64*\" } ).Length -gt 0)) {(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe', '%SERVER_DIRECTORY%\Downloads\vcRedist2015x64.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\vcRedist2015x64.exe' -Args '/install /passive /norestart'} else { write-host 'Microsoft Visual C++ 2015 x64 already installed - skipping'} "}


:: INSTALL DIRECTX
:DownloadDirectX
echo Downloading DirectX
powershell -command "& { if (-not ((Get-ItemProperty "hklm:\Software\Microsoft\DirectX").Version) -like \"4.09.00.0904\") {(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe', '%SERVER_DIRECTORY%\Downloads\dxsetup.exe'); Start-Process '%SERVER_DIRECTORY%\Downloads\dxsetup.exe' -Args '/install /passive /norestart'} else { write-host 'DirectX already installed - skipping'} "}



:: EXILE SERVER FILES
:DownloadExileServer
if exist "%SERVER_DIRECTORY%\Downloads\@ExileServer.zip" goto InstallExileServer
if exist "%SERVER_DIRECTORY%\@ExileServer\basic.cfg" goto DownloadExileClient
echo Downloading Exile Server Files
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://www.exilemod.com/download-all-the-files/@ExileServer-1.0.3f.zip', '%SERVER_DIRECTORY%\Downloads\@ExileServer.zip') }"

:CheckForExileServer
if exist "%SERVER_DIRECTORY%\Downloads\@ExileServer.zip" goto InstallExileServer
timeout /T 30 >nul
goto CheckForExileServer

:InstallExileServer
if exist "%SERVER_DIRECTORY%\@ExileServer\basic.cfg" goto DownloadExileClient
echo Installing Exile Server Files
%PROGRAM_DIRECTORY%\7-Zip\7z.exe x %SERVER_DIRECTORY%\Downloads\@ExileServer.zip -o%SERVER_DIRECTORY%\ -y
xcopy "%SERVER_DIRECTORY%\Arma 3 Server\@ExileServer" "%SERVER_DIRECTORY%\@ExileServer" /E /q /y
xcopy "%SERVER_DIRECTORY%\Arma 3 Server\battleye" "%SERVER_DIRECTORY%\SC\battleye" /E /q /y
xcopy "%SERVER_DIRECTORY%\Arma 3 Server\keys" "%SERVER_DIRECTORY%\keys" /E /q /y
xcopy "%SERVER_DIRECTORY%\Arma 3 Server\mpmissions" "%SERVER_DIRECTORY%\mpmissions" /E /q /y
xcopy "%SERVER_DIRECTORY%\Arma 3 Server\tbbmalloc.dll" "%SERVER_DIRECTORY%" /E /q /y
xcopy "%SERVER_DIRECTORY%\Arma 3 Server\LICENSE.txt" "%SERVER_DIRECTORY%" /E /q /y
rd "%SERVER_DIRECTORY%\Arma 3 Server" /s /q



:: EXILE CLIENT FILES
:DownloadExileClient
if exist "%SERVER_DIRECTORY%\@Exile" goto CheckForMySQLInstaller
if exist "%SERVER_DIRECTORY%\Downloads\@Exile.zip" goto InstallExileClient
echo Downloading Exile Client Files
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://exilecity.com/downloads/Exile.zip', '%SERVER_DIRECTORY%\Downloads\@Exile.zip') }"

:CheckForExileClient
if exist "%SERVER_DIRECTORY%\Downloads\@Exile.zip" goto InstallExileClient
timeout /T 30 >nul
goto CheckForExileClient

:InstallExileClient
if exist "%SERVER_DIRECTORY%\@Exile" goto CheckForMySQLInstaller
echo Installing Exile Client Files
%PROGRAM_DIRECTORY%\7-Zip\7z.exe x %SERVER_DIRECTORY%\Downloads\@Exile.zip -o%SERVER_DIRECTORY%\ -y



:: MYSQL and EXILE DATABASE
:CheckForMySQLInstaller
if exist %PROGRAM_DIRECTORY%"\MySQL\MySQL Server 5.7\bin\" goto InstallDatabase
if not exist "C:\Program Files (x86)\MySQL\MySQL Installer for Windows\MySQLInstallerConsole.exe" goto DownloadMySQL
echo Installing MySQL
"C:\Program Files (x86)\MySQL\MySQL Installer for Windows\MySQLInstallerConsole.exe"  install server^;5.7.20^;x64 -silent
"C:\Program Files (x86)\MySQL\MySQL Installer for Windows\MySQLInstallerConsole.exe" configure server:openfirewall=true^;generallog=true^;binlog=true^;serverid=3306^;enable_tcpip=true^;port=3306^;rootpasswd=%DATABASE_PASSWORD%; -silent
echo Creating Database
cd "C:\Program Files\MySQL\MySQL Server 5.7\bin\"
mysql -u %DATABASE_USERNAME%  -p%DATABASE_PASSWORD% %DATABASE_NAME% -e "drop database %DATABASE_NAME%;"
mysql -u %DATABASE_USERNAME%  -p%DATABASE_PASSWORD% -e "create database %DATABASE_NAME%; GRANT ALL PRIVILEGES ON %DATABASE_NAME%.* TO %DATABASE_USERNAME%@localhost IDENTIFIED BY '%DATABASE_PASSWORD%';"
mysql -u %DATABASE_USERNAME% -p%DATABASE_PASSWORD% %DATABASE_NAME% < "%SERVER_DIRECTORY%\MySQL\exile.sql"
mysql -u %DATABASE_USERNAME% -p%DATABASE_PASSWORD% %DATABASE_NAME% -e "set global sql_mode='NO_ENGINE_SUBSTITUTION';"
goto CreateStartBat

:DownloadMySQL
if exist "%SERVER_DIRECTORY%\Downloads\mysql.msi" goto InstallMySql
echo Downloading MySQL
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.7.20.0.msi', '%SERVER_DIRECTORY%\Downloads\mysql.msi') }"

:CheckForMySQL
if exist "%SERVER_DIRECTORY%\Downloads\mysql.msi" goto InstallMySql
timeout /T 60 >nul
goto CheckForMySQL

:InstallMySql
if exist %PROGRAM_DIRECTORY%"\MySQL\MySQL Server 5.7\bin\" goto InstallDatabase
echo Installing MySQL
timeout /T 60 >nul
msiexec /i %SERVER_DIRECTORY%\Downloads\mysql.msi INSTALLDIR=%PROGRAM_DIRECTORY%"\MySQL\"  /q

:InstallDatabase
echo Creating Database
cd %PROGRAM_DIRECTORY%"\MySQL\MySQL Server 5.7\bin\"
mysql -u %DATABASE_USERNAME%  -p%DATABASE_PASSWORD% %DATABASE_NAME% -e "drop database %DATABASE_NAME%;"
mysql -u %DATABASE_USERNAME%  -p%DATABASE_PASSWORD% -e "create database %DATABASE_NAME%; GRANT ALL PRIVILEGES ON %DATABASE_NAME%.* TO %DATABASE_USERNAME%@localhost IDENTIFIED BY '%DATABASE_PASSWORD%';"
mysql -u %DATABASE_USERNAME% -p%DATABASE_PASSWORD% %DATABASE_NAME% < "%SERVER_DIRECTORY%\MySQL\exile.sql"
mysql -u %DATABASE_USERNAME% -p%DATABASE_PASSWORD% %DATABASE_NAME% -e "set global sql_mode='NO_ENGINE_SUBSTITUTION';"



:: CREATE EXILE SERVER STARTUP.BAT
:CreateStartBat
if exist "%SERVER_DIRECTORY%\@ExileServer\ServerStart.bat" goto CreateUpdater
echo Creating Server Start File
set STARTUP="start \"\" \"%SERVER_DIRECTORY%\arma3server.exe\" -mod=@Exile -servermod=@ExileServer; -config=@ExileServer\config.cfg  -port=%ARMA_3_SERVER_PORT% -profiles=SC -cfg=@ExileServer\basic.cfg -name=ExileServer -autoinit"
powershell -command "& { New-Item %SERVER_DIRECTORY%\@ExileServer\ServerStart.bat -type file -value "Testing"}
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\ServerStart.bat) -replace 'Testing','%STARTUP%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\ServerStart.bat}"



:: CREATE ARMA UPDATER ARMA_UPDATE.BAT
:CreateUpdater
if exist "%SERVER_DIRECTORY%\@ExileServer\Arma_Updater.bat" goto eof
echo Creating Arma Updater File
set UPDATER="%SERVER_DIRECTORY%\steamcmd\steamcmd.exe +login %STEAMLOGIN% +force_install_dir %SERVER_DIRECTORY% +\"app_update 233780 -beta\" validate +quit"
powershell -command "& { New-Item %SERVER_DIRECTORY%\@ExileServer\Arma_Updater.bat -type file -value "Testing"}
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\Arma_Updater.bat) -replace 'Testing','%UPDATER%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\Arma_Updater.bat}"



:: UPDATE DATABASE INI
:UpdateConfigs
echo Updating config files

:: extdb-conf.ini
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini ) -replace 'changeme','%DATABASE_USERNAME%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini}"
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini ) -replace 'Password = ','Password = %DATABASE_PASSWORD%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini}"
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini ) -replace 'Password = %DATABASE_PASSWORD%password','Password = %RCON_PASSWORD%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini}"
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini ) -replace 'Port = 2302','Port = %RCON_PORT%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\extdb-conf.ini}"

:: config.cfg
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg ) -replace 'serverCommandPassword				= \"changeme\";','serverCommandPassword				= \"%SERVER_COMMAND_PASSWORD%\";' | Set-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg}"
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg ) -replace 'passwordAdmin      					= \"changeme\";','passwordAdmin      					= \"%ADMIN_PASSWORD%\";' | Set-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg}"
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg ) -replace 'exilemod\.com \(1\.0\.3\|1\.70\)','%SERVER_NAME%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg}"
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg ) -replace 'Exile\.Malden','%MISSION_FILE%' | Set-Content %SERVER_DIRECTORY%\@ExileServer\config.cfg}"

:: BEServer.cfg
powershell -command "& { (Get-Content %SERVER_DIRECTORY%\SC\battleye\BEServer.cfg) -replace 'changeMe','%RCON_PASSWORD%' | Set-Content %SERVER_DIRECTORY%\SC\battleye\BEServer.cfg}"



:eof

echo --Exile Server Installed--
echo Start your new server with the 
echo ServerStart.bat in the @ExileServer folder.

pause