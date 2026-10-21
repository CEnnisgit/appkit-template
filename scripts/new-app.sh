#!/usr/bin/env bash
# Clones this template into a new app.
# Usage: scripts/new-app.sh <Name> <bundle-suffix> [dest-dir]
#   scripts/new-app.sh Quietwell quietwell ../quietwell
# Renames AppTemplate -> <Name> and apptemplate -> <bundle-suffix> in paths and file contents,
# giving bundle ID com.nimbuswebdesign.<bundle-suffix> and product IDs
# com.nimbuswebdesign.<bundle-suffix>.pro.{monthly,yearly,lifetime}.
set -euo pipefail
NAME="${1:?usage: new-app.sh <Name> <bundle-suffix> [dest-dir]}"
SUFFIX="${2:?usage: new-app.sh <Name> <bundle-suffix> [dest-dir]}"
[[ "$NAME" =~ ^[A-Z][A-Za-z0-9]*$ ]] || { echo "Name must be UpperCamelCase letters/digits" >&2; exit 1; }
[[ "$SUFFIX" =~ ^[a-z][a-z0-9]*$ ]] || { echo "bundle-suffix must be lowercase letters/digits" >&2; exit 1; }
SRC=$(cd "$(dirname "$0")/.." && pwd)
DEST="${3:-$SRC/../$SUFFIX}"
[ -e "$DEST" ] && [ -n "$(ls -A "$DEST" 2>/dev/null)" ] && { echo "$DEST exists and is not empty" >&2; exit 1; }
mkdir -p "$DEST"
DEST=$(cd "$DEST" && pwd)
# copy tracked-ish files (skip git metadata, build output, generated project)
(cd "$SRC" && tar --exclude=.git --exclude=build --exclude=DerivedData --exclude='*.xcodeproj' --exclude=proof -cf - .) | (cd "$DEST" && tar -xf -)
cd "$DEST"
# rename paths, deepest first
find . -depth -name '*AppTemplate*' | while read -r p; do
  mv "$p" "$(dirname "$p")/$(basename "$p" | sed "s/AppTemplate/$NAME/g")"
done
# replace contents in text files
grep -rIl -e AppTemplate -e apptemplate . | while read -r f; do
  sed -i.bak -e "s/AppTemplate/$NAME/g" -e "s/apptemplate/$SUFFIX/g" "$f" && rm -f "$f.bak"
done
# fresh StoreKit file identifier so two apps never share one
python3 - "$NAME.storekit" <<'PY'
import json, sys, uuid
p = sys.argv[1]; d = json.load(open(p)); d["identifier"] = uuid.uuid4().hex[:8].upper()
open(p, "w").write(json.dumps(d, indent=2) + "\n")
PY
echo "Created $NAME at $DEST (bundle com.nimbuswebdesign.$SUFFIX)."
echo "Next: edit $NAME/App/AppConfig.swift, prices in $NAME.storekit, the README, then 'git init'."
