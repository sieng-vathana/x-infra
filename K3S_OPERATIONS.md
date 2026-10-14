# X Platform K3s Operations

## Server

- Host: `sg-vathana-vps`
- IPv4: `45.132.75.51`
- Cluster: one-node K3s, using Traefik for ingress and local-path for persistent volumes
- Namespaces: application workloads use `x-platform`; Headlamp runs in `headlamp`
- K3s API: secrets encryption is enabled; public access to port 6443 is blocked
- Helm: installed for Helm-based platform tools

This server is suitable for the current demo/staging environment. It is a single node, so Kubernetes, MySQL, Kafka, Redis, and local media storage do not have high availability. Persistent volumes live on this VPS disk and need an off-server backup before production use.

Connect with the SSH key stored on the workstation:

```bash
ssh -i ~/.ssh/x-platform-vps root@45.132.75.51
```

The temporary recovery key used during the VPS reinstall has been removed. Use
the persistent `x-platform-vps` SSH key shown above.

The Kubernetes API port is not open to the public internet. Use SSH for cluster administration.

## Check cluster and workloads

```bash
k3s kubectl get nodes -o wide
k3s kubectl get pods -A
k3s kubectl get deployments,services,pvc -n x-platform
k3s kubectl get events -n x-platform --sort-by=.lastTimestamp
```

Follow a service rollout and inspect logs:

```bash
k3s kubectl rollout status deployment/<service> -n x-platform --timeout=180s
k3s kubectl logs -n x-platform deployment/<service> --tail=200
```

Check a failed pod before restarting it:

```bash
k3s kubectl describe pod -n x-platform <pod-name>
k3s kubectl logs -n x-platform <pod-name> --previous --tail=200
```

## Platform services

- MySQL: `mysql.x-platform.svc.cluster.local:3306`, database `x_prod`, private ClusterIP only
- Redis: `redis.x-platform.svc.cluster.local:6379`, cache data is ephemeral
- Kafka: `x-kafka.x-platform.svc.cluster.local:9092`, single broker with a local persistent volume
- File/media service: currently uses a 5 GiB local persistent volume; configure an S3-compatible endpoint and credentials before switching it to S3

Credentials are stored in encrypted Kubernetes Secrets on the VPS. Do not print
their values or commit them to Git. On a completely fresh cluster, create the
initial secrets once with:

```bash
ssh -i ~/.ssh/x-platform-vps root@45.132.75.51 "bash -s" \
  < scripts/bootstrap-platform-secrets.sh
```

The script generates new credentials locally on the VPS, stores them directly
in Kubernetes Secrets, and stops if it finds a partial secret set. It does not
rotate existing credentials.

```bash
k3s kubectl get pods -n x-platform
k3s kubectl logs -n x-platform deployment/mysql --tail=100
k3s kubectl logs -n x-platform deployment/x-kafka --tail=100
k3s kubectl exec -it -n x-platform deployment/x-kafka -- /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
```

## Headlamp

Headlamp is not exposed on a public ingress. A systemd service binds its port forward to VPS loopback at `127.0.0.1:4466`.

From the workstation, open an SSH tunnel:

```bash
ssh -i ~/.ssh/x-platform-vps -L 4466:127.0.0.1:4466 root@45.132.75.51
```

Then open `http://localhost:4466` and paste the read-only token from `~/.ssh/x-platform-headlamp-viewer.token`. The token expires after 90 days. To renew it, create a new token for the `headlamp-viewer` service account and store it in the protected workstation file. The viewer role cannot read Kubernetes Secrets or change resources.

Check the Headlamp pod and tunnel service:

```bash
k3s kubectl get pods -n headlamp
systemctl status headlamp-port-forward.service
```

## GitHub Actions deployment

Fourteen application repositories have repository-scoped self-hosted runners
on this VPS. Each runner accepts both labels used by the existing workflows:
`x-platform-deploy` and `x-platform-deploy-new`. The runners run as the
unprivileged `xplatform` account and use a sudo rule limited to `k3s kubectl`.

Build and publish jobs run on GitHub-hosted runners. Deploy jobs use a short-lived workflow token to pull the private GHCR image, wait for it to start, then remove the temporary pull credential. A push to `main` starts the repository's deployment workflow.

The `x-infra` and `x-windows-config` repositories run validation workflows. `x-redis` and `x-sharedlib` publish Maven packages and do not need Kubernetes runners.

## Domains and ingress

Traefik serves HTTP/HTTPS on ports 80/443. cert-manager is configured for Let's Encrypt HTTP-01 challenges. The application Ingress resources use the `traefik` class.

The API, backoffice, merchant portal, and online store hostnames currently
resolve to `45.132.75.51`. cert-manager uses HTTP-01 with Let's Encrypt; each
application Ingress must be present before its certificate can be issued.

## Resource and disk checks

```bash
k3s kubectl top nodes
k3s kubectl top pods -A
free -h
df -h /
```

The MySQL PVC requests 20 GiB, Kafka 5 GiB, and local media storage 5 GiB. Keep space for operating-system updates, runner work directories, and container images.
