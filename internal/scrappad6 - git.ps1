$status = git status

if ($status[0] -eq "On branch master"){
    write-host "WARNING YOU ARE EDITING MASTER. STOP IT. YOU SHOULD BRANCH BEFORE YOU EDIT" -ForegroundColor Yellow -BackgroundColor Red
}

$NewFiles = $status -match "New:"
$ModFiles = $status -match "modified:"
$DelFiles = $status -match "deleted:"

write-host "Git: "      -NoNewline
write-host "New {0}; " -NoNewline
write-host "Mod {1}; " -NoNewline
write-host "Del {2}"   -NoNewline
-f $NewFiles.Count, $ModFiles.Count, $DelFiles.Count 
