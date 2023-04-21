<#
.SYNOPSIS

Back fill the result of algorithm between startDay and endDay.

.DESCRIPTION

A command line that back fill the result of alg between startDay and endDay.

.PARAMETER appName

The entry application name of PySpark, eg: app.py

.PARAMETER algCode

The name of algorithm.

.PARAMETER algVersion

The version of algorithm.

.PARAMETER startDay

The start day of back fill.

.PARAMETER endDay

The end day of back fill.

.PARAMETER originFormatter

The origin formatter of Date

.PARAMETER targetFormatter

The target formatter of Date

.EXAMPLE

BackFillTool -appName app.py -algCode alg001 -algVersion v1 -startDay 2020-09-01 -stopDay 2020-09-02 -originFormatter yyyy-MM-dd -targetFormatter yyyyMMdd
#>
function BackFillTool {
    [CmdletBinding()]
    [Parameter()]
    param(
        [Parameter(Mandatory=$true)][string] $appName,
        [Parameter(Mandatory=$true)][string] $algCode,
        [string] $algVersion = "v1",
        [Parameter(Mandatory=$true)][string] $startDay,
        [Parameter(Mandatory=$true)][string] $stopDay,
        $originFormatter = "yyyy-MM-dd",
        $targetFormatter = "yyyy-MM-dd"
    )

    $Path = Join-Path $PSScriptRoot 'Public'
    $Functions = Get-ChildItem -Path $Path -Filter '*.ps1'
    Foreach ($import in $Functions) {
        Try {
            Write-Verbose "dot-sourcing file '$($import.fullname)'"
            . $import.fullname
        }
        Catch {
            Write-Error -Message "Failed to import function $($import.name)"
        }
    }

    $days = Get-DateRange -startDay $startDay -stopDay $stopDay -originFormatter $originFormatter -targetFormatter $targetFormatter

    # 
    if ((Test-Path $HOME/tmp/) -eq $false) { mkdir $HOME/tmp }


    Foreach ($currentDay in $days) {
        Try {
            Write-Verbose "starting to process day of $currentDay"
            cmd /c submit.bat $appName $algCode $algVersion $currentDay
            if (!$?) {
                "cmd /c submit.bat $appName $algCode $algVersion $currentDay" | Out-File -FilePath $HOME/tmp/failed.txt -Append
            }
        }
        Catch {
            Write-Error -Message "Failed to process $currentDay"
        }
    }
}

Set-Alias -Name bft -Value BackFillTool

Export-ModuleMember -Function BackFillTool
Export-ModuleMember -Alias bft