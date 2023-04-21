<#
.SYNOPSIS

Convert between DateStr and unix timestamp.

.DESCRIPTION

Convert between DateStr and unix timestamp.

.PARAMETER PSdate

datestr, format: '2020-09-01 12:23:34'

.EXAMPLE

ConvertTo-UnixTimestamp '2020-09-01 12:23:34'

.EXAMPLE

dt2ut '2020-09-01 12:23:34'

.EXAMPLE

'2020-09-01 12:23:34' | ConvertTo-UnixTimestamp

.EXAMPLE

'2020-09-01 12:23:34' | dt2ut
#>

function ConvertTo-UnixTimestamp {
    [CmdletBinding()]
    [Parameter()]

    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string[]] $PSdate
    )

    process {
        $PSdate | ForEach-Object {
            $epoch = [timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')
            (New-TimeSpan -Start $epoch -End $PSItem).TotalSeconds
        }
    }
}

function ConvertTo-Datetime {
    [CmdletBinding()]
    [Parameter()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][int[]] $PSseconds
    )

    process {
        $PSseconds | ForEach-Object {
            (Get-Date 01.01.1970).AddSeconds($PSItem + 60 * 8 * 60)
        }
    }
}

Set-Alias -Name dt2ut -Value ConvertTo-UnixTimestamp
Set-Alias -Name ut2dt -Value ConvertTo-Datetime
Export-ModuleMember -Function ConvertTo-UnixTimestamp,ConvertTo-Datetime
Export-ModuleMember -Alias dt2ut,ut2dt