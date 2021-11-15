export PATH=$PATH:/home/vagrant/keycloak/bin

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install jq -y

kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user vagrant --password vagrant

kcadm.sh create /authentication/flows -r oidcrealm -f - << EOF
{
  "alias" : "auto-link-create",
  "description" : "",
  "providerId" : "basic-flow",
  "topLevel" : true,
  "builtIn" : false
}
EOF

kcadm.sh create /authentication/flows/auto-link-create/executions/execution -r oidcrealm -f - << EOF
{
  "requirement" : "REQUIRED",
  "displayName" : "Create User If Unique",
  "provider" : "idp-create-user-if-unique",
  "level" : 0,
  "index" : 0
}
EOF


kcadm.sh create /authentication/flows/auto-link-create/executions/execution -r oidcrealm -f - << EOF
{
  "requirement" : "REQUIRED",
  "displayName" : "Detect existing broker user",
  "provider" : "idp-detect-existing-broker-user",
  "level" : 0,
  "index" : 1
}
EOF


requiredExecution=$(kcadm.sh get /authentication/flows/auto-link-create/executions -r oidcrealm | jq -r '.[] | (select(.providerId == "idp-create-user-if-unique") | .requirement) |= "REQUIRED" | select(.providerId == "idp-create-user-if-unique")')
kcadm.sh update authentication/flows/auto-link-create/executions -r oidcrealm -f - << EOF
$requiredExecution
EOF

requiredExecution=$(kcadm.sh get /authentication/flows/auto-link-create/executions -r oidcrealm | jq -r '.[] | (select(.providerId == "idp-detect-existing-broker-user") | .requirement) |= "REQUIRED" | select(.providerId == "idp-detect-existing-broker-user")')
kcadm.sh update authentication/flows/auto-link-create/executions -r oidcrealm -f - << EOF
$requiredExecution
EOF

kcadm.sh create identity-provider/instances -r oidcrealm -s alias=saml -s providerId=saml -s enabled=true -s 'config.useJwksUrl="true"' -s config.singleSignOnServiceUrl=https://adfs.devel/adfs/ls/ -s config.nameIDPolicyFormat=urn:oasis:names:tc:SAML:2.0:nameid-format:email -s config.signatureAlgorithm=RSA_SHA256 -s firstBrokerLoginFlowAlias=auto-link-create

idpRedirector=$(kcadm.sh get /authentication/flows/browser/executions -r oidcrealm | jq -r '.[] | select(.providerId == "identity-provider-redirector").id')
kcadm.sh create /authentication/executions/$idpRedirector/config -r oidcrealm -s config.defaultProvider=saml -s alias=straight_to_saml
