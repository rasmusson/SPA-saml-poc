#disable password complex reqs
secedit /export /cfg C:\secpol.cfg
  (gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
  secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
  rm -force C:\secpol.cfg -confirm:$false

#set admin pass
    $adminPassword = "vagrant"
    $adminUser = [ADSI] "WinNT://adfs/Administrator,User"
    $adminUser.SetPassword("vagrant")



    $PlainPassword = "vagrant" # "P@ssw0rd"
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



Write-Host 'Installing ADFS 2'

Install-WindowsFeature adfs-federation

#https://docs.microsoft.com/en-us/powershell/module/adfs/install-adfsfarm?view=windowsserver2019-ps

$cert = New-SelfSignedCertificate -DnsName adfs.samlsecurity.com -CertStoreLocation cert:\LocalMachine\My



$username = "windomain.local\Administrator"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$adminCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

$username = "windomain.local\vagrant"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$fsCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

Install-AdfsFarm -CertificateThumbprint $cert.Thumbprint -FederationServiceName adfs.samlsecurity.com -ServiceAccountCredential $fsCred -Credential $adminCred -OverwriteConfiguration
