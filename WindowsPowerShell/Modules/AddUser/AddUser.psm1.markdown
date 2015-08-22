# 本地调用 Powershell 创建用户邮箱
```powershell
function Remote-Ex {
# 该脚本跟 Exchange 服务器 pekdc1-hub-01.yxtoa.cn 建立一个远程会话
# 在本地 Powershell 控制台中就可以调用 Exchange Managment Console 中的命令
# 该脚本存储了管理员账号和密码
# 建立会话后可以调用本地的 Powershell 脚本
# 本地 Powershell 不需要以管理员身份运行
$user_name="yxtoa\zhangwuji.admin";
$pwd=ConvertTo-SecureString  'sunzhenxia' -AsPlainText -Force;
$credential=New-Object System.Management.Automation.PSCredential($user_name,$pwd);
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://pekdc1-hub-01.yxtoa.cn/Powershell/ -Credential $credential
Import-PSSession $session -AllowClobber
}
Export-ModuleMember Remote-Ex
Remote-Ex

# 之前有学习过PowerShell,但是没有用上，隔了段时间忘记的差不多了。这两天新加了两台测试机，就想试一下远程点检，就捣鼓一下远程管理配置。工作组模式+Windows2008 R2 Enterprise+PowerShell2.0.
# 我的工作PC叫 win7，要点检的服务器就叫 server，无论是Server还是Client都要开启Windows Remote Management (WS-Management)服务。
1.在  server 上打开PowerShell，执行Enable-PSRemoting –Force，接着按提示输入Y回车，系统会自动配置相关功能。
2.在 win7 上打开PowerShell，执行cd WSMan::localhost\client,这是切到远程管理的client目录下。      （因为我在工作组模式下，如果是域环境就不需要了，远程连接时自动套用当前用户来认证。）
    # 然后执行Get-ChildItem，看一下有什么子项。
	# 执行Set-Item ./TrustedHosts 192.168.1.111, 把server 的IP加到Server上受信主机里去。
    # 192.168.1.111 是我其中一台服务器，要加多台的话，用逗号分隔IP: Set-Item ./TrustedHosts '192.168.1.110,192.168.1.111,192.168.1.112'
	
3. 到这里远程管理的配置就完成了。测试一下，在 win7 上执行：
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
   
   
Function Send-Email {
# mail server configuration
   $smtpServer       = "smtp.yingxiaotong.com"
   $smtpUser         = "yxtoa\zhangwuji"
   $smtpPassword     = "caipiaowoyou"

# create the mail message
   $mail             = New-Object System.Net.Mail.MailMessage

# set the addresses
   $MailAddress      = "zhangwuji@yingxiaotong.com"
   $MailtoAddress    = "zhangwuji@yingxiaotong.com"
   $mail.From        = New-Object System.Net.Mail.MailAddress($MailAddress)
   $mail.To.Add($MailtoAddress)

# set the content
   $mail.Subject     = "$display_name ,欢迎加入落川!";
   $mail.Priority    = "High"
   $mail.Body        = "$display_name 邮箱已开通, 谢谢！`n
                        登录名： $pinyin  `n
						初始密码： caipiaowoyou 首字母大写 `n
						
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

Function Add-User {
[cmdletbinding()]
param(
[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true, Position=0)]
[String]$Chinese_name,
[String]$English_name
)
 
    $display_name            = $Chinese_name  -replace '\s+',''
    $pinyin                  = $English_name  -replace '\s+',''
    $display_name_length     = $display_name.length
    $email_address           = $pinyin + '@yingxiaotong.com'

switch($display_name_length) 
{     
   {$_ -eq 3 }   { $LastName = $display_name[0];                  $FirstName = $display_name[1]+$display_name[2]; break  }     
   {$_ -eq 2 }   { $LastName = $display_name[0];                  $FirstName = $display_name[1]                 ; break  }     
   {$_ -eq 4 }   { $LastName = $display_name[0]+$display_name[1]; $FirstName = $display_name[2]+$display_name[3]; break  }     
   Default       {"输入错误！"}
 } 

 Write-host	"$LastName-$FirstName"
 
 $mailbox = New-Mailbox -Name $pinyin  -DisplayName $display_name -OrganizationalUnit 'yxtoa.CN/Employees_Accounts' -UserPrincipalName $email_address -FirstName $FirstName -LastName $LastName -ResetPasswordOnNextLogon $false -password (ConvertTo-SecureString -AsPlainText "caipiaowoyou" -Force) -Alias $pinyin -PrimarySmtpAddress $email_address

if($mailbox) {
   Send-Email
   Write-Host "$name 邮箱创建成功，已发送邮件！"  -ForegroundColor green
   } else {
       Write-Host "$name 邮箱创建失败，请检查是否重名" -ForegroundColor red
   }
 }

Set-Alias add Add-User
Export-ModuleMember -Alias add
Export-ModuleMember Add-User
Export-ModuleMember Send-Email
```
