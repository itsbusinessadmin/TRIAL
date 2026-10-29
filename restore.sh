#!/usr/bin/env bash
# Restores apps removed by debloat.sh.
# Usage: ./restore.sh                 -> restores everything in removed.log
#        ./restore.sh com.miui.notes  -> restores specific package(s)
cd "$(dirname "$0")"
if [ $# -gt 0 ]; then list="$*"
elif [ -f removed.log ]; then list=$(sort -u removed.log)
else echo "Nothing to restore (no removed.log)."; exit 0; fi
for p in $list; do
  adb shell cmd package install-existing "$p" >/dev/null 2>&1 && echo "restored $p" || echo "FAILED   $p"
done
