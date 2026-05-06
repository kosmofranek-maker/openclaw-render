#!/bin/sh
set -e

mkdir -p "${OPENCLAW_STATE_DIR}" "${OPENCLAW_WORKSPACE_DIR}"

if [ -f /app/SOUL.md ]; then
  cp /app/SOUL.md "${OPENCLAW_WORKSPACE_DIR}/SOUL.md"
fi

cat > "${OPENCLAW_STATE_DIR}/openclaw.json" <<EOF
{
  "agents": {
    "defaults": {
      "model": { "primary": "groq/llama-3.3-70b-versatile" },
      "workspace": "${OPENCLAW_WORKSPACE_DIR}"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_BOT_TOKEN}",
      "webhookUrl": "${RENDER_EXTERNAL_URL}/telegram-webhook",
      "webhookPath": "/telegram-webhook",
      "webhookHost": "0.0.0.0",
      "webhookPort": ${OPENCLAW_GATEWAY_PORT}
    }
  }
}
EOF

echo "=== Generated openclaw.json ==="
cat "${OPENCLAW_STATE_DIR}/openclaw.json"
echo "==============================="
echo "RENDER_EXTERNAL_URL=${RENDER_EXTERNAL_URL}"
echo "Starting gateway on port ${OPENCLAW_GATEWAY_PORT}..."

exec openclaw gateway --port "${OPENCLAW_GATEWAY_PORT}" --verbose
