# Local Development Setup (Flutter + Laravel Backend)

## Prerequisites

- **Laragon** installed at `C:\laragon\` with Apache + MySQL
- Laravel backend at `C:\laragon\www\hypercoach`
- Flutter app at `D:\projects\Flutter\hyperarena`
- Physical Android device on the **same WiFi network** as your PC

## Step 1: Find Your PC's LAN IP

```bash
ipconfig
```

Look for the `IPv4 Address` under your active Wi-Fi or Ethernet adapter (e.g., `10.142.152.33`).

> **Note:** This IP can change when you switch networks. Re-check it if connections start failing.

## Step 2: Update Laravel `APP_URL`

Edit `C:\laragon\www\hypercoach\.env`:

```
APP_URL=http://<YOUR_LAN_IP>:8080
```

This ensures image/asset URLs returned by the API are accessible from your device (not `localhost`).

## Step 3: Update Flutter `apiBaseUrl`

Edit `lib/core/config/app_config.dart`, update the `local` config:

```dart
static const local = AppConfig(
  environment: Environment.local,
  apiBaseUrl: 'http://<YOUR_LAN_IP>:8080/api',  // e.g. http://10.142.152.33:8080/api
  useMockData: false,
  enableLogging: true,
  showDebugBanner: true,
);
```

### Which IP to use?

| Device            | IP to use                              |
|-------------------|----------------------------------------|
| Physical device   | Your PC's LAN IP (e.g. `192.168.x.x`) |
| Android emulator  | `10.0.2.2` (special alias for host)    |

## Step 4: Start the Laravel Backend

```bash
cd C:\laragon\www\hypercoach
php artisan serve --host=0.0.0.0 --port=8080
```

- `--host=0.0.0.0` makes it accept connections from other devices (not just localhost)
- `--port=8080` matches the port in `apiBaseUrl`

> **Alternative:** You can use Laragon's built-in Apache (port 80), but `php artisan serve` is simpler for development.

## Step 5: Windows Firewall Rule (one-time)

If the device can't connect (connection timeout), open an **Administrator** terminal and run:

```bash
netsh advfirewall firewall add rule name="Laravel Dev" dir=in action=allow protocol=TCP localport=8080
```

This allows incoming TCP connections on port 8080 through Windows Firewall.

## Step 6: Run the Flutter App on Samsung Tab

```bash
flutter run -t lib/main_local.dart -d RR2X2003GAY
```

- `-t lib/main_local.dart` — uses the local backend config
- `-d RR2X2003GAY` — targets the Samsung Galaxy Tab S9 (SM-X816B)

> To find device IDs: `flutter devices`

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Connection refused` | Backend not running | Start `php artisan serve` |
| `Connection timeout` | Wrong IP or firewall | Re-check LAN IP, add firewall rule |
| `10.0.2.2` not working | Using physical device | Use LAN IP instead |
| Images not loading | Backend image URLs use `localhost` | Update Laravel `APP_URL` in `.env` to `http://<YOUR_LAN_IP>:8080` |

## Entry Points

| File | Environment | Backend |
|------|-------------|---------|
| `lib/main.dart` | mock | No backend needed |
| `lib/main_local.dart` | local | Local Laravel server |
| `lib/main_dev.dart` | dev | `dev-api.hyperarena.id` |
