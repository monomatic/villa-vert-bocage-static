#!/usr/bin/env bash
# Create a Cloudflare Pages project via API (no Git link — connect the repo in the dashboard once).
#
# Prerequisites:
#   1. Create an API token at https://dash.cloudflare.com/profile/api-tokens
#      with permission: Account → Cloudflare Pages → Edit (and read Account ID).
#   2. Export:
#        export CLOUDFLARE_API_TOKEN='...'
#        export CLOUDFLARE_ACCOUNT_ID='...'   # Workers & Pages overview sidebar, or API.
#
# Usage:
#   ./scripts/create-cloudflare-pages-project.sh
#
# Optional overrides:
#   CF_PAGES_PROJECT_NAME   default: villa-vert-bocage-static
#   CF_PAGES_BRANCH         default: main
#
set -euo pipefail

TOKEN="${CLOUDFLARE_API_TOKEN:?Set CLOUDFLARE_API_TOKEN (see script header)}"
ACCOUNT="${CLOUDFLARE_ACCOUNT_ID:?Set CLOUDFLARE_ACCOUNT_ID (see script header)}"
NAME="${CF_PAGES_PROJECT_NAME:-villa-vert-bocage-static}"
BRANCH="${CF_PAGES_BRANCH:-main}"

BODY="$(NAME="$NAME" BRANCH="$BRANCH" node -e "
console.log(JSON.stringify({
  name: process.env.NAME,
  production_branch: process.env.BRANCH,
  build_config: {
    build_command: 'npm run build',
    destination_dir: 'dist',
    root_dir: ''
  }
}))
")"

RESP="$(curl -sS "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT}/pages/projects" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$BODY")"

echo "$RESP" | node -e "
const j = JSON.parse(require('fs').readFileSync(0,'utf8'));
if (!j.success) {
  console.error(JSON.stringify(j, null, 2));
  process.exit(1);
}
console.log('Created Pages project:', j.result?.name || j.result);
console.log('Subdomain (example):', j.result?.subdomain ? j.result.subdomain + '.pages.dev' : '(see dashboard)');
"

echo ""
echo "Next steps:"
echo "  1. Dashboard → Workers & Pages → $NAME → Connect to Git"
echo "  2. Choose GitHub → monomatic/villa-vert-bocage-static → branch $BRANCH"
echo "  3. Build settings should match: npm run build, output dist (already in API payload)."
echo "  4. Add env NODE_VERSION=20 if the build image needs it."
