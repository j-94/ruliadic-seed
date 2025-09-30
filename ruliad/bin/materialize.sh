#!/usr/bin/env bash
set -euo pipefail
have(){ command -v "$1" >/dev/null 2>&1; }
sha256_file(){ if have shasum; then shasum -a 256 "$1"|awk "{print \$1}"; else sha256sum "$1"|awk "{print \$1}"; fi; }
bundle="${1:-/dev/stdin}"
tmp="$(mktemp)"; cat "$bundle" > "$tmp"
jq -r ".files[] | (.path+\"\\u0000\"+.mode+\"\\u0000\"+.encoding+\"\\u0000\"+.sha256+\"\\u0000\"+.contents)" "$tmp" | \
while IFS=$"\0" read -r path mode enc want bytes; do
  mkdir -p "$(dirname "$path")"
  case "$enc" in utf8) printf "%s" "$bytes" > "$path" ;; base64) printf "%s" "$bytes" | base64 -d > "$path" ;; *) echo "unsupported encoding: $enc" >&2; exit 3;; esac
  chmod "$mode" "$path"
  got="$(sha256_file "$path")"; [ "$got" = "$want" ] || { echo "hash mismatch: $path" >&2; exit 4; }
done
mkdir -p receipts
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ"); out="receipts/materialize-$(date +%s).json"
jq --arg ts "$ts" "{ts:$ts,bundle_version,intent,files:[.files[]|{path,sha256}],attestation}" "$tmp" > "$out"
echo "OK -> $out"
