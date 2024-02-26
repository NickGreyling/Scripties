#!ps
if (-not (Test-Path "C:\ITSupport")) {
    New-Item -ItemType Directory -Force -Path C:\ITSupport | Out-Null
}
$BatteryCheck = gwmi win32_battery
if ($null -eq $BatteryCheck) {
    Write-Host "No Battery Detected!"
}
else {
    cmd /c powercfg /batteryreport /output C:\ITSupport\battery-report.xml /XML
    [xml]$XML = Get-Content "C:\ITSupport\battery-report.xml"
    $Info = $XML.BatteryReport.Batteries.Battery
    $Health = ($Info.FullChargeCapacity / $Info.DesignCapacity) * 100
    $Health = [math]::Round($Health, 2)

    Write-Host "`nBattery ID:`t "$Info.ID""
    Write-Host "Manufacturer:`t "$Info.Manufacturer""
    Write-Host "Serial Number:`t "$Info.serialnumber""
    Write-Host "Chemistry:`t "$Info.chemistry""
    Write-Host "Original:`t "$Info.DesignCapacity""mAh""
    Write-Host "Current:`t "$Info.FullChargeCapacity""mAh""
    Write-Host "Battery Health:`t  $Health"%""
    Write-Host "Cycle Count:`t "$Info.CycleCount""
}