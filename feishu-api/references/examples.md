# Feishu API 使用示例

## 快速示例

### 发送文本消息

```bash
scripts/feishu_send_text.sh "Hello, World!" ou_xxxxxxxxx
```

### 发送图片

```bash
scripts/feishu_send_image.sh /path/to/image.png ou_xxxxxxxxx
```

### 发送富文本卡片

```bash
# 先构建卡片 JSON
CARD_JSON='{"config":{"wide_screen_mode":true},"elements":[{"tag":"div","text":{"content":"**Hello** from API","tag":"lark_md"}}]}'

# 发送
TOKEN=$(scripts/feishu_get_token.sh)
curl -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"receive_id\":\"ou_xxxxxxxxx\",\"msg_type\":\"interactive\",\"content\":'$(echo "$CARD_JSON" | jq -Rs .)'}"
```

## 常见场景

### 场景 1：发送带图片的通知

```bash
#!/bin/bash

RECEIVER="ou_xxxxxxxxx"
IMAGE_PATH="/path/to/screenshot.png"

# 上传图片
TOKEN=$(scripts/feishu_get_token.sh)
IMAGE_KEY=$(curl -s -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/images" \
  -H "Authorization: Bearer ${TOKEN}" \
  -F "image_type=message" \
  -F "image=@${IMAGE_PATH}" | jq -r '.data.image_key')

# 构建卡片
read -r -d '' CARD <<'EOF'
{
  "config": {
    "wide_screen_mode": true
  },
  "elements": [
    {
      "tag": "img",
      "img_key": "${IMAGE_KEY}",
      "alt": {
        "tag": "plain_text",
        "content": "图片"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "图片已生成",
        "tag": "lark_md"
      }
    }
  ]
}
EOF

# 替换图片 key
CARD=$(echo "$CARD" | sed "s/\${IMAGE_KEY}/${IMAGE_KEY}/")

# 发送
curl -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"receive_id\":\"${RECEIVER}\",\"msg_type\":\"interactive\",\"content\":'$(echo "$CARD" | jq -Rs .)'}"
```

### 场景 2：批量发送（带速率限制）

```bash
#!/bin/bash

RECEIVERS=("ou_xxx1" "ou_xxx2" "ou_xxx3")
MESSAGE="批量通知消息"
TOKEN=$(scripts/feishu_get_token.sh)

for receiver in "${RECEIVERS[@]}"; do
  curl -s -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/messages?receive_id_type=open_id" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"receive_id\":\"${receiver}\",\"msg_type\":\"text\",\"content\":\"{\\\"text\\\":\\\"${MESSAGE}\\\"}\"}"

  # 速率限制：每次发送间隔 1 秒
  sleep 1
done
```

### 场景 3：发送到群聊

```bash
CHAT_ID="oc_xxxxxxxxx"

curl -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/messages?receive_id_type=chat_id" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"receive_id\":\"${CHAT_ID}\",\"msg_type\":\"text\",\"content\":\"{\\\"text\\\":\\\"群消息\\\"}\"}"
```

### 场景 4：回复消息

```bash
MESSAGE_ID="om_xxxxxxxxx"

curl -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"receive_id\": \"ou_xxxxxxxxx\",
    \"msg_type\": \"text\",
    \"content\": \"{\\\"text\\\":\\\"回复\\\"}\",
    \"reply_in_message\": true
  }"
```

## 调试示例

### 查看完整响应

```bash
curl -v -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"receive_id":"ou_xxx","msg_type":"text","content":"{\"text\":\"test\"}"}' | jq '.'
```

### 测试 Token 有效性

```bash
TOKEN=$(scripts/feishu_get_token.sh)
curl -s "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Authorization: Bearer ${TOKEN}" | jq '.'
```

## 工作流示例

### 工作流：生成截图并发送

```bash
#!/bin/bash

# 1. 生成截图
SCROT_PATH="/tmp/screenshot_$(date +%s).png"
import "$SCROT_PATH"  # 或使用其他截图工具

# 2. 发送到 Feishu
scripts/feishu_send_image.sh "$SCROT_PATH" "ou_xxxxxxxxx"

# 3. 清理临时文件
rm "$SCROT_PATH"
```

### 工作流：定时报告

```bash
#!/bin/bash

# 每日报告脚本
REPORT_TEXT=$(generate_daily_report)  # 假设的报告生成函数
RECEIVER="ou_xxxxxxxxx"

scripts/feishu_send_text.sh "$REPORT_TEXT" "$RECEIVER"
```
