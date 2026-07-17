#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TAG="${1:-dev}"

run_maven() {
  local project_dir="$1"
  local goal="$2"
  if [[ -x "${project_dir}/mvnw" ]]; then
    (cd "${project_dir}" && ./mvnw -DskipTests clean "${goal}")
  else
    mvn -f "${project_dir}/pom.xml" -DskipTests clean "${goal}"
  fi
}

run_maven "${ROOT_DIR}/vyntra-sharedlib" install

services=(
  "vyntra-api-gateway:api-gateway"
  "vyntra-bff:bff"
  "vyntra-user-service:user-service"
  "vyntra-business-service:business-service"
  "vyntra-shop-service:shop-service"
  "vyntra-product-service:product-service"
  "vyntra-inventory-service:inventory-service"
  "vyntra-order-service:order-service"
  "vyntra-payment-service:payment-service"
)

for service in "${services[@]}"; do
  project="${service%%:*}"
  image="${service##*:}"
  run_maven "${ROOT_DIR}/${project}" package
  docker build -t "vyntra/${image}:${TAG}" "${ROOT_DIR}/${project}"
done
