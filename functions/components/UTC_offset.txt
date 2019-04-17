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