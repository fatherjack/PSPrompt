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
        [parameter(Mandatory = $false)]$Search, #= 'event',
        [parameter(Mandatory = $false)]$Type, #= 'ps1'
        [parameter(Mandatory = $false)][switch]$IncludeContent
    )
      
    $Type = '*.' + $Type
    $List = Import-Csv 'C:\Users\jonallen\OneDrive\PowerShellLocations.csv'
  
    # $Results = [[PSCustomObject]@ {
    #     MatchType = $null
    #     FileName = $null
    #     FilePath = $null
    # }]
    $Results = ForEach ($Item in $List) {
    
        ".. Checking $($item.name) .."
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