function ping {
    <#
    .SYNOPSIS
    Replaces cmd Ping.exe
    
    .DESCRIPTION
    Uses Test-NetConnection to check for network statistics
    
    .EXAMPLE
    Ping -target '8.8.8.8' -quiet
    
    .EXAMPLE
    Ping -target 8.8.8.8 -time 2
    
    .NOTES
    General notes
    #>
    
    [cmdletbinding()]
    param(
        # What computer / IP is to be tested
        [parameter(Mandatory = $true)]
        [alias('hostname')]
        [string]$Target,
        # how many packets to send
        [parameter()]
        [switch]$Count,
        # Perform quiet connection test
        [Parameter(ParameterSetName = "quiet")]
        [switch]$Quiet,
        # perform test for given number of seconds
        [alias('t')]
        [parameter(ParameterSetName = "Time")]
        [int]$time = 20
    )

    if ($Quiet) {
        Write-Output "Checking $Target"
        Test-NetConnection -ComputerName $Target -InformationLevel Quiet
    }
    else {
        write-output "Testing $Target"
        $EndTime = (Get-Date).AddSeconds($time)
        do {
            Test-NetConnection -ComputerName $Target -InformationLevel Detailed
            Start-Sleep -Milliseconds 500
        }
        until((Get-Date) -gt $EndTime)
    }    
}
