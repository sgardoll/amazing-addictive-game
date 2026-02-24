#!/bin/bash
# scripts/inject_admob_ids.sh
# 
# Replaces __ADMOB_ANDROID_APP_ID__ and __ADMOB_IOS_APP_ID__ placeholders
# in AndroidManifest.xml and Info.plist with values from environment variables.
# This should be run in CI before building the app.

set -e

# Default to test IDs if not provided in environment
ANDROID_APP_ID="${ADMOB_ANDROID_APP_ID:-ca-app-pub-3940256099942544~3347511713}"
IOS_APP_ID="${ADMOB_IOS_APP_ID:-ca-app-pub-3940256099942544~1458002511}"

echo "Injecting AdMob Application IDs..."

# Android
MANIFEST_PATH="android/app/src/main/AndroidManifest.xml"
if [ -f "$MANIFEST_PATH" ]; then
  # Support both GNU sed and BSD sed
  if sed --version >/dev/null 2>&1; then
    sed -i "s/__ADMOB_ANDROID_APP_ID__/$ANDROID_APP_ID/g" "$MANIFEST_PATH"
  else
    sed -i '' "s/__ADMOB_ANDROID_APP_ID__/$ANDROID_APP_ID/g" "$MANIFEST_PATH"
  fi
  echo "Updated $MANIFEST_PATH"
else
  echo "Warning: $MANIFEST_PATH not found"
fi

# iOS
PLIST_PATH="ios/Runner/Info.plist"
if [ -f "$PLIST_PATH" ]; then
  if sed --version >/dev/null 2>&1; then
    sed -i "s/__ADMOB_IOS_APP_ID__/$IOS_APP_ID/g" "$PLIST_PATH"
  else
    sed -i '' "s/__ADMOB_IOS_APP_ID__/$IOS_APP_ID/g" "$PLIST_PATH"
  fi
  echo "Updated $PLIST_PATH"
else
  echo "Warning: $PLIST_PATH not found"
fi

echo "Done."