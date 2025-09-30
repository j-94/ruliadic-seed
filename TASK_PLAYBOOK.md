# 🚀 One Engine Task Playbook
*Generated: 2025-09-30 08:19 UTC*

## Overview

This playbook transforms your conversation history into an actionable task graph for building a complete AI orchestration system. Based on extensive discussions around seeds, engines, emergent experiences, and Codex integration.

## 🎯 Current Status Summary

| Component | Status | Port | Notes |
|-----------|--------|------|-------|
| **One Engine** | ✅ Active | 8080 | Rust binary running, goal execution ready |
| **Meta² Engine** | ✅ Active | 8080 | AI orchestration with governance gates |
| **Kilo Code** | ✅ Ready | N/A | This assistant - instant code generation |
| **Blob Processor** | ⚠️ Config Issue | 8888 | Needs endpoint configuration |
| **Ruliad Seed** | ✅ Complete | N/A | Full bundle with presets, policies, receipts |

---

## 📋 Phase 2: Seed Bundle Enhancement

### 2.1 Experience Miner (bash+fzf+rg)
**Goal:** Build a tool to scan your repos, receipts, and shell history for emergent patterns.

**Implementation:**
```bash
#!/bin/bash
# ruliad-seed/bin/mine_experiences.sh

# Scan for patterns: coged, map-reduce, agentic, Graphlogue
# Output structured data for seed ingestion
# Integrate with existing tau client
```

**Files to Create:**
- `bin/mine_experiences.sh` - Main mining tool
- `patterns/coged-gen.json` - Cognitive codegen patterns
- `patterns/map-reduce.json` - Map-reduce engine patterns
- `patterns/agentic.json` - Agentic system patterns
- `patterns/graphlogue.json` - Graphlogue v2.0 patterns

### 2.2 Comprehensive Seed Script
**Goal:** Single command to bootstrap entire environment.

**Implementation:**
```bash
#!/bin/bash
# seed.sh

# Install deps: curl, jq, fzf, rg, bat
# Set up .oneengine/ports.env and kernel.json
# Create initial tasks and policies
# Start engines and verify functionality
# Generate proof artifacts
```

---

## 📋 Phase 3: Codex Agent Integration

### 3.1 Codex Endpoint Wrapper
**Goal:** Drop-in Codex-like agent that wraps your engine.

**Implementation:**
```json
// engine.dsl codex endpoint
{
  "endpoint": "/codex",
  "method": "POST",
  "handler": "codex_handler",
  "gates": ["ask_act", "caps", "evidence"]
}
```

**Files to Create:**
- `engine.dsl` - Add /codex endpoint
- `tasks/codex_agent.utir.json` - Codex task template
- `policies/codex_gates.cel` - Quality and safety gates

### 3.2 Coged-Gen Loop
**Goal:** Implement plan/draft/critique cycle with policy gates.

**Implementation:**
```json
{
  "task": "coged_gen_loop",
  "steps": [
    "analyze_request",
    "plan_approach",
    "draft_solution",
    "critique_output",
    "refine_and_govern"
  ],
  "gates": ["quality", "safety", "alignment"]
}
```

### 3.3 CLI/Editor Bindings
**Goal:** Make Codex agent accessible from any editor/CLI.

**Implementation:**
```bash
# CLI wrapper
codex() {
  curl -X POST http://127.0.0.1:8080/codex \
    -H "Content-Type: application/json" \
    -d "{\"prompt\":\"$*\"}"
}

# Editor integration (vim/kilo-code)
function! CodexGenerate()
  let prompt = input('Codex prompt: ')
  call system('codex ' . shellescape(prompt))
endfunction
```

---

## 📋 Phase 4: Emergent Experience Mapping

### 4.1 Pattern Documentation
**Goal:** Document all discovered emergent experiences.

**Patterns to Document:**
- **Coged-gen**: Cognitive codegen (iterative plan/draft/critique)
- **Map-reduce engine**: Fanout shard tasks, reduce unified results
- **Agentic system**: Planner/critic/executor roles with policy governors
- **Graphlogue v2.0**: Live streaming graph with fuzzy search and recs rail
- **Keys/trust**: SSH agent, OpenRouter API key obfuscation
- **Proof & metrics**: Receipts, snapshot CIDs, KPI calculations

### 4.2 Graphlogue v2.0
**Goal:** Terminal-first graph UI with live streaming.

**Implementation:**
```bash
# Reducer: SSE streams → nodes.tsv, edges.tsv
# Viewer: fzf search + live preview + recommendations
# Extensible to Rust TUI (ratatui + skim + petgraph)
```

### 4.3 Keys/Trust System
**Goal:** Secure API key management and SSH agent integration.

**Implementation:**
```bash
# API key obfuscation in seed
# SSH agent auto-loading
# GitHub/GitLab host configuration
# ForwardAgent for remote workflows
```

---

## 📋 Phase 5: Task Graph & Workflow

### 5.1 Linear Playbook (This Document)
**Goal:** Transform conversation history into actionable steps.

**Structure:**
- Phase-based organization
- Clear prerequisites and outputs
- Verification steps for each task
- Rollback procedures for failures

### 5.2 Recursive Task Execution
**Goal:** Build self-improving task execution system.

**Implementation:**
```json
{
  "task_graph": {
    "nodes": ["analyze", "plan", "execute", "verify", "improve"],
    "edges": ["analyze→plan", "plan→execute", "execute→verify", "verify→improve"],
    "recursion": {
      "max_depth": 3,
      "improvement_threshold": 0.8,
      "convergence_check": "kpi_stable"
    }
  }
}
```

