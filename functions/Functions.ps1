#region search engine functions
function New-WebSearch {
    param(
        [parameter()][string]$engine,
        [parameter()][string]$search
    )
    process {
        Write-Host (Get-PSCallStack).InvocationInfo.MyCommand.Definition -ForegroundColor Red -BackgroundColor Yellow
        switch -Regex ($engine) {
            'DDG | DuckDuckGo' { $url = "https://duckduckgo.com/?q=$search" }
            'Google' { $url = "https://www.google.co.uk/search?q=$Search" }
            'Bing' { $url = "https://www.bing.com/search?q=$Search" }
            'Ask' { $url = "https://uk.ask.com/web?q=$Search" }
            default { $url = "https://www.bing.com/search?q=$Search" }
        }    
        Start-Process $url
    }    
}
#endregion

#region specific engine functions
# function Google { param($String) New-WebSearch -engine 'Google' -search $String }
# function DuckDuckGo { param($String) New-WebSearch -engine 'DuckDuckGo' -search $String }
# function Bing { param($String) New-WebSearch -engine 'Bing' -search $String }
# function Ask { param($String) New-WebSearch -engine 'Google' -search $String }
#endregion

#region Search aliases

set-Alias -Name Google -Value New-WebSearch 
set-Alias -Name DuckDuckGo -Value New-WebSearch  
set-Alias -Name DDG -Value New-WebSearch  
set-Alias -Name Ask -Value New-WebSearch 
#endregion

#endregion

