<#
.SYNOPSIS

Get and put file with lftp

.DESCRIPTION

A command line that can get and put file with lftp

.PARAMETER username

The username of jumpserver

.PARAMETER password

The password of jumpserver

.PARAMETER jumpserver

The IP of jumpserver

.PARAMETER port

The port to connect to

.PARAMETER srcPath

The source path of file when get or put

.PARAMETER distPath

The destination path

.PARAMETER get

The switch, when on is get, when off is put

.EXAMPLE

Jump-Server -srcPath /opt/test.txt -distPath . -get

Get file from source path and save to destination path.

.EXAMPLE

Jump-Server -srcPath /tmp/test.txt -distPath /tmp

Put file from source path to destination path

#>
function Jump-Server {
    [CmdletBinding()]
    [Parameter()]

    param(
      [string] $username = "username",
      [string] $password = "password",
      [string] $jumpserver = "192.168.1.1",
      [int] $port = 3333,
      [string] $srcPath,
      [string] $distPath = ".",
      [switch] $get = $true
    )

    if ($get -eq $true) {
        lftp -u $username,$password -p $port -e "set xfer:clobber on; get $srcPath; exit" sftp://$jumpserver
    } else {
        lftp -u $username,$password -p $port -e "cd $distPath; put $srcPath; exit" sftp://$jumpserver
    }
}

Set-Alias -Name js -Value Jump-Server
Export-ModuleMember -Function Jump-Server
Export-ModuleMember -Alias js