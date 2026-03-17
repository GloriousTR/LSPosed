#!/system/bin/sh
MODDIR="${0%/*}"
DAEMON="$MODDIR/daemon"
LOGFILE="/data/adb/modules/zygisk_vector/service.log"

mkdir -p /data/adb/modules/zygisk_vector 2>/dev/null
echo "[$(date)] service.sh start" >> "$LOGFILE"

chmod 0755 "$DAEMON" 2>/dev/null
chown 0:0 "$DAEMON" 2>/dev/null

if [ ! -f "$DAEMON" ]; then
  echo "[$(date)] daemon missing: $DAEMON" >> "$LOGFILE"
  exit 1
fi

if [ ! -x "$DAEMON" ]; then
  echo "[$(date)] daemon not executable: $DAEMON" >> "$LOGFILE"
  exit 1
fi

cd "$MODDIR" || {
  echo "[$(date)] cd failed: $MODDIR" >> "$LOGFILE"
  exit 1
}

pkill -f "/data/adb/modules/zygisk_vector/daemon" 2>/dev/null

if command -v unshare >/dev/null 2>&1; then
  unshare --propagation slave -m "$DAEMON" --system-server-max-retry=3 >> "$LOGFILE" 2>&1 &
  echo "[$(date)] start with unshare rc=$?" >> "$LOGFILE"
else
  "$DAEMON" --system-server-max-retry=3 >> "$LOGFILE" 2>&1 &
  echo "[$(date)] start without unshare rc=$?" >> "$LOGFILE"
fi

exit 0