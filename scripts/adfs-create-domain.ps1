
#disable password complex reqs
secedit /export /cfg C:\secconfig.cfg
  (gc C:\secconfig.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0").replace("MinimumPasswordLength = 7", "MinimumPasswordLength = 0") | Out-File C:\secconfig.cfg
  secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secconfig.cfg /areas SECURITYPOLICY
  rm -force C:\secconfig.cfg -confirm:$false

#set admin pass
$adminPassword = "vagrant"
$adminUser = [ADSI] "WinNT://adfs/Administrator,User"
$adminUser.SetPassword("vagrant")


$PlainPassword = "vagrant"
$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force


Install-WindowsFeature AD-domain-services
Import-Module ADDSDeployment

Install-ADDSForest `
    -SafeModeAdministratorPassword $SecurePassword `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Win2012R2" `
    -DomainName "windomain.local" `
    -DomainNetbiosName "WINDOMAIN" `
    -ForestMode "Win2012R2" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

Start-Sleep -m 5000
