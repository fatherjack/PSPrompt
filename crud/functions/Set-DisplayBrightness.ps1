
function Set-DisplayBrightness {
    <#
    .Synopsis
    custom function to set screen brightness

    .Description
    custom function to set screen brightness

    .parameter
    -WhatIf [<SwitchParameter>]
    If this switch is enabled, no actions are performed but informational messages will be displayed that
    explain what would happen if the command were to run.

    .parameter
    -Confirm [<SwitchParameter>]
    If this switch is enabled, you will be prompted for confirmation before executing any operations that
    change state.

    .Example
    Set-DisplayBrightness 50

    This example sets the display brightness to 50%

    .Example
    Set-DisplayBrightness -report

    This example shows the current brightness value in percent

    .Example
    Dim 75

    This example sets the brightness to 75 using the function alias
    #>
    [alias('dim')]
    [cmdletbinding(SupportsShouldProcess = $true)]
    param(# supply the desired brightness as an integer from 1 to 100
        [parameter()]
        [validaterange(1, 100)]
        [int]$Brightness = 75,
        # use this parameter to get the current brightness
        [parameter()][switch]$Report
    )

    if ($Report) {
        (Get-CimInstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness
    }
    else {
        $display = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBrightnessMethods
        #        $display = Get-CimInstance   -Namespace root\wmi -Class WmiMonitorBrightnessMethods # pscore requires cim
        if ($PSCmdlet.ShouldProcess("Display", "Setting brightness to $Brightness")) {
            $display.WmiSetBrightness(1, $Brightness)
        }
    }
}
