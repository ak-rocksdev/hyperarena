#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
flutter run `
  --dart-define=APP_ENV=production `
  --dart-define=API_BASE_URL=https://api.hyperarena.hyperscore.cloud/api `
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana `
  @args
