function New-ToDo {
    <#
    .SYNOPSIS
    Creates quick To Do list in Notepad
    
    .DESCRIPTION
    Creates quick To Do list in Notepad
    
    .PARAMETER List
    semi-colon separated list of items to put in to do list
    
    .EXAMPLE
    New-ToDo
    
    .EXAMPLE
    New-ToDo -List "Write todo function", "Update calendar" , "Book travel", "submit expenses claim", "cook dinner"
    
    .NOTES
    General notes
    #>
    
    [cmdletbinding(SupportsShouldProcess = $true)]
    param(
        # semi-colon separated list of items to put in to do list
        [parameter(ValueFromRemainingArguments = $True)]
        [string[]]$List
    )
    # split out the items we have been sent
    $items = $List -split (';')
    
    # pad the ToDo items to 5 items with empty lines
    if ($items.count -lt 5) {
        $items.count..5 | ForEach-Object { $items += "" }
    }
    
    # set up header of list
    $txt = @"
To do list - {0:dd MMM yyyy}`r`n
"@ -f (get-date)

    # add the items to the doc
    foreach ($Item in $items) {
        $txt += @"
[]`t$Item`r`n
"@
    }

    # add the footer (Done) section
    $txt += @"
`r`n** Done **`r`n
"@

    # create the file and display
    if ($PSCmdlet.ShouldProcess("new ToDo list file " , "Creating")) {
        $file = New-TemporaryFile
        $txt | set-content $file
        notepad $file    
}
}