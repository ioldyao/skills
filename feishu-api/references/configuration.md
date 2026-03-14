# Feishu API 配置

## 凭证来源

Feishu API 凭证从 OpenClaw 配置文件自动读取：

```bash
/root/.openclaw/openclaw.json
```

## 配置结构

```json
{
  "channels": {
    "feishu": {
      "appId": "cli_xxxxxxxxx",
      "appSecret": "xxxxxxxxxxxxxxxxxxxx"
    }
  }
}
```

## 环境变量

可通过环境变量覆盖默认配置：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `FEISHU_API_DOMAIN` | API 域名 | `open.feishu.cn` |
| `FEISHU_APP_ID` | App ID（覆盖配置文件） | - |
| `FEISHU_APP_SECRET` | App Secret（覆盖配置文件） | - |

## 域名选择

### 国际域名

```bash
export FEISHU_API_DOMAIN="open.feishu.cn"
```

### 国内域名

```bash
export FEISHU_API_DOMAIN="open.feishu.cn"
```

**WSL2 注意事项**：如果 `open.feishu.com` 解析失败，使用国内域名 `open.feishu.cn`。

## Token 管理

### Token 有效期

Tenant Access Token 有效期：**7200 秒（2 小时）**

### 缓存策略

- 脚本自动缓存 Token 到临时文件
- 过期后自动重新获取
- 无需手动管理

### 手动获取 Token

```bash
scripts/feishu_get_token.sh
```

## 获取 App 凭证

1. 登录 [Feishu 开发者后台](https://open.feishu.cn/app)
2. 创建应用或选择现有应用
3. 在「凭证与基础信息」页面获取：
   - App ID
   - App Secret
4. 配置到 OpenClaw 的 `openclaw.json`

## 权限要求

应用需要以下权限才能发送消息：

| 权限 | 说明 |
|------|------|
| `im:message` | 发送消息权限 |
| `im:message:send_as_bot` | 以机器人身份发送 |
| `im:chat` | 访问群聊信息（如需发送到群） |

在开发者后台的「权限管理」中申请这些权限。
