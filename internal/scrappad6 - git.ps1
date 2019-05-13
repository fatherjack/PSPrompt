
# logic to find every nth execution 
if ((Get-History -Count 1).ID % 5 -eq 0) {
    $status = git status

    if ($status[0] -eq "On branch master") {
        write-host "WARNING YOU ARE EDITING MASTER. STOP IT. YOU SHOULD BRANCH BEFORE YOU EDIT" -ForegroundColor Yellow -BackgroundColor Red
    }

    $NewFiles = $status -match "New:"
    $ModFiles = $status -match "modified:"
    $DelFiles = $status -match "deleted:"
    $Pull = if ($status -match "git pull") { $true }
    $Push = if ($status -match "git push") { $true }
    if ($Pull) { $AhdFiles = ($status -match "\d+ commit") } else { $AhdFiles = $false }
    if ($Push) { $BhdFiles = ($status -match "\d+ commit") } else { $BhdFiles = $false }
    
    $AhdFiles
    $BhdFiles

    write-host "Git: "      -NoNewline
    write-host "New $($NewFiles.Count); " -NoNewline
    write-host "Mod $($ModFiles.Count); " -NoNewline
    write-host "Del $($DelFiles.Count)"   
    
}
<#
git status | set-clipboard
if remote has changes we dont
(use "git pull" to merge the remote branch into yours)

if we have changes that needs to go to the remote
(use "git push" to publish your local commits)
#>