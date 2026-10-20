#!/usr/bin/env bash
# Rebuild the PDF edition of the IIoT protocols guide from the Markdown sources.
#
# Requires: perl, and Chrome or Edge for headless PDF rendering.
#   ./scripts/build-docs.sh
set -euo pipefail
cd "$(dirname "$0")/.."

D=docs/iiot-protocols
OUT="$D/IIoT-Communication-Protocols-Guide.pdf"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Order matters: README first, then numbered guides, references last.
FILES=(
  "$D/README.md"
  "$D/01-landscape-and-architecture.md"
  "$D/02-mqtt-and-sparkplug.md"
  "$D/03-opc-ua.md"
  "$D/04-modbus.md"
  "$D/05-industrial-ethernet.md"
  "$D/06-fieldbus-and-device-level.md"
  "$D/07-coap-amqp-dds.md"
  "$D/08-wireless-and-lpwan.md"
  "$D/09-security.md"
  "$D/10-integration-patterns.md"
  "$D/references.md"
)

echo "==> Markdown -> HTML"
perl scripts/md2html.pl "IIoT Communication Protocols - A Practical Guide" \
  "${FILES[@]}" > "$TMP/handbook.html"

echo "==> locating a browser"
BROWSER=""
for c in \
  "/c/Program Files/Google/Chrome/Application/chrome.exe" \
  "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
  "$(command -v google-chrome || true)" \
  "$(command -v chromium || true)" \
  "$(command -v chromium-browser || true)" ; do
  if [ -n "$c" ] && [ -x "$c" ]; then BROWSER="$c"; break; fi
done
[ -n "$BROWSER" ] || { echo "No Chrome/Edge/Chromium found" >&2; exit 1; }
echo "    using: $BROWSER"

echo "==> HTML -> PDF"
# Windows browsers need native paths; convert when cygpath is available.
if command -v cygpath >/dev/null 2>&1; then
  SRC="file:///$(cygpath -m "$TMP/handbook.html")"
  DST="$(cygpath -w "$TMP/out.pdf")"
  PROF="$(cygpath -w "$TMP/profile")"
else
  SRC="file://$TMP/handbook.html"
  DST="$TMP/out.pdf"
  PROF="$TMP/profile"
fi

"$BROWSER" --headless=new --disable-gpu --no-sandbox --no-first-run \
  --no-pdf-header-footer "--user-data-dir=$PROF" \
  "--print-to-pdf=$DST" "$SRC" >/dev/null 2>&1 || true

[ -s "$TMP/out.pdf" ] || { echo "PDF generation failed" >&2; exit 1; }
cp "$TMP/out.pdf" "$OUT"
echo "==> wrote $OUT ($(du -h "$OUT" | cut -f1))"
