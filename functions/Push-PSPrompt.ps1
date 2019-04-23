function Push-PSPrompt {
    <#
    .synopsis
    Worker function that builds up the prompt.ps1 file and dot sources it
    
    #>
    [cmdletbinding()]
    # not sure we need a parameter for this - let's read it every time from the comfig file
    # param(
    #     [parameter()]$PSPromptData
    # )
    #region build up script from components
    $PromptFile = "$WorkingFolder\MyPrompt.ps1" # the file we create with the prompt function in it
    $ModulePath = ($env:PSModulePath -split (';'))[1] 
    [string]$components = ("$(split-path (get-module psprompt).path[1] -Parent)\functions\components").Split(' ')# [1] # where we go hunting for code segments (the building blocks for the)

    Write-Warning $components

    # step one - the start of a function boiler-plate
    get-content "$components\_header.txt" | Out-File $PromptFile -Force

    # read in the settings from the config file created in Set-PSPrompt
    if (test-path "$WorkingFolder\PSPrompt_dev.config" ) {
        $PSPromptData = import-Clixml -Path "$WorkingFolder\PSPrompt_dev.config" 
    }
    else {
        $msg = "Unable to read config file at $WorkingFolder\PSPrompt_dev.config, check that it exists and then run Set-PSPrompt. "
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