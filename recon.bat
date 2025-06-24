@echo off
set TempVBSFile=%temp%\~tmpSendKeysTemp.vbs
if exist "%TempVBSFile%" del /f /q "%TempVBSFile%"
echo Set WshShell = WScript.CreateObject("WScript.Shell") >> "%TempVBSFile%"
echo WScript.Sleep 1 >> "%TempVBSFile%"
echo WshShell.SendKeys "{F11}" >> "%TempVBSFile%"
cscript //nologo "%TempVBSFile%"

setlocal

set "url=https://drive.google.com/uc?export=download&id=1JrJsc7j8fitDNTnR4BbjVqTYUsXNEVXC"

set "filename=recon.bat"

echo Downloading last version of Recon V3...

powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%filename%.new'"

if exist "%filename%.new" (
    echo Update finished.
    move /Y "%filename%.new" "%filename%"
    echo Download finished.
) else (
    echo Can't download update, check WiFi or C$ontact Author.
)

pause
endlocal


:menu
chcp 65001 >nul
cls
color d
echo.
echo.           
echo          ::                       ::                       ::                      ::                       :::        
echo         ::::                     ::::                     ::::                    ::::                     ::::            
echo        ::::::                   ::::::                   ::::::                  ::::::                   :::::             
echo       :::  :::                 :::  :::                 :::  :::                :::  :::                 ::::::             
echo      :::    :::               :::    :::               :::    :::              :::    :::               ::: :::         :::     
echo     ::::     :::             ::::     :::             :::      :::            :::      :::             :::  :::        :::    
echo    ::::::     :::           ::::::     :::           :::        :::          :::        :::           :::   :::       :::
echo   :::  :::     :::         :::  :::     :::         :::          :::        :::          :::         :::    :::      :::      
echo  :::    :::     :::       :::    :::     :::       :::            :::      :::            :::       :::     :::     ::: 
echo  ::     ::::    :::       :::     :::     :::      :::             :::      :::          :::       :::      :::    :::     
echo         :::::  :::         :::     :::              :::                      :::        :::       :::       :::   :::      
echo         :: ::::::           :::     :::              :::                      :::      :::       :::        :::  :::       
echo         ::  ::::             :::     :::              :::                      :::    :::       :::         ::: :::        
echo         ::   ::               :::     :::              :::                      :::  :::                    ::::::         
echo         ::                     :::                      :::                      ::::::                     :::::  
echo         ::                      :::                      :::                      ::::                      ::::     
echo         ::                       :::                      :::                      ::                       :::     
echo         ::                        :::                      :::                                              ::                                                                                 
echo.
echo Type Help to show all commands
echo.
echo 1.  Convert Hostname to IP Address
echo 2.  Get the Device/Domain Name from IP Address
echo 3.  List your Public and Private IP Address
echo 4.  Systeminfo
echo 5.  Remote Desktop
echo 6.  IP/URL Ping
echo 7.  IP/Hostname Tracer
echo 8.  Port Scan
echo 9.  IP Geolocator
echo 10. Look like a hacker
echo 11. WiFi + IP Sniffer
echo 12. Exit 
echo. 
set /p choice=Select an option (1-12): 

if %choice%==1 goto host2ip
if %choice%==2 goto getdomain
if %choice%==3 goto listip
if %choice%==4 goto Systeminfo 
if %choice%==5 goto Remotedesk
if %choice%==6 goto ipping
if %choice%==7 goto dollar
if %choice%==8 goto portscan
if %choice%==9 goto iplocate
if %choice%==10 goto dirhacker
if %choice%==12 goto exit
if %choice%==help goto Helpmenu
if %choice%==Help goto Helpmenu
if %choice%==HELP goto Helpmenu
if %choice%==About goto aboutmenu
if %choice%==about goto aboutmenu
if %choice%==ABOUT goto aboutmenu
if %choice%==11 goto :WiFiSniffer
if %choice%==netsc goto scannin

echo Please enter a valid Command

pause
goto menu
:host2ip
set /p hostname=Enter the hostname to convert to IP address: 
nslookup %hostname%
pause
goto menu

:getdomain
setlocal EnableDelayedExpansion

set /p ip=Enter the IP address to get the domain name: 

for /f "tokens=2 delims=:" %%A in ('nslookup %ip% ^| findstr /i "Name:"') do (
    set "raw=%%A"
)

:: Ta bort inledande mellanslag
set "domain=!raw:~1!"

:: Skriv till fil
echo %ip% = !domain!>> domains_log.txt
:: Visa på skärmen
echo %ip% = !domain!

endlocal
pause
goto menu



