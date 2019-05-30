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

# work laptop
set-location "C:\Users\jonallen\OneDrive\Github\PSPrompt\"

Remove-Module psprompt
Import-Module 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force

#home laptop
if(Get-Module psprompt) { Remove-Module psprompt }
Import-Module 'C:\Users\Jonathan\Documents\GitHub\PSPrompt\PSPrompt.psd1' -Verbose -Force
#C:\Users\Jonathan\Documents\GitHub\PSPrompt\PSPrompt.psd1

#home surface
if (Get-Module psprompt) { Remove-Module psprompt }

import-module C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\PSPrompt.psd1 -verbose -force

Get-Command -Module PSPrompt

Install-Module PSScriptAnalyzer -Scope CurrentUser

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

        PSAvoidTrailingWhitespace


        get-help Invoke-ScriptAnalyzer -ShowWindow
        get-command -Module PSScriptAnalyzer

        Get-ScriptAnalyzerRule | where RuleName -like "*white*"


function prompt  {write-output "$pwd >"}
ii $env:APPDATA\psprompt

code . "$env:APPDATA\psprompt\myprompt.ps1"



ii C:\Users\jonat\AppData\Roaming\PSPrompt
function prompt { "$pwd>" }

code $PromptFile