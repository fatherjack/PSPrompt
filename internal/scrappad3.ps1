# new things 
# :: get calendar events at your prompt
# :: create calendar event from the prompt
# :: start an email from prompt

# Outlook Connection
$Outlook = New-Object -ComObject Outlook.Application
[Reflection.Assembly]::LoadWithPartialname("Microsoft.Office.Interop.Outlook") | out-null
$olFolders = "Microsoft.Office.Interop.Outlook.OlDefaultFolders" -as [type]

## Connect to Calendar 
#$OutlookCalendar = $Outlook.session.GetDefaultFolder(9)

$namespace = $outlook.GetNameSpace("MAPI")
$Calendar = $namespace.GetDefaultFolder($olFolders::olFolderCalendar)

# Todays events
$TodaysEvents = $Calendar.Items | Where-Object { $_.start -gt (get-date).date -and $_.start -lt ((get-date).adddays(+1)).date } 
Write-Host "Today's events"
$TodaysEvents | Select-Object subject, start, end | Sort-Object Start

# This week events
$ThisWeekEvents = $Calendar.Items | Where-Object { $_.start -gt (get-date).date -and $_.start -lt ((get-date).adddays(+7)).date } 
Write-Host "This week's events"
$ThisWeekEvents | Select-Object subject, start, end | Sort-Object Start


# # alternate method
# [Reflection.Assembly]::LoadWithPartialname("Microsoft.Office.Interop.Outlook") | out-null
# $olFolders = "Microsoft.Office.Interop.Outlook.OlDefaultFolders" -as [type]

# $outlook = new-object -comobject outlook.application
# $namespace = $outlook.GetNameSpace("MAPI")
# $Calendar = $namespace.GetDefaultFolder($olFolders::olFolderCalendar)
# "There are $($Calendar.Items.Count) calendar entries. They have these properties:"
# $Calendar.Items | Select -First 1 | Get-Member
# $r = $Calendar.Items | Where-Object { $_.start -gt (get-date).date -and $_.start -lt ((get-date).adddays(+7)).date } 
# "Here's a list:"
# $r | Format-Table Start, Subject -AutoSize -Wrap

# from https://lazywinadmin.com/2015/06/powershell-using-office-365-rest-api-to.html#
Invoke-RestMethod `
    -Uri "https://outlook.office365.com/api/v1.0/users/sharedmailbox@domain.com/calendarview?startDateTime=$(Get-Date)&endDateTime=$((Get-Date).AddDays(7))"`
    -Credential (Get-Credential) |
    foreach-object{ $_.Value }