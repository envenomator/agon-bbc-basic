#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://codeberg.org/envenomator/eZ80-for-rc-basic/raw/branch/agon/src"
DEST_DIR="./include/bbc-ez80"

FILES=(
  DATA.Z80
  EVAL.Z80
  EXEC.Z80
  MAIN.Z80
  MATH.Z80
  TOKENIDS.Z80
)

echo "Creating destination directory: $DEST_DIR"
mkdir -p "$DEST_DIR"

echo "Downloading files..."
for file in "${FILES[@]}"; do
    echo "  -> $file"
    wget -q --show-progress -O "$DEST_DIR/$file" "$BASE_URL/$file"
done

echo "Done. Files saved to $DEST_DIR"
