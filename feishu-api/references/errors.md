# Feishu API 错误处理

## 常见错误码

| code | message | 解决方案 |
|------|---------|---------|
| 0 | success | 成功 |
| 99991663 | app token invalid | App ID/Secret 错误 |
| 99991401 | access_token invalid | Token 过期，重新获取 |
| 99991400 | param invalid | 参数错误，检查请求格式 |
| 9999 | unknown | 未知错误，稍后重试 |

## 错误响应格式

```json
{
  "code": 99991401,
  "msg": "access_token invalid"
}
```

## 常见问题排查

### 1. Token 过期

**现象：** 返回 `code: 99991401`

**解决：** 重新获取 Tenant Access Token

```bash
TOKEN=$(curl -s ... | jq -r '.tenant_access_token')
```

### 2. content 格式错误

**现象：** 返回 `"content" format error`

**原因：** content 必须是 JSON 字符串，不是 JSON 对象

```bash
# ❌ 错误
-d '{"content":{"text":"hello"}}'

# ✅ 正确
-d '{"content":"{\"text\":\"hello\"}"}'
```

### 3. 域名解析失败（WSL2）

**现象：** `curl: (6) Could not resolve host`

**解决：** 使用国内域名

```bash
export FEISHU_API_DOMAIN="open.feishu.cn"
```

### 4. 速率限制

**现象：** 返回 `code: 9999` 或频繁失败

**解决：** 实现指数退避重试

```bash
# 伪代码
for retry in {1..3}; do
  response=$(curl -s ...)
  code=$(echo "$response" | jq -r '.code')

  if [ "$code" = "0" ]; then
    break
  elif [ "$code" = "9999" ]; then
    sleep $((2 ** retry))
  else
    break
  fi
done
```

### 5. 图片上传失败

**可能原因：**
- 文件过大 → 压缩后重试
- 格式不支持 → 转换为 PNG/JPG
- Token 过期 → 重新获取

### 6. 接收者 ID 错误

**现象：** `code: 99991400`，消息未发送

**排查：**
- 确认 `receive_id_type` 正确（open_id / chat_id）
- 确认 `receive_id` 格式正确
- 确认机器人有权限发送到该接收者

## 错误处理最佳实践

```bash
#!/bin/bash

send_message() {
  local content="$1"
  local receiver="$2"

  response=$(curl -s -X POST "https://${API_DOMAIN}/open-apis/im/v1/messages?receive_id_type=open_id" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"receive_id\":\"${receiver}\",\"msg_type\":\"text\",\"content\":\"{\\\"text\\\":\\\"${content}\\\"}\"}")

  code=$(echo "$response" | jq -r '.code')

  case $code in
    0)
      echo "✅ 消息发送成功"
      ;;
    99991401)
      echo "❌ Token 过期，请重新获取"
      exit 1
      ;;
    99991400)
      echo "❌ 参数错误: $response"
      exit 1
      ;;
    9999)
      echo "⚠️  速率限制，稍后重试"
      sleep 2
      send_message "$content" "$receiver"
      ;;
    *)
      echo "❓ 未知错误: $response"
      exit 1
      ;;
  esac
}
```

## 调试技巧

### 启用 curl 详细输出

```bash
curl -v ...
```

### 查看完整响应

```bash
curl -s ... | jq '.'
```

### 检查 Token 有效期

```bash
# 获取 token 时记录时间戳
TOKEN_TIME=$(date +%s)
TOKEN_EXPIRE=7200

# 使用前检查
if [ $(($(date +%s) - TOKEN_TIME)) -gt $TOKEN_EXPIRE ]; then
  echo "Token 已过期，重新获取"
fi
```

## 联系支持

如果遇到无法解决的问题：

1. 检查 [官方文档](https://open.feishu.cn/document/server-docs)
2. 查看开发者社区
3. 提交工单（Feishu 开发者后台）
