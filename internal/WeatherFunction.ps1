# using OpenWeatherMap API to get weather forecast
$Location = "London,UK"
Invoke-RestMethod -Uri "api.openweathermap.org/data/2.5/weather?q=$Location&APPID=8b1cb20942b649fddbbf0e9125b8722f"


$Location = "Hayle, UK"
$weather = Invoke-RestMethod -Uri "api.openweathermap.org/data/2.5/weather?q=$Location&APPID=8b1cb20942b649fddbbf0e9125b8722f"

write-output "Weather in $Location`: $($weather.weather.description)"

$forecast = Invoke-RestMethod -Uri "api.openweathermap.org/data/2.5/forecast?q=$Location&APPID=8b1cb20942b649fddbbf0e9125b8722f"
$forecast.list.weather | select 


# using computer location details
Add-Type -AssemblyName System.Device
$gcw = New-Object System.Device.Location.GeoCoordinateWatcher
$gcw.Start()

while ($gcw.Status -ne "Ready" -and $gcw.Permission -ne "Denied") {
    Start-Sleep -milliseconds 10
}

# $gcw.Position.Location | Select-Object -Property Latitude, Longitude
if($gcw.Permission -ne "Denied"){
    $Location = @{
        City = "Dublin,Ireland"
        Lat  = $gcw.Position.Location.Latitude
        Long = $gcw.Position.Location.Longitude
    } 
}


$weather = Invoke-RestMethod -Uri "api.openweathermap.org/data/2.5/weather?lat=$($Location.Lat)&lon=$($Location.Long)&APPID=8b1cb20942b649fddbbf0e9125b8722f"

$When = ConvertFrom-Epoch $weather.dt
$Msg = $weather.weather.description
$Place = $weather.name

write-host "On $When it is $Msg in $Place" -ForegroundColor Black -BackgroundColor Yellow

($weather.weather).count
$weather.weather.description