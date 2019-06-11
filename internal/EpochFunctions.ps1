function ConvertFrom-Epoch {
    <#
    .SYNOPSIS
    Converts a unix style epoch time to a datetime value
    
    .DESCRIPTION
    Converts a unix style time value like 1559684667 and returns a datetime value like 04 June 2019 21:44:27
    
    .PARAMETER Seconds
    The number of seconds to base the conversion on
    
    .EXAMPLE
    ConvertFrom-Epoch 1428665400 | gm

    
    #>
    
    [cmdletbinding()]
    param(#Seconds value since 01-Jan-1970
        [parameter(ValueFromPipeline=$true)]$Seconds
    )
    #$Epoch = [datetime]"1/jan/1970"
    #return($Epoch.AddSeconds($Seconds))
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Seconds))
}


function ConvertTo-Epoch {
    <#
.SYNOPSIS
Converts a datetime to epoch value

.DESCRIPTION
Converts a value like 10-Apr-2018 10:45:01 to an epoch style int value

.PARAMETER date


.EXAMPLE
    ConvertTo-Epoch '10-Apr-2015 12:30:00' | gm

.NOTES
General notes
#>
    [cmdletbinding()]
    param(# date value to convert to epoch
        [datetime]$date = "04 June 2019 22:10:02"
    )
    [int][double]::Parse((Get-Date ($date).ToUniversalTime() -UFormat %s))
}

ConvertTo-Epoch '01-Oct-2001 13:03:20' | ConvertFrom-Epoch 


#PowerShell	
# current date time to Epoch
[int][double]::Parse((Get-Date (get-date).ToUniversalTime() -UFormat %s))		

#PowerShell	
# epoch value to date time
Function get-epochDate ($epochDate) {
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($epochDate)) 
}
     
    
#get-epochDate 1520000000 #. Works for Windows PowerShell v1 and v2
#From https://www.epochconverter.com/


