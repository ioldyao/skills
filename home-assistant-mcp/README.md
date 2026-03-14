# Home Assistant MCP Server

这是一个简单的 Home Assistant MCP Server，使用 Home Assistant 的 REST API。

## 功能

- `ha_get_states` - 获取所有实体的当前状态
- `ha_get_state` - 获取单个实体的状态
- `ha_call_service` - 调用 Home Assistant 服务
- `ha_get_services` - 获取所有可用服务

## 配置

已通过 mcporter 配置：
```bash
HA_URL=http://127.0.0.1:8123
HA_TOKEN=eyJhbGc...（你的 Bearer Token）
```

## 使用示例

### 获取所有状态
```bash
mcporter call home-assistant.ha_get_states
```

### 获取单个实体
```bash
mcporter call home-assistant.ha_get_state entity_id="weather.forecast_wo_de_jia"
```

### 调用服务（例如：打开开关）
```bash
mcporter call home-assistant.ha_call_service domain="switch" service="turn_on" entity_id="switch.cuco_cn_847875400_v3_on_p_2_1"
```

### 调用服务（例如：关闭开关）
```bash
mcporter call home-assistant.ha_call_service domain="switch" service="turn_off" entity_id="switch.cuco_cn_847875400_v3_on_p_2_1"
```

## 文件位置

- MCP Server: `/root/.openclaw/workspace/skills/home-assistant-mcp/index.js`
- 配置文件: `/root/.openclaw/workspace/config/mcporter.json`
