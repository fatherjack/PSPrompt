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

    
    
    #>
    
    [cmdletbinding()]
    param(
        #Seconds value since 01-Jan-1970
        [parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $Seconds
    )
    
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Seconds))
}


function ConvertTo-Epoch {
    <#
    .SYNOPSIS
    Converts a datetime to epoch int value

    .DESCRIPTION
    Converts a value like 10-Apr-2018 10:45:01 to an epoch style int value

    .PARAMETER date
    The date value that should be converted

    .EXAMPLE
    ConvertTo-Epoch '10-Apr-2015 12:30:00' 

#>
    [cmdletbinding()]
    param(
        # date value to convert to epoch
        [parameter(ValueFromPipeline = $true, Mandatory = $true)][datetime]
        $date
    )
    [int][double]::Parse((Get-Date ($date).ToUniversalTime() -UFormat %s))
}
