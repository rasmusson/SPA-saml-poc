. c:\vagrant\scripts\wait-for-ad.ps1

wget "http://192.168.1.3:8080/auth/realms/oidcrealm/protocol/saml/descriptor" -outfile "keycloak-metadata"


Add-ADFSRelyingPartyTrust -Name 'keycloak' -MetadataURL 'http://192.168.1.3:8080/auth/realms/oidcrealm/protocol/saml/descriptor'
