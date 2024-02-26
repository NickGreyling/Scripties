function Set-Time {
    cmd /c
    W32tm  /query /status;
    W32tm /config /manualpeerlist:"time.nist.gov" /syncfromflags:manual /reliable:yes /update;
    Net stop w32time;
    Net start w32time;
    W32tm /resync;
    W32tm /query /status;
}
Set-Time