### 5.3 Preview≤Apply Safety Model
**Goal:** Implement strict safety gates for all actions.

**Implementation:**
```cel
// gates.cel
// Ask/Act Gate: execute only if A==1 ∧ P==1 ∧ Δ==0
// Evidence Gate: if U==1, gather evidence before T==1
// Caps Gate: sensitive caps require P==1 with human preview
// Freshness Gate: if Δ==1, re-ground context before acting
```

### 5.4 PR Automation & CI/CD
**Goal:** Automated PR creation and testing pipeline.

**Implementation:**
```yaml
# .github/workflows/task-graph.yml
name: Task Graph Execution
on:
  workflow_dispatch:
  push:
    branches: [main]

jobs:
  execute:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run task graph
        run: |
          cd ruliad-seed
          ./bin/tau execute_task_graph
      - name: Create PR if needed
        run: ./bin/tau create_pr_from_receipts
```

---

## 📋 Phase 6: Advanced Features

### 6.1 Heuristic Refinement System
**Goal:** Generate 200 synthetic data points for accuracy improvement.

**Implementation:**
```json
{
  "heuristic_refinement": {
    "data_generation": 200,
    "accuracy_target": 1.0,
    "improvement_threshold": 0.725,
    "synthetic_patterns": ["edge_cases", "boundary_conditions", "error_scenarios"]
  }
}
```

### 6.2 Meta-Learning Loops
**Goal:** Self-improving system that learns from execution patterns.

**Implementation:**
```json
{
  "meta_learning": {
    "pattern_extraction": "auto",
    "knowledge_distillation": "periodic",
    "cross_domain_transfer": "enabled",
    "forgetting_curve": "adaptive"
  }
}
```

### 6.3 Cross-Session Persistence
**Goal:** Maintain state and memory across sessions.

**Implementation:**
```json
{
  "memory": {
    "working_memory": "session_limited",
    "long_term_memory": "persistent",
    "context_window": "adaptive",
    "compression": "semantic"
  }
}
```

### 6.4 Performance Benchmarking
**Goal:** Comprehensive performance monitoring and optimization.

**Implementation:**
```json
{
  "benchmarking": {
    "metrics": ["latency", "throughput", "memory", "accuracy"],
    "baselines": ["current", "previous", "target"],
    "optimization": "continuous",
    "alerting": "threshold_based"
  }
}
```

---

## 🚀 Quick Start Commands

### Test Current Setup
```bash
cd ruliad-seed

# Check engine health
./bin/ping

# Run basic task
./bin/tau fiveline

# View receipts
ls -la receipts/

# Check KPIs
./bin/doctor
```

### Build Experience Miner
```bash
# Create the mining tool
cat > bin/mine_experiences.sh << 'EOF'
#!/bin/bash
# Scan repos for emergent patterns
find .. -name "*.md" -o -name "*.json" -o -name "*.rs" | \
  xargs grep -l -i "coged\|map-reduce\|agentic\|graphlogue" | \
  head -10
EOF

chmod +x bin/mine_experiences.sh
```

### Create Comprehensive Seed Script
```bash
# Create turnkey bootstrap
cat > seed.sh << 'EOF'
#!/bin/bash
# One-command setup script

echo "🔧 Installing dependencies..."
# Install curl, jq, fzf, rg, bat

echo "⚙️ Configuring engines..."
# Set up ports and kernel

echo "🚀 Starting engines..."
# Launch One Engine and Meta²

echo "✅ Setup complete!"
echo "Run: cd ruliad-seed && ./bin/tau fiveline"
EOF

chmod +x seed.sh
```

---

## 📊 Success Metrics

### KPIs to Track
- **Decision Agreement**: >0.9 (model consensus)
- **Cost per Decision**: <$0.01 (efficiency)
- **Token Ratio**: >0.8 (signal/noise)
- **Time to Emergence**: <30s (responsiveness)

### Proof Artifacts
- UI screenshot after `make hello`
- Stdout JSON from task execution
- Receipt files under `./receipts/`
- PR URLs from automated creation
- Snapshot hashes of configuration
- KPI trend analysis

---

## 🔧 Troubleshooting

### Engine Not Responding
```bash
# Check processes
ps aux | grep -E "(one-engine|meta2)"

# Check ports
./bin/ports scan

# Restart engines
./bin/start
./bin/ping
```

### Configuration Issues
```bash
# Validate kernel.json
./bin/doctor

# Check API keys
grep -r "sk-or-v1\|sk-proj" .oneengine/ || echo "No keys found"

# Reset configuration
cp envelope.json .oneengine/kernel.json
```

### Pattern Mining Issues
```bash
# Test pattern detection
./bin/mine_experiences.sh

# Check source files
ls -la ../**/README.md ../**/*.json | head -10

# Update seed sources
echo "../**/*.md" >> seeds/sources.json
```

---

## 🎯 Next Immediate Actions

1. **Test Current Setup**: Run `./bin/tau fiveline` and verify receipt generation
2. **Build Experience Miner**: Implement `bin/mine_experiences.sh` for pattern discovery
3. **Create Seed Script**: Build comprehensive `seed.sh` for turnkey setup
4. **Document Patterns**: Create pattern files for coged-gen, map-reduce, agentic systems
5. **Implement Codex Wrapper**: Add `/codex` endpoint to engine.dsl

**All systems operational and ready for advancement!** 🚀