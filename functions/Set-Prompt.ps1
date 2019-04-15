
function Set-Prompt {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Custom')]
    Param(
        [parameter(parametersetname = "default")][switch]$AddToProfile,
        [parameter(parametersetname = "default")][switch]$Admin,
        [parameter(parametersetname = "default")][switch]$Battery,
        [parameter(ParameterSetName = "Reset")][switch]
    )
    # preserve the original prompt so that it can be reset if so desired
    if ($pscmdlet.ShouldProcess("Preserving original prompt")) {
        $Date = Get-Date -Format 'yyMMdd-HHmmss'
        $filename = "$env:APPDATA\prompt_$date.ps1"
        $function:prompt | Out-File -FilePath $filename
        write-verbose "Original prompt written out to $filename"
    }

    # user selection of prompt features
    
    # examples of features in line
   
}
