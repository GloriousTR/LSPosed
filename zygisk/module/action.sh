MANAGER_PACKAGE_NAME="@MANAGER_PACKAGE_NAME@"
INJECTED_PACKAGE_NAME="@INJECTED_PACKAGE_NAME@"

# Try dedicated manager launcher intent first
am start -a android.intent.action.MAIN \
  -c "${MANAGER_PACKAGE_NAME}.LAUNCH_MANAGER" \
  "${INJECTED_PACKAGE_NAME}/.BugreportWarningActivity" >/dev/null 2>&1

rc=$?

# Fallback: open manager main activity directly
if [ "$rc" -ne 0 ]; then
  am start -n "${MANAGER_PACKAGE_NAME}/.ui.activity.MainActivity" >/dev/null 2>&1
  rc=$?
fi

if [ "$rc" -ne 0 ]; then
  echo "! Failed to launch manager: ${MANAGER_PACKAGE_NAME}"
  exit 1
fi

echo "- Manager launch intent sent: ${MANAGER_PACKAGE_NAME}"