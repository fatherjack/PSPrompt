function Get-Weather {
    <#
    .SYNOPSIS
    Gets the current weather
    
    .DESCRIPTION
    Function that takes a location (City name and country) and returns the current and near future weather conditions
    
    .PARAMETER Location
    City and country name. eg Dublin, Ireland; or London, UK
    
    .EXAMPLE
    Get-Weather -Location "Exeter, UK"
    
    .NOTES
    General notes
    #>
    [alias('weather')]
    [CmdletBinding()]
    param (
        $Location
    )
    
    
}

function Get-Forecast {
    <#
    .SYNOPSIS
    Gets weather forecast for given location
    
    .DESCRIPTION
    Returns the weather forecast for a location provided
    
    .PARAMETER Location
    City name (eg. Oslo, Norway or Detroit, USA)
    
    .EXAMPLE
    Get-Forecast -Location "Reading, UK"
    
    .NOTES
    General notes
    #>
    [alias('Forecast')]
    [CmdletBinding()]
    param (
        $Location
        ##need to have param for period of forecast
    )
# If we dont get a location value then we try to get current location from the computer

## This should be a call to a location function, not testing the location info in a weather function
    if (!($Location)){
        Add-Type -AssemblyName System.Device
        $Location = New-Object System.Device.Location.GeoCoordinateWatcher
        $Location.Start()
        # location might be denied or have no data
        switch ($Location) {
            { $_.Permission -eq "Denied" } {
                Write-Output "Location information permission is denied. Please enable Location access and retry. "
            }
            { $_.Status -ne "Ready" } {
                while ($_.Status -ne "Ready" -and $_.Permission -eq "Denied") {
                    start-sleep -Milliseconds 500
                }
            }
            {$_.Position.Location.IsUnknown} {
                Write-Output "Unable to obtain location information currently."
            }
            Default { }
        }        
        while ($Location.Status -ne "Ready" -and $location.Permission -ne "Denied") {
            Write-output "waiting"
            $Location | select Permission, Status, Position
            Start-Sleep -milliseconds 10
        }



    }
    
}
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

$gcw.Position
$Location.Position.Location.IsUnknown


$weather = Invoke-RestMethod -Uri "api.openweathermap.org/data/2.5/weather?lat=$($Location.Lat)&lon=$($Location.Long)&APPID=8b1cb20942b649fddbbf0e9125b8722f"

$When = ConvertFrom-Epoch $weather.dt
$Msg = $weather.weather.description
$Place = $weather.name

write-host "On $When it is $Msg in $Place" -ForegroundColor Black -BackgroundColor Yellow

($weather.weather).count
$weather.weather.description