nohup ~/keycloak/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0
printf 'waiting for server to start'
until $(curl --output /dev/null --silent --head --fail http://localhost:8080/auth); do
    printf '.'
    sleep 5
done
