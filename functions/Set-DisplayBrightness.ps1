
function Set-Brightness {
    <#
    .Synopsis
    custom function to set screen brightness
    
    #>
    param(
        [parameter()][int]$Brightness = 75,
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

$c = Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness

$c.PSComputerName