#!/bin/bash
# One Engine Seed Script - Turnkey bootstrap for complete AI orchestration system
# Usage: ./seed.sh [install|configure|start|verify|all]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SEED_DIR="$SCRIPT_DIR"
LOG_FILE="$SEED_DIR/deliverables/seed.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Utility functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

# Create directories
setup_directories() {
    log "Setting up directories..."
    mkdir -p "$SEED_DIR/deliverables"
    mkdir -p "$SEED_DIR/patterns"
    mkdir -p "$SEED_DIR/receipts"
    mkdir -p "$SEED_DIR/.oneengine"
    success "Directories created"
}

# Install dependencies
install_dependencies() {
    log "Installing dependencies..."

    # Check if running on macOS or Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! command -v brew &> /dev/null; then
            error "Homebrew not found. Please install Homebrew first: https://brew.sh/"
        fi

        # Install CLI dependencies
        local deps=("curl" "jq" "fzf" "ripgrep" "bat" "git" "netcat")
        for dep in "${deps[@]}"; do
            if ! command -v "$dep" &> /dev/null; then
                log "Installing $dep..."
                brew install "$dep" || warning "Failed to install $dep (may already be installed)"
            else
                success "$dep already installed"
            fi
        done
    else
        # Linux
        if command -v apt-get &> /dev/null; then
            log "Using apt-get for installation..."
            sudo apt-get update
            sudo apt-get install -y curl jq fzf ripgrep bat git netcat-openbsd
        elif command -v yum &> /dev/null; then
            log "Using yum for installation..."
            sudo yum install -y curl jq fzf ripgrep bat git nc
        else
            warning "Unsupported package manager. Please install manually: curl, jq, fzf, ripgrep, bat, git, netcat"
        fi
    fi

    success "Dependencies installed"
}

# Configure engines
configure_engines() {
    log "Configuring engines..."

    # Set up ports.env if it doesn't exist
    local ports_file="$SEED_DIR/.oneengine/ports.env"
    if [[ ! -f "$ports_file" ]]; then
        cat > "$ports_file" << EOF
# One Engine Port Configuration
ENGINE_PORT=8080
META2_PORT=8080
BLOB_PROCESSOR_PORT=8888
UI_PORT=8080

# Network settings
ENGINE_HOST=127.0.0.1
ALLOWED_ORIGINS=http://127.0.0.1:8080,http://localhost:8080
EOF
        success "Created ports.env"
    else
        success "ports.env already exists"
    fi

    # Set up kernel.json if it doesn't exist
    local kernel_file="$SEED_DIR/.oneengine/kernel.json"
    if [[ ! -f "$kernel_file" ]]; then
        # Use envelope.json as base if it exists
        if [[ -f "$SEED_DIR/.oneengine/envelope.json" ]]; then
            cp "$SEED_DIR/.oneengine/envelope.json" "$kernel_file"
            success "Created kernel.json from envelope.json"
        else
            # Create minimal kernel.json
            cat > "$kernel_file" << EOF
{
  "model": {
    "id": "gpt-4o-mini",
    "max_tokens": 120000
  },
  "safety": {
    "net_allow": ["api.github.com", "127.0.0.1"]
  },
  "alignment": {
    "preview_by_default": true,
    "allowed_shell_paths": ["./", "receipts/", "deliverables/"],
    "kpi": ["decision_agreement", "cost_per_decision", "token_ratio"]
  }
}
EOF
            success "Created minimal kernel.json"
        fi
    else
        success "kernel.json already exists"
    fi

    success "Engine configuration complete"
}

# Start engines
start_engines() {
    log "Starting engines..."

    # Check if engines are already running
    if nc -z 127.0.0.1 8080 2>/dev/null; then
        warning "Engine appears to be running on port 8080"
        return 0
    fi

    # Try to find and start One Engine
    if [[ -f "$PROJECT_ROOT/one-engine/target/release/one-engine" ]]; then
        log "Starting One Engine (release)..."
        nohup "$PROJECT_ROOT/one-engine/target/release/one-engine" \
            --port 8080 \
            --host 127.0.0.1 \
            --memory-path "$SEED_DIR/memory" \
            --allowed-domains httpbin.org,api.github.com,jsonplaceholder.typicode.com \
            > "$SEED_DIR/deliverables/engine.log" 2>&1 &
        ENGINE_PID=$!
        echo $ENGINE_PID > "$SEED_DIR/deliverables/engine.pid"
    elif [[ -f "$PROJECT_ROOT/one-engine/target/debug/one-engine" ]]; then
        log "Starting One Engine (debug)..."
        nohup "$PROJECT_ROOT/one-engine/target/debug/one-engine" \
            --port 8080 \
            --host 127.0.0.1 \
            --memory-path "$SEED_DIR/memory" \
            --allowed-domains httpbin.org,api.github.com,jsonplaceholder.typicode.com \
            > "$SEED_DIR/deliverables/engine.log" 2>&1 &
        ENGINE_PID=$!
        echo $ENGINE_PID > "$SEED_DIR/deliverables/engine.pid"
    else
        warning "One Engine binary not found. Please build it first or run manually."
        return 0
    fi

    # Wait for engine to start
    log "Waiting for engine to start..."
    for i in {1..30}; do
        if nc -z 127.0.0.1 8080 2>/dev/null; then
            success "Engine started successfully on port 8080"
            return 0
        fi
        sleep 1
    done

    warning "Engine may not have started properly. Check logs: $SEED_DIR/deliverables/engine.log"
}

