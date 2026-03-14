#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// 从环境变量获取配置
const HA_URL = process.env.HA_URL || 'http://127.0.0.1:8123';
const HA_TOKEN = process.env.HA_TOKEN;

if (!HA_TOKEN) {
  console.error('Error: HA_TOKEN environment variable is required');
  process.exit(1);
}

// 创建 MCP Server
const server = new Server(
  {
    name: 'home-assistant-mcp-local',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// 注册工具列表
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'ha_get_states',
        description: '获取所有 Home Assistant 实体的当前状态',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'ha_get_state',
        description: '获取单个 Home Assistant 实体的状态',
        inputSchema: {
          type: 'object',
          properties: {
            entity_id: {
              type: 'string',
              description: '实体 ID (例如: switch.living_room_light)',
            },
          },
          required: ['entity_id'],
        },
      },
      {
        name: 'ha_call_service',
        description: '调用 Home Assistant 服务 (例如: 开关灯、启动脚本等)',
        inputSchema: {
          type: 'object',
          properties: {
            domain: {
              type: 'string',
              description: '服务域 (例如: switch, light, script)',
            },
            service: {
              type: 'string',
              description: '服务名称 (例如: turn_on, turn_on)',
            },
            entity_id: {
              type: 'string',
              description: '实体 ID (可选，某些服务需要)',
            },
            data: {
              type: 'object',
              description: '服务数据 (可选)',
            },
          },
          required: ['domain', 'service'],
        },
      },
      {
        name: 'ha_get_services',
        description: '获取所有可用的 Home Assistant 服务',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
    ],
  };
});

// 工具执行处理
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'ha_get_states': {
        const response = await fetch(`${HA_URL}/api/states`, {
          headers: {
            'Authorization': `Bearer ${HA_TOKEN}`,
            'Content-Type': 'application/json',
          },
        });
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(data, null, 2),
            },
          ],
        };
      }

      case 'ha_get_state': {
        const { entity_id } = args;
        const response = await fetch(`${HA_URL}/api/states/${entity_id}`, {
          headers: {
            'Authorization': `Bearer ${HA_TOKEN}`,
            'Content-Type': 'application/json',
          },
        });
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(data, null, 2),
            },
          ],
        };
      }

      case 'ha_call_service': {
        const { domain, service, entity_id, data = {} } = args;
        
        const body = entity_id 
          ? { entity_id, ...data }
          : data;
        
        const response = await fetch(`${HA_URL}/api/services/${domain}/${service}`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${HA_TOKEN}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(body),
        });
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const result = await response.json();
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(result, null, 2),
            },
          ],
        };
      }

      case 'ha_get_services': {
        const response = await fetch(`${HA_URL}/api/services`, {
          headers: {
            'Authorization': `Bearer ${HA_TOKEN}`,
            'Content-Type': 'application/json',
          },
        });
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(data, null, 2),
            },
          ],
        };
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({
            error: error.message,
          }),
        },
      ],
      isError: true,
    };
  }
});

// 启动服务器
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Home Assistant MCP Server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
