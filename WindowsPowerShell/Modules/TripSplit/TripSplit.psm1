<#
.SYNOPSIS

Split can data of  between startDay and endDay.

.DESCRIPTION

A command line that split trip between startDay and endDay.

.PARAMETER appName

The entry application name of PySpark, eg: thermorunaway_app.py

.PARAMETER startDay

The start day of date range.

.PARAMETER endDay

The end day of date range.

.EXAMPLE

TripSplit -appName thermorunaway_app.py -startDay 2020-09-01 -stopDay 2020-09-02
#>
function TripSplit {
    [CmdletBinding()]
    [Parameter()]
    param(
        [Parameter(Mandatory=$true)][string] $appName,
        [Parameter(Mandatory=$true)][string] $startDay,
        [Parameter(Mandatory=$true)][string] $stopDay
    )

    # 
    if ((Test-Path $HOME/tmp/) -eq $false) { mkdir $HOME/tmp }

    $start = [DateTime]::ParseExact($startDay, "yyyy-MM-dd", $null)
    $end = [DateTime]::ParseExact($stopDay, "yyyy-MM-dd", $null)
    $count = 0
    while ($start.AddDays($count) -le $end) {
        $presentDay = $start.AddDays($count).ToString("yyyy-MM-dd")
        Write-Host "$presentDay"
        $count = $count + 1
        cmd /c submit.bat $appName $presentDay
        # 
        if (!$?) {
            "cmd /c submit.bat $appName $presentDay" | Out-File -FilePath $HOME/tmp/failed.txt -Append
        }
    }
}

Export-ModuleMember -Function TripSplit