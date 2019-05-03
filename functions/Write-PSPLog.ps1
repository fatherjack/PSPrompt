function Write-PSPLog {
    <#
    .Synopsis
    Worker function for PSPrompt

    .Description
    Called internally by PSPrompt to store log info and facilitate prompt information such as battery drain rate

    .Example
    Write-PSPLog -message ("It's test # $_ everybody." ) -Source "Testing"

    This writes a message to the PSPLog.log
    
    #>
    [cmdletbinding()]
    param(
        # message to be written to the log
        [parameter()]
        [string]$Message,
        # where the message has been sent from
        [Parameter()]
        [string]
        $Source
    )
    begin {
        $LogFile = "C:\temp\PSPLog.log"
        # check we have a logfile
        if (!(test-path $LogFile)) {
            $null = New-Item -Path $LogFile -ItemType File
        }
        else {
            # check the logfile isnt getting too big
            $file = get-item $LogFile
            if ($file.length -gt 5MB) {
                # if its big rename it and recreate it
                $date = (get-date).ToString("yyyyMMdd")
                try {
                    $archive = $($file.FullName -replace '\.log', "") + $date + "_archive.log"
                    $null = $File.CopyTo($archive)
                    Set-Content -Value "" -Path $LogFile
                    $msg = "{0}`t{1}`t{2}" -f (get-date).ToString("yyyyMMddHHmmss"), 'Internal', "previous PSPrompt Log file archived"
                    $msg | Out-File -FilePath $LogFile -Append
                }
                catch {
                    Write-Warning "Unable to archive / reset PSPrompt Log file"
                    $msg = "{0}`t{1}`t{2}" -f (get-date).ToString("yyyyMMddHHmmss"), $Source, "Unable to archive / reset PSPrompt Log file"
                    $msg | Out-File -FilePath $LogFile -Append 
                    $msg = "{0}`t{1}`t{2}" -f (get-date).ToString("yyyyMMddHHmmss"), $Source, $error[0].Exception
                    $msg | Out-File -FilePath $LogFile -Append -Encoding 
                    
                }                
            }
        }
    }
    process {
        $msg = "{0}`t{1}`t{2}" -f (get-date).ToString("yyyyMMddHHmmss"), $Source, $message
        $msg | Out-File -FilePath $LogFile -Append 
    }
    end { }
}
