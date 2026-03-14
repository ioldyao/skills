#!/bin/bash
# Feishu Send Image Message
# Usage: scripts/feishu_send_image.sh /path/to/image.png "ou_xxxxxxxxx"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOKEN=$("$SCRIPT_DIR/feishu_get_token.sh")

IMAGE_PATH="${1:?❌ Error: Image path required}"
RECEIVER_ID="${2:?❌ Error: Receiver ID required}"
API_DOMAIN="${FEISHU_API_DOMAIN:-open.feishu.cn}"

if [[ ! -f "$IMAGE_PATH" ]]; then
    echo "❌ Error: File not found: $IMAGE_PATH" >&2
    exit 1
fi

# Upload image
echo "📤 Uploading image..."
UPLOAD_RESPONSE=$(curl -s -X POST "https://${API_DOMAIN}/open-apis/im/v1/images" \
    -H "Authorization: Bearer ${TOKEN}" \
    -F "image_type=message" \
    -F "image=@${IMAGE_PATH}")

UPLOAD_CODE=$(echo "$UPLOAD_RESPONSE" | jq -r '.code')

if [[ "$UPLOAD_CODE" != "0" ]]; then
    echo "❌ Error uploading image: $UPLOAD_RESPONSE" >&2
    exit 1
fi

IMAGE_KEY=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.image_key')
echo "✅ Image uploaded: ${IMAGE_KEY}"

# Send image message
echo "📨 Sending image message..."
SEND_RESPONSE=$(curl -s -X POST "https://${API_DOMAIN}/open-apis/im/v1/messages?receive_id_type=open_id" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
        \"receive_id\": \"${RECEIVER_ID}\",
        \"msg_type\": \"image\",
        \"content\": \"{\\\"image_key\\\":\\\"${IMAGE_KEY}\\\"}\"
    }")

SEND_CODE=$(echo "$SEND_RESPONSE" | jq -r '.code')

if [[ "$SEND_CODE" == "0" ]]; then
    MESSAGE_ID=$(echo "$SEND_RESPONSE" | jq -r '.data.message_id')
    echo "✅ Image message sent: ${MESSAGE_ID}"
else
    echo "❌ Error sending message: $SEND_RESPONSE" >&2
    exit 1
fi
