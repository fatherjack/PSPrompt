function Find-Scripts {
    <#
    .SYNOPSIS
    
        # script finder
        # reviews locations known to have .ps1 files in them for specified string
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    Find-Script -Search event -Type ps1
    
    .EXAMPLE
    Find-Scripts -Search audit -Type sql -includecontent
    
    .NOTES
    General notes
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
      
        write-output ".. Checking $($item.name) .."
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