. c:\vagrant\scripts\wait-for-ad.ps1
. c:\vagrant\scripts\wait-for-adfs.ps1

#WARNING disabling certificate trust check
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

Add-ADFSRelyingPartyTrust -Name 'keycloak' -MetadataURL 'https://192.168.38.3:8443/realms/oidcrealm/broker/saml/endpoint/descriptor' -IssuanceAuthorizationRules @'
@RuleTemplate = "AllowAllAuthzRule"
 => issue(Type = "http://schemas.microsoft.com/authorization/claims/permit", Value = "true");
'@ -IssuanceTransformRules @'
@RuleTemplate = "LdapClaims"
@RuleName = "Email Attribute"
c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"] => issue(store = "Active Directory", types = ("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"), query = ";mail;{0}", param = c.Value);

@RuleTemplate = "MapClaims"
@RuleName = "Email ad nameid"
c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"] => issue(Type ="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, Value = c.Value, ValueType = c.ValueType, Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/format"] = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress");
'@
