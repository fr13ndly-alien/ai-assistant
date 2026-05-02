#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"

if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
  set +a
fi

GOCLAW_BIN="${GOCLAW_BIN:-}"
if [[ -z "${GOCLAW_BIN}" ]]; then
  if command -v goclaw >/dev/null 2>&1; then
    GOCLAW_BIN="$(command -v goclaw)"
  elif [[ -x "${HOME}/go/bin/goclaw" ]]; then
    GOCLAW_BIN="${HOME}/go/bin/goclaw"
  else
    echo "goclaw binary not found. Install it first or set GOCLAW_BIN." >&2
    exit 1
  fi
fi

POSTGRES_USER="${POSTGRES_USER:-goclaw}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-}"
POSTGRES_DB="${POSTGRES_DB:-goclaw}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"

if [[ -z "${GOCLAW_POSTGRES_DSN:-}" ]]; then
  if [[ -z "${POSTGRES_PASSWORD}" ]]; then
    echo "POSTGRES_PASSWORD is required. Populate .env or export GOCLAW_POSTGRES_DSN." >&2
    exit 1
  fi
  export GOCLAW_POSTGRES_DSN="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"
fi

export GOCLAW_CONFIG="${GOCLAW_CONFIG:-${ROOT_DIR}/config.json}"
export GOCLAW_DATA_DIR="${GOCLAW_DATA_DIR:-${ROOT_DIR}/.runtime/data}"
export GOCLAW_WORKSPACE="${GOCLAW_WORKSPACE:-${ROOT_DIR}/.runtime/workspace}"

mkdir -p "${GOCLAW_DATA_DIR}" "${GOCLAW_WORKSPACE}"
"${ROOT_DIR}/scripts/sync-skills.sh"

exec "${GOCLAW_BIN}" --config "${GOCLAW_CONFIG}" "$@"
