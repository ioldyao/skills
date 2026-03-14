# Home Assistant MCP 故障排查

常见问题及解决方案。

## 连接问题

### MCP 服务器无响应

**症状**: 调用 `mcporter call home-assistant.xxx` 无响应或超时

**排查步骤**:

1. **检查 Home Assistant 是否运行**:
   ```bash
   curl http://127.0.0.1:8123/api/
   ```

2. **检查 MCP 配置**:
   ```bash
   cat ~/.config/mcporter/servers.json
   ```

3. **查看 MCP 日志**:
   ```bash
   mcporter logs home-assistant
   ```

---

## 认证问题

### 401 Unauthorized

**症状**: 返回 `401 Unauthorized` 错误

**原因**: HA_TOKEN 无效或过期

**解决方案**:

1. **生成新 Token**:
   - Home Assistant 界面 → 用户设置 → 底部 → 长期访问令牌 → 创建令牌

2. **更新环境变量**:
   ```bash
   export HA_TOKEN="你的新Token"
   ```

3. **重启 MCP 服务**:
   ```bash
   mcporter restart home-assistant
   ```

---

## 实体问题

### 404 Not Found

**症状**: 调用服务时返回 `404 Not Found`

**原因**: entity_id 不存在

**解决方案**:

1. **列出所有可用实体**:
   ```bash
   mcporter call home-assistant.ha_get_states
   ```

2. **检查 entity_id 拼写**

3. **确认实体未被删除或禁用**

---

### Entity 状态 unavailable

**症状**: 实体存在但状态为 `unavailable`

**原因**: 设备离线、网络断开、或集成配置错误

**解决方案**:

1. **检查设备电源和网络**
2. **重启 Home Assistant**:
   ```bash
   # HA 界面 → 设置 → 系统 → 主机 → 重启
   ```
3. **检查集成配置**:
   - HA 界面 → 设置 → 设备与服务 → 选择集成 → 重新配置

---

## 服务调用问题

### 400 Bad Request

**症状**: 调用服务时返回 `400 Bad Request`

**原因**:
- Domain 和 service 不匹配
- 参数格式错误
- Entity 不支持该服务

**解决方案**:

1. **检查 domain/service 是否正确**:
   ```bash
   mcporter call home-assistant.ha_get_services
   ```

2. **确认参数格式**:
   ```bash
   # 错误
   data='temperature: 24'

   # 正确（JSON 字符串）
   data='{"temperature": 24}'
   ```

3. **检查 entity 是否支持该服务**:
   - 传感器（sensor）不支持任何服务
   - 二进制传感器（binary_sensor）不支持任何服务
   - 天气（weather）不支持任何服务

---

## 常见错误信息

| 错误 | 原因 | 解决方案 |
|------|------|----------|
| `401 Unauthorized` | Token 无效 | 更新 HA_TOKEN |
| `404 Not Found` | Entity 不存在 | 检查 entity_id |
| `400 Bad Request` | 参数错误 | 检查 data 格式 |
| `timeout` | HA 无响应 | 检查 HA 服务状态 |
| `connection refused` | MCP 服务未启动 | `mcporter start home-assistant` |

---

## 调试技巧

### 直接调用 HA API

绕过 MCP 直接测试 HA API：

```bash
# 获取所有状态
curl http://127.0.0.1:8123/api/states \
  -H "Authorization: Bearer $HA_TOKEN"

# 调用服务
curl -X POST http://127.0.0.1:8123/api/services/switch/turn_on \
  -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.xxx"}'
```

### 查看 HA 日志

Home Assistant 界面：
- 设置 → 系统 → 日志
- 查看错误信息和警告

### 重启相关服务

```bash
# 重启 MCP 服务
mcporter restart home-assistant

# 重启 Home Assistant
# 通过 HA 界面：设置 → 系统 → 主机 → 重启
```
