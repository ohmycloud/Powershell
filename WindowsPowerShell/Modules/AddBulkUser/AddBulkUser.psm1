# ��������û��ʻ�/����, ��ʽ�����; ������ӳ�Ա��ͨѶ��
```powershell
# Import-Module AddBulkUser -Verbose -Force һ��Ҫ���� -Force ���������ˢ�¼��صĺ�����
# �ýű��� Exchange ������ WIN-JJRLJ6SDSRU.yxtoa.cn ����һ��Զ�̻Ự
# �ڱ��� Powershell ����̨�оͿ��Ե��� Exchange Managment Console �е�����
# �ýű��洢�˹���Ա�˺ź�����
# �����Ự����Ե��ñ��ص� Powershell �ű�
# ���� Powershell ����Ҫ�Թ���Ա�������
Function Connect-Exchange {
$user_name="yxtoa\zhangwuji.admin";
$pwd=ConvertTo-SecureString  'xiaozhaowoaini' -AsPlainText -Force;
$credential=New-Object System.Management.Automation.PSCredential($user_name,$pwd);
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://pekdc1-hub-01.yxtoa.cn/Powershell/ -Credential $credential
Import-PSSession $session -AllowClobber


     # ������ģʽ+Windows2008 R2 Enterprise+PowerShell2.0.
     # �ҵĹ���PC�� win7��Ҫ���ķ������ͽ� server��������Server����Client��Ҫ����Windows Remote Management (WS-Management)����
# 1.��  server �ϴ�PowerShell��ִ��Enable-PSRemoting �CForce�����Ű���ʾ����Y�س���ϵͳ���Զ�������ع��ܡ�
# 2.�� win7 �ϴ�PowerShell��ִ��cd WSMan::localhost\client,�����е�Զ�̹����clientĿ¼�¡�      ����Ϊ���ڹ�����ģʽ�£�������򻷾��Ͳ���Ҫ�ˣ�Զ������ʱ�Զ����õ�ǰ�û�����֤����
    # Ȼ��ִ��Get-ChildItem����һ����ʲô���
	# ִ��Set-Item ./TrustedHosts 192.168.1.111, ��server ��IP�ӵ�Server������������ȥ��
    # 192.168.1.111 ��������һ̨��������Ҫ�Ӷ�̨�Ļ����ö��ŷָ�IP: Set-Item ./TrustedHosts '192.168.1.110,192.168.1.111,192.168.1.112'
	
# 3. ������Զ�̹�������þ�����ˡ�����һ�£��� win7 ��ִ�У�
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
   $mail.Subject     = "��ӭ��������!";
   $mail.Priority    = "High"
   $mail.Body        = "�����ѿ�ͨ, лл��`n
$header
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
$lines
						
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

Function Add-BulkUser {
[cmdletbinding()]
param(
[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true, Position=0)]
[String]$Path
)

# $Path ��ÿ�и�ʽΪ  �������� �ո� ����ȫƴ

foreach  ($line  in get-content $Path ) {
    $zh_en                    = $line  -split  "\s+";
    $display_name             = $zh_en[0];
    $pinyin                   = $zh_en[1];
    $display_name_length      = $display_name.length
    $email_address            = $pinyin + '@yingxiaotong.com'

switch($display_name_length) 
{     
   {$_ -eq 3 }   { $LastName = $display_name[0];��$FirstName = $display_name[1]+$display_name[2]; break  }     
   {$_ -eq 2 }   { $LastName = $display_name[0];��$FirstName = $display_name[1]  ; break                  }     
   {$_ -eq 4 }   { $LastName = $display_name[0]+$display_name[1]; $FirstName = $display_name[2]+$display_name[3]; break  }     
   Default       {"������������";break}
 } 

 $mailbox = New-Mailbox -Name $pinyin  -DisplayName $display_name -OrganizationalUnit 'yxtoa.CN/Employees_Accounts' -UserPrincipalName $email_address -FirstName $FirstName -LastName $LastName -ResetPasswordOnNextLogon $false -password (ConvertTo-SecureString -AsPlainText "liubaishuang" -Force) -Alias $pinyin -PrimarySmtpAddress $email_address -ErrorAction SilentlyContinue -ErrorVariable myErrors


if($mailbox) {
   Set-Mailbox $pinyin -ProhibitSendReceiveQuota 500Mb -ProhibitSendQuota 480Mb -IssueWarningQuota 450Mb
   $lines += Format-Lines;
   Write-Host " -> $display_name ���䴴���ɹ���"  -ForegroundColor green
   } else {
 write-host " -> $display_name �Ѵ���" -ForegroundColor red;
 "$display_name $pinyin" | out-file dumplicate.txt -Encoding utf8 -Append;  
}

}
$header = "{0,6} {1,20} {2,33} {3,16}" -f '����','��¼��','����','��ʼ����(����ĸ��д)';

Write-Host " -> ��Ϣ�ѷ��͵����䣬����գ�"  -ForegroundColor red
Send-Email

<#
.Synopsis
    �����������
.Path     
    �ļ�·���������ݸ�ʽ���£�
	���޼�      zhangwuji
    �ֳ�        linchong
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

# $Path ��ÿ�и�ʽΪ ����ȫƴ�� ��ռһ��

foreach  ($line  in get-content $Path ) {
   Add-DistributionGroupMember -Identity $Group_Name -Member $line -BypassSecurityGroupManagerCheck
   write-host " -> $line �����" -ForegroundColor green;
}

<#
.Synopsis
    ��������û���ָ����ͨ����
.Path     
    �����û�����ƴ�������ļ���·��,��������������
	zhangwuji
	linchong
.Example
    Add-BulkMember -Path allmember.txt -Group_Name �����ܲ�
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
	  write-host " -> ",$col[0] ,"�����" -ForegroundColor green;
  }
}

<#
.Synopsis
    ��������ͨѶ�鲢ΪͨѶ��������ӹ���Ա
.Path     
    �����û�����ƴ�������ļ���·������ʽ���£�
	������̳   mingjiaozt.list 
	���̽���   mingjiaojd.list��
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