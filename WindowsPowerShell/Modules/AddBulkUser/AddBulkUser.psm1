# 批量添加用户帐户/邮箱, 格式化输出; 批量添加成员到通讯组
```powershell
# Import-Module AddBulkUser -Verbose -Force 一定要加上 -Force 参数，这会刷新加载的函数！
# 该脚本跟 Exchange 服务器 WIN-JJRLJ6SDSRU.yxtoa.cn 建立一个远程会话
# 在本地 Powershell 控制台中就可以调用 Exchange Managment Console 中的命令
# 该脚本存储了管理员账号和密码
# 建立会话后可以调用本地的 Powershell 脚本
# 本地 Powershell 不需要以管理员身份运行
Function Connect-Exchange {
$user_name="yxtoa\zhangwuji.admin";
$pwd=ConvertTo-SecureString  'xiaozhaowoaini' -AsPlainText -Force;
$credential=New-Object System.Management.Automation.PSCredential($user_name,$pwd);
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://pekdc1-hub-01.yxtoa.cn/Powershell/ -Credential $credential
Import-PSSession $session -AllowClobber


     # 工作组模式+Windows2008 R2 Enterprise+PowerShell2.0.
     # 我的工作PC叫 win7，要点检的服务器就叫 server，无论是Server还是Client都要开启Windows Remote Management (WS-Management)服务。
# 1.在  server 上打开PowerShell，执行Enable-PSRemoting –Force，接着按提示输入Y回车，系统会自动配置相关功能。
# 2.在 win7 上打开PowerShell，执行cd WSMan::localhost\client,这是切到远程管理的client目录下。      （因为我在工作组模式下，如果是域环境就不需要了，远程连接时自动套用当前用户来认证。）
    # 然后执行Get-ChildItem，看一下有什么子项。
	# 执行Set-Item ./TrustedHosts 192.168.1.111, 把server 的IP加到Server上受信主机里去。
    # 192.168.1.111 是我其中一台服务器，要加多台的话，用逗号分隔IP: Set-Item ./TrustedHosts '192.168.1.110,192.168.1.111,192.168.1.112'
	
# 3. 到这里远程管理的配置就完成了。测试一下，在 win7 上执行：
   # $Credential=Get-Credential –Credential Administrator;
   # Enter-PSSession –ComputerName   192.168.1.110 –Credential $Credential
   # 弹出一个框要求输入当前要连接服务器的用户名和密码，我这里用的是管理员。
   # 这只是一个纯粹在工作组情况下的简单配置远程管理的方式，有很多细节和有意义的地方没有提到。
   
   #  在不加域的 Win7 计算机上启用 Enable-PSRemoting 遇到的问题
   #   1、Administrator 没有设置密码时提示拒绝访问
   #   2、为 Administrator 设置密码后再尝试启用  Enable-PSRemoting ，提示由于计算机上的网络连接类型之一设置为公用，因此
   #       WinRM 防火墙例外将不运行。将网络连接类型更改为域或专用，然后再尝试。
   #   3、 解决方法是 点击网络和共享中心 -> 查看活动网络 -> 点击公用网络 -> 更改为工作网络
   #   4、 然后以管理员身份重新运行  Enable-PSRemoting  即可
}   
Connect-Exchange;

Function Format-Lines {
"{0,6} {1,22} {2,35} {3,20}`n" -f $display_name,$pinyin,$email_address,'liubaishuang'
}
   
Function Send-Email {
# mail server configuration
   $smtpServer       = "smtp.yingxiaotong.com"
   $smtpUser         = "yxtoa\zhangwuji"
   $smtpPassword     = "liubaishuang"

# create the mail message
   $mail             = New-Object System.Net.Mail.MailMessage

# set the addresses
   $MailAddress      = "zhangwuji@yingxiaotong.com"
   $MailtoAddress    = "zhangwuji@yingxiaotong.com"
   $mail.From        = New-Object System.Net.Mail.MailAddress($MailAddress)
   $mail.To.Add($MailtoAddress)

# set the content
   $mail.Subject     = "欢迎加入明教!";
   $mail.Priority    = "High"
   $mail.Body        = "邮箱已开通, 谢谢！`n
$header
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
$lines
						
请及时修改初始密码，新设置密码要符合密码复杂性策略：`n
必须有字母大写或小写（A-Z、a-z）、数字（0-9）以及特殊符号（！、@、#、￥….）8位或8位以上字符。`n
					   "  
# set attachment
# $filename="C:\Users\Administrator\Desktop\Exchange 2010依赖包.txt"
# $attachment = new-Object System.Net.Mail.Attachment($filename)
# $mail.Attachments.Add($attachment)				   
					   
# send the message
   $smtp             = New-Object System.Net.Mail.SmtpClient -argumentList $smtpServer
   $smtp.Credentials = New-Object System.Net.NetworkCredential -argumentList $smtpUser,$smtpPassword
   $smtp.Send($mail)
}

