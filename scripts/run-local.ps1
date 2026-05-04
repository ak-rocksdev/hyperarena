#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
flutter run `
  --dart-define=APP_ENV=local `
  --dart-define=API_BASE_URL=http://hyperarena.local/api `
  --dart-define=DEFAULT_TENANT_SLUG=petenis-kelana `
  @args
