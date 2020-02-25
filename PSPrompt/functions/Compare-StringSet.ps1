function Compare-Array {
    param(
        [array]$Ref,
        [array]$Diff
    )

    $max = [math]::Max($Ref.Length, $Diff.Length)

    for ($i = 0; $i -lt $max; $i++) {
        if ($Ref[$i] -ne $Diff[$i]) {
            [pscustomobject]@{ 
                Index = $i
                Left  = $Ref[$i]
                Right = $Diff[$i]
            }
        }
    }
}

function Compare-StringSet {
    <#
    .SYNOPSIS
    Compare two sets of strings and see the matched and unmatched elements from each input
    
    .DESCRIPTION
    Compares sets of 
    
    .PARAMETER Ref
    The reference set of values to be compared
    
    .PARAMETER Diff
    The difference set of values to be compared
    
    .PARAMETER CaseSensitive
    Enables a case-sensitive comparison
    
    .EXAMPLE
    $ref, $dif = @(
        , @('a', 'b', 'c')
        , @('b', 'c', 'd')
    )
    $Sets = Compare-StringSet $ref $dif
    $Sets.RefOnly
    
    $Sets.DiffOnly
    
    $Sets.Both
    
    This example sets up two arrays with some similar values and then passes them both to the Compare-StringSet function. the results of this are stored in the variable $Sets.
    $Sets is an object that has three properties - RefOnly, DiffOnly, and Both. These are sets of the incoming values where they intersect or not.
    
    .EXAMPLE
    $ref, $dif = @(
        , @('tree', 'house', 'football')
        , @('dog', 'cat', 'tree', 'house', 'Football')
    )
    $Sets = Compare-StringSet $ref $dif -CaseSensitive
    $Sets.RefOnly
    $Sets.DiffOnly
    $Sets.Both
    
    This example sets up two arrays with some similar values and then passes them both to the Compare-StringSet function using the -CaseSensitive switch. The results of this are stored in the variable $Sets.
    $Sets is an object that has three properties - RefOnly, DiffOnly, and Both. 
    
    Because of the -CaseSensitive switch usage 'football' is shown as in RefOnly and 'Football' is shown as in DiffOnly.
    
    .NOTES
    From https://gist.github.com/IISResetMe/57ce7b76e1001974a4f7170e10775875
    #>
    
    [cmdletbinding()]
    param(
        [string[]]$Ref,
        [string[]]$Diff,

        [switch]$CaseSensitive
    )

    $Comparer = if ($CaseSensitive) {
        [System.StringComparer]::InvariantCulture
    }
    else {
        [System.StringComparer]::InvariantCultureIgnoreCase
    }

    $Results = [ordered]@{
        RefOnly  = @()
        Both     = @()
        DiffOnly = @()
    }

    $temp = [System.Collections.Generic.HashSet[string]]::new($Ref, $Comparer)
    $temp.IntersectWith($Diff)
    $Results['Both'] = $temp

    #$temp = [System.Collections.Generic.HashSet[string]]::new($Ref, [System.StringComparer]::CurrentCultureIgnoreCase)
    $temp = [System.Collections.Generic.HashSet[string]]::new($Ref, $Comparer)
    $temp.ExceptWith($Diff)
    $Results['RefOnly'] = $temp

    #$temp = [System.Collections.Generic.HashSet[string]]::new($Diff, [System.StringComparer]::CurrentCultureIgnoreCase)
    $temp = [System.Collections.Generic.HashSet[string]]::new($Diff, $Comparer)
    $temp.ExceptWith($Ref)
    $Results['DiffOnly'] = $temp

    return [pscustomobject]$Results
}