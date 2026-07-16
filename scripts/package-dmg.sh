#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PRODUCT_NAME="PromptPin"
VERSION="0.1.1"
DIST_DIR="$ROOT_DIR/dist"
WORK_DIR="$ROOT_DIR/.build/package-dmg"
APP_BUNDLE="$WORK_DIR/$PRODUCT_NAME.app"
DMG_ROOT="$WORK_DIR/dmg-root"
DMG_PATH="$DIST_DIR/$PRODUCT_NAME-$VERSION.dmg"
ICON_SOURCE="$ROOT_DIR/Assets/PromptPinIcon.png"
ICONSET="$WORK_DIR/$PRODUCT_NAME.iconset"

export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"

rm -rf "$WORK_DIR"
mkdir -p \
    "$APP_BUNDLE/Contents/MacOS" \
    "$APP_BUNDLE/Contents/Resources" \
    "$DMG_ROOT" \
    "$DIST_DIR" \
    "$ICONSET"

swift build -c release --package-path "$ROOT_DIR"
BIN_DIR="$(swift build -c release --package-path "$ROOT_DIR" --show-bin-path)"

cp "$BIN_DIR/$PRODUCT_NAME" "$APP_BUNDLE/Contents/MacOS/$PRODUCT_NAME"
cp "$ROOT_DIR/Packaging/Info.plist" "$APP_BUNDLE/Contents/Info.plist"
cp "$ROOT_DIR/Sources/PromptPin/Resources/PromptPinMenuBarIcon.png" \
    "$APP_BUNDLE/Contents/Resources/PromptPinMenuBarIcon.png"

sips -z 16 16 "$ICON_SOURCE" --out "$ICONSET/icon_16x16.png" >/dev/null
sips -z 32 32 "$ICON_SOURCE" --out "$ICONSET/icon_16x16@2x.png" >/dev/null
sips -z 32 32 "$ICON_SOURCE" --out "$ICONSET/icon_32x32.png" >/dev/null
sips -z 64 64 "$ICON_SOURCE" --out "$ICONSET/icon_32x32@2x.png" >/dev/null
sips -z 128 128 "$ICON_SOURCE" --out "$ICONSET/icon_128x128.png" >/dev/null
sips -z 256 256 "$ICON_SOURCE" --out "$ICONSET/icon_128x128@2x.png" >/dev/null
sips -z 256 256 "$ICON_SOURCE" --out "$ICONSET/icon_256x256.png" >/dev/null
sips -z 512 512 "$ICON_SOURCE" --out "$ICONSET/icon_256x256@2x.png" >/dev/null
sips -z 512 512 "$ICON_SOURCE" --out "$ICONSET/icon_512x512.png" >/dev/null
cp "$ICON_SOURCE" "$ICONSET/icon_512x512@2x.png"

iconutil -c icns "$ICONSET" -o "$APP_BUNDLE/Contents/Resources/$PRODUCT_NAME.icns"
codesign --force --deep --sign - "$APP_BUNDLE"
codesign --verify --deep --strict "$APP_BUNDLE"

cp -R "$APP_BUNDLE" "$DMG_ROOT/$PRODUCT_NAME.app"
ln -s /Applications "$DMG_ROOT/Applications"

hdiutil create \
    -volname "$PRODUCT_NAME" \
    -srcfolder "$DMG_ROOT" \
    -ov \
    -format UDZO \
    "$DMG_PATH"

echo "$DMG_PATH"
