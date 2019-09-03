function ConvertFrom-Epoch {
    <#
    .SYNOPSIS
    Converts a unix style epoch time to a datetime value
  
    .DESCRIPTION
    Converts a unix style time value like 1559684667 and returns a datetime value like 04 June 2019 21:44:27
  
    .PARAMETER Seconds
    The integer value that should be used to convert to a date time value
  
    .EXAMPLE
    ConvertFrom-Epoch 1428665400   

    This returns the date time value of 10 April 2015 12:30:00
  
    #>
    [outputtype([system.datetime])]
  
    [cmdletbinding()]
    param(
        #Seconds value since 01-Jan-1970
        [parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $Seconds
    )
  
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Seconds))
}


