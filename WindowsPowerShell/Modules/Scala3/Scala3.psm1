function Start-Scala3 {
    # To use the -EncodedCommand parameter:
    $command = 'cmd /k C:\Users\ohmycloud\scoop\apps\scala\3.1.2\bin\scala.bat'
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    
    powershell.exe -encodedCommand $encodedCommand
}

Set-Alias -Name scala3 -Value Start-Scala3

Export-ModuleMember -Function Start-Scala3
Export-ModuleMember -Alias scala3