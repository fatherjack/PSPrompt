#region Show if using Administrator level account
    if ($admin) {
        $principal = [Security.Principal.WindowsPrincipal] ([Security.Principal.WindowsIdentity]::GetCurrent())
        $adm = [Security.Principal.WindowsBuiltInRole]::Administrator
        if ($principal.IsInRole($adm)) {
            write-host -ForegroundColor "Black" -BackgroundColor "DarkRed" "[ADMIN]" -NoNewline
        }
        "added admin"
    }
    #endregion