# thinking about adding battery drain analysis by parsing history

# Past Jonathan you are an idiot - the prompt data isnt written to the history - you can see the previous values
# middle jonathan - remember that you might be able to log battery values ever 10th command (?) and then work out drain rate

get-help Get-History -showwindow
$hist = Get-History

$hist | ConvertFrom-String | select -first 20 *

$hist | Select-Object -first 20 *

$hist | Where-Object { $_.ID % 5 -eq 0 }

# logic to find every nth execution 
if ((Get-History -Count 1).ID % 5 -eq 0) {
    "5th step"
}
