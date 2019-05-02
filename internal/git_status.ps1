#Set-Location C:\Users\jonallen\OneDrive\Documents\GitHub\HowToGit\

if ((Get-History -Count 1).ID % 5 -eq 0) {
    $r = git status
    $NewFiles = ($r -match 'new file:').count
    $ModFiles = ($r -match 'modified:').count
    $DelFiles = ($r -match 'deleted:').count
    $Branch = $r[0]

    Write-Host "git status: " -ForegroundColor White -BackgroundColor Black -NoNewline
    if ($Branch -eq "On branch master") { Write-Host "*WARNING : Working in MASTER.*" -ForegroundColor Yellow -BackgroundColor Red -NoNewline } 
    else { Write-Host "$r[0]" -ForegroundColor Blue -BackgroundColor Black -NoNewline } 
    Write-Host " New[$NewFiles] " -ForegroundColor Green -BackgroundColor Black -NoNewline
    Write-Host " Mod[$ModFiles] " -ForegroundColor DarkCyan -BackgroundColor Black -NoNewline
    Write-Host " Del[$DelFiles] " -ForegroundColor Red -BackgroundColor Black 
}
