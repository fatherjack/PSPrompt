#region search engine functions
function google {
invoke-item "http://google.co.uk/"
}

function DuckDuckGo {
    param(
        [parameter()][string]$search
    )
    Start-Process "https://duckduckgo.com/?q=$search&atb=v5&ia=web"
}
new-alias -Name DDG -Value DuckDuckGo
#endregion