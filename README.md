# POCO X3 Pro Debloat (no root)

Removes Xiaomi ad services and preinstalled bloatware from a POCO X3 Pro (codename `vayu`)
running MIUI 12–14 or HyperOS. No root, no unlocked bootloader, warranty stays intact.

Apps are removed with `pm uninstall -k --user 0`. That hides an app from your user but
leaves it on the system partition, so it is **fully reversible** with the restore script
or a factory reset. System updates (OTA) keep working.

> **No computer?** Follow [the phone-only guide](#phone-only-no-computer) below.

## 1. Prepare the phone
1. **Settings → About phone →** tap **MIUI/OS version** 7 times (this turns on Developer options).
2. **Settings → Additional settings → Developer options →** turn on:
   - **USB debugging**
   - **USB debugging (Security settings)** (needs a SIM and a Mi account sign-in)
3. Plug the phone into your PC and tap **Allow** on the "Allow USB debugging?" prompt.

## 2. Prepare the PC
Download Google's **Android SDK Platform-Tools** (adb):
https://developer.android.com/tools/releases/platform-tools
Unzip it, then copy this repo's files into the `platform-tools` folder.

## 3. Run it
| | Windows | Linux / macOS |
|---|---|---|
| Preview only | — | `./debloat.sh --dry-run` |
| Ads + bloat (recommended) | double-click `debloat.bat` | `./debloat.sh` |
| Also remove optional apps | `debloat.bat optional` | `./debloat.sh --optional` |
| Undo everything | `restore.bat` | `./restore.sh` |
| Undo one app | `restore.bat com.miui.notes` | `./restore.sh com.miui.notes` |

Reboot the phone afterwards.

## What gets removed
- `lists/1-ads-telemetry.txt`: the ad engine (MSA), analytics, App Vault, Wallpaper Carousel, GetApps, Facebook services.
- `lists/2-bloat-apps.txt`: Mi Browser, Mi Video, Mi Music, ShareMe, Cleaner, preloaded games, Netflix, Amazon, TikTok, and other apps that came with the phone.
- `lists/3-optional.txt`: apps some people use (Weather, Notes, File Manager, YouTube, Gmail...). These are only removed with `optional`.
- `lists/DO-NOT-REMOVE.txt`: critical packages. The scripts always skip these, even if you add one to another list.

Edit the lists to fit your needs: one package per line, and anything after `#` is a comment.

## 4. Remove the remaining ads (settings, no PC needed)
Some ads come from settings inside the apps you keep:
- **Settings → Passwords & security → Authorization & revocation →** turn **msa** off (if it is still there).
- **Settings → Passwords & security → Privacy → Ad services →** turn off **Personalized ad recommendations**.
- **Security app → ⚙ →** turn off **Receive recommendations**. Do the same in the **Cleaner** settings.
- **File Manager, Themes, Music, Downloads, Gallery →** Settings → turn off **Recommendations / Online content**.
- **Settings → Notifications** → turn off notifications for any app that sends promos.
- **System-wide ad blocking:** **Settings → Connection & sharing → Private DNS →** hostname `dns.adguard-dns.com`.
  This blocks ads in most apps and browsers.

## Troubleshooting
- **`Failure [not installed for 0]`**: that app isn't on your firmware. This is harmless.
- **Something broke**: run `restore.bat` / `./restore.sh`, or restore one app as shown above.
- **Phone won't boot (very unlikely with these lists)**: boot to recovery (Power + Vol Up) and wipe data. All removed apps come back.

## Phone-only (no computer)
This uses two free, open-source apps. **Shizuku** gives other apps ADB access through
Wireless debugging. **Canta** uses that access to uninstall system apps. Removal works
the same way as the PC scripts, so it is reversible.

1. Install **Shizuku** and **Canta** from the Play Store.
   You can also get them from GitHub: `RikkaApps/Shizuku` and `samolego/Canta`.
2. Turn on Developer options (Settings → About phone → tap the OS version 7 times).
3. In **Developer options**, turn on **USB debugging**, **USB debugging (Security settings)**
   and **Wireless debugging**. You must be connected to Wi-Fi (any network, internet is not needed).
4. Open **Shizuku → Pairing → Developer options**. In Wireless debugging, tap **Pair device with pairing code**.
   Type the 6-digit code into Shizuku's notification. Then go back to Shizuku and tap **Start**.
   It should say "Shizuku is running".
5. Open **Canta** and tap **Allow** for Shizuku. Search for each package from
   `lists/1-ads-telemetry.txt` and `lists/2-bloat-apps.txt` (for example `com.miui.msa.global`),
   tick it and tap the 🗑 button. Canta also labels packages as Recommended, Advanced or Unsafe.
   **Never remove anything marked Unsafe, or anything in `lists/DO-NOT-REMOVE.txt`.**
6. Reboot the phone. To undo, open Canta → **Uninstalled** tab → select the app → **Restore**.

Notes:
- After a reboot, Shizuku stops. Repeat the **Start** step (no new pairing needed) whenever you want to use Canta again.
- If MIUI keeps killing Shizuku, set its battery saver to **No restrictions**.
- When you are done, turn **Wireless debugging** off again.
