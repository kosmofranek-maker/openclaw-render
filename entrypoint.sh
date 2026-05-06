#!/bin/sh
# No `set -e` — we want diagnostics even if individual commands fail.

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

echo "=== Generated openclaw.json (token redacted) ==="
sed 's/"botToken": *"[^"]*"/"botToken": "***REDACTED***"/' "${OPENCLAW_STATE_DIR}/openclaw.json"
echo "==============================================="
echo "RENDER_EXTERNAL_URL=${RENDER_EXTERNAL_URL}"

echo "=== openclaw --version ==="
openclaw --version 2>&1 || true
echo "=== openclaw --help ==="
openclaw --help 2>&1 | head -80 || true
echo "=== openclaw onboard --help ==="
openclaw onboard --help 2>&1 | head -60 || true

echo "=== Running onboard with auto-yes ==="
yes | openclaw onboard --mode local --no-install-daemon 2>&1 | head -100 || echo "(onboard exited non-zero, continuing)"

echo "=== Starting gateway in foreground on port ${OPENCLAW_GATEWAY_PORT} ==="
exec openclaw gateway --port "${OPENCLAW_GATEWAY_PORT}" --verbose
