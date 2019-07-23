

# get the github app key
(import-csv -Path "C:\Users\jonallen\Dropbox\git.txt"  | ? name -eq 'git' | select key).key | clip

#region work laptop
###################

# publish local
set-location "C:\Users\jonallen\OneDrive\Github\PSPrompt\"

Update-ModuleManifest -Path 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -ModuleVersion 0.2.3

Publish-Module -path 'C:\Users\jonallen\OneDrive\Github\PSPrompt' -Repository LocalRepo 

#install
update-Module -Repository localrepo PSPrompt -Force -MinimumVersion 0.2.3

get-module psprompt -ListAvailable

#import
import-module -name psprompt -Force -RequiredVersion 0.2.3

update-module -name psprompt -Verbose 

get-command -module PSPrompt

Invoke-WebSearch is this thing working

Get-OutlookCalendar -Next7 | Format-Table -AutoSize -Wrap

#remove

Remove-Module psprompt -Verbose
Uninstall-Module psprompt


install-Module 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force
#Import-Module 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force -Scope CurrentUser



get-command -module PSPrompt
#endregion

#region home laptop
###################

# publish local
set-location "C:\Users\jonathan\OneDrive\Github\PSPrompt\"
Update-ModuleManifest -Path 'C:\Users\jonathan\OneDrive\Github\PSPrompt\PSPrompt.psd1' -ModuleVersion 0.2.2

Publish-Module -path 'C:\Users\jonathan\OneDrive\Github\PSPrompt' -Repository LocalRepo -NuGetApiKey 'ThisIsAFiller' 


#install
Install-Module -Repository localrepo PSPrompt -Force -Scope CurrentUser

get-module psprompt -ListAvailable | select Name, RepositorySourceLocation, Version

find-module -Repository LocalRepo 

get-command -noun module

#import
import-module -name psprompt -Force -RequiredVersion 0.2.2 -Verbose

get-command -module PSPrompt

Invoke-WebSearch is this thing working

Get-OutlookCalendar -Next7 | Format-Table -AutoSize -Wrap

#remove

Remove-Module psprompt
Uninstall-Module psprompt


install-Module 'C:\Users\jonathan\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force
#Import-Module 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force -Scope CurrentUser



get-command -module PSPrompt

if (Get-Module psprompt) { Remove-Module psprompt }
Import-Module 'C:\Users\Jonathan\Documents\GitHub\PSPrompt\PSPrompt.psd1' -Verbose -Force
#C:\Users\Jonathan\Documents\GitHub\PSPrompt\PSPrompt.psd1
#endregion

#region home surface
if (Get-Module psprompt) { 
    Remove-Module PSPrompt
    Remove-Module PSPrompt -Force
}

import-module C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\PSPrompt.psd1 -verbose -force

Get-Command -Module PSPrompt

Install-Module PSScriptAnalyzer -Scope CurrentUser

#endregion