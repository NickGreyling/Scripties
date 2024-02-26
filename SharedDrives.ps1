#!ps
$SID = Get-WmiObject -Class win32_computersystem |
Select-Object -ExpandProperty Username |
ForEach-Object { ([System.Security.Principal.NTAccount]$_).Translate([System.Security.Principal.SecurityIdentifier]).Value }
Get-ChildItem -Path REGISTRY::HKEY_USERS\$SID\Network -Recurse | Get-ItemProperty | ft @{Label = "Letter"; Expression = {$_.PsChildName.toUpper()}}, RemotePath