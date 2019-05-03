#region code to execute every Nth command
#TODO:: remove hard-coded 5 and replace with user option
if ((Get-History -Count 1).ID % 5 -eq 0) {
    if ($BatteryHistory -or $Git) {
        #region Git status every Nth command
        if ($Git) {
        
            $r = git status
            $NewFiles = ($r -match 'new file:').count
            $ModFiles = ($r -match 'modified:').count
            $DelFiles = ($r -match 'deleted:').count
            $Branch = $r[0]

            Write-Host "git status: " -ForegroundColor White -BackgroundColor Black -NoNewline
            if ($Branch -eq "On branch master") { Write-Host "*WARNING : Working in MASTER.*" -ForegroundColor Yellow -BackgroundColor Red -NoNewline } 
            else { Write-Host "$r[0]" -ForegroundColor Blue -BackgroundColor Black -NoNewline } 
            Write-Host " New[$NewFiles] " -ForegroundColor Green -BackgroundColor Black -NoNewline
            Write-Host " Mod[$ModFiles] " -ForegroundColor DarkCyan -BackgroundColor Black -NoNewline
            Write-Host " Del[$DelFiles] " -ForegroundColor Red -BackgroundColor Black 
        }
        #endregion

        #region BatteryHistory 
        if ($BatteryHistory) {
            #region BatteryHistory logging
            $b = (Get-CimInstance -ClassName CIM_Battery)
            Write-PSPLog -Message "$($b.EstimatedChargeRemaining)" -Source "BatteryPct"
            $Battery = @{    
                IsCharging = if ($b.BatteryStatus -eq 1) { $false } else { $true }
                Charge     = $b.EstimatedChargeRemaining.GetValue(1)
                Remaining  = $b.EstimatedRunTime.GetValue(1)
            }
            $msg = "Charging:{0}; ChargePct:{1}; Remaining:{2}" -f $Battery.IsCharging, ($Battery.Charge), $Battery.Remaining
            $msg
            Write-PSPLog -Message $msg -Source "BatteryStatus"
            #endregion

            #region BatteryHistory display
            $Hdr = "Date", "Source", "Message"
            $Hist = Import-Csv -Path "C:\temp\PSPLog.log" -Delimiter "`t" -Header $Hdr
            $BHist = $Hist | Where-Object source -eq "Batterypct" | Sort-Object date -Descending
            
            $Drain = $BHist[0, 1] | select date, message
            # $Drain[1].message - $Drain[0].message
            $Duration = New-TimeSpan -Start ([datetime]::parseexact($Drain[1].Date, "yyyyMMddHHmmss", $null)) -End ([datetime]::parseexact($Drain[0].Date, "yyyyMMddHHmmss", $null) )
            $PowerLoss = ($Drain[1].message - $Drain[0].message) / $Duration.TotalMinutes # Percent loss per minute
            write-verbose ("Battery % loss per min {0:N1}" -f $PowerLoss)
            $msg ="[{0:N0}m]" -f ($Battery.Charge / $PowerLoss)
Write-Host $msg
            #endregion
        }
        #endregion    
    }
}
#endregion