Function Add-BulkUser {
[cmdletbinding()]
param(
[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true, Position=0)]
[String]$Path
)

# $Path 中每行格式为  中文姓名 空格 姓名全拼

foreach  ($line  in get-content $Path ) {
    $zh_en                    = $line  -split  "\s+";
    $display_name             = $zh_en[0];
    $pinyin                   = $zh_en[1];
    $display_name_length      = $display_name.length
    $email_address            = $pinyin + '@yingxiaotong.com'

switch($display_name_length) 
{     
   {$_ -eq 3 }   { $LastName = $display_name[0];　$FirstName = $display_name[1]+$display_name[2]; break  }     
   {$_ -eq 2 }   { $LastName = $display_name[0];　$FirstName = $display_name[1]  ; break                  }     
   {$_ -eq 4 }   { $LastName = $display_name[0]+$display_name[1]; $FirstName = $display_name[2]+$display_name[3]; break  }     
   Default       {"请检查中文名！";break}
 } 

 $mailbox = New-Mailbox -Name $pinyin  -DisplayName $display_name -OrganizationalUnit 'yxtoa.CN/Employees_Accounts' -UserPrincipalName $email_address -FirstName $FirstName -LastName $LastName -ResetPasswordOnNextLogon $false -password (ConvertTo-SecureString -AsPlainText "liubaishuang" -Force) -Alias $pinyin -PrimarySmtpAddress $email_address -ErrorAction SilentlyContinue -ErrorVariable myErrors


if($mailbox) {
   Set-Mailbox $pinyin -ProhibitSendReceiveQuota 500Mb -ProhibitSendQuota 480Mb -IssueWarningQuota 450Mb
   $lines += Format-Lines;
   Write-Host " -> $display_name 邮箱创建成功！"  -ForegroundColor green
   } else {
 write-host " -> $display_name 已存在" -ForegroundColor red;
 "$display_name $pinyin" | out-file dumplicate.txt -Encoding utf8 -Append;  
}

}
$header = "{0,6} {1,20} {2,33} {3,16}" -f '姓名','登录名','邮箱','初始密码(首字母大写)';

Write-Host " -> 信息已发送到邮箱，请查收！"  -ForegroundColor red
Send-Email

<#
.Synopsis
    批量添加邮箱
.Path     
    文件路径名，内容格式如下：
	张无忌      zhangwuji
    林冲        linchong
.Example
    Add-BulkUser -Path users.txt
#>
}

Function Add-BulkMember {
[cmdletbinding()]
param(
[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true, Position=0)]
[String]$Path,
[String]$Group_Name
)

# $Path 中每行格式为 姓名全拼， 独占一行

foreach  ($line  in get-content $Path ) {
   Add-DistributionGroupMember -Identity $Group_Name -Member $line -BypassSecurityGroupManagerCheck
   write-host " -> $line 已添加" -ForegroundColor green;
}

<#
.Synopsis
    批量添加用户到指定的通信组
.Path     
    含有用户名（拼音）的文件的路径,内容如下这样：
	zhangwuji
	linchong
.Example
    Add-BulkMember -Path allmember.txt -Group_Name 明教总部
#>

}

function Add-BulkManager {
[cmdletbinding()]
param(
[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
[String]$Path
)
 
foreach  ($line  in get-content $Path ) {
$col = $line  -split  "\s+";
$user = $col[2] -split ",";
new-DistributionGroup -Name $col[0] -OrganizationalUnit 'yxtoa.CN/Communication_Groups'  -SamAccountName $col[0] -Alias $col[1];
   if ($user) {  
      Set-DistributionGroup -BypassSecurityGroupManagerCheck -ManagedBy $user[0],$user[1] -Identity $col[0]
	  write-host " -> ",$col[0] ,"已添加" -ForegroundColor green;
  }
}

<#
.Synopsis
    批量创建通讯组并为通讯组批量添加管理员
.Path     
    含有用户名（拼音）的文件的路径，格式如下：
	明教总坛   mingjiaozt.list 
	明教禁地   mingjiaojd.list　
.Example
    Add-BulkManager -Path member.txt
#>

}

Set-Alias add Add-BulkUser
Export-ModuleMember -Alias add
Export-ModuleMember Add-BulkUser
Export-ModuleMember Send-Email
Export-ModuleMember Add-BulkMember
Export-ModuleMember Add-BulkManager
```