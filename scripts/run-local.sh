#!/usr/bin/env bash
set -euo pipefail
flutter run \
  --dart-define=APP_ENV=local \
  --dart-define=API_BASE_URL=http://hypercoach.test/api \
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana \
  "$@"
