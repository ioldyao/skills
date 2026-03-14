#!/bin/bash
# Feishu Send Text Message
# Usage: scripts/feishu_send_text.sh "Your message" "ou_xxxxxxxxx"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOKEN=$("$SCRIPT_DIR/feishu_get_token.sh")

TEXT="${1:?❌ Error: Text message required}"
RECEIVER_ID="${2:?❌ Error: Receiver ID required}"
API_DOMAIN="${FEISHU_API_DOMAIN:-open.feishu.cn}"

# Escape text for JSON
ESCAPED_TEXT=$(echo "$TEXT" | jq -Rs .)

RESPONSE=$(curl -s -X POST "https://${API_DOMAIN}/open-apis/im/v1/messages?receive_id_type=open_id" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
        \"receive_id\": \"${RECEIVER_ID}\",
        \"msg_type\": \"text\",
        \"content\": \"{\\\"text\\\":${ESCAPED_TEXT}}\"
    }")

CODE=$(echo "$RESPONSE" | jq -r '.code')

if [[ "$CODE" == "0" ]]; then
    echo "✅ Text message sent successfully"
else
    echo "❌ Error sending message: $RESPONSE" >&2
    exit 1
fi
