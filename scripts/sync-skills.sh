#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="${ROOT_DIR}/skills"
WORKSPACE_DIR="${GOCLAW_WORKSPACE:-${ROOT_DIR}/.runtime/workspace}"
TARGET_DIR="${WORKSPACE_DIR}/skills"

rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"
cp -R "${SOURCE_DIR}/." "${TARGET_DIR}/"

echo "Synced skills into ${TARGET_DIR}"
