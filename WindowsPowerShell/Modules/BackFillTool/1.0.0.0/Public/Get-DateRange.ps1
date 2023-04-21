<#
.SYNOPSIS

Get the days between startDay and endDay.

.DESCRIPTION

A tool that get the days between startDay and endDay.

.PARAMETER startDay

The start day.

.PARAMETER endDay

The end day.

.PARAMETER originFormatter

The origin formatter of Date

.PARAMETER targetFormatter

The target formatter of Date

.EXAMPLE

Get-DateRange -startDay 2020-09-01 -stopDay 2020-09-02 -originFormatter yyyy-MM-dd -targetFormatter yyyyMMdd
#>
function Get-DateRange {
    [CmdletBinding()]
    [OutputType([String])]
    [Parameter()]
    param(
        [Parameter(Mandatory=$true)][string] $startDay,
        [Parameter(Mandatory=$true)][string] $stopDay,

        [Parameter(Mandatory=$true)][string]
        [ValidateSet("yyyy-MM-dd", "yyyyMMdd", "MMddyyyy", "MM-dd-yyyy")]
        $originFormatter,

        [Parameter(Mandatory=$true)][string]
        [ValidateSet("yyyy-MM-dd", "yyyyMMdd", "MMddyyyy", "MM-dd-yyyy")]
        $targetFormatter
    )

    $start = [DateTime]::ParseExact($startDay, $originFormatter, $null)
    $end = [DateTime]::ParseExact($stopDay, $originFormatter, $null)
    $count = 0
    $days = @()
    while ($start.AddDays($count) -le $end) {
        $presentDay = $start.AddDays($count).ToString($targetFormatter)
        $days += $presentDay
        $count = $count + 1
    }
    $days
}