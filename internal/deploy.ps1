
#region work laptop
###################

# publish local
set-location "C:\Users\jonallen\OneDrive\Github\PSPrompt\"
Publish-Module -path 'C:\Users\jonallen\OneDrive\Github\PSPrompt' -Repository LocalRepo 

#install
Install-Module -Repository localrepo PSPrompt -Force -MinimumVersion 0.2.2

get-module psprompt -ListAvailable

#import
import-module -name psprompt -Force -RequiredVersion 0.2.2

get-command -module PSPrompt

ddg is this thing working

cal -Next7 | ft -AutoSize -Wrap

#remove

Remove-Module psprompt
Uninstall-Module psprompt


install-Module 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force
#Import-Module 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force -Scope CurrentUser



get-command -module PSPrompt
#endregion

#region home laptop
###################

# publish local
set-location "C:\Users\jonathan\OneDrive\Github\PSPrompt\"
Update-ModuleManifest -Path 'C:\Users\jonathan\OneDrive\Github\PSPrompt\PSPrompt.psd1' 

Publish-Module -path 'C:\Users\jonathan\OneDrive\Github\PSPrompt' -Repository LocalRepo

#install
Install-Module -Repository localrepo PSPrompt -Force -Scope CurrentUser

get-module psprompt -ListAvailable

find-module -Repository LocalRepo 

get-command -noun module

#import
import-module -name psprompt -Force -RequiredVersion 0.2.2 -Verbose

get-command -module PSPromptdi

ddg is this thing working

cal -Next7 | ft -AutoSize -Wrap

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