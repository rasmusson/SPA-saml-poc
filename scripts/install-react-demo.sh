curl -sL curl -sL https://deb.nodesource.com/setup_23.x | sudo bash -
apt-get update
apt-get install nodejs git -y

git clone https://github.com/keycloak/keycloak-quickstarts.git
cd keycloak-quickstarts/js/spa

#sed -i 's|url: "http://localhost:8180"|url: "https://keycloak.localhost:8443"|g' public/index.html
sed -i 's|realm: "quickstart"|realm: "oidcrealm"|g' public/index.html
sed -i 's|clientId: "spa"|clientId: "oidc-client"|g' public/index.html

npm install