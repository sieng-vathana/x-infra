# Vyntra on local K3s

This deployment implements the request path:

```text
Traefik -> API Gateway -> BFF -> private domain services
```

Only the API Gateway is reachable through the Traefik ingress. The BFF,
domain services, MySQL, and Redis use private `ClusterIP` services.

## Prerequisites

- A single-node K3s installation
- Docker for building the local images
- Java 17 and Maven; existing Maven wrappers are used where available

## Build and load the images

```bash
./k3s/build-images.sh
./k3s/load-images-k3s.sh
```

The first script builds the shared library before the BFF. The second imports
the runtime images into the K3s containerd image store.

## Deploy

Provide local-only credentials without committing them:

```bash
export VYNTRA_MYSQL_ROOT_PASSWORD='<local-root-password>'
export VYNTRA_MYSQL_APP_PASSWORD='<local-app-password>'
export VYNTRA_JWT_SECRET='<at-least-32-random-characters>'
export VYNTRA_SEED_ADMIN_PASSWORD='<local-admin-password>'
./k3s/deploy-local.sh
```

Add this local hostname:

```text
127.0.0.1 api.vyntra.local
```

Inspect the deployment:

```bash
sudo k3s kubectl get pods,services,ingress -n vyntra
sudo k3s kubectl get events -n vyntra --sort-by=.lastTimestamp
```

The `local-seed` Spring profile is enabled only for the local user service and
uses the admin password supplied to the deployment script. Do not enable this
profile in a public environment.

MySQL uses K3s `local-path` storage and JPA currently manages the local tables.
This is a development setup, not a production migration or backup strategy.

Payment service is not deployed yet because its current project has no HTTP
API or long-running server dependency. The shared library is a build-time
dependency and is not deployed as a pod.
