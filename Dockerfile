FROM node:24-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@latest

ENV OPENCLAW_STATE_DIR=/data/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/data/workspace
ENV OPENCLAW_GATEWAY_PORT=10000
ENV OPENCLAW_LOG_LEVEL=debug

EXPOSE 10000

CMD ["sh", "-c", "mkdir -p ${OPENCLAW_STATE_DIR} ${OPENCLAW_WORKSPACE_DIR} && openclaw gateway --port ${OPENCLAW_GATEWAY_PORT} --verbose"]
