#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-dev}"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TEMP_DIR}"' EXIT

images=(
  api-gateway
  bff
  user-service
  business-service
  shop-service
  product-service
  inventory-service
  order-service
)

for image in "${images[@]}"; do
  archive="${TEMP_DIR}/${image}.tar"
  docker image inspect "vyntra/${image}:${TAG}" >/dev/null
  docker save "vyntra/${image}:${TAG}" -o "${archive}"
  sudo k3s ctr -n k8s.io images import "${archive}"
done
