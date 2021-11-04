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
mv keycloak /opt/keycloak
groupadd keycloak
useradd -r -g keycloak -d /opt/keycloak -s /sbin/nologin keycloak
chown -R keycloak: /opt/keycloak
chmod o+x /opt/keycloak/bin/
cd /etc/
mkdir keycloak
cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.conf /etc/keycloak/keycloak.conf
cp /opt/keycloak/docs/contrib/scripts/systemd/launch.sh /opt/keycloak/bin/
chown keycloak: /opt/keycloak/bin/launch.sh

sed -i 's/WILDFLY_HOME="\/opt\/wildfly"/WILDFLY_HOME="\/opt\/keycloak"/g' /opt/keycloak/bin/launch.sh

cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/keycloak.service

sed -i 's/Description=The WildFly Application Server/Description=The Keycloak Server/g' /etc/systemd/system/keycloak.service
sed -i 's/EnvironmentFile=-\/etc\/wildfly\/wildfly\.conf/EnvironmentFile=\/etc\/keycloak\/keycloak\.conf/g' /etc/systemd/system/keycloak.service
sed -i 's/User=wildfly/User=keycloak\nGroup=keycloak/g' /etc/systemd/system/keycloak.service
sed -i 's/PIDFile=\/var\/run\/wildfly\/wildfly\.pid/PIDFile=\/var\/run\/keycloak\/keycloak\.pid/g' /etc/systemd/system/keycloak.service
sed -i 's/ExecStart=\/opt\/wildfly\/bin\/launch\.sh \$WILDFLY_MODE \$WILDFLY_CONFIG \$WILDFLY_BIND/ExecStart=\/opt\/keycloak\/bin\/launch\.sh \$WILDFLY_MODE \$WILDFLY_CONFIG \$WILDFLY_BIND /g' /etc/systemd/system/keycloak.service

systemctl daemon-reload
systemctl enable keycloak
systemctl start keycloak

echo "Opening adminport port 9990 "
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=9990/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

#Adding admin user
/opt/keycloak/bin/add-user-keycloak.sh -r master -u vagrant -p vagrant
