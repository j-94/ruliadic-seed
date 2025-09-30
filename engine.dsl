# One Engine DSL - Endpoint and Handler Definitions
# Generated: 2025-09-30 08:23 UTC

# Core engine endpoints
endpoints {
    # Health and status
    "/healthz" = "health_handler"
    "/health" = "health_handler"
    "/version" = "version_handler"
    "/metrics" = "metrics_handler"

    # Core tau endpoint (main interface)
    "/tau" = "tau_handler"

    # Codex agent integration
    "/codex" = "codex_handler"

    # Task execution
    "/execute" = "execute_handler"
    "/execute/{task_id}" = "execute_status_handler"

    # Pattern mining and analysis
    "/mine" = "mine_handler"
    "/patterns" = "patterns_handler"
    "/patterns/{pattern_id}" = "pattern_detail_handler"

    # Seed and configuration
    "/seed" = "seed_handler"
    "/config" = "config_handler"

    # UI endpoints
    "/ui" = "ui_handler"
    "/ui/{path}" = "ui_static_handler"

    # Development and debugging
    "/debug" = "debug_handler"
    "/debug/{component}" = "debug_component_handler"
}

# Handler definitions
handlers {
    # Health and monitoring
    health_handler = """
        Returns engine health status and basic metrics.

        Response format:
        {
            "status": "healthy|degraded|unhealthy",
            "timestamp": "ISO8601",
            "version": "engine_version",
            "uptime_seconds": 123,
            "active_tasks": 5,
            "memory_usage_mb": 256
        }
    """

    version_handler = """
        Returns engine version and build information.

        Response format:
        {
            "version": "1.0.0",
            "build_date": "2025-09-30",
            "git_commit": "abc123...",
            "rust_version": "1.80.0",
            "features": ["codex", "tau", "patterns"]
        }
    """

    metrics_handler = """
        Returns comprehensive engine metrics and KPIs.

        Response format:
        {
            "timestamp": "ISO8601",
            "kpis": {
                "decision_agreement": 0.95,
                "cost_per_decision": 0.005,
                "token_ratio": 0.85,
                "time_to_emergence": 25.5
            },
            "counters": {
                "total_requests": 150,
                "successful_executions": 145,
                "failed_executions": 5,
                "cache_hits": 30
            }
        }
    """

    # Main tau handler (core functionality)
    tau_handler = """
        Main interface for tau operations (τ single stepper).

        Request format:
        {
            "input": "user prompt or goal",
            "preset": "fiveline|organise|improve|codex",
            "context": {
                "conversation_id": "optional",
                "parent_task_id": "optional",
                "metadata": {}
            },
            "options": {
                "stream": false,
                "format": "json|text|markdown",
                "temperature": 0.1,
                "max_tokens": 120000
            }
        }

        Response format:
        {
            "run_id": "unique_identifier",
            "status": "completed|streaming|error",
            "result": {
                "output": "generated content",
                "metadata": {
                    "tokens_used": 150,
                    "cost_usd": 0.002,
                    "processing_time_ms": 1250
                },
                "artifacts": [
                    {
                        "type": "file",
                        "path": "generated/file.py",
                        "content": "file content...",
                        "purpose": "implementation"
                    }
                ]
            },
            "bits": {
                "A": 1, "U": 0, "P": 1, "E": 0, "Δ": 0, "I": 0, "R": 0, "T": 1
            }
        }
    """

    # Codex agent handler (drop-in code generation)
    codex_handler = """
        Drop-in Codex-like agent for code generation tasks.

        Request format:
        {
            "prompt": "Write a Python function to calculate fibonacci numbers",
            "language": "python|javascript|rust|go|java|cpp",
            "context": {
                "project_type": "web|cli|library|api",
                "framework": "fastapi|express|axum|gin",
                "existing_code": "optional existing code for context"
            },
            "requirements": {
                "generate_tests": true,
                "include_documentation": true,
                "follow_style_guide": "pep8|eslint|rustfmt",
                "max_complexity": "medium"
            },
            "safety": {
                "allow_network": false,
                "allow_file_system": true,
                "require_review": false,
                "max_risk": "low"
            }
        }

        Response format:
        {
            "run_id": "codex_unique_id",
            "status": "completed|review_required|blocked",
            "result": {
                "code": "generated code content",
                "explanation": "what the code does and why",
                "files": [
                    {
                        "name": "fibonacci.py",
                        "content": "def fibonacci_recursive(n): ...",
                        "type": "implementation"
                    },
                    {
                        "name": "test_fibonacci.py",
                        "content": "def test_fibonacci(): ...",
                        "type": "test"
                    }
                ],
                "dependencies": ["typing", "pytest"],
                "installation_commands": ["pip install pytest"]
            },
            "safety_check": {
                "passed": true,
                "risk_level": "low",
                "concerns": [],
                "approvals_required": false
            },
            "coged_gen": {
                "plan": "Step 1: Analyze requirements...",
                "draft": "Initial code structure...",
                "critique": "Code review and improvements...",
                "refined": "Final optimized version..."
            }
        }
    """

    # Task execution handlers
    execute_handler = """
        Execute a predefined task or goal.

        Request format:
        {
            "goal": "Human-readable goal description",
            "task_type": "code_generation|analysis|refactoring|testing",
            "parameters": {
                "language": "python",
                "complexity": "medium",
                "output_format": "files|single_block|explanation"
            }
        }
    """

    execute_status_handler = """
        Check status of a running or completed task.

        Path parameters:
        - task_id: UUID of the task to check

        Response includes current status, progress, and results if complete.
    """

    # Pattern mining handlers
    mine_handler = """
        Mine for emergent patterns in codebase and conversation history.

        Request format:
        {
            "sources": ["../**/*.md", "../**/*.json", "../**/*.rs"],
            "patterns": ["coged", "map-reduce", "agentic", "graphlogue"],
            "output_format": "summary|detailed|files"
        }
    """

    patterns_handler = """
        List all discovered patterns and their metadata.

        Query parameters:
        - format: json|text|markdown
        - limit: max number of patterns to return
        - category: filter by pattern category
    """

    pattern_detail_handler = """
        Get detailed information about a specific pattern.

        Path parameters:
        - pattern_id: ID of the pattern (e.g., "coged-gen", "map-reduce")
    """

    # Configuration handlers
    seed_handler = """
        Manage seed configuration and bootstrap settings.

        GET: Return current seed configuration
        POST: Update seed configuration
        PUT: Reset to default seed configuration
    """

    config_handler = """
        Get or update engine configuration.

        GET: Return current configuration
        POST: Update configuration (requires admin privileges)
    """

    # UI handlers
    ui_handler = """
        Serve the main UI interface.

        Returns the main HTML interface for the engine.
    """

    ui_static_handler = """
        Serve static UI assets.

        Path parameters:
        - path: Path to the static asset (css, js, images, etc.)
    """

    # Development handlers
    debug_handler = """
        General debugging endpoint for development.

        Returns system status, recent logs, and debug information.
    """

    debug_component_handler = """
        Debug a specific engine component.

        Path parameters:
        - component: Component to debug (tau, codex, patterns, config)
    """
}

