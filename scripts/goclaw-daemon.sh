#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID_FILE="${ROOT_DIR}/.runtime/goclaw.pid"
LOG_FILE="${ROOT_DIR}/.runtime/goclaw.log"
RUNNER="${ROOT_DIR}/scripts/run-goclaw.sh"

mkdir -p "${ROOT_DIR}/.runtime"

is_running() {
  [[ -f "${PID_FILE}" ]] && kill -0 "$(cat "${PID_FILE}")" 2>/dev/null
}

start_gateway() {
  if is_running; then
    echo "goclaw already running pid=$(cat "${PID_FILE}")"
    return 0
  fi

  python3 - <<'PY' "${ROOT_DIR}" "${LOG_FILE}" "${PID_FILE}" "${RUNNER}"
import pathlib
import subprocess
import sys

root = pathlib.Path(sys.argv[1])
log_path = pathlib.Path(sys.argv[2])
pid_path = pathlib.Path(sys.argv[3])
runner = sys.argv[4]

log_path.parent.mkdir(parents=True, exist_ok=True)
with log_path.open("ab", buffering=0) as log_file:
    proc = subprocess.Popen(
        [runner],
        cwd=str(root),
        stdin=subprocess.DEVNULL,
        stdout=log_file,
        stderr=subprocess.STDOUT,
        start_new_session=True,
    )
    pid_path.write_text(str(proc.pid))
    print(proc.pid)
PY
}

stop_gateway() {
  if ! is_running; then
    rm -f "${PID_FILE}"
    echo "goclaw is not running"
    return 0
  fi

  local pid
  pid="$(cat "${PID_FILE}")"
  kill "${pid}"
  for _ in $(seq 1 20); do
    if ! kill -0 "${pid}" 2>/dev/null; then
      break
    fi
    sleep 0.5
  done

  if kill -0 "${pid}" 2>/dev/null; then
    kill -9 "${pid}"
  fi

  rm -f "${PID_FILE}"
  echo "stopped pid=${pid}"
}

status_gateway() {
  if is_running; then
    echo "goclaw running pid=$(cat "${PID_FILE}")"
  else
    echo "goclaw not running"
  fi
}

case "${1:-start}" in
  start)
    start_gateway
    ;;
  stop)
    stop_gateway
    ;;
  restart)
    stop_gateway || true
    start_gateway
    ;;
  status)
    status_gateway
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}" >&2
    exit 1
    ;;
esac
