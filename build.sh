#!/usr/bin/env bash
set -euo pipefail

# Read version from module.prop
VERSION=$(grep '^version=' module.prop | cut -d= -f2)
MODULE_ID=$(grep '^id=' module.prop | cut -d= -f2)
OUTDIR="build"
OUTFILE="${OUTDIR}/${MODULE_ID}-${VERSION}.zip"

echo "Building ${MODULE_ID} ${VERSION}..."

mkdir -p "$OUTDIR"
rm -f "$OUTFILE"

zip -r "$OUTFILE" . \
  -x '.git/*' \
  -x '.gitignore' \
  -x 'build/*' \
  -x 'build.sh' \
  -x 'release.sh' \
  -x 'CLAUDE.md' \
  -x 'CHANGELOG.md' \
  -x 'LICENSE' \
  -x 'README.md' \
  -x '.DS_Store' \
  -x '.github/*'

echo "Built: $OUTFILE"
echo "Size: $(du -h "$OUTFILE" | cut -f1)"
