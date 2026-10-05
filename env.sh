#!/bin/sh
# Generate runtime environment config for the React app.
# This script runs at container startup (via /docker-entrypoint.d/)
# and writes a JS file that exposes env vars to the browser.
#
# ⚠️ WARNING: All values here are PUBLIC and visible in the browser.
# Do NOT add API secrets, tokens, or credentials as VITE_* env vars.
#
# How it works:
#   1. Reads APP_ENV (set via Helm, e.g. "dev", "stage")
#   2. Sources /app/config/.env.${APP_ENV} to load VITE_* vars
#   3. Auto-discovers all VITE_* env vars and writes env-config.js
#
# Developers: update .env.dev / .env.stage in the UI repo.
# DevOps: only set APP_ENV in Helm values.

ENV_NAME="${APP_ENV:-dev}"
ENV_FILE="/app/config/.env.${ENV_NAME}"

if [ -f "$ENV_FILE" ]; then
  echo "📄 Loading env from: $ENV_FILE"
  set -a
  . "$ENV_FILE"
  set +a
else
  echo "⚠️ Env file not found: $ENV_FILE — using existing env vars"
fi

# Generate env-config.js from all VITE_* environment variables
OUTPUT="/usr/share/nginx/html/env-config.js"

echo "window.__ENV__ = {" > "$OUTPUT"

env | grep '^VITE_' | sort | while IFS='=' read -r key value; do
  echo "  ${key}: \"${value}\"," >> "$OUTPUT"
done

echo "};" >> "$OUTPUT"
echo "✅ Generated $OUTPUT with APP_ENV=${ENV_NAME}"
