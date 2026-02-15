#!/usr/bin/env bash
set -euo pipefail

# Usage: ./release.sh <patch|minor|major>

BUMP_TYPE="${1:-}"

if [ -z "$BUMP_TYPE" ] || [[ ! "$BUMP_TYPE" =~ ^(patch|minor|major)$ ]]; then
  echo "Usage: ./release.sh <patch|minor|major>"
  echo ""
  echo "  patch  - bug fixes, minor script tweaks (1.0.0 → 1.0.1)"
  echo "  minor  - new features, new fixes added  (1.0.0 → 1.1.0)"
  echo "  major  - breaking changes, major rework  (1.0.0 → 2.0.0)"
  exit 1
fi

# Read current version from module.prop
CURRENT_VERSION=$(grep '^version=' module.prop | cut -d= -f2 | sed 's/^v//')
CURRENT_CODE=$(grep '^versionCode=' module.prop | cut -d= -f2)

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

case "$BUMP_TYPE" in
  patch) PATCH=$((PATCH + 1)) ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
NEW_CODE=$((CURRENT_CODE + 1))
TAG="v${NEW_VERSION}"
DATE=$(date +%Y-%m-%d)

echo "Version: v${CURRENT_VERSION} → v${NEW_VERSION}"
echo "Code:    ${CURRENT_CODE} → ${NEW_CODE}"
echo "Tag:     ${TAG}"
echo ""

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Error: uncommitted changes. Commit or stash first."
  exit 1
fi

# Check CHANGELOG.md has an entry for the new version
if ! grep -q "## \[${NEW_VERSION}\]" CHANGELOG.md; then
  echo "Error: no changelog entry for [${NEW_VERSION}] in CHANGELOG.md"
  echo ""
  echo "Add this to CHANGELOG.md before releasing:"
  echo ""
  echo "## [${NEW_VERSION}] - ${DATE}"
  echo ""
  echo "### Added/Changed/Fixed"
  echo "- your changes here"
  exit 1
fi

# Bump version in module.prop
sed -i '' "s/^version=v.*/version=v${NEW_VERSION}/" module.prop
sed -i '' "s/^versionCode=.*/versionCode=${NEW_CODE}/" module.prop

# Build
./build.sh

# Commit, tag, push
git add module.prop
git commit -m "release: v${NEW_VERSION}"
git tag "$TAG"

echo ""
echo "Ready to push. Run:"
echo ""
echo "  git push origin main --tags"
echo ""
echo "GitHub Actions will create the release with build/oos16-notification-fix-v${NEW_VERSION}.zip"
