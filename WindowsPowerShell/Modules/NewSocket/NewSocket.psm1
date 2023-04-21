<#
.SYNOPSIS

Send mina data to socket.

.DESCRIPTION

A command line that send mina data to socket.

.PARAMETER host

The ip address of target host.

.PARAMETER port

The port of target host.

.PARAMETER interval

The data interval of application.

.PARAMETER file

The path of data file.

.PARAMETER startDevice

The start device.

.PARAMETER stopDevice

The stop device.

.PARAMETER deviceId

The deviceId array.

.EXAMPLE

NewSocket -host 10.0.0.39 -port 5000 -interval 0.005 -file D:\scripts\Raku\socket\data.txt -startDevice 27 -stopDevice 32

.EXAMPLE

27, 28, 29 | NewSocket -host 10.0.0.39 -port 5000 -interval 0.005 -file D:\scripts\Raku\socket\data.txt

.EXAMPLE


99, 98, 87 | NewSocket -host 10.0.0.39 -port 5000 -interval 0.005 -file D:\scripts\Raku\socket\data.txt -startDevice 27 -stopDevice 32

#>
function NewSocket {
    [CmdletBinding()]
    [Parameter()]
    param(
        [Parameter(Mandatory=$false)][string] $host = '10.0.0.22',
        [Parameter(Mandatory=$false)][int] $port = 5000,
        [Parameter(Mandatory=$false)][float] $interval = 0.005,
        [string] $file = "D:\\scripts\\Raku\\socket\\data.txt",
        [Parameter(Mandatory=$false)][int] $startDevice,
        [Parameter(Mandatory=$false)][int] $stopDevice,
        [Parameter(Mandatory=$false, ValueFromPipeline)][int[]]$deviceId
    )

    Begin {
        # 测试文件是否存在
        if ((Test-Path $file) -eq $false) { exit }
        $devices = @()
    }
    Process {
        $deviceId | ForEach-Object { $devices += $_ }
    }
    End {
        if ($startDevice -gt 0 -and $stopDevice -gt 0) {
            $devices += ($startDevice..$stopDevice)
        }

        if ($devices.Count -gt 0) {
            $devices | Where-Object { $_ -gt 0 }| ForEach-Object {
                Set-Location D:\scripts\Raku\socket
                Write-Host "> sending mina log to deviceId: $_"
                Start-Process -FilePath "raku.exe" -ArgumentList "reactive_fake_sender.raku --host=$host --port=$port --interval=$interval --file=$file --device-id=$_"
                #"cmd /c raku reactive_fake_sender.raku --host=$host --port=$port --interval=$interval --file=$file --device-id=$_" 
            }
        }
    }
}

Set-Alias -Name nst -Value NewSocket

Export-ModuleMember -Function NewSocket
Export-ModuleMember -Alias nst