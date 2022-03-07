export PATH=$PATH:/home/vagrant/keycloak/bin

kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user vagrant --password vagrant
kcadm.sh create realms -s realm=oidcrealm -s enabled=true


kcadm.sh create users -r oidcrealm -s username=test -s enabled=true -o --fields id,username
kcadm.sh set-password -r oidcrealm --username test --new-password test

kcadm.sh create clients -r oidcrealm -f - << EOF
{"clientId" : "oidc-client", "redirectUris": ["http://react:3000"], "webOrigins": ["+"], "standardFlowEnabled": true, "publicClient": true, "attributes": {"pkce.code.challenge.method":"S256"}}
