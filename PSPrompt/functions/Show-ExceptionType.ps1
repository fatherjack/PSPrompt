function Show-ExceptionType {
    <#
    .SYNOPSIS
    Function to give inheritance of exception types for error handling purposes
    
    .DESCRIPTION
    Take an error and returns all InnerException types for the Error object
    
    .PARAMETER Exception
    The exception as it occurred in your script
    
    .EXAMPLE
    
    try {
        10/0
    }
    catch {
        Show-ExceptionType -Exception $_.Exception
    }

    This example causes a Divide by zero error which is Exception type System.DivideByZeroException which is part of the System.Management.Automation.RuntimeException exceptions

    Output is :
    System.Management.Automation.RuntimeException
      System.DivideByZeroException

    
    .NOTES
    I didnt create this script but I am sorry to say that I cant recall the source either. 
    
    Thank you anonymous PowerShell person.

    Script reproduced here as I often forget what I call it and where I save it and it might be useful to others
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Exception]
        $Exception
    )

    $indent = 1

    $e = $Exception

    while ($e) {
        Write-Host ("{0,$indent}{1}" -f ('-' * $indent), $e.GetType().FullName)
        
        $indent += 2
        $e = $e.InnerException
    }

}
