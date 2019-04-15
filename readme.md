# Custom PowerShell Prompt

Customised PowerShell prompt with information in terminal and custom functions loaded

Authored by Jonathan Allen

## The custom prompt

The PowerShell prompt can give so much more than just a clue regarding your current drive location. It is where we focus when writing our scripts so having useful information in line of sight is easier to reference than going to alternate locations.

With this customised prompt you can see:

- whether you are logged in with an Admin level credential
- how long your last command took to execute
- how much charge you have left and your estimated run-time if you are running on battery
- your difference from your home timezone when you are travelling
- an abbreviated path when you are a long way down your drive levels
- current date and time

## accelerator functions

The PSPrompt module gets you closer to your search results with a set of functions designed to speed up your fact checking. By default, search on DuckDuckGo, Bing, Google and Ask from the command prompt.

### Thanks

The idea for the custom prompt came from dbatools, visit <https://github.com/sqlcollaborative/dbatools> for a great module to help manage your databases.

Details of how I created this module from a Plaster (<https://github.com/PowerShell/Plaster>) template can be found here
https://sqldbawithabeard.com/2017/11/09/using-plaster-to-create-a-new-powershell-module/

