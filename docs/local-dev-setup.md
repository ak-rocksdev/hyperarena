# Local Development Setup (Flutter + Laravel Backend)

This guide covers running the Flutter app against your local Laravel backend (instead of the production VPS). For the env-config system itself, see [flutter-environment.md](flutter-environment.md).

## Prerequisites

- **Laragon** installed at `C:\laragon\` with Apache + MySQL
- Laravel backend at `C:\laragon\www\hypercoach`
- Flutter app at `D:\projects\Flutter\hyperarena`
- Physical Android device on the **same WiFi network** as your PC

## Step 1: Find Your PC's LAN IP

```bash
ipconfig
```

Look for the `IPv4 Address` under your active Wi-Fi or Ethernet adapter (e.g., `192.168.1.6`).

> **Note:** This IP can change when you switch networks. Re-check it if connections start failing.

## Step 2: Update Laravel `APP_URL`

Edit `C:\laragon\www\hypercoach\.env`:

```
APP_URL=http://<YOUR_LAN_IP>:8080
```

This ensures image/asset URLs returned by the API are accessible from your device (not `localhost`).

## Step 3: Start the Laravel Backend

```bash
cd C:\laragon\www\hypercoach
php artisan serve --host=0.0.0.0 --port=8080
```

- `--host=0.0.0.0` makes it accept connections from other devices (not just localhost)
- `--port=8080` matches the port you'll pass to the Flutter app

> **Alternative:** Use Laragon's built-in Apache (port 80) if you've configured the `hyperarena.local` vhost. The default helper script assumes this. With `php artisan serve` you'll override the URL — see Step 5.

## Step 4: Windows Firewall Rule (one-time)

If the device can't connect (connection timeout), open an **Administrator** terminal and run:

```bash
netsh advfirewall firewall add rule name="Laravel Dev" dir=in action=allow protocol=TCP localport=8080
```

This allows incoming TCP connections on port 8080 through Windows Firewall.

## Step 5: Run the Flutter App

The default `run-local` script points at `http://hyperarena.local/api` (Laragon Apache). If you're using `php artisan serve` instead, override `API_BASE_URL` at the command line:

```bash
# Linux/macOS or Git Bash
./scripts/run-local.sh \
  --dart-define=API_BASE_URL=http://<YOUR_LAN_IP>:8080/api \
  -d <your-device-id>

# Windows PowerShell
./scripts/run-local.ps1 `
  --dart-define=API_BASE_URL=http://<YOUR_LAN_IP>:8080/api `
  -d <your-device-id>
```

To find device IDs: `flutter devices`. For an Android emulator, use `10.0.2.2` instead of your LAN IP (`http://10.0.2.2:8080/api`).

If you're using Laragon Apache with the default `hyperarena.local` vhost, the unmodified helper script works:

```bash
./scripts/run-local.sh -d <your-device-id>
```

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Connection refused` | Backend not running | Start `php artisan serve` (Step 3) |
| `Connection timeout` | Wrong IP or firewall | Re-check LAN IP, add firewall rule (Step 4) |
| `10.0.2.2` not working | Using physical device | Use LAN IP instead |
| Images not loading | Backend image URLs use `localhost` | Update Laravel `APP_URL` in `.env` (Step 2) |
| `Failed host lookup: hyperarena.local` | Laragon Apache vhost not configured | Use `--dart-define=API_BASE_URL=http://<LAN_IP>:8080/api` (Step 5) |

## How the Environment Config Works

The Flutter app reads three compile-time `--dart-define` flags:

| Flag | Default | Source |
|------|---------|--------|
| `APP_ENV` | `production` | `lib/core/config/app_env.dart` |
| `API_BASE_URL` | `https://api.hyperarena.hyperscore.cloud/api` | same |
| `DEFAULT_TENANT_SLUG` | `petenis-kelana` | same |

A flagless `flutter run` hits production safely. The helper scripts in `scripts/` set `APP_ENV=local` and the local URL. To use a different URL, override at the command line as shown in Step 5. See [flutter-environment.md](flutter-environment.md) for the full reference.
