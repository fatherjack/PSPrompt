function Invoke-WebSearch {
    <#
        .SYNOPSIS
        Quick search the internet for content

        .DESCRIPTION
        Access your preferred search engine directly from your powershell console

        .PARAMETER search
        provide the search string and the search engine

        .EXAMPLE
        New-WebSsearch -engine google -search 'kitten gifs'

        Searches google for gifs of kittens
        .NOTES
        n/a
    #>
    [alias('Google','DuckDuckGo','DDG','Ask','Bing')]
    [cmdletbinding()]
    param(
        # the search string
        [parameter(ValueFromRemainingArguments=$true)][string]$search
    )
    # begin {
        if ($search -eq 'gal') {
            $url = 'https://www.powershellgallery.com/'
        }
    # }
    # process {
        $engine = (Get-PSCallStack).InvocationInfo.MyCommand.Definition[1] # check how we called the function
        switch -Regex ($engine) {
            { $_ -match ('DDG | DuckDuckGo') } { $url = "https://duckduckgo.com/?q=$search"; break }
            { $_ -match 'Google' } { $url = "https://www.google.co.uk/search?q=$Search"; break }
            { $_ -match 'Bing' } { $url = "https://www.bing.com/search?q=$Search"; break }
            { $_ -match 'Ask' } { $url = "https://uk.ask.com/web?q=$Search"; break }
            default { $url = "https://www.bing.com/search?q=$Search" }
        }
        Start-Process $url
    # }
}