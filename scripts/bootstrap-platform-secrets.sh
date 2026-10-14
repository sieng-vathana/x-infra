#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run this script as root on the K3s server." >&2
  exit 1
fi

kubectl() {
  /usr/local/bin/k3s kubectl "$@"
}

namespace=x-platform
secrets=(mysql-secret x-app-database x-app-auth x-app-storage)
present=0

for secret in "${secrets[@]}"; do
  if kubectl -n "$namespace" get secret "$secret" >/dev/null 2>&1; then
    ((present += 1))
  fi
done

if [[ "$present" -eq "${#secrets[@]}" ]]; then
  echo "Platform secrets already exist; nothing changed."
  exit 0
fi

if [[ "$present" -ne 0 ]]; then
  echo "Found a partial platform secret set. Reconcile it manually; no secrets were changed." >&2
  exit 1
fi

umask 077
stage="$(mktemp -d /run/x-platform-secrets.XXXXXX)"
trap 'rm -f "$stage"/*; rmdir "$stage"' EXIT

database_password="$(openssl rand -hex 32)"
root_password="$(openssl rand -hex 32)"
jwt_secret="$(openssl rand -base64 64 | tr -d '\n')"

printf '%s' "$root_password" > "$stage/mysql-root-password"
printf 'SPRING_DATASOURCE_USERNAME=x_prod\nSPRING_DATASOURCE_PASSWORD=%s\n' \
  "$database_password" > "$stage/database.env"
printf 'JWT_SECRET=%s\n' "$jwt_secret" > "$stage/auth.env"
printf '%s\n' \
  'X_STORAGE_TYPE=local' \
  'X_STORAGE_ROOT=/data/uploads' \
  'X_STORAGE_PUBLIC_BASE_URL=https://api.learner-teach.online' \
  > "$stage/storage.env"

kubectl create namespace "$namespace" --dry-run=client -o yaml \
  | kubectl apply -f -
kubectl -n "$namespace" create secret generic mysql-secret \
  --from-file="root-password=$stage/mysql-root-password" \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$namespace" create secret generic x-app-database \
  --from-env-file="$stage/database.env" \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$namespace" create secret generic x-app-auth \
  --from-env-file="$stage/auth.env" \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$namespace" create secret generic x-app-storage \
  --from-env-file="$stage/storage.env" \
  --dry-run=client -o yaml | kubectl apply -f -

unset database_password root_password jwt_secret
echo "Created the platform secrets. Credential values were not printed or written to Git."
