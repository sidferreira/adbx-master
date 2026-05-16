#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/adbx"
TAP="$SCRIPT_DIR/homebrew-adbx"
FORMULA="$TAP/Formula/adbx.rb"
TARBALL_BASE="https://github.com/sidferreira/adbx/archive/refs/tags"

DRY_RUN=false

# ── helpers ──────────────────────────────────────────────────────────────────

run() {
  if $DRY_RUN; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

die() { echo "error: $*" >&2; exit 1; }

# ── arg parsing ───────────────────────────────────────────────────────────────

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *) die "unknown argument: $arg" ;;
  esac
done

# ── preflight ─────────────────────────────────────────────────────────────────

preflight_repo() {
  local label="$1" path="$2"

  [[ -d "$path/.git" || -f "$path/.git" ]] || die "$label: not a git repo at $path"

  local branch
  branch=$(git -C "$path" rev-parse --abbrev-ref HEAD)
  [[ "$branch" == "main" ]] || die "$label: not on main (currently on $branch)"

  local dirty
  dirty=$(git -C "$path" status --porcelain)
  [[ -z "$dirty" ]] || die "$label: working tree is dirty — commit or stash first"

  git -C "$path" fetch --quiet origin
  local local_sha remote_sha
  local_sha=$(git -C "$path" rev-parse main)
  remote_sha=$(git -C "$path" rev-parse origin/main)
  [[ "$local_sha" == "$remote_sha" ]] || die "$label: main is not in sync with origin/main (run git pull or git push)"
}

echo "Running preflight checks..."
preflight_repo "adbx" "$SOURCE"
preflight_repo "homebrew-adbx" "$TAP"
echo "Preflight passed."
echo

# ── version prompt ────────────────────────────────────────────────────────────

latest=$(git -C "$SOURCE" describe --tags --abbrev=0 2>/dev/null || echo "none")

if [[ "$latest" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  suggested="v${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.$((BASH_REMATCH[3] + 1))"
  echo "Latest tag: $latest"
  echo -n "New version? [$suggested]: "
  read -r VERSION
  VERSION="${VERSION:-$suggested}"
else
  echo "No existing tags found."
  echo -n "New version (e.g. v0.1.0): "
  read -r VERSION
fi

[[ "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "version must match vMAJOR.MINOR.PATCH (got: $VERSION)"

if git -C "$SOURCE" rev-parse "$VERSION" &>/dev/null; then
  die "tag $VERSION already exists in adbx"
fi

TARBALL_URL="$TARBALL_BASE/$VERSION.tar.gz"
echo

# ── confirm ───────────────────────────────────────────────────────────────────

echo "Planned actions:"
echo "  1. git tag $VERSION && git push origin $VERSION  (in adbx/)"
echo "  2. curl $TARBALL_URL | shasum -a 256"
echo "  3. Update url + sha256 in $FORMULA"
echo "  4. git commit -m \"adbx $VERSION\" && git push  (in homebrew-adbx/)"
echo
echo -n "Proceed? [y/N]: "
read -r CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
echo

# ── tag source ────────────────────────────────────────────────────────────────

echo "Tagging $VERSION in adbx/..."
run git -C "$SOURCE" tag "$VERSION"
run git -C "$SOURCE" push origin "$VERSION"
echo

# ── compute hash ─────────────────────────────────────────────────────────────

if $DRY_RUN; then
  echo "[dry-run] would download $TARBALL_URL and compute sha256"
  SHA256="<sha256-computed-at-runtime>"
else
  echo "Downloading tarball and computing sha256..."
  SHA256=$(curl -fsSL "$TARBALL_URL" | shasum -a 256 | awk '{print $1}')
  echo "sha256: $SHA256"
fi
echo

# ── update formula ────────────────────────────────────────────────────────────

echo "Updating $FORMULA..."
if $DRY_RUN; then
  echo "[dry-run] sed url line -> $TARBALL_URL"
  echo "[dry-run] sed sha256 line -> $SHA256"
else
  sed -i.bak "s|url \".*\"|url \"$TARBALL_URL\"|" "$FORMULA"
  sed -i.bak "s|sha256 \".*\"|sha256 \"$SHA256\"|" "$FORMULA"
  rm -f "$FORMULA.bak"
  echo "Formula updated."
fi
echo

# ── commit and push tap ───────────────────────────────────────────────────────

echo "Committing and pushing homebrew-adbx..."
run git -C "$TAP" add Formula/adbx.rb
run git -C "$TAP" commit -m "adbx $VERSION"
run git -C "$TAP" push origin main
echo

# ── summary ───────────────────────────────────────────────────────────────────

TAP_SHA=$(git -C "$TAP" rev-parse --short HEAD 2>/dev/null || echo "<pending>")

echo "Done."
echo
echo "  Tag:     $VERSION"
echo "  sha256:  $SHA256"
echo "  Release: https://github.com/sidferreira/adbx/releases/tag/$VERSION"
echo "  Tap:     https://github.com/sidferreira/homebrew-adbx/commit/$TAP_SHA"
