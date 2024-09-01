export PATH=$PATH:/home/vagrant/keycloak/bin

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
apt-get install jq -y

sleep 30
kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user vagrant --password vagrant

kcadm.sh create identity-provider/instances -r oidcrealm -s alias=saml -s providerId=saml -s enabled=true -s config.wantAuthnRequestsSigned=true -s config.allowedClockSkew=10 -s 'config.useJwksUrl="true"' -s config.singleSignOnServiceUrl=https://adfs.devel/adfs/ls/ -s config.singleLogoutServiceUrl=https://adfs.devel/adfs/ls/ -s config.nameIDPolicyFormat=urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress -s config.signatureAlgorithm=RSA_SHA256

idpRedirector=$(kcadm.sh get /authentication/flows/browser/executions -r oidcrealm | jq -r '.[] | select(.providerId == "identity-provider-redirector").id')
kcadm.sh create /authentication/executions/$idpRedirector/config -r oidcrealm -s config.defaultProvider=saml -s alias=straight_to_saml

reviewProfileExecution=$(kcadm.sh get /authentication/flows/first%20broker%20login/executions -r oidcrealm | jq -r '.[] | (select(.alias == "review profile config") | .requirement) |= "DISABLED" | select(.alias == "review profile config")')
kcadm.sh update authentication/flows/first%20broker%20login/executions -r oidcrealm -f - << EOF
$reviewProfileExecution
EOF
