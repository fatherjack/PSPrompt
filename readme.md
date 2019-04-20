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

## enabling the custom prompt

After installing the module with the command `Import-Module PSPrompt` you can run the command `Set-PSPrompt` to be taken through the customisation process to choose what you what information you want to have available to you.

Its a step-by-step process that will let you choose which customisation to accept and your old PowerShell prompt will be preserved so that you can go back to it at any time.

## accelerator functions

The PSPrompt module gets you closer to your search results with a set of functions designed to speed up your fact checking and research. By default, search on DuckDuckGo, Bing, Google and Ask from the command prompt.

| **Alias**      | **Description**                           |
|---------------:|-------------------------------------------|
| **Ask**        | Runs search via <https://ask.com>         |
| **Bing**       | Runs search via <https://bing.com>        |
| **DuckDuckGo** | Runs search via <https://duckduckgo.com>  |
| **DDG**        | see DuckDuckGo                            |
| **Google**     | Runs search via <https://google.co.uk>    |

**Get-OutlookCalendar** [Alias **Cal** or **Events**]

Get details of your calendar appointments in your console.

**Set-DisplayBrightness** [Alias **Dim**]

Control screen brightness from the console.

### Thanks

The idea for the custom prompt came from dbatools, visit <https://github.com/sqlcollaborative/dbatools> for a great module to help manage your databases.

Details of how I created this module from a Plaster (<https://github.com/PowerShell/Plaster>) template can be found here
<https://sqldbawithabeard.com/2017/11/09/using-plaster-to-create-a-new-powershell-module/>