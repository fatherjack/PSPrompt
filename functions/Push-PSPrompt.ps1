function Push-PSPrompt {
    <#
    .synopsis
    Worker function that builds up the MyPrompt.ps1 file and dot sources it to apply selecgted changes

    .description
    This is the function that actually applies the change to the users session

    .example

    Push-PSPrompt

    #>

    #region build up script from components
        New-Variable -Name WorkingFolder -Value "$env:APPDATA\PSPrompt" -Option Constant
        $PromptFile = "$WorkingFolder\MyPrompt.ps1"
        ## unused variable? $ModulePath = ($env:PSModulePath -split (';'))[1]
        $mpath = (get-module -name psprompt).path
        $Path = split-path $mpath -parent
        $child = "\functions\components"
        write-verbose $path
        write-verbose $child
        $components = (Join-Path -path $Path -ChildPath $child)
        Write-Debug "" # used as a stop line for review of variable assignment during debug
        $components = (Join-Path -path $Path -ChildPath $child -Resolve)


        # step one - the boiler-plate start of a function 
        get-content "$components\_header.txt" | Out-File $PromptFile -Force

        # next read in the settings from the config file created in Set-PSPrompt
        if (!(test-path "$WorkingFolder\PSPrompt.config" )) {
            $msg = "Unable to read config file at $WorkingFolder\PSPrompt.config, check that it exists or run Set-PSPrompt. "
            Write-Warning $msg
            return
        }
        else {
            Write-Verbose "Reading settings from $WorkingFolder\PSPrompt.config"
            $PSPromptData = Import-Clixml -Path "$WorkingFolder\PSPrompt.config"
        }

        # now for each value from our hash table where True means we need to gather the script component to build up the prompt

        #region first to build is the 'second' prompt line that is shown occasionally above the prompt
        If ($PSPromptData.SecondLine) {
            # add header of Nth command
            get-content "$components\NthCommandHeader.txt" | Out-File $PromptFile -Force -Append
            # add second line content
            switch ($PSPromptData) {
                { $_.GitStatus } { get-content "$components\GitStatus.txt" | Out-File $PromptFile -Append }
            }
            # add footer of Nth command
            get-content "$components\NthCommandFooter.txt" | Out-File $PromptFile -Force -Append
        }
        #endregion

        #region - now, all the components selected to be shown in the permanent prompt line
        switch ($PSPromptData) {
            { $_.Admin } { get-content "$components\admin.txt" | Out-File $PromptFile -Append }
            { $_.Battery } { get-content "$components\battery.txt" | Out-File $PromptFile -Append }
            { $_.Day_and_date } { get-content "$components\daydate.txt" | Out-File $PromptFile -Append }
            { $_.UTC_offset } { get-content "$components\UTC_offset.txt" | Out-File $PromptFile -Append }
            { $_.last_command } { get-content "$components\last_command.txt" | Out-File $PromptFile -Append }
            { $_.shortpath } { get-content "$components\shortpath.txt" | Out-File $PromptFile -Append }
        }
        #endregion

        # complete the Prompt function boiler plate in the file so that we can dot source it dreckly
        get-content "$components\_footer.txt" | Out-File $PromptFile -Append
        write-verbose "Function compiled from components and now saved as $PromptFile"

        #region Final step is now to apply the prompt to the current session
        # dot source the prompt function to apply the changes
        try {
            Write-Verbose "Dot sourcing $Promptfile"
            . $PromptFile 
            write-host "`r`nCongratulations!! `r`nYour prompt has been updated. If you want to change the components in effect, just run Set-PSPrompt again.
        `r`nIf you want to remove the PSPrompt changes run Set-PSPrompt -reset`r`n"
        }
        catch {
            Write-Warning "Something went wrong with applying the PSPrompt changes."
            Write-Warning "Try running <. $PromptFile>"
        }
        #endregion
    }