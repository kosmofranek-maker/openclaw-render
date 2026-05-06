FROM node:24-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw

COPY SOUL.md /app/SOUL.md

ENV PORT=10000
EXPOSE 10000

CMD ["sh", "-c", "openclaw gateway --port ${PORT} --verbose"]
