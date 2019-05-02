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
Remove-Module psprompt
Import-Module 'C:\Users\jonallen\OneDrive\Github\PSPrompt\PSPrompt.psd1' -Verbose -Force

#home laptop
Remove-Module psprompt
import-module 'C:\Users\Jonathan\Documents\GitHub\PSPrompt\PSPrompt.psd1' -Verbose -Force
