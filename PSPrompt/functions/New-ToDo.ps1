﻿function New-ToDo {
    <#
    .SYNOPSIS
    Creates quick To Do list in Notepad

    .DESCRIPTION
    Creates quick To Do list in Notepad

    .PARAMETER Editor
    The editor that should open the todo list. By default Notepad++ is preferred as it doesn't lose data on app close

    .PARAMETER List
    semi-colon separated list of items to put in to do list

    .parameter WhatIf
    [<SwitchParameter>]
    If this switch is enabled, no actions are performed but informational messages will be displayed that
    explain what would happen if the command were to run.

    .parameter Confirm
    [<SwitchParameter>]
    If this switch is enabled, you will be prompted for confirmation before executing any operations that
    change state.

    .EXAMPLE
    New-ToDo

    Basic execution of this function to start a new ToDo list

    .EXAMPLE
    New-ToDo -List "Write todo function", "Update calendar" , "Book travel", "submit expenses claim", "cook dinner"

    Advanced execution of this function to start a new ToDo list with specific items in the list already

    .EXAMPLE
    New-ToDo -Editor npp 'item 1' 'next item' 'more things to do'

    .NOTES
    General notes
    #>
    [alias('ToDo')]
    [cmdletbinding(SupportsShouldProcess = $true, PositionalBinding = $false)]
    param(
        # name of the editor to open the todo list
        [parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Notepad', 'Notepad++', 'NPP')]
        [string]$Editor,
        # semi-colon separated list of items to put in to do list
        [parameter(ValueFromRemainingArguments = $True)]
        [string[]]$List
    )
    if (!(test-path "C:\Program Files (x86)\Notepad++\notepad++.exe") -and ($Editor -in ('Notepad++', 'NPP'))) {
        Write-Warning "Notepad++ not found on this computer. Using Notepad instead"
        $Editor = 'Notepad'
    }
    $ReadChoice = 1
    $ToDoHistory = "$env:APPDATA\PSPrompt\ToDoArchive.csv"

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
        # did we already create a ToDo today? If so, perhaps we want to append to that one...
        # get latest Todo file date
        if (test-path $todohistory) {
            $History = Import-Csv $ToDoHistory
            $Latest = $History | Sort-Object date -Descending | Select-Object -First 1 date
        }
        else {
            $Latest = (get-date).AddYears(-1)
        }

        # if the latest entry is  today then offer to append new items
        if ($Latest.date -ge (get-date).Date) {
            $splt = @{
                Caption    = "You have created a ToDo already today"
                ChoiceList = "&Append to existing", "&Create new ToDo"
                Message    = "Do you want to append to it or create a new one?"
            }
            $ReadChoice = Read-Choice @splt
            if ($ReadChoice -eq 0) {
                Write-Verbose "OK we add to the file"
                $file = $History | Sort-Object date -Descending | Select-Object -First 1 FileName

                $txt | Add-Content ($file.FileName )
            }
        }
        else {
            $txt | Set-Content $file

            # record that we created this file today
            [pscustomobject]@{
                Date     = [datetime]("{0:yyyy-MM-dd-HH:mm}" -f (get-date))
                FileName = $file.fullname
            } | Export-Csv -path $ToDoHistory -Append
        }

        # now show the list in selected editor
        switch -Regex ($Editor) {
            'notepad' {
                notepad $file
                break
            }
            { 'Notepad\+\+ | npp' } {
                # if notepad++ is installed then use that as it is restart-proof
                &"C:\Program Files (x86)\Notepad++\notepad++.exe" $file
                break
            }
            default { notepad $file }
        }
    }
}
