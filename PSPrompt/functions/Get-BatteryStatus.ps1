function Get-BatteryStatus {
    <#
    .SYNOPSIS
    Displays battery status to console

    .DESCRIPTION
    Displays battery status to console

    .EXAMPLE
    Get-BatteryStatus

    Get the battery status - showing current charge in percent and also of the battery is charging or discharging
      
    .EXAMPLE
    battery

    returns battery status as hashtable - suitable for pipeline usage

    .EXAMPLE
    Get-BatteryStatus -asmessage

    returns the battery charge and remaining minutes estimate as a string message
    #>
    [outputtype([system.string])]
    [alias('battery')]
    [CmdletBinding()]
    param (
        [parameter()]
        [switch]
        $AsMessage
    )

    process {
        $b = (Get-CimInstance -ClassName CIM_Battery | Where-Object EstimatedChargeRemaining -ne $null)

        $Battery = [PSCustomObject]@{
            IsCharging = if ($b.BatteryStatus -eq 1) { $False } else { $True }
            Charge     = $b.EstimatedChargeRemaining 
            Remaining  = $b.EstimatedRunTime 
        }

        if ($AsMessage) {
            $msg = "$($Battery.Charge)%"
            if ($Battery.IsCharging ) {
                $msg += " Charging "
            }
            else {
                $msg += " / $($Battery.Remaining) mins - Discharging"
            }
      
            return $msg
        }
        else {
            return ($Battery)
        }
    }
}