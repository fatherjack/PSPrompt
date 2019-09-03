function Push-PSPrompt {
    <#
    .synopsis
    Worker function that builds up the MyPrompt.ps1 file and dot sources it to apply selecgted changes

    .description
    This is the function that actually applies the change to the users session

    .example

    Push-PSPrompt

    Use Push-PSPrompt to make the customisation take effect

    #>

    #region build up script from components
        New-Variable -Name WorkingFolder -Value "$env:APPDATA\PSPrompt" -Option Constant
        $PromptFile = "$WorkingFolder\MyPrompt.ps1"
        ## unused variable? $ModulePath = ($env:PSModulePath -split (';'))[1]
        $mpath = (Get-Module -name psprompt)[-1].path
        $Path = Split-Path $mpath -parent
        $child = "\functions\components"
        Write-Verbose $mpath
        Write-Verbose $path
        Write-Verbose $child
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
        # dot source the prompt function to apply the changes to the prompt
        # and then add prompt function code to the profile
        try {
            Write-Verbose "Dot sourcing $Promptfile"
            . $PromptFile

            Write-Verbose "Adding prompt to CurrentUserAllHosts profile"
            $prompt = get-content $Promptfile
            $profilefile = $profile.CurrentUserAllHosts
            # check if there is a PSPROMPT function already there
            $Exists = get-content $profilefile
            if($Exists -match "PSPROMPTSTART(?s)(.*)PSPROMPTEND","jumboreplace" ){
                Write-Verbose "Existing prompt found in profile"
                $Exists -replace "PSPROMPTSTART(?s)(.*)PSPROMPTEND",$null | Set-Content $profilefile
                Write-Verbose "Previous PSPrompt found and removed from profile"
            }
            $prompt | Out-File $profilefile -Append
            write-host "`r`nCongratulations!! `r`nYour prompt and your CurrentUserAllHosts profile have been updated . If you want to change the components in effect, just run Set-PSPrompt again.
        `r`nIf you want to remove the PSPrompt changes run Set-PSPrompt -reset`r`n"
        }
        catch {
            Write-Warning "Something went wrong with applying the PSPrompt changes."
            Write-Warning "Try running <. $PromptFile>"
        }
        #endregion
    }