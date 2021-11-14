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


#Adding HTTPS
keytool -genkey -keystore ssl.jks -keyalg RSA -keysize 2048 \
        -validity 10000 -alias app -dname "cn=Unknown, ou=Unknown, o=Unknown, c=Unknown" \
        -storepass vagrant -keypass vagrant

mv ssl.jks keycloak/configuration/

# ex keycloak/configuration/standalone.xml <<eof
# /security-realms/ append
# <security-realm name="UndertowRealm">
#     <server-identities>
#         <ssl>
#             <keystore path="ssl.jks" relative-to="jboss.server.config.dir" keystore-password="vagrant" />
#         </ssl>
#     </server-identities>
# </security-realm>
# .
# xit
# eof
#
# ex keycloak/configuration/standalone.xml <<eof
# /<https-listener name="https" socket-binding="https" security-realm="ApplicationRealm" enable-http2="true"\/>/ change
# <https-listener name="https" socket-binding="https" security-realm="UndertowRealm" enable-http2="true"/>
# .
# xit
# eof

#Opening firewall

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=9990/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8443/tcp --permanent
firewall-cmd --reload
