# HuePowershell
Controling Hue Philips 
This script get IP of ur HUE hub and create at the first start a new user newdeveloper if necessary
It can Switch On / off lights , ramdom colrs, set brit, pick color with windows Dialog 

Don't miss to execute  set-executionpolicy remotesigned with powershell

Create a shortcut for hidden powershell window:
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -command "& 'URPATH\hue.ps1'
