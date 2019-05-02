
# logic to find every nth execution 
if ((Get-History -Count 1).ID % 5 -eq 0) {
    $status = git status

    if ($status[0] -eq "On branch master") {
        write-host "WARNING YOU ARE EDITING MASTER. STOP IT. YOU SHOULD BRANCH BEFORE YOU EDIT" -ForegroundColor Yellow -BackgroundColor Red
    }

    $NewFiles = $status -match "New:"
    $ModFiles = $status -match "modified:"
    $DelFiles = $status -match "deleted:"

    write-host "Git: "      -NoNewline
    write-host "New $($NewFiles.Count); " -NoNewline
    write-host "Mod $($ModFiles.Count); " -NoNewline
    write-host "Del $($DelFiles.Count)"   
    
}