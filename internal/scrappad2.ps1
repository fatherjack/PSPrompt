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