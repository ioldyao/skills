# Home Assistant 操作示例

常见的 Home Assistant 设备控制示例。

## 基础操作

### 查看所有设备

```bash
mcporter call home-assistant.ha_get_states
```

### 查询单个实体

```bash
mcporter call home-assistant.ha_get_state entity_id="weather.forecast_wo_de_jia"
```

### 打开开关

```bash
mcporter call home-assistant.ha_call_service \
  domain="switch" \
  service="turn_on" \
  entity_id="switch.cuco_cn_847875400_v3_on_p_2_1"
```

### 关闭开关

```bash
mcporter call home-assistant.ha_call_service \
  domain="switch" \
  service="turn_off" \
  entity_id="switch.cuco_cn_847875400_v3_on_p_2_1"
```

---

## 高级操作

### 设置灯光亮度

```bash
mcporter call home-assistant.ha_call_service \
  domain="light" \
  service="turn_on" \
  entity_id="light.living_room" \
  data='{"brightness": 200}'
```

### 设置灯光颜色

```bash
mcporter call home-assistant.ha_call_service \
  domain="light" \
  service="turn_on" \
  entity_id="light.living_room" \
  data='{"rgb_color": [255, 0, 0]}'
```

### 渐变开关灯光

```bash
mcporter call home-assistant.ha_call_service \
  domain="light" \
  service="turn_on" \
  entity_id="light.bedroom" \
  data='{"transition": 10}'
```

### 设置空调温度

```bash
mcporter call home-assistant.ha_call_service \
  domain="climate" \
  service="set_temperature" \
  entity_id="climate.ac" \
  data='{"temperature": 24}'
```

### 设置空调模式

```bash
mcporter call home-assistant.ha_call_service \
  domain="climate" \
  service="set_hvac_mode" \
  entity_id="climate.ac" \
  data='{"hvac_mode": "cool"}'
```

### 执行脚本

```bash
mcporter call home-assistant.ha_call_service \
  domain="script" \
  service="turn_on" \
  entity_id="script.good_night"
```

### 打开窗帘

```bash
mcporter call home-assistant.ha_call_service \
  domain="cover" \
  service="open_cover" \
  entity_id="cover.living_room_curtain"
```

---

## 批量操作

### 同时打开多个开关

```bash
mcporter call home-assistant.ha_call_service \
  domain="switch" \
  service="turn_on" \
  entity_id='["switch.light1", "switch.light2", "switch.light3"]'
```

### 查询多个实体

```bash
mcporter call home-assistant.ha_get_states \
  filter='{"entity_id": ["switch.light1", "switch.light2"]}'
```

---

## 参数格式

### data 参数格式

所有 `data` 参数必须是 JSON 字符串格式：

```bash
data='{"key": "value"}'
data='{"temperature": 24, "hvac_mode": "cool"}'
data='{"brightness": 200, "rgb_color": [255, 0, 0]}'
```

### entity_id 参数

- 单个实体: `entity_id="switch.xxx"`
- 多个实体: `entity_id='["switch.xxx", "switch.yyy"]'`
