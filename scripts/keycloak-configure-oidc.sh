export PATH=$PATH:/home/vagrant/keycloak/bin

kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password admin
kcadm.sh create realms -s realm=oidcrealm -s enabled=true


kcadm.sh create users -r oidcrealm -s username=test -s enabled=true -o --fields id,username
kcadm.sh set-password -r oidcrealm --username test --new-password test

kcadm.sh create clients -r oidcrealm -f - << EOF
  {
    "clientId" : "oidc-client",
    "redirectUris": ["http://localhost:8080"],
    "webOrigins": ["+"],
    "standardFlowEnabled": true,
    "publicClient": true
  }
