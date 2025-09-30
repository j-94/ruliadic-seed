#!/bin/bash
# Simple web server to serve the ChatLoop interface
# Usage: ./serve-chatloop.sh [port]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT="${1:-8080}"
HTML_FILE="$SCRIPT_DIR/chatloop.html"

echo "🚀 Starting Ruliad-Seed ChatLoop Server"
echo "📂 Serving: $HTML_FILE"
echo "🌐 URL: http://localhost:$PORT"
echo "⏹️  Press Ctrl+C to stop"
echo ""

# Check if file exists
if [[ ! -f "$HTML_FILE" ]]; then
    echo "❌ Error: $HTML_FILE not found!"
    echo "Make sure chatloop.html exists in the ruliad-seed directory."
    exit 1
fi

# Simple Python HTTP server
cd "$SCRIPT_DIR"
python3 -m http.server "$PORT"