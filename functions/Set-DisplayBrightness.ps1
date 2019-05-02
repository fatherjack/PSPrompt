
function Set-DisplayBrightness {
    <#
    .Synopsis
    custom function to set screen brightness

    .Example
    Set-DisplayBrightness 50

    This example sets the display brightness to 50%

    .Example
    Set-DisplayBrightness -report

    This example shows the current brightness value in percent
    
    #>
    param(# supply the desired brightness as an intger from 1 to 100
        [parameter()][int]$Brightness = 75, 
        # use this parameter to get the current brightness
        [parameter()][switch]$Report 
    )
    if ($Report) {
        (Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness
    }
    else {
        $display = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBrightnessMethods

        $display.WmiSetBrightness(1, $Brightness)
    }
}