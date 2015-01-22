# 查询指定账号所属的通讯组
```powershell
Function Get-AllUserGroups {
[cmdletbinding()]
param(
[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true, Position=0)]   
[String]$UserName
)
          
Add-Type -AssemblyName System.DirectoryServices.AccountManagement            
$ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain            
$user = [System.DirectoryServices.AccountManagement.Principal]::FindByIdentity($ct,$UserName)
$user.GetGroups() | Where {$_.Displayname -notlike ""} | select DisplayName
            
# $user.GetGroups() #gets all user groups (direct)        
# $user.GetAuthorizationGroups() #gets all user groups including nested groups (indirect)

<#
.Synopsis
    查询指定账号所属的通讯组
.UserName     
    指定要查找的用户名
.Example
    Get-AllUserGroups Tom
	gg SomeBody
#>
}

Set-Alias gg Get-AllUserGroups
Export-ModuleMember Get-AllUserGroups
Export-ModuleMember -Alias gg
```