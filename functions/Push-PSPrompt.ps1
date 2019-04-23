function Push-PSPrompt {
    <#
    .synopsis
    Worker function that builds up the prompt.ps1 file and dot sources it
    
    #>
    ##    [cmdletbinding()]
    # not sure we need a parameter for this - let's read it every time from the comfig file
    # param(
    #     [parameter()]$PSPromptData
    # )
    #region build up script from components
    $PromptFile = "$WorkingFolder\MyPrompt.ps1"
    $ModulePath = ($env:PSModulePath -split (';'))[1]
    $components = "$(split-path (get-module psprompt | Sort-Object version -Descending | Select-Object -First 1 ).path -Parent)\functions\components" 

    Write-Warning $components

    # step one - the start of a function boiler-plate
    get-content "$components\_header.txt" | Out-File $PromptFile -Force

    # read in the settings from the config file created in Set-PSPrompt
    if (test-path "$WorkingFolder\PSPrompt.config" ) {
        $PSPromptData = import-Clixml -Path "$WorkingFolder\PSPrompt.config" 
    }
    else {
        $msg = "Unable to read config file at $WorkingFolder\PSPrompt.config, check that it exists and then run Set-PSPrompt. "
        Write-Warning $msg
    }

    # now for each value from out hash table we need to gather the 
    switch ($PSPromptData) {
        { $_.Admin } { get-content "$components\admin.txt" | Out-File $PromptFile -Append }
        { $_.Battery } { get-content "$components\battery.txt" | Out-File $PromptFile -Append }
        { $_.Day_and_date } { get-content "$components\daydate.txt" | Out-File $PromptFile -Append }
        { $_.UTC_offset } { get-content "$components\UTC_offset.txt" | Out-File $PromptFile -Append }
        { $_.last_command } { get-content "$components\last_command.txt" | Out-File $PromptFile -Append }
        { $_.shortpath } { get-content "$components\shortpath.txt" | Out-File $PromptFile -Append }
    }

    # complete the Prompt function in the file so that we can dot source it dreckly
    Get-Content "$components\_footer.txt" | Out-File $PromptFile -Append
    Write-Verbose "PSPrompt set from invoking $PromptFile"

    # dot source the prompt to apply the changes
    try {  
        . $PromptFile
        write-host "`r`nCongratulations!! `r`nYour prompt has been updated. If you want to change the components in effect, just run Set-PSPrompt again. 
        `r`nIf you want to remove the PSPrompt changes run Set-PSPrompt -reset`r`n"
    }    
    catch {
        Write-Warning "Something went wrong with applying the PSPrompt changes." 
    }
    #endregion
}