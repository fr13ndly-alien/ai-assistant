#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"
EXAMPLE_FILE="${ROOT_DIR}/.env.example"

gen_hex() {
  openssl rand -hex "$1" 2>/dev/null || head -c "$1" /dev/urandom | xxd -p | tr -d '\n'
}

get_env_val() {
  local key="$1"
  if [[ -f "${ENV_FILE}" ]]; then
    grep -E "^${key}=" "${ENV_FILE}" 2>/dev/null | tail -1 | cut -d'=' -f2-
  fi
}

set_env_val() {
  local key="$1"
  local val="$2"

  if [[ ! -f "${ENV_FILE}" ]]; then
    printf "%s=%s\n" "${key}" "${val}" >>"${ENV_FILE}"
    return
  fi

  if grep -qE "^${key}=" "${ENV_FILE}" 2>/dev/null; then
    local current
    current="$(get_env_val "${key}")"
    if [[ -z "${current}" ]]; then
      if [[ "${OSTYPE:-}" == darwin* ]]; then
        sed -i '' "s|^${key}=.*|${key}=${val}|" "${ENV_FILE}"
      else
        sed -i "s|^${key}=.*|${key}=${val}|" "${ENV_FILE}"
      fi
    fi
  else
    printf "%s=%s\n" "${key}" "${val}" >>"${ENV_FILE}"
  fi
}

if [[ ! -f "${ENV_FILE}" ]]; then
  cp "${EXAMPLE_FILE}" "${ENV_FILE}"
  chmod 600 "${ENV_FILE}"
  echo "Created ${ENV_FILE} from .env.example"
else
  echo "Using existing ${ENV_FILE}"
fi

if [[ -z "$(get_env_val GOCLAW_GATEWAY_TOKEN)" ]]; then
  set_env_val "GOCLAW_GATEWAY_TOKEN" "$(gen_hex 16)"
  echo "Generated GOCLAW_GATEWAY_TOKEN"
fi

if [[ -z "$(get_env_val GOCLAW_ENCRYPTION_KEY)" ]]; then
  set_env_val "GOCLAW_ENCRYPTION_KEY" "$(gen_hex 32)"
  echo "Generated GOCLAW_ENCRYPTION_KEY"
fi

if [[ -z "$(get_env_val POSTGRES_PASSWORD)" ]]; then
  set_env_val "POSTGRES_PASSWORD" "$(gen_hex 16)"
  echo "Generated POSTGRES_PASSWORD"
fi

echo "Environment file is ready: ${ENV_FILE}"
