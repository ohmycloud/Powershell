# ���ص��� Powershell �����û�����
```powershell
function Remote-Ex {
# �ýű��� Exchange ������ pekdc1-hub-01.yxtoa.cn ����һ��Զ�̻Ự
# �ڱ��� Powershell ����̨�оͿ��Ե��� Exchange Managment Console �е�����
# �ýű��洢�˹���Ա�˺ź�����
# �����Ự����Ե��ñ��ص� Powershell �ű�
# ���� Powershell ����Ҫ�Թ���Ա�������
$user_name="yxtoa\zhangwuji.admin";
$pwd=ConvertTo-SecureString  'sunzhenxia' -AsPlainText -Force;
$credential=New-Object System.Management.Automation.PSCredential($user_name,$pwd);
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://pekdc1-hub-01.yxtoa.cn/Powershell/ -Credential $credential
Import-PSSession $session -AllowClobber
}
Export-ModuleMember Remote-Ex
Remote-Ex

# ֮ǰ��ѧϰ��PowerShell,����û�����ϣ����˶�ʱ�����ǵĲ���ˡ��������¼�����̨���Ի���������һ��Զ�̵�죬�͵���һ��Զ�̹������á�������ģʽ+Windows2008 R2 Enterprise+PowerShell2.0.
# �ҵĹ���PC�� win7��Ҫ���ķ������ͽ� server��������Server����Client��Ҫ����Windows Remote Management (WS-Management)����
1.��  server �ϴ�PowerShell��ִ��Enable-PSRemoting �CForce�����Ű���ʾ����Y�س���ϵͳ���Զ�������ع��ܡ�
2.�� win7 �ϴ�PowerShell��ִ��cd WSMan::localhost\client,�����е�Զ�̹����clientĿ¼�¡�      ����Ϊ���ڹ�����ģʽ�£�������򻷾��Ͳ���Ҫ�ˣ�Զ������ʱ�Զ����õ�ǰ�û�����֤����
    # Ȼ��ִ��Get-ChildItem����һ����ʲô���
	# ִ��Set-Item ./TrustedHosts 192.168.1.111, ��server ��IP�ӵ�Server������������ȥ��
    # 192.168.1.111 ��������һ̨��������Ҫ�Ӷ�̨�Ļ����ö��ŷָ�IP: Set-Item ./TrustedHosts '192.168.1.110,192.168.1.111,192.168.1.112'
	
3. ������Զ�̹�������þ�����ˡ�����һ�£��� win7 ��ִ�У�
   # $Credential=Get-Credential �CCredential Administrator;
   # Enter-PSSession �CComputerName   192.168.1.110 �CCredential $Credential
   # ����һ����Ҫ�����뵱ǰҪ���ӷ��������û��������룬�������õ��ǹ���Ա��
   # ��ֻ��һ�������ڹ���������µļ�����Զ�̹���ķ�ʽ���кܶ�ϸ�ں�������ĵط�û���ᵽ��
   
   
   
   #  �ڲ������ Win7 ����������� Enable-PSRemoting ����������
   #   1��Administrator û����������ʱ��ʾ�ܾ�����
   #   2��Ϊ Administrator ����������ٳ�������  Enable-PSRemoting ����ʾ���ڼ�����ϵ�������������֮һ����Ϊ���ã����
   #       WinRM ����ǽ���⽫�����С��������������͸���Ϊ���ר�ã�Ȼ���ٳ��ԡ�
   #   3�� ��������� �������͹������� -> �鿴����� -> ����������� -> ����Ϊ��������
   #   4�� Ȼ���Թ���Ա�����������  Enable-PSRemoting  ����
   
   
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
   $mail.Subject     = "$display_name ,��ӭ��������!";
   $mail.Priority    = "High"
   $mail.Body        = "$display_name �����ѿ�ͨ, лл��`n
                        ��¼���� $pinyin  `n
						��ʼ���룺 caipiaowoyou ����ĸ��д `n
						
�뼰ʱ�޸ĳ�ʼ���룬����������Ҫ�������븴���Բ��ԣ�`n
��������ĸ��д��Сд��A-Z��a-z�������֣�0-9���Լ�������ţ�����@��#������.��8λ��8λ�����ַ���`n
					   "  
# set attachment
# $filename="C:\Users\Administrator\Desktop\Exchange 2010������.txt"
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
   Default       {"�������"}
 } 

 Write-host	"$LastName-$FirstName"
 
 $mailbox = New-Mailbox -Name $pinyin  -DisplayName $display_name -OrganizationalUnit 'yxtoa.CN/Employees_Accounts' -UserPrincipalName $email_address -FirstName $FirstName -LastName $LastName -ResetPasswordOnNextLogon $false -password (ConvertTo-SecureString -AsPlainText "caipiaowoyou" -Force) -Alias $pinyin -PrimarySmtpAddress $email_address

if($mailbox) {
   Send-Email
   Write-Host "$name ���䴴���ɹ����ѷ����ʼ���"  -ForegroundColor green
   } else {
       Write-Host "$name ���䴴��ʧ�ܣ������Ƿ�����" -ForegroundColor red
   }
 }

Set-Alias add Add-User
Export-ModuleMember -Alias add
Export-ModuleMember Add-User
Export-ModuleMember Send-Email
```