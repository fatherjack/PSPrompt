function Prompt {
    <#
    .Synopsis
    Your custom PowerShell prompt

    # origins from https://dbatools.io/prompt but formatting the execution time without using the DbaTimeSpanPretty C# type

    .Description
    Custom prompt that includes the following features:
    - Admin user    : if the current session is running as Administrator then the prompt shows [Admin] in black on red
    - Battery       : if you are working on your battery - % charged and est min remaining
    - Day and date  : the current day and date are shown at the left side of the prompt in all use-cases
    - UTC offset    : if the system timezone is not UTC then the offset in hours is shown Red/Green for + or - difference
    - fun function  : put some fun into your PowerShell prompt with a countdown to your next big event ()
    - current path  : shortens the path if there are more than 2 directories and truncates those to 7 characters
    - last command  : execution duration of the last command executed

    #>
    #region Show if using Administrator level account
    $principal = [Security.Principal.WindowsPrincipal] ([Security.Principal.WindowsIdentity]::GetCurrent())
    $adm = [Security.Principal.WindowsBuiltInRole]::Administrator
    if ($principal.IsInRole($adm)) {
        write-host -ForegroundColor "Black" -BackgroundColor "DarkRed" "[ADMIN]" -NoNewline
    }
    #endregion
    
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
        $Battery.Remaining = "$($Battery.Remaining.ToString())m"
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

#region Day and date
    $msg = "[{0}]" -f (Get-Date -Format "ddd HH:mm:ss")        
    Write-Host $msg -NoNewline
    #endregion

    #region UTC offset
    # add info if not in home timezone
    # get offset and daylight savings name
    $tz = Get-TimeZone
    $offset = $tz.BaseUtcOffset # need to place YOUR normal timezone here
    [timespan]$adjustment = 0
    # if we are in daylight saving then the offset from home will be 60 mins, not 0
    if ($tz.id -eq $tz.daylightname) {
        $adjustment = New-TimeSpan -minutes 60
    } 
    $fc = "white"
    $p = "GMT"
    if (($offset.TotalMinutes + $adjustment.TotalMinutes) -ne 0) {
        [double]$h = $offset.TotalMinutes / 60
        if ($h -lt 0) {
            $sign = ""
            $fc = "Red"
        }
        else {
            $sign = "+"
            $fc = "Green"
        }
        $p = "(UK $sign$($h.ToString()))"
    
        write-host -ForegroundColor $fc -BackgroundColor Black $p -NoNewline
    }
    #endregion
    
    #region custom/fun function
    if ((get-date).Month -eq 12 -and (get-date).Day -lt 25) {
        $msg = "["
        $msg += TimetoSanta -purpose Prompt
        $msg += "]"
        Write-Host $msg -NoNewline -BackgroundColor Red -ForegroundColor DarkBlue
    }
    #endregion

    #region last command execution duration
    try {        
        $history = Get-History -ErrorAction Ignore -Count 1
        if ($history) {
            $ts = New-TimeSpan $history.StartExecutionTime  $history.EndExecutionTime
            Write-Host "[" -NoNewline
            switch ($ts) {
                {$_.TotalSeconds -lt 1} { 
                    [decimal]$d = $_.TotalMilliseconds
                    '{0:f3}ms' -f ($d) | Write-Host  -ForegroundColor Black -NoNewline -BackgroundColor DarkGreen
                    break
                }
                {$_.totalminutes -lt 1} { 
                    [decimal]$d = $_.TotalSeconds
                    '{0:f3}s' -f ($d) | Write-Host  -ForegroundColor Black -NoNewline -BackgroundColor DarkYellow
                    break
                }
                {$_.totalminutes -lt 30} { 
                    [decimal]$d = $ts.TotalMinutes
                    '{0:f3}m' -f ($d) | Write-Host  -ForegroundColor Gray -NoNewline  -BackgroundColor Red
                    break
                }
                Default {
                    $_.Milliseconds | Write-Host  -ForegroundColor Gray -NoNewline
                }
            }
            Write-Host "]" -NoNewline
        }
    }
    catch { }
    #endregion

    #region reduce the path displayed if it is long
    if (($pwd.Path.Split('\').count -gt 2)) {        
        $One = $pwd.path.split('\')[-1]
        $Two = $pwd.path.split('\')[-2]

        if ($One.Length -gt 10) {$One = "$($One[0..7] -join '')~"}
        if ($Two.Length -gt 10) {$Two = "$($Two[0..7] -join '')~"}

        write-host " $($pwd.path.split('\')[0], '...', $Two, $One -join ('\'))" -NoNewline
    }
    else {
        Write-Host " $($pwd.path)" -NoNewline
    }
    #endregion
    "> "
}