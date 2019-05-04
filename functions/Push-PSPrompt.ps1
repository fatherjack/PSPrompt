function Push-PSPrompt {
    <#
    .synopsis
    Worker function that builds up the MyPrompt.ps1 file and dot sources it to apply selecgted changes
    
    .description
    This is the function that actually applies the change to the users session

    .example

    no real usage exists for this but it would be called as 

    Push-PSPrompt
    
    #>
    ##    [cmdletbinding()]
    # not sure we need a parameter for this - let's read it every time from the comfig file
    # param(
    #     [parameter()]$PSPromptData
    # )
    #region build up script from components
    #begin {
        New-Variable -Name WorkingFolder -Value "$env:APPDATA\PSPrompt" -Option Constant
        $PromptFile = "$WorkingFolder\MyPrompt.ps1"
        $ModulePath = ($env:PSModulePath -split (';'))[1]
        $mpath = (get-module -name psprompt).path
        $Path = split-path $mpath -parent
        $child = "\functions\components"
        write-verbose $path
        write-verbose $child
        $components = (Join-Path -path $Path -ChildPath $child)

    #}
    #process { 

        ####Write-Warning $components

        # step one - the start of a function boiler-plate
        get-content "$components\_header.txt" | Out-File $PromptFile -Force

        # read in the settings from the config file created in Set-PSPrompt
    if (!(test-path "$WorkingFolder\PSPrompt.config" ) {
            $msg = "Unable to read config file at $WorkingFolder\PSPrompt.config, check that it exists or run Set-PSPrompt. "
            Write-Warning $msg
            return
        }
        else {
            $PSPromptData = Import-Clixml -Path "$WorkingFolder\PSPrompt.config" 
        }

        # now for each value from our hash table we need to gather the script component
        # firstly - components in the permanent prompt line 
        switch ($PSPromptData) {
            { $_.Admin } { get-content "$components\admin.txt" | Out-File $PromptFile -Append }
            { $_.Battery } { get-content "$components\battery.txt" | Out-File $PromptFile -Append }
            { $_.Day_and_date } { get-content "$components\daydate.txt" | Out-File $PromptFile -Append }
            { $_.UTC_offset } { get-content "$components\UTC_offset.txt" | Out-File $PromptFile -Append }
            { $_.last_command } { get-content "$components\last_command.txt" | Out-File $PromptFile -Append }
            { $_.shortpath } { get-content "$components\shortpath.txt" | Out-File $PromptFile -Append }
        }
        # then the second prompt line that is shown occasionally
        If ($PSPromptData.SecondLine) {
            switch ($PSPromptData) {
                { $_.GitStatus } { get-content "$components\shortpath.txt" | Out-File $PromptFile -Append }
            }

            # complete the Prompt function in the file so that we can dot source it dreckly
            get-content "$components\_footer.txt" | Out-File $PromptFile -Append
            write-verbose $PromptFile

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
    #}
    #end { }
}