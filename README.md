# OpenClaw on Render

Personal AI agent (OpenClaw) deployed to Render free tier with Groq LLM and Telegram messaging.

## Stack
- **Hosting**: Render free tier (Web Service, Docker)
- **LLM**: Groq (Llama 3.3 70B)
- **Messenger**: Telegram bot

## Required env vars on Render
- `GROQ_API_KEY` — from console.groq.com
- `TELEGRAM_BOT_TOKEN` — from @BotFather

## Keeping the service awake
Free tier sleeps after 15 min idle. Use UptimeRobot to ping `/` every 5 minutes.
