export PATH=$PATH:/home/vagrant/keycloak/bin
kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user vagrant --password vagrant
kcadm.sh create identity-provider/instances -r oidcrealm -s alias=saml -s providerId=saml -s enabled=true -s 'config.useJwksUrl="true"' -s config.singleSignOnServiceUrl=https://adfs.devel/adfs/ls/ -s config.nameIDPolicyFormat=urn:oasis:names:tc:SAML:2.0:nameid-format:email -s config.signatureAlgorithm=RSA_SHA256 -s firstBrokerLoginFlowAlias=auto-link-create

kcadm.sh create /authentication/flows -r oidcrealm -f - << EOF
{
  "id" : "3a08d545-c30d-4b71-b3b4-8a1db14cda00",
  "alias" : "auto link or auto create",
  "description" : "",
  "providerId" : "basic-flow",
  "topLevel" : true,
  "builtIn" : false,
  "authenticationExecutions" : [ {
    "authenticator" : "idp-create-user-if-unique",
    "authenticatorFlow" : false,
    "requirement" : "REQUIRED",
    "priority" : 0,
    "userSetupAllowed" : false,
    "autheticatorFlow" : false
  }, {
    "authenticator" : "idp-detect-existing-broker-user",
    "authenticatorFlow" : false,
    "requirement" : "REQUIRED",
    "priority" : 1,
    "userSetupAllowed" : false,
    "autheticatorFlow" : false
  }
EOF

idpRedirector=$(kcadm.sh get /authentication/flows/browser/executions -r oidcrealm | jq -r '.[] | select(.providerId == "identity-provider-redirector").id')
kcadm.sh create /authentication/executions/$idpRedirector/config -r oidcrealm -s config.defaultProvider=saml -s alias=straight_to_saml
