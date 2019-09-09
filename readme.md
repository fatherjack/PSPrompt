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

## Custom Function

### ConvertFrom-Byte

Convert a number representing bytes into the number in MB, GB, or TB without the need to specify the denominator.

### ConvertFrom-Epoch

Convert an Epoch time value into a date and time value.

### ConvertTo-Epoch

Convert a date and time value into an Epoch time value.

### Find-Script

Locate that code you wrote all that time ago. Search by name or content.

### Get-BatteryStatus

Get the details of you battery charge state in your command line.

### Get-OutlookCalendar

Check the details in your calendar from your PowerShell command line.

### Invoke-WebSearch

Searching for a script example? Needing to do make a quick reference? The PSPrompt module gets you closer to your search results with a set of functions designed to speed up your fact checking and research. By default, search on DuckDuckGo, Bing, Google and Ask from the command prompt.

| **Alias**      | **Description**                           |
|---------------:|-------------------------------------------|
| **Ask**        | Runs search via <https://ask.com>         |
| **Bing**       | Runs search via <https://bing.com>        |
| **DuckDuckGo** | Runs search via <https://duckduckgo.com>  |
| **DDG**        | see DuckDuckGo                            |
| **Google**     | Runs search via <https://google.co.uk>    |

With custom aliases that let you control the search engine that you prefer to use.

### New-OutlookCalendar

Add an item to your calendar while you are writing code, no need to go off to Outlook to create it, just add some key parameter values and its done.

### New-ToDo

Create a new To Do list in Notepad just to help you track a few things that  need your attention.

### Push-PSPrompt

This is the function that applies the custom prompt changes that you have set up.

### Set-DisplayBrightness

Adjust the screen brightness from the command line makes it easier to keep working on your code and be comfortable without having to go into the UI and find the setting.

### Set-PSPrompt

This is the function that you use to create your custom PowerShell prompt.

### Show-Calendar

A quick table of your upcoming events, right in your console.

## Thanks

The idea for the custom prompt came from dbatools, visit <https://github.com/sqlcollaborative/dbatools> for a great module to help manage your databases.

Details of how I created this module from a Plaster (<https://github.com/PowerShell/Plaster>) template can be found here
<https://sqldbawithabeard.com/2017/11/09/using-plaster-to-create-a-new-powershell-module/>
