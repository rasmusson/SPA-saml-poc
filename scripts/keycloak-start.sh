nohup /home/vagrant/keycloak/bin/kc.sh start-dev --bootstrap-admin-password admin --bootstrap-admin-username admin --https-port=8443 --https-certificate-file=/home/vagrant/keycloak-server.crt.pem --https-certificate-key-file=/home/vagrant/keycloak-server.key.pem &
printf 'waiting for server to start'
until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
    printf '.'
    sleep 5
done
