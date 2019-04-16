
function Set-Prompt {
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
        $PSPromptData = @{ }
        $WorkingFolder = "$env:APPDATA\PSPrompt"
        $ConfigFile = "PSPrompt.config"

        if (!(Test-Path $WorkingFolder)) {
            New-Item -Path $WorkingFolder -ItemType Directory
        }
    }
    process {
        # preserve the original prompt so that it can be reset if so desired
        if ($pscmdlet.ShouldProcess("Preserving original prompt")) {
            $Date = Get-Date -Format 'yyMMdd-HHmmss'
            $filename = "$WorkingFolder\prompt_$date.ps1"
            $function:prompt | Out-File -FilePath $filename
            write-verbose "Original prompt written out to $filename"
        }

        # code route options:
        # 1 user selection of prompt features at first execution
        # 2 gather user preferences from a static json file if it exists
        # 3 user overrides the json option at (1) and wants to add/remove features
        # 4 user wants to revert to their original prompt, prior to installing PSPrompt
    
        # option 1 first usage of Set-Prompt so we need to collect user preference
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
        $msg = $null
        $msg += "`r`n`r`nFirst of all, do you want a notification when you are running a PS session as an Adminstrator level account?"
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
        
        $PSPromptData | Export-Clixml -Path "$WorkingFolder\PSPrompt_dev.config" 
        start-process notepad "$WorkingFolder\PSPrompt_dev.config"
    }   
    end { }
}
