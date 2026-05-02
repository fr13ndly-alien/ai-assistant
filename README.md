# AI Assistant Playground

Local-first GoClaw playground for a Telegram AI assistant. This MVP runs the `goclaw` gateway on the host Mac and uses Docker for external services only.

## MVP Scope

- Telegram private DM assistant
- Web research with sources
- Always-on skills for research behavior

Out of scope for v1:

- Calendar integration
- Group chats
- Browser automation
- Cron, reminders, and multi-agent delegation

## Runtime Layout

- Host process: `goclaw`
- Docker services:
  - `postgres` using `pgvector/pgvector:pg18`
- Project-owned config: `config.json`
- Repo-owned skills: `skills/`
- Local runtime state: `.runtime/`

The Google Calendar sidecar is still in the repo as an optional `calendar` Docker profile, but it is disabled by default and not wired into GoClaw.

Docker is the default pattern for external dependencies in this repo. Do not add host-installed Postgres or host-run MCP sidecars for new integrations.

## Setup

1. Create `.env` and generate local secrets:

   ```bash
   bash scripts/prepare-env.sh
   ```

2. Fill in these required values in `.env`:
   - `GOCLAW_OPENAI_API_KEY`
   - `GOCLAW_TELEGRAM_TOKEN`

3. Start external services:

   ```bash
   docker compose up -d
   ```

4. Check the GoClaw runtime wiring:

   ```bash
   scripts/run-goclaw.sh doctor
   ```

5. Start the gateway:

   ```bash
   scripts/run-goclaw.sh
   ```

The gateway listens on `127.0.0.1:18790`.

## Project Commands

Sync repo skills into the local GoClaw workspace:

```bash
scripts/sync-skills.sh
```

Run any GoClaw command through the project wrapper:

```bash
scripts/run-goclaw.sh doctor
scripts/run-goclaw.sh sessions --help
scripts/run-goclaw.sh
```

Manage the detached gateway process:

```bash
scripts/goclaw-daemon.sh start
scripts/goclaw-daemon.sh status
scripts/goclaw-daemon.sh restart
scripts/goclaw-daemon.sh stop
```

Stop external services:

```bash
docker compose down
```

If you ever want to bring the optional calendar sidecar back:

```bash
docker compose --profile calendar up -d
```

## Assistant Behavior

- Telegram is configured for private DMs only.
- The assistant can use:
  - `web_search`
  - `web_fetch`
  - `datetime`

## Notes

- Keep secrets in `.env`; it is intentionally ignored by Git.
