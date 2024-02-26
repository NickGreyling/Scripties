#!ps
$cim = get-ciminstance win32_computersystem; if ($cim.domain -eq "WORKGROUP"){"Not domain joined!"}else{"FQDN:`t$($cim.name).$($cim.domain)"}