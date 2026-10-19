#!/usr/bin/env bash
# Reassemble the split archives and load every image into Docker.
#
#   ./restore.sh              # restore all images
#   ./restore.sh mysql-8.0    # restore a single image
#
# Requires: docker, unzip, sha256sum
set -euo pipefail
cd "$(dirname "$0")"

command -v docker >/dev/null || { echo "ERROR: docker not found in PATH" >&2; exit 1; }
command -v unzip  >/dev/null || { echo "ERROR: unzip not found (apt-get install -y unzip)" >&2; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if [ $# -gt 0 ]; then
  targets=()
  for t in "$@"; do targets+=("images/$t"); done
else
  mapfile -t targets < <(find images -mindepth 1 -maxdepth 1 -type d | sort)
fi

echo "==> Verifying checksums"
sha256sum -c SHA256SUMS --quiet

for d in "${targets[@]}"; do
  [ -d "$d" ] || { echo "ERROR: no such image dir: $d" >&2; exit 1; }
  name="$(basename "$d")"
  echo "==> $name : joining parts"
  cat "$d/$name.zip.part"* > "$TMP/$name.zip"

  echo "==> $name : unzipping"
  unzip -oq "$TMP/$name.zip" -d "$TMP"

  echo "==> $name : docker load"
  docker load -i "$TMP/$name.tar"

  rm -f "$TMP/$name.zip" "$TMP/$name.tar"
done

echo
echo "Done. Loaded images:"
docker images
