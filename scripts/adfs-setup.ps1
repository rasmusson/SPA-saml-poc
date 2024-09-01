. c:\vagrant\scripts\wait-for-ad.ps1
#https://docs.microsoft.com/en-us/powershell/module/adfs/install-adfsfarm?view=windowsserver2019-ps

$fqdn = "adfs.devel"

Write-Host "Installing nuget package provider"
Install-PackageProvider nuget -force

Write-Host "Installing PSPKI module"
Install-Module -Name PSPKI -Force

Write-Host "Importing PSPKI into current environment"
Import-Module -Name PSPKI

Write-Host "Generating Certificate"
$selfSignedCert = New-SelfSignedCertificate `
    -Subject "CN=$fqdn" `
    -KeyUsage "DigitalSignature" `
    -KeyExportPolicy "Exportable" -CertStoreLocation "Cert:\LocalMachine\My"
$certThumbprint = $selfSignedCert.Thumbprint

$username = "windomain.local\Administrator"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$adminCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

$username = "windomain.local\vagrant"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$fsCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

Install-AdfsFarm -CertificateThumbprint $certThumbprint -FederationServiceName $fqdn -ServiceAccountCredential $fsCred -Credential $adminCred -OverwriteConfiguration


$username = "windomain.local\Administrator"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$adminCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

$username = "windomain.local\vagrant"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$fsCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
#One more time to make sure ADFS is set up, the first call might fail due to configuration db timeout
Install-AdfsFarm -CertificateThumbprint $certThumbprint -FederationServiceName $fqdn -ServiceAccountCredential $fsCred -Credential $adminCred -OverwriteConfiguration
