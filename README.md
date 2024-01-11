keycloak-awscli
========================================

Keycloak with AWS CLI container.


How to use
----------------------------------------

```bash
docker build -t keycloak-awscli .

docker container run \
-p 8080:8080 \
-e KEYCLOAK_ADMIN=admin \
-e KEYCLOAK_ADMIN_PASSWORD=admin \
keycloak-awscli \
start-dev
```

DO NOT use the configuration that has `start-dev` option in production.

For more details, see also:

- https://www.keycloak.org/getting-started/getting-started-docker
- https://www.keycloak.org/server/containers

