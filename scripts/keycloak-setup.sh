VERSION=26.0.5

DOWNLOAD_URL=https://github.com/keycloak/keycloak/releases/download/${VERSION}/keycloak-${VERSION}.tar.gz

echo "Installing Java JDK "
apt-get update
apt-get install wget openjdk-21-jdk -y


echo "Downloading Keycloak"
wget -q -O keycloak.tar.gz "${DOWNLOAD_URL}"
if [ $? != 0 ];
  then
        echo "Failed to download Keycloak from ${DOWNLOAD_URL}"
        exit 1
    fi

echo "Installing Keycloak ..."

mkdir keycloak
tar -xzf keycloak.tar.gz -C keycloak --strip-components 1

#./keycloak/bin/add-user-keycloak.sh -r master -u admin -p admin

openssl req -newkey rsa:2048 -nodes \
  -keyout keycloak-server.key.pem \
  -x509 -days 3650 -out keycloak-server.crt.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=keycloak.example.com"

#Opening firewall
ufw enable
ufw allow 9990
ufw allow 8080
ufw allow 8443
