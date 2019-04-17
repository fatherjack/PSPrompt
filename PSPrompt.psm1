
Write-verbose $PSScriptRoot

Write-verbose 'Import everything in function sub folder' # leaving internal in code incase we need it later

#foreach ($folder in @('internal', 'functions')) {
    
foreach ($folder in @('functions')) {

    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
    Write-verbose "processing folder $root"
    if (Test-Path -Path $root) {
        $files = Get-ChildItem -Path $root -Filter *.ps1 -Recurse
        # dot source each file
        $files | 
        ForEach-Object { 
            Write-Verbose $_.basename;
            . $_.FullName 
        }
    }
}

# Export functions and aliases
#Export-ModuleMember -alias * -function (Get-ChildItem -Path "$PSScriptRoot\functions\*.ps1").basename 

