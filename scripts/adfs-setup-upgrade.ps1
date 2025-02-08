
$fqdn = "adfs.devel"


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

Install-AdfsFarm -CertificateThumbprint $certThumbprint -FederationServiceName $fqdn -ServiceAccountCredential $fsCred -Credential $adminCred -OverwriteConfiguration -SQLConnectionString "Data Source=SQL;Integrated Security=True"


$username = "windomain.local\Administrator"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$adminCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

$username = "windomain.local\vagrant"
$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$fsCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
#One more time to make sure ADFS is set up, the first call might fail due to configuration db timeout
Install-AdfsFarm -CertificateThumbprint $certThumbprint -FederationServiceName $fqdn -ServiceAccountCredential $fsCred -Credential $adminCred -OverwriteConfiguration
