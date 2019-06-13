$Promptoptions = @{
    admin   = $true
    battery = $false

}

$Promptoptions -eq $true | prompt

$PSPromptData = @{
    Adminuser    = $true
    Battery      = $true
    Day_and_date = $true
    UTC_offset   = $true
    fun_function = $true
    current_path = $true
    last_command = $true
}

$PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"

$PSPromptData = $null

$PSPromptData = import-Clixml -Path "$WorkingFolder\PSPrompt.config"

write-verbose $PSPromptData


Write-Host "`r`n(GMT +1)" -ForegroundColor Green -NoNewline
Write-Host "`tor`t" -ForegroundColor white -NoNewline
Write-Host "(GMT -3) `r`n" -ForegroundColor Red

#region work laptop

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

# publish local
set-location "C:\Users\jonathan\OneDrive\Github\PSPrompt\"
Publish-Module -path 'C:\Users\jonathan\OneDrive\Github\PSPrompt' -Repository LocalRepo

#install
Install-Module -Repository localrepo PSPrompt -Force -MinimumVersion 0.2.2

get-module psprompt -ListAvailable

find-module -Repository LocalRepo 

get-command -noun module

#import
import-module -name psprompt -Force -RequiredVersion 0.2.2

get-command -module PSPrompt

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
Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer  -ExcludeRule PSAvoidUsingWriteHost |
#        group scriptname |
Export-Csv "C:\Users\jonat\Documents\PSPrompt_analysis.csv" -NoTypeInformation -Force

ii "C:\Users\jonat\Documents\PSPrompt_analysis.csv"

Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer |
group scriptname, severity

Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer |
group severity


Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer  -ExcludeRule PSAvoidTrailingWhitespace, PSAvoidUsingWriteHost |
group RuleName




get-help Invoke-ScriptAnalyzer -ShowWindow
get-command -Module PSScriptAnalyzer

Get-ScriptAnalyzerRule | where RuleName -like "*white*"
#endregion

function prompt { write-output "$pwd >" }
ii $env:APPDATA\psprompt

code "$env:APPDATA\psprompt\myprompt.ps1"

. "$env:APPDATA\psprompt\myprompt.ps1"



ii C:\Users\jonat\AppData\Roaming\PSPrompt
function prompt { "$pwd>" }

code $PromptFile