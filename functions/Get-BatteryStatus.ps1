function Get-BatteryStatus {
    <#
    .SYNOPSIS
    Displays battery status to console

    .DESCRIPTION
    Displays battery status to console

    .EXAMPLE
    Get-BatteryStatus

    #>
    [alias('battery')]
    [CmdletBinding()]
    param (    )

    process {
        $b = (Get-CimInstance -ClassName CIM_Battery)
        $Battery = @{
            IsCharging = if ($b.BatteryStatus -eq 1) { "Not Charging" } else { "Charging" }
            Charge     = $b.EstimatedChargeRemaining #.GetValue(1)
            Remaining  = $b.EstimatedRunTime #.GetValue(1)
        }
        $msg = ("{0}% / {1}mins {2}" -f $Battery.Charge, $Battery.Remaining, $Battery.IsCharging)
        Write-Output $msg
    }
}