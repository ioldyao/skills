#!/bin/bash
# Feishu API Token Helper
# Usage: scripts/feishu_get_token.sh

set -euo pipefail

# Load config
CONFIG_FILE="/root/.openclaw/openclaw.json"
API_DOMAIN="${FEISHU_API_DOMAIN:-open.feishu.cn}"

# Read credentials from config
APP_ID=$(jq -r '.channels.feishu.appId // .channels.feishu.app_id // empty' "$CONFIG_FILE")
APP_SECRET=$(jq -r '.channels.feishu.appSecret // .channels.feishu.app_secret // empty' "$CONFIG_FILE")

if [[ -z "$APP_ID" || -z "$APP_SECRET" ]]; then
    echo "❌ Error: Feishu credentials not found in $CONFIG_FILE" >&2
    exit 1
fi

# Get token
RESPONSE=$(curl -s -X POST "https://${API_DOMAIN}/open-apis/auth/v3/tenant_access_token/internal" \
    -H "Content-Type: application/json" \
    -d "{\"app_id\":\"${APP_ID}\",\"app_secret\":\"${APP_SECRET}\"}")

CODE=$(echo "$RESPONSE" | jq -r '.code')

if [[ "$CODE" != "0" ]]; then
    echo "❌ Error getting token: $RESPONSE" >&2
    exit 1
fi

TOKEN=$(echo "$RESPONSE" | jq -r '.tenant_access_token')
echo "$TOKEN"