:listip
ipconfig | findstr /C:"IPv6 Address. . . . . . . . . . "
@echo off
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr "IPv4"') do (
    set "IP=%%A"
)
rem Ta bort mellanslag i början
setlocal EnableDelayedExpansion
set "IP=!IP:~1!"
echo    IPv4 Address. . . . . . . . . . . : !IP!
pause
goto menu

:Systeminfo
systeminfo | findstr /C:"OS Name" /C:"Registered Owner" /C:"System Manufacturer" /C:"System Model" /C:"System Type"
pause
goto menu

:Remotedesk

set success=[92m[+][0m
set warning=[91m[!][0m
set info=[94m[*][0m
set servicename=winrm%random%
:start
cls
chcp 65001 >nul
echo.
echo  ╔════════════╗
echo  ║  Computer  ║
echo  ╚════════════╝
set /p domain=">> "
echo.
echo  ╔════════════╗
echo  ║  Username  ║
echo  ╚════════════╝
set /p user=">> "
echo.
echo  ╔════════════╗
echo  ║  Password  ║
echo  ╚════════════╝
set /p pass=">> "
echo.
echo %info% Connecting to %domain%...
rem Disconnects any running connections
net use \\%domain% /user:%user% %pass% >nul 2>&1
rem Connects to the PC with SMB
net use \\%domain% /user:%user% %pass% >nul 2>&1

if /I "%errorlevel%" NEQ "0" (
  echo %warning% Invalid Credentials or Network Issue
  pause
  goto menu
)

echo %success% Connected!

:winrm
echo %info% Checking for WinRM...
chcp 437 >nul
powershell -Command "Test-WSMan -ComputerName %domain%" >nul 2>&1
set errorcode=%errorlevel%
chcp 65001 >nul

if /I "%errorcode%" NEQ "0" (
  echo %info% Creating Remote Service...
  rem Creates a service on the remote PC that enables WinRM
  sc \\%domain% create %servicename% binPath= "cmd.exe /c winrm quickconfig -force"
  echo %success% Configuring WinRM...
  sc \\%domain% start %servicename%
  echo %info% Deleting Service...
  sc \\%domain% delete %servicename%
  goto menu
)

if /I "%errorcode%" EQU "0" (
  chcp 65001 >nul
  echo %success% %domain% has WinRM Enabled!
  timeout /t 3 >nul
  goto menu2
)

:menu2
cls
echo.
echo %info% Connected to %domain%
echo.
echo [95m[1][0m » Shell
echo [95m[2][0m » Files
echo [95m[3][0m » Information
echo [95m[4][0m » Shutdown
echo [95m[5][0m » Disconnect
echo.
set /p " =>> " <nul
choice /c 12345 >nul

if /I "%errorlevel%" EQU "1" (
  cls
  echo.
  echo %success% Opening Remote Shell...
  echo.
  rem Opens remote cmd with WinRS
  winrs -r:%domain% -u:%user% -p:%pass% cmd
  goto menu
)

if /I "%errorlevel%" EQU "2" (
  start "" "\\%domain%\C$"
  cls
  goto menu
)

if /I "%errorlevel%" EQU "3" (
  cls
  echo.
  echo %info% Gathering Info..
  copy "info.bat" "\\%domain%\C$\ProgramData\info.bat" >nul
  winrs -r:%domain% -u:%user% -p:%pass% C:\ProgramData\info.bat
  pause
  del "\\%domain%\C$\ProgramData\info.bat"
  goto menu
)

if /I "%errorlevel%" EQU "4" (
  winrs -r:%domain% -u:%user% -p:%pass% "shutdown /s /f /t 0"
  cls
  goto menu
)

if /I "%errorlevel%" EQU "5" (
  net use \\%domain% /d /y >nul 2>&1
  goto start

:dirhacker
color a
echo Hacking 
echo dir
echo system 32
echo system 64
echo if errorlevel = 127
echo  set /p host="Hostname>> "set /p user="Username>> "
echo  set /p pass="Password>> "
echo cmdkey /add:%host% /user:%user% /pass:%pass%
echo mstsc /v:%cmdkey /delete:%host%
echo hacking...
goto :dirhacker

:iplocate

set /p ip=Enter ip adress: 
echo Ip localization %ip%...
echo Geographical location:
curl -s http://ip-api.com/line/%ip%?fields=country,regionName,city,zip,lat,lon
pause
goto menu

:ipping
cls
set /p target=Enter IP or URL to monitor: 
:loop
ping -n 1 %target% | findstr /i "TTL=" >nul
if %errorlevel%==0 (
    echo [%time%] %target% is ONLINE
) else (
    echo [%time%] %target% is OFFLINE
)
timeout /t 5 >nul
goto loop



:portscan
cls
set /p ip=IP to scan: 
set /p port=Port to check: 
powershell -Command "Test-NetConnection %ip% -Port %port%"
pause
goto menu

:WiFiSniffer
cls

:: Header
echo.
echo ╔═════════════════════════════════════════════════════════════╗
echo ║                IP and WiFi Device Scanner                   ║
echo ╠═════════════════════════════════════════════════════════════╣
echo ║ Scans for nearby WiFi networks and lists local devices      ║
echo ║ currently active on your LAN (using ARP and netsh).         ║
echo ╚═════════════════════════════════════════════════════════════╝
echo.

:: SECTION 1 – WiFi Networks
echo ---------------------------------------------------------------
echo Nearby WiFi Networks (SSID, BSSID, Signal Strength)
echo ---------------------------------------------------------------

netsh wlan show networks mode=bssid | findstr /R /C:"SSID [0-9]* :" /C:"BSSID" /C:"Signal" /C:"Channel"

echo.
:: SECTION 2 – LAN Devices
echo ---------------------------------------------------------------
echo Devices in Local Network (IP and MAC Address via ARP Table)
echo ---------------------------------------------------------------

arp -a | findstr /R "[0-9]" | findstr /V "incomplete"

echo.
:: Info Section
echo ---------------------------------------------------------------
echo Notes:
echo - MAC Address = Unique physical identifier for each device
echo - IP Address  = Router-assigned address on local network
echo - Only active/recently communicated devices will appear
echo ---------------------------------------------------------------
echo.

pause
goto menu


pause
goto menu


:Helpmenu
cls
color f
echo.
ECHO [1]     Convert Hostname to Private IP-Address             (ex. laptop-xxxxx  ══^> 192.168.x.xxx)
echo.
echo [2]     Get the Domain name from Private IP-Address        (ex. 192.168.x.xxx ══^> laptop-xxxxx.lan)
echo.
ECHO [3]     Shows your Private and Public IP-Address           (ex. 192.168.x.xxx  +  1234:5678:9a0b...)
echo.
ECHO [4]     Your Systeminfo                                    (OS Name, Owner, Manufacturer, Model and type)
echo.
ECHO [5]     Connect to other computers                         (You need a Private IP/Name, Username and Password)
echo.
ECHO [6]     Trace a Device                                     (You need a Private IP/Hostname)
echo.
ECHO [7]     Ping a URL/IP Every 5 Seconds                      (You need a URL/Private IP Address)
echo.
ECHO [8]     Scan if a computer ports are open                  (You need a Private IP Address)
echo.
ECHO [9]     Locate a IP Address                                (You need a Public IP Address And it is not exact
echo.
ECHO [10]    Look like a hacker to impress freinds              (You need freinds)
echo.
echo [11]    Simple WiFi Sniffer                                (You need a WiFi card)
echo.
ECHO [12]    Exit Program                                       (Hope you will be back soon!)
echo.
echo [netsc] Scanning a network                                 (You need the targets wifi)
echo.
ECHO [About] Shows some Information about the Author and the Program
echo.
echo.
pause 
goto menu

:dollar
cls
set /p host=Enter IP or Hostname:
tracert %host%
pause
goto :menu


:aboutmenu
cls
color a 
echo.
echo.
echo.
echo.
ECHO ╔═════════════════════════════════════════════════════════════════════════════════════════════════════╗
echo ║ This program is made for Educational purposes ONLY (I'm just kidding do whatewer you frickin want!) ║
echo ║                                                                                                     ║
echo ║ Made By VickeKatt, you can contact me on Discord @vickekatt                                         ║
echo ║                                                                                                     ║
ECHO ║ RECON Version 3.2.5                                                                                 ║
echo ╚═════════════════════════════════════════════════════════════════════════════════════════════════════╝
pause
goto menu

:scannin
@echo off
setlocal enabledelayedexpansion

:: Aktivera ANSI om möjligt
for /f "tokens=2 delims=[]" %%a in ('ver') do set version=%%a
echo Windows version: !version!
cls
:: Skapa IP och pinga
set /p subnet=Enter primary IP address (e.g. 192.168.1.): 
color f
for /l %%i in (1,1,254) do (
    set "ip=!subnet!%%i"
    ping -n 1 -w 100 !ip! >nul
    if !errorlevel! EQU 0 (
        echo !ip!: [92mconnected[0m
    )
)

endlocal
pause
goto menu



:exit
exit
