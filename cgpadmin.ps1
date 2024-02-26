#!ps  
$username = "cgpadmin"
$randomPassword = -join ((97..122) + (65..90) + ('@#$%*^!?@#$%*^!?').ToCharArray() | Get-Random -Count 15 | % {[Char]$_}) +"!"
net user $username
if (!$?) {
    net user $username $randomPassword /add /Y 
    net localgroup administrators $username /add 
    write-host "Admin account $username created with a password of $randomPassword"  
}
else {
    net user $username $randomPassword  
    write-host "$username account password changed to $randomPassword"  
}