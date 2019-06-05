Add-Type -AssemblyName System.Device
$gcw = New-Object System.Device.Location.GeoCoordinateWatcher
$gcw.Start()

while ($gcw.Status -ne "Ready" -and $gcw.Permission -ne "Denied") {
    sleep -milliseconds 10
}

$gcw.Position.Location | Select-Object -Property Latitude, Longitude