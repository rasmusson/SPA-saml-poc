VERSION=15.0.2

DOWNLOAD_URL=https://github.com/keycloak/keycloak/releases/download/${VERSION}/keycloak-${VERSION}.tar.gz

echo "Installing Java JDK "
yum install wget firewalld java-1.8.0-openjdk-devel -y


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

./keycloak/bin/add-user-keycloak.sh -r master -u vagrant -p vagrant


#Opening firewall
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=9990/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8443/tcp --permanent
firewall-cmd --reload
