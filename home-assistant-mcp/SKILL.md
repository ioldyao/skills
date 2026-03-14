---
name: home-assistant-mcp
description: Control Home Assistant devices via MCP server. Use when user asks to query or control smart home devices, check sensor status, automate home tasks, or mentions Home Assistant/HA/smart home/lighting/switches/sensors/weather.
---

# Home Assistant 智能家居控制

通过 MCP Server 控制 Home Assistant 智能家居设备。

## 快速开始

**获取所有设备状态：**
```bash
mcporter call home-assistant.ha_get_states
```

**控制设备：**
```bash
# 打开
mcporter call home-assistant.ha_call_service domain="switch" service="turn_on" entity_id="switch.xxx"

# 关闭
mcporter call home-assistant.ha_call_service domain="switch" service="turn_off" entity_id="switch.xxx"
```

## 工作流程

1. **查询设备** - 调用 `ha_get_states` 获取所有实体
2. **识别目标** - 根据用户输入筛选 entity_id
3. **执行操作** - 调用 `ha_call_service` 控制设备

## Domain 与服务

不同设备类型使用不同的 domain 和服务：

| Domain | 设备类型 | 常用服务 |
|--------|----------|----------|
| `switch` | 开关 | `turn_on`, `turn_off`, `toggle` |
| `light` | 灯光 | `turn_on`, `turn_off`, `toggle` |
| `sensor` | 传感器 | 只读，无服务 |
| `weather` | 天气 | 只读，无服务 |

**完整 Domain 参考**: 见 [references/domains.md](references/domains.md)

## Entity ID 命名规则

格式：`{domain}.{friendly_name}`

示例：
- `switch.cuco_cn_847875400_v3_on_p_2_1`
- `sensor.temperature_2`
- `weather.forecast_wo_de_jia`

## 更多示例

- **带参数的服务调用**: [references/examples.md](references/examples.md)
- **故障排查**: [references/troubleshooting.md](references/troubleshooting.md)
