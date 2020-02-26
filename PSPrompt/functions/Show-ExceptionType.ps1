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
    Exception details:
    -System.Management.Automation.RuntimeException
    ---System.DivideByZeroException
    
    .EXAMPLE

    Calling this function via the pipeline with the -incmessages parameter to see exception messages as well as  exception names

    $ErrorActionPreference = 'Stop'
    try {
        Stop-Service iexplore -erroraction Stop
    }
    catch {
        $_.Exception | Show-ExceptionType -incmessages
    }

    This example causes a ServiceCommandException because iexplore is not a service name
    
    Output is :
    Exception details:
    -Microsoft.PowerShell.Commands.ServiceCommandException

    Exception message details:
    -Cannot find any service with service name 'iexplore'.
    
    .NOTES
    I didn't create this script but I am sorry to say that I cant recall the source either.
    
    Thank you anonymous PowerShell person.

    Script reproduced here as I often forget what I call it and where I save it and it might be useful to others
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,ValueFromPipeline=$true)]
        [System.Exception]
        $Exception,
        # switch to control inclusion of error messages
        [Parameter()]
        [switch]
        $IncMessages
    )

    process {
        $indent = 1

        $e = $Exception

        Write-Output "Exception details:"

        while ($e) {
            Write-Output ("{0,$indent}{1}" -f ('-' * $indent), $e.GetType().FullName)
        
            $indent += 2
            $e = $e.InnerException
        }

        if ($IncMessages) {
            Write-Output "`nException message details:"

            $indent = 1
            $e = $Exception
            while ($e) {
                Write-Output ("{0,$indent}{1}" -f ('-' * $indent), $e.message)
                $indent += 2
                $e = $e.InnerException
            }
        }
    }
}
