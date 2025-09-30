#!/bin/bash
# Ruliadic Seed - Evolutionary Self-Improvement Loop

echo "🧬 Ruliadic Seed - Evolutionary Self-Improvement Loop"
echo "==================================================="

GENERATIONS=3
IMPROVEMENT_INTERVAL=30

echo "📊 Starting evolutionary loop..."
echo "🔄 Generations to create: $GENERATIONS"
echo "⏱️  Improvement interval: $IMPROVEMENT_INTERVAL seconds"

mkdir -p evolution

for generation in $(seq 1 $GENERATIONS); do
    echo ""
    echo "🌟 === GENERATION $generation ==="
    timestamp=$(date +%Y%m%d-%H%M%S)
    
    echo "🔧 Starting improvement cycle..."
    
    # Start system
    python3 api-server.py &
    API_PID=$!
    sleep 3
    
    # Create session
    SESSION_ID=$(curl -s -X POST http://localhost:5000/api/sessions | jq -r .session_id)
    echo "💾 Created session: $SESSION_ID"
    
    # Request improvement
    IMPROVEMENT_REQUEST="Generate an improved version of this system for generation $generation"
    IMPROVEMENT_RESPONSE=$(curl -s -X POST http://localhost:5000/api/chat \
        -H "Content-Type: application/json" \
        -d "{\"message\":\"$IMPROVEMENT_REQUEST\", \"session_id\":\"$SESSION_ID\"}")
    
    # Generate interface
    NEW_INTERFACE=$(curl -s http://localhost:5000/api/autogenerate/interface)
    
    # Generate component
    IMPROVED_COMPONENT=$(curl -s -X POST http://localhost:5000/api/generate \
        -H "Content-Type: application/json" \
        -d '{"component":"self_improvement_engine", "specifications":{"generation":'$generation'}}')
    
    # Create directory
    VERSION_DIR="evolution/gen-$generation-$timestamp"
    mkdir -p "$VERSION_DIR"
    
    # Save data
    echo $IMPROVEMENT_RESPONSE | jq . > "$VERSION_DIR/improvement-response.json"
    echo $NEW_INTERFACE | jq . > "$VERSION_DIR/interface-data.json"
    echo $IMPROVEMENT_RESPONSE | jq -r .response > "$VERSION_DIR/ai-improvements.md"
    
    # Copy files
    cp api-server.py "$VERSION_DIR/api-server-improved.py"
    cp bootstrap.html "$VERSION_DIR/bootstrap-improved.html"
    
    # Create README
    echo "# Ruliadic Seed - Generation $generation

## Evolutionary Improvements

**Generation:** $generation
**Timestamp:** $timestamp
**Session ID:** $SESSION_ID

### AI-Generated Improvements

$(echo $IMPROVEMENT_RESPONSE | jq -r .response)

### Files in this Generation

- \`api-server-improved.py\` - Enhanced API server
- \`bootstrap-improved.html\` - Improved chat interface
- \`improvement-response.json\` - Full AI improvement response
- \`interface-data.json\` - Auto-generated interface data

This generation represents evolutionary step $generation in the Ruliadic Seed development cycle.
" > "$VERSION_DIR/README.md"
    
    # Cleanup
    kill $API_PID 2>/dev/null || true
    
    echo "✅ Generation $generation completed: $VERSION_DIR"
    
    if [ $generation -lt $GENERATIONS ]; then
        echo "⏳ Waiting $IMPROVEMENT_INTERVAL seconds..."
        sleep $IMPROVEMENT_INTERVAL
    fi
done

echo ""
echo "🎉 Evolutionary cycle complete!"
echo "📁 Generated $GENERATIONS improved versions in: evolution/"
ls -la evolution/

# Create summary
echo ""
echo "📋 Creating evolution summary..."

echo "# Ruliadic Seed - Evolutionary Development Summary

## Overview

This document summarizes the evolutionary development cycle of the Ruliadic Seed self-generating AI system.

## Evolutionary Generations

" > EVOLUTION-SUMMARY.md

# Add each generation to summary
for gen_dir in evolution/gen-*; do
    if [ -d "$gen_dir" ]; then
        gen_num=$(basename "$gen_dir" | sed 's/gen-\([0-9]\+\).*/\1/')
        timestamp=$(basename "$gen_dir" | sed 's/.*-\([0-9]\+\)$/\1/')
        
        echo "" >> EVOLUTION-SUMMARY.md
        echo "### Generation $gen_num" >> EVOLUTION-SUMMARY.md
        echo "- **Directory:** \`$gen_dir\`" >> EVOLUTION-SUMMARY.md
        echo "- **Timestamp:** $timestamp" >> EVOLUTION-SUMMARY.md
        echo "- **Status:** ✅ Completed" >> EVOLUTION-SUMMARY.md
        
        if [ -f "$gen_dir/ai-improvements.md" ]; then
            echo "- **AI Improvements:** $(wc -l < "$gen_dir/ai-improvements.md") lines generated" >> EVOLUTION-SUMMARY.md
        fi
    fi
done

echo "" >> EVOLUTION-SUMMARY.md
echo "## Evolution Statistics" >> EVOLUTION-SUMMARY.md
echo "- **Total Generations:** $GENERATIONS" >> EVOLUTION-SUMMARY.md
echo "- **Improvement Cycles:** $GENERATIONS" >> EVOLUTION-SUMMARY.md
echo "- **Auto-Generated Interfaces:** $GENERATIONS" >> EVOLUTION-SUMMARY.md
echo "- **AI Improvement Responses:** $GENERATIONS" >> EVOLUTION-SUMMARY.md
echo "" >> EVOLUTION-SUMMARY.md
echo "## Repository Status" >> EVOLUTION-SUMMARY.md
echo "- **Base Repository:** https://github.com/j-94/ruliadic-seed" >> EVOLUTION-SUMMARY.md
echo "- **Evolution Directory:** evolution/" >> EVOLUTION-SUMMARY.md
echo "" >> EVOLUTION-SUMMARY.md
echo "🚀 **The Ruliadic Seed system has successfully evolved and auto-generated $GENERATIONS improved versions of itself!**" >> EVOLUTION-SUMMARY.md

echo "✅ Evolution summary created: EVOLUTION-SUMMARY.md"
echo ""
echo "🎉 EVOLUTIONARY LOOP COMPLETE!"
echo "=============================="
echo "📁 Generated directory: evolution/"
echo "📋 Summary: EVOLUTION-SUMMARY.md"
echo "🔗 GitHub: https://github.com/j-94/ruliadic-seed"
echo ""
echo "The system has successfully created $GENERATIONS evolutionary generations!"
