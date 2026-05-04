# Flutter Environment Configuration

The HyperArena Flutter app uses compile-time `--dart-define` flags to switch between environments. The default values point to **production**, so a flagless `flutter run` is always safe — it cannot accidentally produce a localhost build.

## TL;DR

```bash
# Run against local dev backend (Laragon at hyperarena.local)
./scripts/run-local.sh        # Linux/macOS
./scripts/run-local.ps1       # Windows PowerShell

# Run against production VPS
./scripts/run-production.sh   # Linux/macOS
./scripts/run-production.ps1  # Windows PowerShell

# Release APK
./scripts/build-production.sh
```

VS Code users: pick **"Flutter (local)"** or **"Flutter (production)"** from the Run and Debug panel.

## Environment Variables

| `--dart-define` flag | `AppEnv` accessor | Local value | Production value | Default |
|---|---|---|---|---|
| `APP_ENV` | `AppEnv.name` | `local` | `production` | `production` |
| `API_BASE_URL` | `AppEnv.apiBaseUrl` | `http://hyperarena.local/api/v1` | `https://api.hyperarena.hyperscore.cloud/api/v1` | production URL |
| `DEFAULT_TENANT_SLUG` | `AppEnv.defaultTenantSlug` | `petenis-kelana` | `petenis-kelana` | `petenis-kelana` |

## Adding a New Environment Variable

To add a new env var (e.g. `FCM_SERVER_KEY`):

1. **Declare** in `lib/core/config/app_env.dart`:
   ```dart
   static const String fcmServerKey = String.fromEnvironment(
     'FCM_SERVER_KEY',
     defaultValue: '',
   );
   ```
2. **Add a unit test** in `test/core/config/app_env_test.dart` for the default value.
3. **Add the flag** to all four helper scripts (`scripts/run-local.{sh,ps1}` and `scripts/run-production.{sh,ps1}`) and `scripts/build-production.{sh,ps1}`.
4. **Add the flag** to both configurations in `.vscode/launch.json`.
5. **Add a row** to the table above.

## Troubleshooting

- **App is hitting production but I want local.** You ran `flutter run` directly without flags — production is the default. Use `./scripts/run-local.sh` instead.
- **`flutter test` reads the default values.** Pass flags during test if needed: `flutter test --dart-define=APP_ENV=local`.
- **CI builds need different values.** Pass `--dart-define` directly in the CI step; the scripts are for developers.
- **My provider override stopped working in tests.** The old pattern was `appConfigProvider.overrideWith(...)`. Now there is no `appConfigProvider` — override the specific provider you need (e.g. `authRepositoryProvider.overrideWithValue(MockAuthRepository())`).

## Why `--dart-define` and not `.env` files?

- **Compile-time const** → tree-shakeable by the Dart compiler, no runtime lookup cost.
- **No file IO at startup** → faster cold starts.
- **No accidental commits of secrets** → there is no `.env` file to forget about.
- **Production-safe defaults** → if a developer or CI step forgets to pass flags, the app still works correctly against production. A typo in a `.env` file or a missing file would crash the app.
