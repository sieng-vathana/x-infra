# X Platform K3s Operations Guide

This guide is for developers operating the shared K3s server. Run commands after connecting through the approved SSH access method.

```bash
ssh <deploy-user>@<server-host>
```

All application resources run in the `x-platform` namespace.

## Check platform status

```bash
sudo k3s kubectl get nodes
sudo k3s kubectl get deployments,pods,services -n x-platform
sudo k3s kubectl get pods -A
```

Watch pods while a deployment is starting:

```bash
sudo k3s kubectl get pods -n x-platform --watch
```

## View logs

Replace `<service>` with a service name, for example `x-product-service` or `x-delivery-service`.

```bash
sudo k3s kubectl logs -n x-platform deployment/<service> --tail=200
sudo k3s kubectl logs -n x-platform deployment/<service> --follow
sudo k3s kubectl logs -n x-platform deployment/<service> --previous --tail=200
```

View pod events when a pod does not start:

```bash
sudo k3s kubectl describe pod -n x-platform <pod-name>
sudo k3s kubectl get events -n x-platform --sort-by=.lastTimestamp
```

## Restart or redeploy a service

GitHub Actions deploys automatically after a push to `main`. For a manual restart:

```bash
sudo k3s kubectl rollout restart deployment/<service> -n x-platform
sudo k3s kubectl rollout status deployment/<service> -n x-platform --timeout=180s
```

Check rollout history or undo the latest rollout:

```bash
sudo k3s kubectl rollout history deployment/<service> -n x-platform
sudo k3s kubectl rollout undo deployment/<service> -n x-platform
```

## List deployed services

```bash
sudo k3s kubectl get services -n x-platform
sudo k3s kubectl get deployment -n x-platform
```

Current platform service names:

```text
x-api-gateway
x-bff
x-business-service
x-delivery-service
x-inventory-service
x-order-service
x-payment-service
x-product-service
x-storage-service
x-store-service
x-user-service
mysql
redis
```

## Database and Redis checks

Do not print Secrets to the terminal or commit them to Git.

```bash
sudo k3s kubectl get pod -n x-platform -l app=mysql
sudo k3s kubectl get pod -n x-platform -l app=redis
sudo k3s kubectl logs -n x-platform deployment/mysql --tail=100
sudo k3s kubectl logs -n x-platform deployment/redis --tail=100
```

Open a MySQL shell only when you have the approved credentials:

```bash
sudo k3s kubectl exec -it -n x-platform deployment/mysql -- mysql -u <username> -p x_prod
```

Test Redis from its pod:

```bash
sudo k3s kubectl exec -it -n x-platform deployment/redis -- redis-cli ping
```

## Resource usage

```bash
sudo k3s kubectl top nodes
sudo k3s kubectl top pods -n x-platform
free -h
df -h /
```

## CI/CD checks from a developer computer

Run these from a workstation authenticated with GitHub CLI:

```bash
gh run list --repo VathanaProgrammer/<service-repository> --limit 10
gh run watch --repo VathanaProgrammer/<service-repository> <run-id>
gh run view --repo VathanaProgrammer/<service-repository> <run-id> --log-failed
```

Example:

```bash
gh run list --repo VathanaProgrammer/x-product-service --limit 10
```

## Important safety rules

- Do not delete namespaces, deployments, volumes, Secrets, or databases without team approval.
- Do not use `kubectl delete` as a first response to a failed pod; check events and logs first.
- Never paste passwords, private keys, tokens, or Secret contents into GitHub issues, commits, or chat.
- Application images are deployed from GitHub Actions after pushes to `main`.
