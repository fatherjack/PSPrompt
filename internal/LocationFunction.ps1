Add-Type -AssemblyName System.Device
$gc = New-Object System.Device.Location.GeoCoordinate; $gc

$gps = New-Object System.Device.Location.GeoPositionStatus; $gps




$gcw = New-Object System.Device.Location.GeoCoordinateWatcher
# $gcw.Start()

$gcw.TryStart($false, "00:00:10")

while ($gcw.Status -ne "Ready" -and $gcw.Permission -eq "Denied") {
    start-sleep -milliseconds 10
    $gcw
}


if ($gcw.Permission -ne "denied") {
    $gcw.Position.Location | Select-Object -Property Latitude, Longitude 
}
else {
    "Unable to access computer location information. You may need to allow access to this process."
}


    $gcw.DesiredAccuracy
    $gcw.Position