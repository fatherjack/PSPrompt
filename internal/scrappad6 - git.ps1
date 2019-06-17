"##" * 100
# logic to find every nth execution
if ((Get-History -Count 1).ID % 5 -eq 0) {
    $status = git status

    if ($status[0] -eq "On branch master") {
        write-host "WARNING YOU ARE EDITING MASTER. STOP IT. YOU SHOULD BRANCH BEFORE YOU EDIT" -ForegroundColor Yellow -BackgroundColor Red
    }

    $NewFiles = $status -match "New:"
    $ModFiles = $status -match "modified:"
    $DelFiles = $status -match "deleted:"

    $msg = $null
    if ($status -match "git pull") {
        $msg = ($status -match "\d+ commit")
        $msg += "`nYou should git pull soon"
    }
    if ($status -match "git push") {
        $msg = ($status -match "\d+ commit")
        $msg += "`nYou should git push soon"
    }
    if ($status -match "untracked") {
        $msg += "`nNOTE: You have untracked files"
    }

    Write-Host "Git: " -NoNewline
    Write-Host "New[$($NewFiles.Count)] " -NoNewline
    Write-Host "Mod[$($ModFiles.Count)] " -NoNewline
    Write-Host "Del[$($DelFiles.Count)]" 
    if ($msg.Length -gt 0) {
        Write-Host "$msg"
    }

}
<#
git status | set-clipboard
if remote has changes we dont
(use "git pull" to merge the remote branch into yours)

if we have changes that needs to go to the remote
(use "git push" to publish your local commits)
#>