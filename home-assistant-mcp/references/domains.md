# Home Assistant Domain 参考手册

完整 Home Assistant Domain 和服务列表。

## 常用 Domain

### Switch（开关设备）

**Domain**: `switch`

**常用服务**:
- `turn_on` - 打开设备
- `turn_off` - 关闭设备
- `toggle` - 切换状态

**示例**:
```bash
mcporter call home-assistant.ha_call_service domain="switch" service="turn_on" entity_id="switch.cuco_cn_847875400_v3_on_p_2_1"
```

---

### Light（灯光）

**Domain**: `light`

**常用服务**:
- `turn_on` - 打开灯光
- `turn_off` - 关闭灯光
- `toggle` - 切换状态

**支持的参数**:
- `brightness` (0-255) - 亮度
- `color_name` - 颜色名称（如 "red", "blue"）
- `rgb_color` - RGB 颜色数组 [r, g, b]
- `transition` - 渐变时间（秒）

---

### Cover（窗帘/卷帘）

**Domain**: `cover`

**常用服务**:
- `open_cover` - 打开
- `close_cover` - 关闭
- `stop_cover` - 停止
- `toggle` - 切换

---

### Climate（暖通空调）

**Domain**: `climate`

**常用服务**:
- `set_temperature` - 设置目标温度
- `set_hvac_mode` - 设置模式（heat/cool/off/auto）
- `set_fan_mode` - 设置风扇模式

---

### Script（脚本）

**Domain**: `script`

**常用服务**:
- `turn_on` - 执行脚本
- `reload` - 重新加载脚本

---

## 只读 Domain（无服务）

这些 Domain 只能查询，不能控制：

| Domain | 描述 |
|--------|------|
| `sensor` | 数值传感器（温度、湿度等） |
| `binary_sensor` | 二进制传感器（门窗、运动等） |
| `weather` | 天气预报 |
| `zone` | 区域 |
| `group` | 设备组 |

---

## 完整 Domain 列表

获取所有可用服务：

```bash
mcporter call home-assistant.ha_get_services
```

这将返回完整的 domain 列表及其支持的服务。
