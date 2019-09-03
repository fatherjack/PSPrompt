function ConvertFrom-Byte {
    <#
    .SYNOPSIS
    Convert a Byte value to a KB, MB, GB, or TB value
    
    .DESCRIPTION
    Convert a Byte value to a KB, MB, GB, or TB value
    
    .PARAMETER Bytes
    The value in bytes that you want to see expressed in a higher metric
    
    .EXAMPLE
    ConvertFrom-Byte 1234342562

    result:
    1.15GB
    
    .EXAMPLE
    ConvertFrom-Byte 123434

    result:
    120.54KB
    
    #>
    [outputtype('system.string')]
    param (
        [parameter(ValueFromPipeline=$true)]
        [Alias('Length')]
        [ValidateNotNullorEmpty()]
        $Bytes
    )

    begin {}

    process {
        switch -Regex ([math]::truncate([math]::log([System.Convert]::ToInt64($Bytes), 1024))) {
            '^0' { "$Total Bytes" ; Break }
            '^1' { "{0:n2} KB" -f ($Bytes / 1KB) ; Break }
            '^2' { "{0:n2} MB" -f ($Bytes / 1MB) ; Break }
            '^3' { "{0:n2} GB" -f ($Bytes / 1GB) ; Break }
            '^4' { "{0:n2} TB" -f ($Bytes / 1TB) ; Break }
            '^5' { "{0:n2} PB" -f ($Bytes / 1PB) ; Break }
            # When we fail to have any matches, 0 Bytes is more clear than 0.00 PB (since <5GB would be 0.00 PB still)
            Default { "0 Bytes" }
        }
    }

    end {}
}
