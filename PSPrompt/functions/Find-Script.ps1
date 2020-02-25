function Find-Script {
    <#
    .SYNOPSIS

    script finder

    .DESCRIPTION

    reviews locations known to have script files in them for specified string

    .EXAMPLE
    Find-Script -Search event -Type ps1

    Example searches for the string 'event' in filenames with extension matching ps1

    .EXAMPLE
    Find-Script -Search audit -Type sql -includecontent

    Example searches for the string 'audit' in file names and content with extension matching sql


    #>
    [CmdletBinding()]

    param (
        # The string you want to search for
        [parameter(Mandatory = $true)]
        [ValidateScript]
        [string]$Search,
        # The file type you want to search for
        [parameter(Mandatory = $false)]
        [string]$Type,
        # custom locations to search
        [parameter(Mandatory = $false)]
        [string]$Locations,
        # Do you want to search in file content too
        [parameter(Mandatory = $false)]
        [switch]$IncludeContent
    )

    $Type = '*.' + $Type
    $List = Import-Csv 'C:\Users\jonallen\OneDrive\PowerShellLocations.csv'
    if ($Locations) { $List += $Locations -split ',' }

    # $Results = [[PSCustomObject]@ {
    #     MatchType = $null
    #     FileName = $null
    #     FilePath = $null
    # }]
    $Results = ForEach ($Item in $List) {
        $msg = if ($null -eq $item.name){$Item.folder}else{$item.name}
        Write-Output ".. Checking $msg .."

        foreach ($doc in Get-ChildItem $item.Folder -Recurse -include $Type) {
            if ($doc -match $search) {
                [pscustomobject]@{
                    MatchType = "FileName"
                    FileName  = $($doc.Name)
                    FilePath  = $($doc.FullName)
                }
            }
            else {
                if ($IncludeContent) {
                    try {
                        $content = Get-Content $doc
                        if ($content -match $Search) {
                            [pscustomobject]@{
                                MatchType = "Content"
                                FileName  = $($doc.Name)
                                FilePath  = $($doc.FullName)
                            }
                        }
                    }
                    catch {
                        write-verbose "unable to open $doc"
                    }
                }
            }
        }
    }
    return $Results

}