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

Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer  -ExcludeRule PSAvoidUsingWriteHost |
#        group scriptname |
Export-Csv "C:\Users\jonat\Documents\PSPrompt_analysis.csv" -NoTypeInformation -Force

Invoke-Item "C:\Users\jonat\Documents\PSPrompt_analysis.csv"

Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer |
Group-Object scriptname, severity

Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer |
Group-Object severity


Get-ChildItem -Path C:\Users\jonat\OneDrive\Documents\GitHub\psprompt\functions -Recurse |
Invoke-ScriptAnalyzer  -ExcludeRule PSAvoidTrailingWhitespace, PSAvoidUsingWriteHost |
Group-Object RuleName




get-help Invoke-ScriptAnalyzer -ShowWindow
get-command -Module PSScriptAnalyzer

Get-ScriptAnalyzerRule | Where-Object RuleName -like "*white*"
#endregion

function prompt { write-output "$pwd >" }
Invoke-Item $env:APPDATA\psprompt

code "$env:APPDATA\psprompt\myprompt.ps1"

. "$env:APPDATA\psprompt\myprompt.ps1"



Invoke-Item C:\Users\jonat\AppData\Roaming\PSPrompt
function prompt { "$pwd>" }

code $PromptFile

if (($profile.CurrentUserAllHosts).Length -gt 0) {
    $p = get-content $profile.CurrentUserAllHosts
    if ($p -match "(##PSPROMPT*)"){
        write-output "PSPROMPT content found in CurrentUserAllHosts"
    }
#    code $profile.CurrentUserAllHosts
}

if (($profile.CurrentUserCurrentHost).Length -gt 0){
    $p = get-content $profile.CurrentUserCurrentHost
    if ($p -match "(##PSPROMPT*)") {
        write-output "PSPROMPT content found in CurrentUserCurrentHost"
    }
#    code $profile.CurrentUserCurrentHost
}

# get the github app key
<#work laptop#>(import-csv -Path "C:\Users\jonallen\Dropbox\git.txt"  | ? name -eq 'git' | select key).key | clip
<#surface#>(import-csv -Path "C:\Users\jonat\Dropbox\git.txt"  | ? name -eq 'git' | select key).key | clip

