function New-OutlookCalendar {
    <#
    .synopsis
    .description
    .example
    .example
    .link
    olItems <https://docs.microsoft.com/en-us/dotnet/api/microsoft.office.interop.outlook.olitemtype?view=outlook-pia>
    olBusyStatus https://docs.microsoft.com/en-us/dotnet/api/microsoft.office.interop.outlook.olbusystatus?view=outlook-pia
    #>
    [cmdletbinding()]
    param(
        # Start time of new event
        [Parameter(Mandatory = $true)]
        [datetime]$Start,
        # Subject of the new event
        [Parameter(Mandatory = $true)]
        [string]$Subject,
        # How long is the event in minutes (default 30m)
        [Parameter()]
        [int]$Duration = 30,
        # Busy status
        [Parameter()]
        [validateset('Free','Tentative','Busy','Out of Office','Working away')]
        [string]$Status,
        # No reminder for the event
        [Parameter()]
        [switch]$NoReminder
    )

    begin { 
    
        $null = Add-type -assembly "Microsoft.Office.Interop.Outlook" 
        $olFolders = "Microsoft.Office.Interop.Outlook.olDefaultFolders" -as [type]
        $outlook = new-object -comobject outlook.application
        $namespace = $outlook.GetNameSpace("MAPI")

        switch ($status) {
            'Free' { $olStatus = 0 }
            'Tentative' { $olStatus = 1}
            'Busy' { $olStatus = 2 }
            'Out of Office' { $olStatus = 3 }
            'Working Elsewhere' { $olStatus = 4}
        }
    }
    process {
        #region Create New Calendar Item
        $NewEvent = $Outlook.CreateItem(1)
        $NewEvent.Subject = $Subject
        $NewEvent.Start = $Start
        $NewEvent.duration = $Duration
        $NewEvent.BusyStatus = $olStatus
        if ($NoReminder) {
            $NewEvent.ReminderSet = $false
        }
        $NewEvent.save()
        #endregion
    }

    end { }

}

<#
$NewEvent | Get-Member
.alldayevent bool
.body string
.duration .int
.end date
.importance olimportance
.isrecurring bool
.start
.subject


#>