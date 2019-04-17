function Push-PSPrompt {
    <#
    .synopsis
    Worker function that builds up the prompt.ps1 file and dot sources it
    
    #>
    [cmdletbinding()]
    param(
        [parameter()]$PSPromptData
    )
    #region build up script from components
    $PromptFile = "$WorkingFolder\MyPrompt.ps1"
    $ModulePath = ($env:PSModulePath -split (';'))[1]
    $components = "$(split-path (get-module psprompt).path -Parent)\functions\components"

    get-content "$components\_header.txt" | Out-File $PromptFile -Force
            
    switch ($PSPromptData) {
        { $_.Admin } { get-content "$components\admin.txt" | Out-File $PromptFile -Append }
        { $_.Battery } { get-content "$components\battery.txt" | Out-File $PromptFile -Append }
        { $_.Day_and_date } { get-content "$components\daydate.txt" | Out-File $PromptFile -Append }
        { $_.UTC_offset } { get-content "$components\UTC_offset.txt" | Out-File $PromptFile -Append }
        { $_.last_command } { get-content "$components\last_command.txt" | Out-File $PromptFile -Append }
        { $_.shortpath } { get-content "$components\shortpath.txt" | Out-File $PromptFile -Append }
    }

    # complete the Prompt function in the file so that we can dot source it dreckly
    get-content "$components\_footer.txt" | Out-File $PromptFile -Append
    write-verbose $PromptFile

    # dot source the prompt to apply the changes
    try {  
        . $PromptFile
        write-host "Your prompt has been updated. If you want to change the components in effect, just run Set-PSPrompt again. `r`nIf you want to remove the PSPrompt changes run Set-PSPrompt -reset"
    }    
    catch {
        Write-Warning "Something went wrong with applying the PSPrompt changes." 
    }
    #endregion
}