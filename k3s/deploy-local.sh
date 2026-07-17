#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

required_variables=(
  VYNTRA_MYSQL_ROOT_PASSWORD
  VYNTRA_MYSQL_APP_PASSWORD
  VYNTRA_JWT_SECRET
  VYNTRA_SEED_ADMIN_PASSWORD
)

for variable in "${required_variables[@]}"; do
  if [[ -z "${!variable:-}" ]]; then
    echo "Required environment variable is missing: ${variable}" >&2
    exit 1
  fi
done

if (( ${#VYNTRA_JWT_SECRET} < 32 )); then
  echo "VYNTRA_JWT_SECRET must contain at least 32 characters" >&2
  exit 1
fi

sudo k3s kubectl apply -f "${ROOT_DIR}/local/namespace.yaml"

sudo k3s kubectl -n vyntra create secret generic vyntra-runtime \
  --from-literal=mysql-root-password="${VYNTRA_MYSQL_ROOT_PASSWORD}" \
  --from-literal=mysql-app-password="${VYNTRA_MYSQL_APP_PASSWORD}" \
  --from-literal=jwt-secret="${VYNTRA_JWT_SECRET}" \
  --from-literal=seed-admin-password="${VYNTRA_SEED_ADMIN_PASSWORD}" \
  --dry-run=client \
  -o yaml \
  | sudo k3s kubectl apply -f -

sudo k3s kubectl apply -k "${ROOT_DIR}/local"
