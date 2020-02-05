@echo off
color 0a
title Arma 3 Server Monitor
:Serverstart
echo Launching Server
D: 
cd "D:\xsv_arma_servers\Development_server"
echo Arma 3 Server Monitor... Active !
start /min /wait arma3server.exe -mod=; -port="____" -profiles=Admin -config=D:\xsv_arma_servers\"server_???"config.cfg -cfg=C:\xsv_community\xsv_arma_server_"00?"\config -name=Admin -autoInit 
ping 127.0.0.1 -n 15 >NUL
echo Arma 3 Server Shutdown ... Restarting!
ping 127.0.0.1 5 >NUL
cls
goto Serverstart