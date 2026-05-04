#!/usr/bin/env bash
set -euo pipefail
flutter run \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.hyperarena.hyperscore.cloud/api/v1 \
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana \
  "$@"
