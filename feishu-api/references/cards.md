# Feishu 交互式卡片

交互式卡片（Interactive Card）允许发送带有按钮、表单等交互元素的消息。

## 基础结构

```json
{
  "config": {
    "wide_screen_mode": true
  },
  "header": {
    "title": {
      "content": "卡片标题",
      "tag": "plain_text"
    }
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "卡片内容",
        "tag": "lark_md"
      }
    },
    {
      "tag": "action",
      "actions": [
        {
          "tag": "button",
          "text": {
            "content": "点击按钮",
            "tag": "plain_text"
          },
          "type": "primary",
          "url": "https://example.com"
        }
      ]
    }
  ]
}
```

## 发送卡片

```bash
curl -X POST "https://${API_DOMAIN}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TENANT_ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "receive_id": "ou_xxxxxxxxx",
    "msg_type": "interactive",
    "content": "{\"config\":{...},\"elements\": [...]}"
  }'
```

**注意：** `content` 必须是 JSON 字符串，需要转义引号。

## 卡片元素

### 文本元素

```json
{
  "tag": "div",
  "text": {
    "content": "**加粗** 和 [链接](https://example.com)",
    "tag": "lark_md"
  }
}
```

支持的 Markdown 语法：
- **加粗**
- *斜体*
- `代码`
- [链接](url)

### 按钮

```json
{
  "tag": "action",
  "actions": [
    {
      "tag": "button",
      "text": {
        "content": "主要按钮",
        "tag": "plain_text"
      },
      "type": "primary",
      "url": "https://example.com"
    },
    {
      "tag": "button",
      "text": {
        "content": "次要按钮",
        "tag": "plain_text"
      },
      "type": "default",
      "url": "https://example.com"
    }
  ]
}
```

按钮类型：
- `primary`: 主要按钮（蓝色）
- `default`: 默认按钮（灰色）
- `danger`: 危险按钮（红色）

### 图片

```json
{
  "tag": "img",
  "img_key": "img_v3_xxx",
  "alt": {
    "tag": "plain_text",
    "content": "图片描述"
  }
}
```

### 分割线

```json
{
  "tag": "hr"
}
```

## 完整示例

### 简单通知卡片

```json
{
  "config": {
    "wide_screen_mode": true
  },
  "header": {
    "title": {
      "content": "📢 系统通知",
      "tag": "plain_text"
    }
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "您的任务已完成！",
        "tag": "lark_md"
      }
    },
    {
      "tag": "hr"
    },
    {
      "tag": "action",
      "actions": [
        {
          "tag": "button",
          "text": {
            "content": "查看详情",
            "tag": "plain_text"
          },
          "type": "primary",
          "url": "https://example.com"
        }
      ]
    }
  ]
}
```

### 图片展示卡片

```json
{
  "config": {
    "wide_screen_mode": true
  },
  "elements": [
    {
      "tag": "img",
      "img_key": "img_v3_xxx",
      "alt": {
        "tag": "plain_text",
        "content": "生成的图片"
      }
    },
    {
      "tag": "div",
      "text": {
        "content": "这是 AI 生成的图片",
        "tag": "lark_md"
      }
    },
    {
      "tag": "action",
      "actions": [
        {
          "tag": "button",
          "text": {
            "content": "下载图片",
            "tag": "plain_text"
          },
          "type": "default",
          "url": "https://example.com/image.png"
        }
      ]
    }
  ]
}
```

## Bash 转义技巧

在 Bash 中发送卡片时，注意 JSON 转义：

```bash
#!/bin/bash

# 方法 1: 使用 heredoc
read -r -d '' CARD_CONTENT <<'EOF'
{
  "config": {
    "wide_screen_mode": true
  },
  "elements": [
    {
      "tag": "div",
      "text": {
        "content": "Hello",
        "tag": "lark_md"
      }
    }
  ]
}
EOF

# 转义为 JSON 字符串
CARD_JSON=$(echo "$CARD_CONTENT" | jq -Rs .)

# 发送
curl -X POST "https://${API_DOMAIN}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"receive_id\": \"${RECEIVER_ID}\",
    \"msg_type\": \"interactive\",
    \"content\": ${CARD_JSON}
  }"
```

## 卡片设计最佳实践

1. **保持简洁**：不要在一个卡片中放太多信息
2. **使用图片**：适当使用图片提升视觉效果
3. **明确行动**：按钮文案要清晰明确
4. **移动优先**：卡片在移动端显示，注意布局
5. **测试预览**：使用官方卡片预览工具测试

## 参考链接

- [卡片官方文档](https://open.feishu.cn/document/server-docs/im-v1/message-card/README)
- [卡片预览工具](https://open.feishu.cn/card-tool?lang=zh-CN)
- [卡片元素参考](https://open.feishu.cn/document/server-docs/im-v1/message-card/content-types/README)
