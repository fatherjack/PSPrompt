
# from https://sqlnotesfromtheunderground.wordpress.com/2014/09/06/by-example-powershell-commands-for-outlook/
#########################################################################################
## Outlook Commands by Example
#########################################################################################
 
 
#########################################################################################
## Connect to Outlook
 
# Outlook Connection
$Outlook = New-Object -ComObject Outlook.Application
 
## Listing Folders in Outlook (Shows Email, Calendar, Tasks etc)
$OutlookFolders = $Outlook.Session.Folders.Item(1).Folders
$OutlookFolders | Format-Table FolderPath
 
## Using Default 
$OutlookDeletedITems = $Outlook.session.GetDefaultFolder(3)
$outlookOutbox = $Outlook.session.GetDefaultFolder(4)
$OutlookSentItems = $Outlook.session.GetDefaultFolder(5)
$OutlookInbox = $Outlook.session.GetDefaultFolder(6)
$OutlookCalendar = $Outlook.session.GetDefaultFolder(9)
$OutlookContacts = $Outlook.session.GetDefaultFolder(10)
$OutlookJournal = $Outlook.session.GetDefaultFolder(11)
$OutlookNotes = $Outlook.session.GetDefaultFolder(12)
$OutlookTasks = $Outlook.session.GetDefaultFolder(13)
 
 
# #########################################################################################
# ## Inbox Folders
 
# # List all Folders 
# $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Folders | ft FullFolderPath 
 
# # Create folder
# $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Folders.Add(&quot; Scripts Received&quot; )
 
# # Delete Folder
# $OutlookFolderToDelete = $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Folders.Item(&quot; Scripts Received&quot; )
# $OutlookFolderToDelete.Delete()
 
 
# #########################################################################################
# ## Inbox Email
 
# ## Navigating to Sub folder of Inbox called Daily Tasks
# $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Folders.Item(&quot; Daily Tasks&quot; )
 
# # Read All Emails in a Folder Path Inbox -&amp;gt; SPAM Mail
# $EmailsInFolder = $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Folders.Item(&quot; SPAM Folder&quot; ).Items
# $EmailsInFolder | ft SentOn, Subject, SenderName, To, Sensitivity -AutoSize -Wrap
 
# # Send an Email from Outlook
# $Mail = $Outlook.CreateItem(0)
# $Mail.To = &quot; stephen@badseeds.local&quot;
# $Mail.Subject = &quot; Action&quot;
# $Mail.Body = &quot; Pay rise please&quot;
# $Mail.Send()           
 
# # Delete an Email from the folder Inbox with Subject Title &quot;Action&quot;
# $EmailInFolderToDelete = $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Items
# $EmailInFolderToDelete | ft SentOn, Subject, SenderName, To, Sensitivity -AutoSize -Wrap
# $EmailToDelete = $EmailInFolderToDelete | Where-Object { $_.Subject -eq &quot; Action&quot; }
# $EmailToDelete.Delete()
 
# # Delete All Emails in Folder.Items
# $EmailsInFolderToDelete = $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Folders.Item(&quot; SPAM Folder&quot; ).Items
# foreach ($email in $EmailsInFolderToDelete) {
#     $email.Delete()
# }
 
# # Move Emails from Inbox to Test folder
# $EmailIToMove = $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Items
# $EmailIToMove | ft SentOn, Subject, SenderName, To, Sensitivity -AutoSize -Wrap
# $NewFolder = $Outlook.Session.Folders.Item(1).Folders.Item(&quot; Inbox&quot; ).Folders.Item(&quot; test&quot; )
 
# FOREACH ($Email in $EmailIToMove ) { 
#     $Email.Move($NewFolder) 
# }
 
  
#########################################################################################
## Calender
 
## Connect to Calendar 
$OutlookCalendar = $Outlook.session.GetDefaultFolder(9)
 
# Read Calendar 
$OutlookCalendar.Items | Format-Table subject, start
 
#region Create New Calendar Item
$NewEvent = $Outlook.CreateItem(1)
$NewEvent.Subject = &quot; Timmys Birthday&quot;
$NewEvent.Start = [datetime]”10/9/2014&quot;
$NewEvent.save()
#endregion

#region

#Create recuring Event
$NewEvent = $Outlook.CreateItem(1)
$NewEvent.Subject = &quot;Timmys Birthday&quot;
$NewEvent.Start = [datetime]”10 / 9 / 2014&quot;
$Recur = $NewEvent.GetRecurrencePattern()
$Recur.Duration = 1440
$Recur.Interval = 12
$Recur.RecurrenceType = 5
$Recur.Noenddate = $TRUE
$NewEvent.save()

#endregion


#region Delete Event - Timmys Birthday
$TimmyCalendar = $OutlookCalendar.Items | Where-Object { $_.Subject -eq &quot; Timmys Birthday&quot; }
$TimmyCalendar.Delete()
#endregion

$today
$OutlookCalendar.Items | Where-Object start -gt (get-date).date # ft subject, start

$TodaysEvents = $OutlookCalendar.Items | Where-Object { $_.start -gt (get-date).date -and $_.start -lt ((get-date).adddays(+1)).date } # ft subject, start

$TodaysEvents | select subject, start, end | sort Start

# #########################################################################################
# ## Tasks
 
# # Read Tasks
# $OutlookTasks = $Outlook.session.GetDefaultFolder(13).Items
# $OutlookTasks | ft Subject, Body
 
# # Create a task
# $newTaskObject = $Outlook.CreateItem(&quot; olTaskItem&quot; )
# $newTaskObject.Subject = &quot; New Task&quot;
# $newTaskObject.Body = &quot; This is the main text&quot;
# $newTaskObject.Save()
 
# # Delete a task
# $OutlookTasks = $Outlook.session.GetDefaultFolder(13).Items
# $DeleteTask = $OutlookTasks | Where-Object { $_.Subject -eq &quot; New Task&quot; }
# $DeleteTask.Delete()
 
# # Edit a task
# $OutlookTasks = $Outlook.session.GetDefaultFolder(13).Items
# $Task = $OutlookTasks | Where-Object { $_.Subject -eq &quot; New Task&quot; }
# $Task.Body = &quot; Updated Results&quot;
# $Task.Save()
 
 
# #########################################################################################
# ## Contacts
 
# # Read Contacts
# $OutlookContacts = $Outlook.session.GetDefaultFolder(10).items
# $OutlookContacts | Format-Table FullName, MobileTelephoneNumber, Email1Address
 
# # Add a Contact
# $OutlookContacts = $Outlook.session.GetDefaultFolder(10)
# $NewContact = $OutlookContacts.Items.Add()
# $NewContact | gm
# $NewContact.FullName = &quot; John&quot;
# $NewContact.Email1Address = &quot; John@Badseeds.local&quot;
# $NewContact.Save()
 
# # Delete Contact Full Name - &quot;John&quot;
# $OutlookContacts = $Outlook.session.GetDefaultFolder(10).items
# $DeleteJohn = $OutlookContacts | Where-Object { $_.FullName -eq &quot; John&quot; }
# $DeleteJohn.Delete()
 
# # Update Contact
# $OutlookContacts = $Outlook.session.GetDefaultFolder(10).items
# $John = $OutlookContacts | Where-Object { $_.FullName -eq &quot; John&quot; }
# $John.CompanyName = &quot; BadSeeds&quot;
# $John.Save()