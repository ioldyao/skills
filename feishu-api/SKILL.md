---
name: feishu-api
description: 向飞书用户发送消息、图片、文件的直接工具。当用户说"发给我"、"发送给我"、"推送给我"、"把这个图片发给我"等需要主动推送内容到飞书时使用。也用于上传图片/文件到飞书。文档读写用 feishu-doc，云盘管理用 feishu-drive。
---

# Feishu API Skill

直接向飞书用户发送内容的工具。

## 快速开始

用户要求"发给我"或"发送"时：

```bash
# 发送图片
scripts/feishu_send_image.sh /path/to/image.png ou_xxxxxxxxx

# 发送文本
scripts/feishu_send_text.sh "消息内容" ou_xxxxxxxxx
```

`ou_xxxxxxxxx` 是用户的 open_id，通常从消息上下文中获取。

## 辅助脚本

| 脚本 | 功能 | 用法 |
|------|------|------|
| `scripts/feishu_send_text.sh` | 发送文本消息 | `feishu_send_text.sh "文本" open_id` |
| `scripts/feishu_send_image.sh` | 发送图片 | `feishu_send_image.sh /path/to/image.png open_id` |
| `scripts/feishu_get_token.sh` | 获取 Access Token | 内部使用，脚本自动调用 |

## 使用场景

**用这个：**
- 用户说"发给我"、"发送给我"、"推送给我"
- 用户说"把这个图片发给我"
- 用户说"把结果发送到飞书"
- 任何需要主动向飞书用户推送内容的场景

**不用这个：**
- 文档读写 → 用 `feishu-doc`
- 云盘文件管理 → 用 `feishu-drive`

## 获取用户 open_id

在飞书对话中，用户的 open_id 通常在消息上下文中：
- `sender_id` 或 `sender.open_id`
- 格式通常是 `ou_` 开头

## 脚本细节

### feishu_send_image.sh

上传图片并发送消息：

```bash
scripts/feishu_send_image.sh /path/to/image.png ou_xxxxxxxxx
```

输出：
```
📤 Uploading image...
✅ Image uploaded: img_v3_02vp_xxx
📨 Sending image message...
✅ Image message sent: om_xxx
```

### feishu_send_text.sh

发送文本消息：

```bash
scripts/feishu_send_text.sh "Hello World" ou_xxxxxxxxx
```

### feishu_get_token.sh

获取飞书 API access token（内部使用）：

```bash
TOKEN=$(scripts/feishu_get_token.sh)
```

Token 自动缓存，有效期 2 小时。

## 直接 API 调用（高级用法）

如果脚本无法满足需求，可以直接调用 API：

```bash
TOKEN=$(scripts/feishu_get_token.sh)

# 发送文本
curl -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"receive_id":"ou_xxx","msg_type":"text","content":"{\"text\":\"Hello\"}"}'

# 上传图片
curl -X POST "https://${FEISHU_API_DOMAIN:-open.feishu.cn}/open-apis/im/v1/images" \
  -H "Authorization: Bearer ${TOKEN}" \
  -F "image_type=message" \
  -F "image=@/path/to/image.png"
```

注意：`content` 字段必须是 JSON 字符串，需要转义。

## 环境变量

- `FEISHU_API_DOMAIN`: API 域名，默认 `open.feishu.cn`
- `FEISHU_APP_ID`: 应用 ID
- `FEISHU_APP_SECRET`: 应用密钥

这些通常已配置，无需手动设置。

## 参考

详细配置和高级用法：
- **[配置说明](references/configuration.md)** — 凭证、域名、权限
- **[完整 API](references/api.md)** — 认证、消息类型、参数
- **[使用示例](references/examples.md)** — 常见场景、工作流
- **[错误处理](references/errors.md)** — 错误码、排查技巧
- **[交互式卡片](references/cards.md)** — 卡片结构、设计最佳实践
