﻿Function Get-OutlookCalendar {
    <#
   .Synopsis
    This function returns InBox items from default Outlook profile

   .Description
    This function returns InBox items from default Outlook profile. It
    uses the Outlook interop assembly to use the olFolderInBox enumeration.
    It creates a custom object consisting of Subject, ReceivedTime, Importance,
    SenderName for each InBox item.
    *** Important *** depending on the size of your InBox items this function
    may take several minutes to gather your InBox items. If you anticipate
    doing multiple analysis of the data, you should consider storing the
    results into a variable, and using that.

    .Example
    Get-OutlookCalendar -StartTime (get-date).date -EndTime ((get-date).adddays(+7)).date

    This returns all calendar events for the forth-coming 7 days

    .Example
    Get-OutlookCalendar -StartTime (get-date).date -EndTime ((get-date).adddays(+1)).date -verbose

    This returns all calendar events for the forth-coming 24 hours

    .Example
    Get-OutlookCalendar -Today | ft -a -Wrap

    This example uses the -Today switch to get information just for the current day. Output is formatted as a table

    .Notes
    # genesis of Outlook access from https://gallery.technet.microsoft.com/scriptcenter/af63364d-8b04-473f-9a98-b5ab37e6b024
    NAME:  Get-OutlookInbox
    AUTHOR: ed wilson, msft
    LASTEDIT: 05/13/2011 08:36:42
    KEYWORDS: Microsoft Outlook, Office
    HSG: HSG-05-26-2011

   .Link
     Http://www.ScriptingGuys.com/blog
 #>
    [outputtype([system.string])]
    [alias('cal', 'event')]
    [cmdletbinding(DefaultParameterSetName = "Today")]
    param(
        # Start of time span to show calendar events.
        [Parameter(ParameterSetName = "StartEnd",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Start of time span to show calendar events.")]
        [datetime]$StartTime,
        # End of time span to show calendar events.
        [Parameter(ParameterSetName = "StartEnd",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "End of time span to show calendar events.")]
        [datetime]$EndTime,
        # Show calendar events for just today.
        [Parameter(ParameterSetName = "Today",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Show calendar events for just today.")]
        [switch]$Today,
        # Show calendar events for next 7 days.
        [Parameter(ParameterSetName = "Next7Days",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Show calendar events for next 7 days.")]
        # use Next7 to get the next 7 days of calendar events
        [switch]$Next7
    )

    begin {
        Write-Verbose "command is : $command"
        Write-Verbose " folder items : $(($script:eventsfolder).count) "
        $null = Add-type -assembly "Microsoft.Office.Interop.Outlook"
        $olFolders = "Microsoft.Office.Interop.Outlook.olDefaultFolders" -as [type]
        $outlook = new-object -comobject outlook.application
        $namespace = $outlook.GetNameSpace("MAPI")
        $script:eventsfolder = $namespace.getDefaultFolder($olFolders::olFolderCalendar)

        $msg = "Getting you outlook calendar takes a few seconds ..."
        Write-Host $msg
        $today = $true
        # just todays events
        if ($Today) {
            $StartTime = (get-date).Date
            $EndTime = ((get-date).AddDays(+1)).date
        }
        # events for the whole week
        if ($Next7) {
            $StartTime = (get-date).Date
            $EndTime = ((get-date).AddDays(+7)).date
        }
        $BusyStatus = @{
            0 = "Free"
            1 = "Tentative"
            2 = "Busy"
            3 = "Out of Office"
            4 = "Working away"
        }
    }
    process {
        # actually go and get the calendar events for the chosen period
        $cal = $script:eventsfolder.items |
        Where-Object { $_.start -gt $StartTime -and $_.start -lt $EndTime } |
        Select-Object subject, start, end, busystatus, @{name = 'Duration'; expression = { "*" * (New-TimeSpan -Start $_.start -End $_.end).TotalHours } }
        if ($cal.count -eq 0) {
            "Nothing in your calendar"
        }
        else {
            $cal | Select-Object Subject, Start, End, @{name = "Busy status"; expression = { $BusyStatus[$_.busystatus] } }, Duration
        }
    }
    end { }
} #end function