# Policy and gate definitions
policies {
    # Default policy for all endpoints
    default_policy = """
        Apply to all requests unless overridden:
        - Rate limiting: 100 requests per minute per IP
        - Timeout: 30 seconds for completion
        - Logging: All requests logged with sanitized parameters
        - Caching: Responses cached for 5 minutes where appropriate
    """

    # Codex-specific policies
    codex_policy = """
        Additional policies for /codex endpoint:
        - Code quality gates: Enforce minimum test coverage (80%)
        - Security scanning: Check for common vulnerabilities
        - Complexity limits: Cyclomatic complexity < 10
        - Size limits: Generated files < 1000 lines each
        - Language restrictions: Only allow approved languages
        - Network access: Block unless explicitly required
        - File system access: Limited to project directories only
    """

    # Pattern mining policies
    mining_policy = """
        Policies for pattern mining operations:
        - Source restrictions: Only scan approved directories
        - Pattern limits: Maximum 100 patterns per scan
        - Performance: Timeout after 60 seconds
        - Output sanitization: Remove sensitive information from results
    """

    # Safety gates (CEL expressions)
    safety_gates = """
        // Ask/Act Gate: execute only if A==1 ∧ P==1 ∧ Δ==0
        ask_act_gate: request.alignment.A == 1 && request.permission.P == 1 && request.context.Δ == 0

        // Evidence Gate: if U==1, gather evidence before T==1
        evidence_gate: request.uncertainty.U == 0 || (request.evidence_gathered == true && request.trust.T == 1)

        // Caps Gate: sensitive caps require P==1 with human preview
        caps_gate: request.capabilities.sensitive == false || (request.capabilities.sensitive == true && request.human_preview == true)

        // Freshness Gate: if Δ==1, re-ground context before acting
        freshness_gate: request.context.Δ == 0 || request.context.regrounded == true
    """
}

