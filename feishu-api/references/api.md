# Feishu API 完整参考

## 基础信息

- **Base URL**: `https://open.feishu.cn`（国际）或 `https://open.feishu.cn`（国内）
- **认证方式**: Bearer Token（Tenant Access Token）
- **Token 有效期**: 7200 秒（2 小时）

## 认证

### 获取 Tenant Access Token

```bash
curl -X POST "https://${API_DOMAIN}/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d '{
    "app_id": "cli_xxxxxxxxx",
    "app_secret": "xxxxxxxxxxxxxxxxxxxx"
  }'
```

**响应：**
```json
{
  "code": 0,
  "tenant_access_token": "t-xxx...",
  "expire": 7200
}
```

## 消息类型

### 支持的消息类型

| msg_type | content 格式 | 说明 |
|----------|-------------|------|
| text | `{"text":"内容"}` | 纯文本 |
| image | `{"image_key":"img_xxx"}` | 图片 |
| post | `{"post":{...}}` | 富文本 |
| interactive | `{"config":{...},"elements":[...]}` | 交互式卡片 |
| card | `{"config":{...},"elements":[...]}` | 卡片（新版） |

### 发送消息

```bash
curl -X POST "https://${API_DOMAIN}/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer ${TENANT_ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "receive_id": "ou_xxxxxxxxx",
    "msg_type": "text",
    "content": "{\"text\":\"Hello\"}",
    "reply_in_message": false
  }'
```

**参数：**
- `receive_id_type`: `open_id` | `union_id` | `user_id` | `chat_id`
- `receive_id`: 接收者 ID
- `msg_type`: 消息类型
- `content`: JSON 字符串
- `reply_in_message`: 是否回复消息（布尔）

## 图片上传

### 上传图片

```bash
curl -X POST "https://${API_DOMAIN}/open-apis/im/v1/images" \
  -H "Authorization: Bearer ${TENANT_ACCESS_TOKEN}" \
  -F "image_type=message" \
  -F "image=@/path/to/image.png"
```

**参数：**
- `image_type`: 固定为 `message`
- `image`: 二进制文件数据

**响应：**
```json
{
  "code": 0,
  "data": {
    "image_key": "img_v3_02vp_..."
  }
}
```

### 图片格式限制

- 支持格式：PNG, JPG, JPEG, GIF, WEBP
- 大小限制：具体限制参考官方文档
- 建议：压缩后上传以提升速度

## 富文本消息 (post)

富文本消息结构复杂，建议参考官方文档：

https://open.feishu.cn/document/server-docs/im-v1/message/create_json

## 交互式卡片

交互式卡片允许添加按钮、表单等交互元素。详细参考 [cards.md](cards.md)。

## 接收 ID 类型

### open_id

推荐用于个人消息。格式：`ou_xxxxxxxxx`

### chat_id

用于群聊消息。格式：`oc_xxxxxxxxx`

### union_id

应用内唯一标识，跨应用不变。

### user_id

用户在应用内的唯一标识。

## 批量发送

目前 Feishu API 不支持批量发送。需要循环调用发送接口。

注意：批量发送时需要实现速率限制和重试机制。

## 参考链接

- **认证文档**: https://open.feishu.cn/document/server-docs/authentication-management/access-token
- **消息文档**: https://open.feishu.cn/document/server-docs/im-v1/message-list/send
- **图片上传**: https://open.feishu.cn/document/server-docs/im-v1/image/create
- **富文本**: https://open.feishu.cn/document/server-docs/im-v1/message/create_json
