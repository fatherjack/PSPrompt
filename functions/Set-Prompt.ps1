
function Set-PSPrompt {
    <#
    .synopsis
    The function that creates the desired prompt function.

    .description
    It has to build a command out of the component pieces as it will be executed everytime a command is executed and therefore cant make use of any parameterisation

    .example
    there are no examples at the moment

    #>

    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Custom')]
    Param(
        [parameter(parametersetname = "default")][switch]$AddToProfile,
        [parameter(parametersetname = "default")][switch]$Admin,
        [parameter(parametersetname = "default")][switch]$Battery,
        [parameter(ParameterSetName = "Reset")  ][switch]$Reset
    )
    begin {
        $PSPromptData = [ordered]@{ }
        $WorkingFolder = "$env:APPDATA\PSPrompt"
        $ConfigFile = "PSPrompt.config"
        # create working folder for module if its not there
        if (!(Test-Path $WorkingFolder)) {
            New-Item -Path $WorkingFolder -ItemType Directory
        }
    }
    process {
        #region preserve the original prompt so that it can be reset if so desired
        if ($pscmdlet.ShouldProcess("Preserving original prompt")) {
            $Date = Get-Date -Format 'yyMMdd-HHmmss'
            $filename = "$WorkingFolder\prompt_$date.ps1"
            $function:prompt | Out-File -FilePath $filename
            write-verbose "Original prompt written out to $filename"
        }
        #endregion

        #region code route options:
        # 1 user selection of prompt features at first execution
        # 2 gather user preferences from a static json file if it exists
        # 3 user overrides the json option at (1) and wants to add/remove features
        # 4 user wants to revert to their original prompt, prior to installing PSPrompt
    
        #region option 1 first usage of Set-Prompt so we need to collect user preference
        if (!(test-path $ConfigFile)) {
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
        }
        #region Admin user
        $msg = $null
        $msg += "`r`n`r`nFirst of all, do you want a notification when you are running a PS session as an Administrator level account?"
        $msg += "Like this:"
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
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt_dev.config" 
        #endregion

        #region Battery
        cls
        $msg = $null
        $msg += "`r`n`r`nNext, do you work from a laptop? Do you want an indicator of your battery status while you are working on battery power?"
        $msg += "Like this:"
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
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt_dev.config" 
        #endregion

        #region Day and Date
        cls
        $msg = $null
        $msg += "`r`n`r`nNeed to keep your eye on the time? Add the day/date to your prompt?"
        $msg += "Like this:"
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
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt_dev.config" 
        #endregion

        #region UTC offset
        cls
        $msg = $null
        $msg += "`r`n`r`nIf you work across timezones then as your laptop updates to a different timezone we can have your timezone offset indicated in your prompt.`r`n Add the day/date to your prompt?"
        $msg += "Like this:"
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
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt_dev.config"
        #endregion

        #region Fun function
        #endregion

        #region last command duration
        #endregion
        

        #endregion (option 1)


        # temporary check of file contents during development
        start-process notepad "$WorkingFolder\PSPrompt_dev.config"
        
        
        #region option 2
        #endregion option 2
        
        #region option 3
        #endregion option 3

        #region option 4
        #endregion option 4

        #endregion all options 
    }   
    end { }
}
