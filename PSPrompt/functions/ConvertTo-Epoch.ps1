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
    [outputtype('system.int32')]
    [cmdletbinding()]
    param(
        # date value to convert to epoch
        [parameter(ValueFromPipeline = $true, Mandatory = $true)][datetime]
        $date
    )
    [int][double]::Parse((Get-Date ($date).ToUniversalTime() -UFormat %s))
}