# Verify setup
verify_setup() {
    log "Verifying setup..."

    # Test engine connectivity
    if nc -z 127.0.0.1 8080 2>/dev/null; then
        success "Engine is responding on port 8080"

        # Test basic endpoints
        if curl -s http://127.0.0.1:8080/healthz > /dev/null 2>&1; then
            success "Health endpoint responding"
        elif curl -s http://127.0.0.1:8080/health > /dev/null 2>&1; then
            success "Alternative health endpoint responding"
        else
            warning "Health endpoint not found - may need endpoint configuration"
        fi
    else
        warning "Engine not responding on port 8080"
    fi

    # Test tau client
    if [[ -x "$SEED_DIR/bin/tau" ]]; then
        success "Tau client available"
    else
        warning "Tau client not found or not executable"
    fi

    # Test experience miner
    if [[ -x "$SEED_DIR/bin/mine_experiences.sh" ]]; then
        success "Experience miner available"
    else
        warning "Experience miner not found"
    fi

    # Check for API keys
    if [[ -f "$SEED_DIR/.oneengine/kernel.json" ]]; then
        if grep -q "sk-or-v1\|sk-proj" "$SEED_DIR/.oneengine/kernel.json" 2>/dev/null; then
            success "API keys configured in kernel.json"
        else
            warning "No API keys found in kernel.json - LM fallback may not work"
        fi
    fi

    success "Verification complete"
}

# Generate proof artifacts
generate_proofs() {
    log "Generating proof artifacts..."

    local proof_file="$SEED_DIR/deliverables/bootstrap_proof.json"

    cat > "$proof_file" << EOF
{
  "bootstrap_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "seed_version": "1.0.0",
  "components_configured": {
    "engines": $(nc -z 127.0.0.1 8080 2>/dev/null && echo "true" || echo "false"),
    "dependencies": $(command -v curl jq fzf rg bat git nc 2>/dev/null | wc -l),
    "ports_configured": $([[ -f "$SEED_DIR/.oneengine/ports.env" ]] && echo "true" || echo "false"),
    "kernel_configured": $([[ -f "$SEED_DIR/.oneengine/kernel.json" ]] && echo "true" || echo "false"),
    "patterns_available": $([[ -f "$SEED_DIR/bin/mine_experiences.sh" ]] && echo "true" || echo "false")
  },
  "next_steps": [
    "Run: cd $SEED_DIR && ./bin/tau fiveline",
    "Visit: http://127.0.0.1:8080/",
    "Mine patterns: ./bin/mine_experiences.sh all",
    "View docs: cat TASK_PLAYBOOK.md"
  ],
  "success_criteria": {
    "engine_responding": $(nc -z 127.0.0.1 8080 2>/dev/null && echo "true" || echo "false"),
    "tau_functional": $([[ -x "$SEED_DIR/bin/tau" ]] && echo "true" || echo "false"),
    "proofs_generated": "true"
  }
}
EOF

    success "Proof artifacts generated: $proof_file"

    # Create summary
    echo ""
    echo -e "${GREEN}🎉 Bootstrap Complete!${NC}"
    echo ""
    echo "📋 Next Steps:"
    echo "  1. Test basic functionality: cd $SEED_DIR && ./bin/tau fiveline"
    echo "  2. Visit the UI: http://127.0.0.1:8080/"
    echo "  3. Mine for patterns: ./bin/mine_experiences.sh all"
    echo "  4. Read the playbook: cat TASK_PLAYBOOK.md"
    echo ""
    echo "📊 Proof artifacts saved to: $SEED_DIR/deliverables/"
    echo "📜 Full log available at: $LOG_FILE"
}

# Main command dispatcher
main() {
    # Create log file
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"

    echo -e "${BLUE}"
    echo "🚀 One Engine Seed Bootstrap"
    echo "==========================="
    echo -e "${NC}"

    local cmd="${1:-all}"

    case "$cmd" in
        "install")
            setup_directories
            install_dependencies
            ;;
        "configure")
            setup_directories
            configure_engines
            ;;
        "start")
            start_engines
            ;;
        "verify")
            verify_setup
            ;;
        "all")
            setup_directories
            install_dependencies
            configure_engines
            start_engines
            verify_setup
            generate_proofs
            ;;
        "help"|"-h"|"--help")
            cat << EOF
One Engine Seed Script - Complete bootstrap automation

USAGE:
    $0 [COMMAND]

COMMANDS:
    install     Install system dependencies (curl, jq, fzf, etc.)
    configure   Set up engine configuration files
    start       Start the engines (requires built binary)
    verify      Verify all components are working
    all         Run complete bootstrap (install → configure → start → verify)

EXAMPLES:
    $0 all                    # Complete bootstrap
    $0 install && $0 configure # Step-by-step setup
    $0 verify                 # Check existing setup

REQUIREMENTS:
    - bash shell
    - curl, git (for cloning if needed)
    - Rust (for building one-engine if needed)

OUTPUT:
    deliverables/              # Proof artifacts and logs
    .oneengine/               # Configuration files
    receipts/                 # Execution records

NEXT STEPS AFTER BOOTSTRAP:
    cd $SEED_DIR
    ./bin/tau fiveline        # Test basic functionality
    ./bin/mine_experiences.sh # Discover patterns
    open http://127.0.0.1:8080 # View UI
EOF
            ;;
        *)
            error "Unknown command: $cmd. Use 'help' for usage information."
            ;;
    esac
}

# Run main function with all arguments
main "$@"