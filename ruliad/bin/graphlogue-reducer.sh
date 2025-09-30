#!/usr/bin/env bash
set -euo pipefail
mkdir -p .graphlogue
nodes=.graphlogue/nodes.tsv   # id<TAB>kind<TAB>label
edges=.graphlogue/edges.tsv   # src<TAB>dst<TAB>type
touch "$nodes" "$edges"
upsert(){ awk -v id="$1" -v k="$2" -v l="$3" -Ft "BEGIN{f=0} \$1==id{print id\"\t\"k\"\t\"l; f=1; next}1 END{if(!f)print id\"\t\"k\"\t\"l}" "$nodes" > "$nodes.tmp" && mv "$nodes.tmp" "$nodes"; }
edge(){ echo -e "$1\t$2\t$3" >> "$edges"; }
hid(){ printf "%s" "$1"|sha1sum|awk "{print \$1}"; }
while IFS= read -r line; do
  kind=$(jq -r ".kind // empty"<<<"$line")||continue
  case "$kind" in
    run.start) rid=$(jq -r ".run_id"<<<"$line"); intent=$(jq -r ".intent"<<<"$line"); upsert "run/$rid" "Run" "$rid"; iid="intent/$(hid "$intent")"; upsert "$iid" "Intent" "$intent"; edge "run/$rid" "$iid" "RUN_INTENT" ;;
    plan.step) rid=$(jq -r ".run_id"<<<"$line"); n=$(jq -r ".n"<<<"$line"); p=$(jq -r ".purpose // .summary // (\"step \" + (.n|tostring))"<<<"$line"); upsert "step/$rid/$n" "PlanStep" "$p" ;;
    bundle.proposed) jq -r ".files[]|[.path,.sha256]|@tsv"<<<"$line"|while IFS=$"\t" read -r p s; do upsert "filep/$s" "FileProposal" "$p"; done ;;
    file.write) p=$(jq -r ".path"<<<"$line"); s=$(jq -r ".sha256"<<<"$line"); upsert "filew/$s" "FileWrite" "$p" ;;
    gate.eval) rid=$(jq -r ".run_id"<<<"$line"); st=$(jq -r ".step"<<<"$line"); dec=$(jq -r ".decision"<<<"$line"); upsert "gate/$rid/$st" "GateDecision" "$dec" ;;
    deeplink) url=$(jq -r ".url"<<<"$line"); lbl=$(jq -r ".label // \"link\""<<<"$line"); id="link/$(hid "$url")"; upsert "$id" "Deeplink" "$url" ;;
    kpi) rid=$(jq -r ".run_id"<<<"$line"); da=$(jq -r ".decision_agreement // empty"<<<"$line"); id="kpi/$rid/$(date +%s%3N)"; upsert "$id" "KPI" "agreement=${da:-?}" ;;
    receipt.write) s=$(jq -r ".sha256"<<<"$line"); where=$(jq -r ".where"<<<"$line"); upsert "receipt/$s" "Receipt" "$where" ;;
    run.halt) rid=$(jq -r ".run_id"<<<"$line"); code=$(jq -r ".code"<<<"$line"); upsert "halt/$rid/$code" "Halt" "$code" ;;
  esac
done
