#!/usr/bin/env bash
set -euo pipefail
nodes=.graphlogue/nodes.tsv; edges=.graphlogue/edges.tsv
preview(){ id="$1"; echo ":: $id"; awk -F"\t" -v id="$id" "$1==id{print \"Kind:\",$2; print \"Label:\",$3}" "$nodes"; echo; echo "Neighbors:"; awk -F"\t" -v id="$id" "$1==id{print \"→\",$2,\"(\"$3\")\"} $2==id{print \"←\",$1,\"(\"$3\")\"}" "$edges"|sed "s/\t/ /g"|head -n 30; echo; echo "Recommendations:"; k=$(awk -F"\t" -v id="$id" "$1==id{print $2}" "$nodes"); l=$(awk -F"\t" -v id="$id" "$1==id{print $3}" "$nodes"); case "$k" in Deeplink) echo "  open: xdg-open \"$l\"  # mac: open";; FileProposal|FileWrite) echo "  view: less \"$l\""; echo "  diff: git diff --no-index \"$l\" \"$l\"";; PlanStep) echo "  filter: grep -F \"$l\" .graphlogue/nodes.tsv";; Receipt) echo "  show receipt: less \"$l\"";; KPI) echo "  list KPIs: awk -F\"\t\" \"$3==\\\"decision_agreement\\\"{print}\" .graphlogue/deliverables.tsv 2>/dev/null || true";; *) echo "  grep receipts: grep -F \"$id\" receipts/* 2>/dev/null || true";; esac; }
fzf --prompt="graphlogue> " --with-nth=2,3 --preview-window=down,60% \
  --bind "change:reload(cat $nodes)" \
  --bind "enter:execute-silent(echo {1} > .graphlogue/last && printf )" \
  --preview bash
