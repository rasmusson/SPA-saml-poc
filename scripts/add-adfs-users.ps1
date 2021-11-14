. c:\vagrant\scripts\wait-for-ad.ps1

secedit /export /cfg C:\secconfig.cfg
  (gc C:\secconfig.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0").replace("MinimumPasswordLength = 7", "MinimumPasswordLength = 0") | Out-File C:\secconfig.cfg
  secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secconfig.cfg /areas SECURITYPOLICY
  rm -force C:\secconfig.cfg -confirm:$false

Import-Module ActiveDirectory
New-ADUser -SamAccountName test -GivenName Test -Surname User -Name "Test User" -Email "test@test.com"`
           -Path "CN=Users,DC=windomain,DC=local" `
           -AccountPassword (ConvertTo-SecureString 'test' -AsPlainText -Force) -Enabled $true
