#!/bin/bash
# Experience Miner - Scan for emergent patterns in repos and conversation history
# Usage: ./bin/mine_experiences.sh [scan|analyze|export]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPERIENCES_DIR="$SCRIPT_DIR/patterns"
OUTPUT_DIR="$SCRIPT_DIR/deliverables/mined_experiences"

# Create directories
mkdir -p "$EXPERIENCES_DIR"
mkdir -p "$OUTPUT_DIR"

# Pattern definitions based on conversation history
PATTERNS=(
    "coged:iterative plan/draft/critique loop"
    "map-reduce:fanout shard tasks, reduce unified results"
    "agentic:planner/critic/executor roles, policies as governors"
    "graphlogue:live streaming graph of runs, fuzzy search, recs rail"
    "keys_trust:SSH agent, OpenRouter API key obfuscation"
    "proof_metrics:receipts, snapshot CIDs, KPIs"
    "codex:drop-in agent, CLI that runs codex/LM locally"
    "seed:turnkey bootstrap, no secrets required"
    "tau:single stepper τ(S,I) → O"
    "ruliad:ruliadic themes T1–T6"
)

scan_repositories() {
    echo "🔍 Scanning repositories for emergent patterns..."

    local findings=()

    # Scan for pattern keywords in various file types
    while IFS=':' read -r pattern_type description; do
        pattern_name=$(echo "$pattern_type" | cut -d':' -f1)
        pattern_keywords=$(echo "$pattern_type" | cut -d':' -f2)

        echo "  📋 Looking for: $pattern_name ($description)"

        # Search for pattern in various locations
        {
            # Current workspace files
            find "$SCRIPT_DIR/.." -type f \( -name "*.md" -o -name "*.json" -o -name "*.rs" -o -name "*.py" -o -name "*.js" -o -name "*.ts" \) | head -20 | xargs grep -l -i "$pattern_keywords" 2>/dev/null || true

            # Conversation history
            find "$SCRIPT_DIR/.." -name "*conversation*" -o -name "*chat*" -o -name "*history*" | xargs grep -l -i "$pattern_keywords" 2>/dev/null || true

            # Code comments and documentation
            find "$SCRIPT_DIR/.." -type f \( -name "*.rs" -o -name "*.py" -o -name "*.js" \) | xargs grep -l -i "TODO.*$pattern_keywords\|FIXME.*$pattern_keywords\|NOTE.*$pattern_keywords" 2>/dev/null || true
        } | sort | uniq | while read -r file; do
            if [[ -f "$file" ]]; then
                echo "    📄 Found in: $(realpath "$file")"
                findings+=("$pattern_name:$file")
            fi
        done
    done <<< "$(printf '%s\n' "${PATTERNS[@]}")"

    # Export findings
    printf '%s\n' "${findings[@]}" > "$OUTPUT_DIR/pattern_findings.txt"

    echo "✅ Scan complete. Findings saved to: $OUTPUT_DIR/pattern_findings.txt"
}

analyze_patterns() {
    echo "🧠 Analyzing discovered patterns..."

    local analysis_file="$OUTPUT_DIR/pattern_analysis.json"

    cat > "$analysis_file" << EOF
{
  "analysis_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "patterns_analyzed": $(printf '%s\n' "${PATTERNS[@]}" | wc -l),
  "findings_summary": {
EOF

    # Count findings per pattern
    while IFS=':' read -r pattern_type description; do
        pattern_name=$(echo "$pattern_type" | cut -d':' -f1)
        count=$(grep "^$pattern_name:" "$OUTPUT_DIR/pattern_findings.txt" | wc -l)
        echo "    \"$pattern_name\": $count," >> "$analysis_file"
    done <<< "$(printf '%s\n' "${PATTERNS[@]}")"

    cat >> "$analysis_file" << EOF
  },
  "recommendations": [
    "Implement coged-gen loop as primary code generation pattern",
    "Build map-reduce engine for parallel task processing",
    "Create agentic system with planner/critic/executor roles",
    "Develop Graphlogue v2.0 for live visualization",
    "Integrate keys/trust system for secure API management"
  ]
}
EOF

    echo "✅ Analysis complete. Results saved to: $analysis_file"
}

export_patterns() {
    echo "📦 Exporting patterns for seed integration..."

    # Export each pattern as a structured file
    while IFS=':' read -r pattern_type description; do
        pattern_name=$(echo "$pattern_type" | cut -d':' -f1)

        local pattern_file="$EXPERIENCES_DIR/${pattern_name}.json"

        cat > "$pattern_file" << EOF
{
  "pattern": "$pattern_name",
  "description": "$description",
  "discovered_in": "$(grep "^$pattern_name:" "$OUTPUT_DIR/pattern_findings.txt" | cut -d':' -f2- | tr '\n' ',' | sed 's/,$//')",
  "implementation_priority": "high",
  "integration_points": [
    "engine.dsl endpoints",
    "task templates",
    "policy gates",
    "seed configuration"
  ],
  "conversation_context": "Discovered during One Engine development discussions"
}
EOF

        echo "  📋 Exported: $pattern_file"
    done <<< "$(printf '%s\n' "${PATTERNS[@]}")"

    echo "✅ Pattern export complete. Files in: $EXPERIENCES_DIR/"
}

show_help() {
    cat << EOF
Experience Miner - Discover emergent patterns in your codebase

USAGE:
    $0 [COMMAND]

COMMANDS:
    scan        Scan repositories for pattern keywords (default)
    analyze     Analyze discovered patterns and generate insights
    export      Export patterns as structured files for seed integration
    all         Run scan → analyze → export in sequence

EXAMPLES:
    $0 scan                    # Scan for patterns
    $0 all                     # Complete mining workflow
    $0 analyze                 # Analyze existing findings

PATTERNS DETECTED:
$(printf '    • %s\n' "${PATTERNS[@]}")

OUTPUT:
    deliverables/mined_experiences/    # Analysis results
    patterns/                          # Exported pattern files
EOF
}

main() {
    cd "$SCRIPT_DIR"

    local cmd="${1:-scan}"

    case "$cmd" in
        "scan")
            scan_repositories
            ;;
        "analyze")
            [[ ! -f "$OUTPUT_DIR/pattern_findings.txt" ]] && scan_repositories
            analyze_patterns
            ;;
        "export")
            [[ ! -f "$OUTPUT_DIR/pattern_analysis.json" ]] && analyze_patterns
            export_patterns
            ;;
        "all")
            scan_repositories
            analyze_patterns
            export_patterns
            echo "🎉 Complete mining workflow finished!"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo "❌ Unknown command: $cmd"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"