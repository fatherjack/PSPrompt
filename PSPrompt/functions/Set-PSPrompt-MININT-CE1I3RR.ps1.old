
function Set-PSPrompt {
    <#
    .synopsis
    The function that creates the desired prompt function.

    .description
    It has to build a command out of the component pieces as it will be executed every time a command is executed and therefore cant make use of any parameterisation

    .example
    there are no examples at the moment

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]

    Param(
        ## dont think we need parameters [parameter(parametersetname = "default")][switch]$AddToProfile,
        ## dont think we need parameters [parameter(parametersetname = "default")][switch]$Admin,
        ## dont think we need parameters [parameter(parametersetname = "default")][switch]$Battery,
        # switch to reset to console prompt back to original state
        [parameter()][switch]$Reset
    )

    $PSPromptData = [ordered]@{ }
    New-Variable -Name WorkingFolder -Value "$env:APPDATA\PSPrompt" -Option Constant
    $ConfigFile = "PSPrompt*.config" # TODO:: remove this line to set correct config file
    # create working folder for module if its not there
    if (!(Test-Path $WorkingFolder)) {
        $null = New-Item -Path $WorkingFolder -ItemType Directory
    }

    #region preserve the original prompt so that it can be reset if so desired
    Write-Verbose "Preserving original prompt"
    $Date = Get-Date -Format 'yyMMdd-HHmmss'
    $filename = "$WorkingFolder\prompt_$date.ps1"
    $function:prompt | Out-File -FilePath $filename
    Write-Verbose "Existing prompt written out to $filename."

    #endregion - preserve prompt

    #region all processing code
    # code route options:
    # A - user wants to revert to their original prompt, prior to installing PSPrompt
    # B - there is no psprompt definition found so we have to create a new one - essentially this is First Time use
    # C - There are one or more psprompt definitions so we have to allow for user selection
    # D - other


    # 1 gather user preferences from a static json file if it exists
    # 2 user overrides the json option at (?) and wants to add/remove features
    # 3 user wants to revert to their original prompt, prior to installing PSPrompt
    # 4 user selection of prompt features at first execution

    #region Option A - Reset to original prompt
    # need to show options for reset and allow for selection
    if ($Reset) {
        $ProfileCUAHPath = $profile.CurrentUserAllHosts
        $ProfileCUCHPath = $profile.CurrentUserCurrentHost
        $ProfileCUAH = Get-Content $ProfileCUAHPath -Raw
        $ProfileCUCH = Get-Content $ProfileCUCHPath -Raw

        # remove PSPrompt from CurrentUserAllHosts
        if ($PSCmdlet.ShouldProcess("CurrentUserAllHosts", "Remove PSPrompt custom prompt") ) {
            $Exists = get-content $ProfileCUAHPath -Raw
            if ($Exists -match "PSPROMPTSTART(?s)(.*)PSPROMPTEND", "jumboreplace" ) {
                Write-Verbose "Existing prompt found in CurrentUserAllHosts profile"
                $Exists -replace "PSPROMPTSTART(?s)(.*)PSPROMPTEND", $null | Set-Content -Path $ProfileCUAHPath -Verbose
                Write-Verbose "Previous PSPrompt found and removed from CurrentUserAllHosts profile"
            }
        }

        # remove PSPrompt from CurrentUserCurrentHosts
        if ($PSCmdlet.ShouldProcess("CurrentUserCurrentHost", "Remove PSPrompt custom prompt")) {
            $Exists = get-content $ProfileCUCHPath -Raw
            if ($Exists -match "PSPROMPTSTART(?s)(.*)PSPROMPTEND", "jumboreplace" ) {
                Write-Verbose "Existing prompt found in CurrentUserCurrentHost profile"
                $Exists -replace "PSPROMPTSTART(?s)(.*)PSPROMPTEND", $null | Set-Content $ProfileCUCHPath
                Write-Verbose "PSPrompt found and removed from CurrentUserCurrentHost profile"
            }
        }

        return # no more processing in this script
    }
    #endregion Option A - Reset Option
   
    #region Option B - no config file to load so we

    #endregion Option B

    #region Option C
    # there is config file we can load settings from
    # load the settings
    # handle multiple config files
    $ConfigFiles = get-item (join-path $WorkingFolder $configFile)

    if ($ConfigFiles.count -gt 1) {
        # too many files
        $i = 1
        foreach ($File in $ConfigFiles) {
            Write-Host "$i - $File"
            $i++
        }
        do {
            $LoadConfig = Read-Host "There are multiple config files - which do you want to implement?"
            Write-Host "Please select the number of the file you want to import, enter 'configure' to create a new prompt or press Ctrl + C to cancel."
        } until ($LoadConfig -in ((1..$Configfiles.count), 'configure' ) )

        $PSPromptData = Import-Clixml $configFiles[$LoadConfig - 1]
    }
    elseif ($ConfigFiles.count -lt 1) {
        # not enough files
        Write-Warning "No config files found. Need to do something here."
        ## essentially we need to just run this function to create the prompt
    }
    else {
        # happy red riding hood - just the right amount of file
       
        Write-Verbose "Loading from (join-path $WorkingFolder $configFiles[$LoadConfig - 1])"

        $msg = ("WorkingFolder: {0}; ConfigFiles: {1}" -f $WorkingFolder, $ConfigFiles)
        Write-Verbose $msg

        $PSPromptData = Import-Clixml $configFiles
        # confirm to user
        Write-Host "There is a config file that will enable the following PSPrompt features:`r`n"
        Write-Output  $PSPromptData
        while ($choice -notin ('yes', 'no')) {
            $choice = Read-Host -Prompt "Do you want to apply these settings? (Yes) or (No)."
        }
        if ($choice -eq 'yes') {
            if ($PSCmdlet.ShouldProcess("Console Prompt", "Customising being applied")) {
                Push-PSPrompt

                return
            }
        }
        elseif ($choice -eq 'no') {
            if ($PSCmdlet.ShouldProcess("PSPrompt config files" , "Removing")) {
                Write-Verbose "Removing PSPrompt config file."
                Remove-Item $ConfigFiles
                Write-Verbose "Removing MyPrompt.ps1 config file."
                Remove-Item -path (join-path -path (split-path -path $ConfigFiles -parent) -child "myprompt.ps1")
                Write-Verbose "PSPrompt config file removed."
            }
        }
    }
    #endregion Option C

    #region option 1


    #endregion option 1

    #region option 2 - custom choice from command line
    #endregion option 2

    # temporary check of file contents during development
    # start-process notepad "$WorkingFolder\PSPrompt.config"

    # hand over to function that reads in function sectors based on config file settings and invokes the prompt function
    #*#*#*#       Push-PSPrompt $PSPromptData

    #region option 3 - reset

    #endregion option 3

    #region option 4 That means we are at first usage of Set-Prompt so we need to collect user preference
    if (!(test-path (join-path $WorkingFolder $ConfigFile))) {
        Clear-Host
        $msg = @()
        $msg += "Welcome to PSPrompt. It looks like this is your first time using the prompt so you need to make some choices on how you want your prompt to look."
        $msg += "There are some choices coming up and you need to respond with (Y)es or (N)o to each. When you respond (Yes) that feature will be included in your prompt."
        $msg += "If you respond (N)o then the feature wont be applied."
        $msg += "If you want to change your mind at any time, run the command Set-Prompt -options and you will enter this menu again."
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }
        #region Admin user
        $msg = $null
        $msg += "`r`n`r`nFirst of all, do you want a notification when you are running a PS session as an Administrator level account?"
        $msg += "`r`nLike this:"
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }
        Write-Host -ForegroundColor "Black" -BackgroundColor "DarkRed" "[ADMIN]"
        $r = read-host -Prompt "(Y)es to have this in the prompt, (N)o to give it a miss."
        if ($r -eq "y") {
            $PSPromptData.Adminuser = $true
        }
        else {
            $PSPromptData.Adminuser = $false

        }
        # record selection into xml file
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"
        #endregion

        #region Battery
        Clear-Host
        $msg = $null
        $msg += "`r`n`r`nNext, do you work from a laptop? Do you want an indicator of your battery status while you are working on battery power?"
        $msg += "`r`nLike this:"
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }
        $msg = ("[75%:60m]" )
        Write-Host -Object $msg -BackgroundColor Green -ForegroundColor Black
        $r = read-host -Prompt "(Y)es to have this in the prompt, (N)o to give it a miss."
        if ($r -eq "y") {
            $PSPromptData.Battery = $true
        }
        else {
            $PSPromptData.Battery = $false

        }
        # record selection into xml file
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"
        #endregion

        #region Day and Date
        Clear-Host
        $msg = $null
        $msg += "`r`n`r`nNeed to keep your eye on the time? Add the day/date to your prompt?"
        $msg += "`r`nLike this:"
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }

        $msg = "[{0}]" -f (Get-Date -Format "ddd HH:mm:ss")
        Write-Host $msg
        $r = read-host -Prompt "(Y)es to have this in the prompt, (N)o to give it a miss."
        if ($r -eq "y") {
            $PSPromptData.Day_and_date = $true
        }
        else {
            $PSPromptData.Day_and_date = $false

        }
        # record selection into xml file
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"
        #endregion

        #region UTC offset
        Clear-Host
        $msg = $null
        $msg += "`r`n`r`nIf you work across timezones then as your laptop updates to a different timezone we can have your timezone offset indicated in your prompt.`r`n Add the timezone offset to your prompt?"
        $msg += "`r`nLike this:"
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }

        Write-Host "`r`n(GMT +1)" -ForegroundColor Green -NoNewline
        Write-Host "`tor`t" -ForegroundColor white -NoNewline
        Write-Host "(GMT -3) `r`n" -ForegroundColor Red

        $r = read-host -Prompt "(Y)es to have this in the prompt, (N)o to give it a miss."
        if ($r -eq "y") {
            $PSPromptData.UTC_offset = $true
        }
        else {
            $PSPromptData.UTC_offset = $false
        }
        # record selection into xml file
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"
        #endregion

        #region Fun function
        #endregion

        #region last command duration
        Clear-Host
        $msg = $null
        $msg += "`r`n`r`nEveryone likes to write fast executing scripts. Have the execution time of your last script shown right where you are focussed.`r`n Add the previous script duration to your prompt?"
        $msg += "`r`nLike this:"
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }


        Write-Host "`r`n[56ms]" -ForegroundColor Green -NoNewline
        Write-Host "`tor`t" -ForegroundColor white -NoNewline
        Write-Host "[29s] `r`n" -ForegroundColor Red
        $r = read-host -Prompt "(Y)es to have this in the prompt, (N)o to give it a miss."
        if ($r -eq "y") {
            $PSPromptData.last_command = $true
        }
        else {
            $PSPromptData.last_command = $false
        }
        # record selection into xml file
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"
        #endregion

        #region Short Path

        Clear-Host
        $msg = $null
        $msg += "`r`n`r`nSometimes you get down a lot of folder levels and the prompt gets really wide.`r`n We can give you a shortened version of the path"
        $msg += "`r`nLike this:"
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }


        Write-Host "`r`nC:\...\PowerShell\ProfileF~>" -NoNewline
        Write-Host "`tinstead of `t" -ForegroundColor white -NoNewline
        Write-Host "C:\Users\jonallen\OneDrive\Scripts\PowerShell\ProfileFunctions `r`n"
        $r = read-host -Prompt "(Y)es to have this in the prompt, (N)o to give it a miss."
        if ($r -eq "y") {
            $PSPromptData.shortpath = $true
        }
        else {
            $PSPromptData.shortpath = $false
        }

        # record selection into xml file
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"
        #endregion

        #region second line every Nth command
        Clear-Host
        $msg = $null
        $msg += @"
There are some things that its good to keep your eye on but you don't need to see every time you run a command.
So, we can show you some information every few commands (default is every 5 commands). Would you like a second line to occasionally give you info
about your Git status or perhaps additional battery information?
"@
        $msg += "`r`nLike this:"
        $msg | ForEach-Object {
            Write-Host $_
            start-sleep -Milliseconds 800
        }


        Write-Host "git status: " -ForegroundColor White -BackgroundColor Black -NoNewline
        Write-Host "New[0] " -ForegroundColor Green -NoNewline
        Write-Host "Mod[7] " -ForegroundColor Cyan -NoNewline
        Write-Host "Del[1]" -ForegroundColor Red
        $r = read-host -Prompt "(Y)es to have this occasionally in your prompt, (N)o to give it a miss."
        if ($r -eq "y") {
            $PSPromptData.SecondLine = $true
            $PSPromptData.GitStatus = $true
        }
        else {
            $PSPromptData.GitStatus = $false
        }
        # record selection into xml file
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt.config"

        #endregion

        #region Battery decline rate
        # still not sure on this so leaving code in Nth command.ps1 - JA 20190503
        #endregion
    }

    #endregion (option 4)

    #endregion all options
       
}
