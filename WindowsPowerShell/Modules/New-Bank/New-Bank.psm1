<#
.SYNOPSIS
ETL script for jiangsudianli energy storage project.

.DESCRIPTION
A command line tool for ETL 

.PARAMETER appName
The entry application name of PySpark, eg: app.py

.PARAMETER tankNo
The tank number

.PARAMETER stackNo
The stack number

.PARAMETER startDay
The start day

.PARAMETER stopDay
The stop day

.EXAMPLE
New-Bank -appName app.py -algCode alg001 -algVersion v1 -dayPrefix -startDay 2020-09-01 -stopDay 2020-09-02
#>

function New-Bank {
    [CmdletBinding()]
    [Parameter()]
    param(
        [Parameter(Mandatory=$true)][string] $appName,
        [Parameter(Mandatory=$true)][string] $tankNo,
        [Parameter(Mandatory=$true)][string] $stackNo
    )

    # test file path
    if ((Test-Path $HOME/tmp/) -eq $false) { mkdir $HOME/tmp }

    $start = [DateTime]::ParseExact($startDay, "yyyy-MM-dd", $null)
    $end = [DateTime]::ParseExact($stopDay, "yyyy-MM-dd", $null)
    $count = 0
    while ($start.AddDays($count) -le $end) {
        $presentDay = $dayOptionPrex + $start.AddDays($count).ToString("yyyy-MM-dd")
        Write-Host "$presentDay"
        $count = $count + 1
        #.\submit.bat energy_storage_app.py --station-no=1 --tank-no=9 --stack-no=1 --group-no=5 --day-no=2022-08-07
        cmd /c submit.bat $appName --station-no=1 $tankNo $stackNo $presentDay
        # error process
        if (!$?) {
            "cmd /c submit.bat $appName --station-no=1 $tankNo $stackNo $presentDay" | Out-File -FilePath $HOME/tmp/failed.txt -Append
        }
    }
}

Set-Alias -Name nbk -Value New-Bank

Export-ModuleMember -Function New-Bank
Export-ModuleMember -Alias nbk