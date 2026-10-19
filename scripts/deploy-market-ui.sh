#!/usr/bin/env bash
# Builds the marketplace storefront at a given git commit and puts it live at market.learner-teach.online.
#
#   scripts/deploy-market-ui.sh <path-to-market-ui-checkout> [commit]     (default commit: HEAD)
#   scripts/deploy-market-ui.sh --rollback <release>                     (a folder name under releases/)
#
# Needs node/npm locally and SSH access to the VPS (key ~/.ssh/x-platform-vps).
set -euo pipefail

HOST=${MARKET_UI_HOST:-root@45.132.75.51}
KEY=${MARKET_UI_SSH_KEY:-$HOME/.ssh/x-platform-vps}
REMOTE=/srv/market-ui
MANIFEST="$(cd "$(dirname "$0")/.." && pwd)/k8s/market-ui.yaml"
ssh_vps() { ssh -i "$KEY" -o StrictHostKeyChecking=accept-new "$HOST" "$@"; }

if [ "${1:-}" = "--rollback" ]; then
  release=${2:?release name}
  ssh_vps "test -d $REMOTE/releases/$release && ln -sfn releases/$release $REMOTE/current && echo 'Now serving $release'"
  exit 0
fi

repo=${1:?path to the market-ui checkout}
commit=$(git -C "$repo" rev-parse --short "${2:-HEAD}")
work=$(mktemp -d)
trap 'git -C "$repo" worktree remove --force "$work/src" >/dev/null 2>&1 || true; rm -rf "$work"' EXIT

echo ">> Building market-ui $commit"
git -C "$repo" worktree add --detach "$work/src" "$commit" >/dev/null
(cd "$work/src" && npm ci --no-audit --no-fund && npm run build)
release="$commit-$(date +%Y%m%d%H%M%S)"

echo ">> Uploading release $release"
ssh_vps "mkdir -p $REMOTE/releases/$release"
tar -C "$work/src/dist" -cf - . | ssh_vps "tar -C $REMOTE/releases/$release -xf -"

echo ">> Switching market.learner-teach.online to $release"
ssh_vps "ln -sfn releases/$release $REMOTE/current && ls -1dt $REMOTE/releases/* | tail -n +6 | xargs -r rm -rf"
ssh_vps "kubectl apply -f -" < "$MANIFEST"
ssh_vps "kubectl -n x-platform rollout status deployment/market-ui --timeout=120s"
echo ">> Live: https://market.learner-teach.online ($release)"
