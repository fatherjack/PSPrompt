#region search engine functions
function New-WebSearch {
    param(
        # the search string
        [parameter()][string]$search
    )
    process {
        $engine = (Get-PSCallStack).InvocationInfo.MyCommand.Definition[1] # -ForegroundColor Red -BackgroundColor Yellow
        switch -Regex ($engine) {
            { $_ -match ('DDG | DuckDuckGo') } { $url = "https://duckduckgo.com/?q=$search"; break }
            { $_ -match 'Google' } { $url = "https://www.google.co.uk/search?q=$Search"; break }
            { $_ -match 'Bing' } { $url = "https://www.bing.com/search?q=$Search"; break }
            { $_ -match 'Ask' } { $url = "https://uk.ask.com/web?q=$Search"; break }
            default { $url = "https://www.bing.com/search?q=$Search" }
        }    
        Start-Process $url
    }    
}
#endregion

#region Search aliases
set-Alias -Name Google -Value New-WebSearch 
set-Alias -Name DuckDuckGo -Value New-WebSearch  
Set-Alias -Name DDG -Value New-WebSearch  
Set-Alias -Name Ask -Value New-WebSearch  
Set-Alias -Name Bing -Value New-WebSearch 
#endregion

#endregion

