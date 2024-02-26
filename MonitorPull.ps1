function Get-Monitors {

    enum VideoOutputTechnology {
        Uninitialized = -2
        Other = -1
        VGA = 0
        Svideo = 1
        CompositeVideo = 2
        ComponentVideo = 3
        DVI = 4
        HDMI = 5
        LVDS = 6
        D_JPN = 8
        SDI = 9
        DisplayPort_External = 10
        DisplayPort_Internal = 11
        UDI_External = 12
        UDI_Internal = 13
        Dongle = 14
        Miracast = 15
        Internal = 0x80000000
    }
    $MonitorDatas = @()
 
    $Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi
    $MonitorDisplayParams = Get-WmiObject WmiMonitorBasicDisplayParams -Namespace root\wmi
    $MonitorConnectionParams = Get-WmiObject WmiMonitorConnectionParams -Namespace root\wmi
 
    foreach ($Monitor in $Monitors) {
        $MonitorData = New-Object -TypeName psobject
        $Display = $MonitorDisplayParams | Where-Object { $_.InstanceName -eq $Monitor.InstanceName }
        $Connection = $MonitorConnectionParams | Where-Object { $_.InstanceName -eq $Monitor.InstanceName }
        $W = $Display.MaxHorizontalImageSize * 0.393701
        $H = $Display.MaxVerticalImageSize * 0.393701
        $WH = ($W * $W) + ($H * $H) 
        $D = [math]::Round([math]::Sqrt($WH))
        $Manufacturer = ($Monitor.ManufacturerName -notmatch 0 | ForEach-Object { [char]$_ }) -join "" 
        $ConnectionType = [VideoOutputTechnology].GetEnumName($Connection.VideoOutputTechnology)
        $Model = ($Monitor.UserFriendlyName -notmatch 0 | ForEach-Object { [char]$_ }) -join "" 
        $serialNumber = ($Monitor.SerialNumberID -notmatch 0 | ForEach-Object { [char]$_ }) -join "" 
        $InputType = (& { If ($m.VideoInputType -eq 0) { "Analog" } Else { "Digital" } })
        $MonitorData | Add-Member -MemberType NoteProperty -Name Manufacturer -Value $Manufacturer
        $MonitorData | Add-Member -MemberType NoteProperty -Name Model -Value $Model
        $MonitorData | Add-Member -MemberType NoteProperty -Name "Video Connection" -Value $ConnectionType
        $MonitorData | Add-Member -MemberType NoteProperty -Name "Connection Type" -Value $InputType
        $MonitorData | Add-Member -MemberType NoteProperty -Name "Size (Inches)" -Value $D 
        $MonitorData | Add-Member -MemberType NoteProperty -Name "Serial Number" -Value $Serialnumber
        $MonitorData | Add-Member -MemberType NoteProperty -Name "Manufacture Year" -Value ($Monitor.YearOfManufacture)
        $MonitorData | Add-Member -MemberType NoteProperty -Name "Manufacture Week" -Value ($Monitor.WeekOfManufacture)
 
   
        $MonitorDatas += $MonitorData
    }
    $MonitorDatas | Format-Table
}
Get-Monitors
