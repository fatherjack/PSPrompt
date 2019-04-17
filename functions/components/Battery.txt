#region Battery status
    $b = (Get-CimInstance -ClassName CIM_Battery)
    $Battery = $null
    $Battery = @{    
        IsCharging = if ($b.BatteryStatus -eq 1) { $false } else { $true }
        Charge     = $b.EstimatedChargeRemaining
        Remaining  = $b.EstimatedRunTime
    }
    if ($Battery.Remaining -gt 90) {
        $Battery.Remaining = "90m+"
    }
    else {
        $Battery.Remaining = "$($Battery.Remaining)m"
    }

    Write-Verbose $Battery

    if (!($Battery.IsCharging)) {
        $msg = $b = $extramsg = $null
        switch ($Battery.Charge[1]) {
    
            { $_ -gt 80 } {
                $colour = "Green"
                break
            }
            { $_ -gt 60 } {
                $colour = "DarkGreen"
                break
            } 
            { $_ -gt 40 } {
                $colour = "DarkRed"
                break
            }
            { $_ -gt 20 } {
                $colour = "Red"
                break
            }
            default {
                $extramsg = "BATTERY VERY LOW :: SAVE YOUR WORK" 
                $colour = "yellow"
            }
        }
        $msg = ("[{0}%:{1}{2}]" -f $Battery.Charge[1], $Battery.Remaining, $EXTRAmsg )
        Write-Host -Object $msg -BackgroundColor $colour -ForegroundColor Black -NoNewline
    } 
    #endregion