function New-OutlookCalendar {
    <#
    .synopsis
    command line Outlook calendar event creation

    .description
    Quickly and easily add meetings and reminders to your Outlook calendar via your keyboard without leaving your PowerShell host

    .example
    New-OutlookCalendar -Start '20-Mar-2019 12:00' -Subject "Get birthday present for Timmy" -Status 'Out of Office'

    This example create a 30 minute event in the calendar at 12:00 on 20th Mar 2019 with a subject of "Get birthday present for Timmy" with a reminder

    .example
    New-OutlookCalendar -Start (get-date -date ((get-date).ToShortDateString())).AddHours(18) -Subject "After work drinks" -Status 'Busy' -duration 180

    This example create a 3 hour event in the calendar at 18:00 today with a subject of "After work drinks" with a reminder
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
        # How long is the event in minutes (default - 30m)
        [Parameter()]
        [int]$Duration = 30,
        # Busy status (default - Busy)
        [Parameter()]
        [validateset('Free', 'Tentative', 'Busy', 'Out of Office', 'Working away')]
        [string]$Status = "Busy",
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
            'Tentative' { $olStatus = 1 }
            'Busy' { $olStatus = 2 }
            'Out of Office' { $olStatus = 3 }
            'Working away' { $olStatus = 4 }
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