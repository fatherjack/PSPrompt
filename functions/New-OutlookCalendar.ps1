
$null = Add-type -assembly "Microsoft.Office.Interop.Outlook" 
$olFolders = "Microsoft.Office.Interop.Outlook.olDefaultFolders" -as [type]
$outlook = new-object -comobject outlook.application
$namespace = $outlook.GetNameSpace("MAPI")

$importance = "Microsoft.Office.Interop.Outlook.olImportance" -as [type]
$importance = 2
$start = (get-date).AddMinutes(15)
#region Create New Calendar Item
$NewEvent = $Outlook.CreateItem(1)
$NewEvent.Subject = "Timmys Birthday"
$NewEvent.Start = $Start
$NewEvent.duration = 15
$NewEvent.Importance = $importance
$NewEvent.ReminderSet = $false
$NewEvent.save()
#endregion

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