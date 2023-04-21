function Start-Anaconda {
    # To use the -EncodedCommand parameter:
    $command = 'cmd /k C:\Users\ohmycloudy\Anaconda3\Scripts\activate.bat & powershell -NoLogo'
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    
    powershell.exe -encodedCommand $encodedCommand
}

Set-Alias -Name ipython3 -Value Start-Anaconda

Export-ModuleMember -Function Start-Anaconda
Export-ModuleMember -Alias ipython3