# Task templates and presets
tasks {
    # Coged-gen task template
    coged_gen_template = """
        Cognitive code generation with plan/draft/critique loop:

        1. Analyze requirements and constraints
        2. Plan the implementation approach
        3. Draft initial code solution
        4. Critique and identify improvements
        5. Refine and optimize the solution
        6. Apply safety and quality gates
        7. Generate final deliverables
    """

    # Map-reduce task template
    map_reduce_template = """
        Parallel processing with fanout/fanin pattern:

        1. Divide task into independent subtasks
        2. Execute subtasks in parallel
        3. Collect and validate subtask results
        4. Reduce/merge results into unified output
        5. Verify final result meets requirements
    """

    # Agentic system template
    agentic_template = """
        Multi-agent coordination with roles:

        1. Planner: Analyze and break down requirements
        2. Coder: Implement the planned solution
        3. Critic: Review and identify issues
        4. Executor: Apply approved changes
        5. Monitor: Track progress and metrics
    """
}

# Integration points
integrations {
    # OpenRouter API integration
    openrouter = """
        Provider: OpenRouter (https://openrouter.ai/api/v1)
        Models: gpt-4o-mini, claude-3.5-sonnet, deepseek-coder
        Authentication: Bearer token from OPENROUTER_API_KEY
        Rate limits: Respect provider limits and implement backoff
    """

    # GitHub API integration
    github = """
        Provider: GitHub API (https://api.github.com)
        Authentication: Personal access token or OAuth app
        Capabilities: PR creation, file operations, issue management
        Rate limits: 5000 requests per hour for authenticated users
    """

    # Local file system integration
    filesystem = """
        Provider: Local file system
        Root paths: ./, receipts/, deliverables/
        Operations: read, write, list, stat
        Restrictions: No access to sensitive directories
    """
}

# Monitoring and observability
observability {
    # Metrics collection
    metrics = """
        Collect and expose metrics:
        - Request count and latency by endpoint
        - Error rates and types
        - Resource usage (CPU, memory, disk)
        - Cache hit rates
        - API rate limit status
    """

    # Logging configuration
    logging = """
        Structured logging with levels:
        - ERROR: Request failures, exceptions, timeouts
        - WARN: Rate limit warnings, deprecated features
        - INFO: Request completion, major state changes
        - DEBUG: Detailed execution traces, variable values
    """

    # Tracing
    tracing = """
        Distributed tracing for request flow:
        - Request ID propagation
        - Component timing breakdown
        - External API call tracing
        - Error context and stack traces
    """
}

# Development and testing
development {
    # Test endpoints (only available in development mode)
    test_endpoints = """
        /test/*: Test-only endpoints for development
        /debug/*: Debug endpoints for troubleshooting
        /mock/*: Mock external services for testing
    """

    # Development tools
    dev_tools = """
        Hot reload: Watch for file changes and reload
        Debug logging: Verbose logging for development
        Test coverage: Track test coverage for handlers
        Performance profiling: Built-in profiler for optimization
    """
}