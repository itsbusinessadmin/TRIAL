#!/usr/bin/env bash
# POCO X3 Pro debloater (no root). Uses "pm uninstall --user 0", which is fully
# reversible with restore.sh or a factory reset.
#
# Usage: ./debloat.sh            -> removes tier 1 (ads) + tier 2 (bloat)
#        ./debloat.sh --optional -> also removes tier 3
#        ./debloat.sh --dry-run  -> only shows what would be removed
set -u
cd "$(dirname "$0")"

lists=(lists/1-ads-telemetry.txt lists/2-bloat-apps.txt)
dry=0
for arg in "$@"; do
  case "$arg" in
    --optional) lists+=(lists/3-optional.txt) ;;
    --dry-run)  dry=1 ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

pkgs() { sed -e 's/#.*//' -e 's/[[:space:]]//g' -e '/^$/d' "$@"; }

command -v adb >/dev/null || { echo "adb not found. Install Android platform-tools first."; exit 1; }
adb get-state >/dev/null 2>&1 || { echo "No device. Enable USB debugging and accept the prompt on the phone."; exit 1; }

model=$(adb shell getprop ro.product.device | tr -d '\r')
[ "$model" = "vayu" ] || [ "$model" = "bhima" ] || {
  read -rp "Device is '$model', not POCO X3 Pro (vayu). Continue anyway? [y/N] " a
  [ "$a" = "y" ] || exit 1
}

protected=$(pkgs lists/DO-NOT-REMOVE.txt)
installed=$(adb shell pm list packages | tr -d '\r' | sed 's/^package://')

removed=0
for p in $(pkgs "${lists[@]}"); do
  grep -qxF "$p" <<<"$protected" && { echo "SKIP (protected) $p"; continue; }
  grep -qxF "$p" <<<"$installed" || continue
  if [ $dry -eq 1 ]; then echo "would remove $p"; continue; fi
  if adb shell pm uninstall -k --user 0 "$p" | grep -q Success; then
    echo "removed  $p"; echo "$p" >> removed.log; removed=$((removed+1))
  else
    echo "FAILED   $p"
  fi
done
echo "Done. $removed package(s) removed. Reboot the phone. Undo with ./restore.sh"
