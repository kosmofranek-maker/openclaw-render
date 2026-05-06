#!/bin/sh
# No `set -e` — we want diagnostics even if individual commands fail.

mkdir -p "${OPENCLAW_STATE_DIR}" "${OPENCLAW_WORKSPACE_DIR}"

if [ -f /app/SOUL.md ]; then
  cp /app/SOUL.md "${OPENCLAW_WORKSPACE_DIR}/SOUL.md"
fi

cat > "${OPENCLAW_STATE_DIR}/openclaw.json" <<EOF
{
  "gateway": {
    "mode": "local",
    "bind": "lan",
    "port": ${OPENCLAW_GATEWAY_PORT}
  },
  "agents": {
    "defaults": {
      "model": { "primary": "groq/llama-3.3-70b-versatile" },
      "workspace": "${OPENCLAW_WORKSPACE_DIR}"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_BOT_TOKEN}"
    }
  }
}
EOF

echo "=== Generated openclaw.json (secrets redacted) ==="
sed -e 's/"botToken": *"[^"]*"/"botToken": "***REDACTED***"/' \
    "${OPENCLAW_STATE_DIR}/openclaw.json"
echo "=================================================="
echo "RENDER_EXTERNAL_URL=${RENDER_EXTERNAL_URL}"

echo "=== openclaw --version ==="
openclaw --version 2>&1 || true

echo "=== openclaw gateway --help ==="
openclaw gateway --help 2>&1 | head -60 || true

echo "=== openclaw daemon --help ==="
openclaw daemon --help 2>&1 | head -40 || true

echo "=== Starting gateway in foreground on port ${OPENCLAW_GATEWAY_PORT} (bind=lan) ==="
exec openclaw gateway run --port "${OPENCLAW_GATEWAY_PORT}" --bind lan --verbose
