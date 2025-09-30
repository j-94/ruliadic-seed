#!/bin/bash
# ChatLoop Seed Generator - Create portable, injectable versions for any system
# Usage: ./generate-seed.sh [target-system] [output-format] [options]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEED_DIR="$SCRIPT_DIR/seeds"
OUTPUT_DIR="$SEED_DIR/generated"
CHATLOOP_SOURCE="$SCRIPT_DIR/chatloop.html"

# Create directories
mkdir -p "$SEED_DIR"
mkdir -p "$OUTPUT_DIR"

# Seed configuration templates (using simple arrays for compatibility)
SYSTEM_TEMPLATES_WEB="web-embeddable"
SYSTEM_TEMPLATES_NODE="nodejs-module"
SYSTEM_TEMPLATES_PYTHON="python-flask"
SYSTEM_TEMPLATES_REACT="react-component"
SYSTEM_TEMPLATES_VSCODE="vscode-extension"
SYSTEM_TEMPLATES_CHROME="chrome-extension"
SYSTEM_TEMPLATES_ELECTRON="electron-app"
SYSTEM_TEMPLATES_DOCKER="docker-container"
SYSTEM_TEMPLATES_STATIC="static-files"
SYSTEM_TEMPLATES_MINIMAL="core-interface"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# System detection and alignment
detect_system() {
    echo -e "${BLUE}🔍 Detecting target system...${NC}"

    # Check for common system indicators
    if [[ -n "${1:-}" ]]; then
        TARGET_SYSTEM="$1"
    else
        # Auto-detect based on environment
        if [[ -n "${NODE_ENV:-}" ]] || command -v node >/dev/null 2>&1; then
            TARGET_SYSTEM="node"
        elif [[ -n "${PYTHONPATH:-}" ]] || command -v python3 >/dev/null 2>&1; then
            TARGET_SYSTEM="python"
        elif [[ -d "node_modules" ]] && [[ -f "package.json" ]]; then
            TARGET_SYSTEM="react"
        elif [[ -d ".vscode" ]]; then
            TARGET_SYSTEM="vscode"
        elif [[ -f "Dockerfile" ]] || [[ -n "${DOCKER_CONTAINER:-}" ]]; then
            TARGET_SYSTEM="docker"
        else
            TARGET_SYSTEM="web"
        fi
    fi

    echo -e "${GREEN}✅ Detected/Using system: $TARGET_SYSTEM${NC}"
}

# Generate minimal core interface
generate_core_seed() {
    echo -e "${BLUE}🏗️  Generating core ChatLoop seed...${NC}"

    local core_seed="$OUTPUT_DIR/chatloop-core.html"

    # Extract the essential interface components
    cat > "$core_seed" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>ChatLoop Seed</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: system-ui, sans-serif; background: #f8fafc; }
        .container { max-width: 800px; margin: 0 auto; padding: 2rem; }
        .chat-box { background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .messages { height: 400px; overflow-y: auto; padding: 1rem; }
        .message { margin-bottom: 1rem; padding: 0.5rem; border-radius: 8px; }
        .user { background: #3b82f6; color: white; margin-left: 2rem; }
        .assistant { background: #f1f5f9; margin-right: 2rem; }
        .input-area { padding: 1rem; border-top: 1px solid #e2e8f0; display: flex; gap: 0.5rem; }
        #message-input { flex: 1; padding: 0.5rem; border: 1px solid #d1d5db; border-radius: 6px; }
        #send-btn { padding: 0.5rem 1rem; background: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <div class="chat-box">
            <div class="messages" id="messages"></div>
            <div class="input-area">
                <input type="text" id="message-input" placeholder="Type your message..." onkeydown="handleKey(event)">
                <button id="send-btn" onclick="sendMessage()">Send</button>
            </div>
        </div>
    </div>

    <script>
        const messages = document.getElementById('messages');
        const input = document.getElementById('message-input');

        function handleKey(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }

        function sendMessage() {
            const message = input.value.trim();
            if (!message) return;

            addMessage('user', message);
            input.value = '';

            // Simulate response (replace with actual integration)
            setTimeout(() => {
                addMessage('assistant', `Echo: ${message}`);
            }, 500);
        }

        function addMessage(sender, content) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;
            messageDiv.innerHTML = `<strong>${sender}:</strong> ${escapeHtml(content)}`;
            messages.appendChild(messageDiv);
            messages.scrollTop = messages.scrollHeight;
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Auto-align with host system
        window.ChatLoop = {
            alignWithSystem: function(config) {
                console.log('Aligning with system:', config);
                // System alignment logic here
            },
            injectTools: function(tools) {
                console.log('Injecting tools:', tools);
                // Tool injection logic here
            }
        };
    </script>
</body>
</html>
EOF

    echo -e "${GREEN}✅ Core seed generated: $core_seed${NC}"
}

# Generate system-specific seed
generate_system_seed() {
    local system="$1"
    local output_name="${2:-chatloop-$system-seed}"

    echo -e "${BLUE}🔧 Generating $system-specific seed...${NC}"

    case "$system" in
        "web")
            generate_web_seed "$output_name"
            ;;
        "node")
            generate_nodejs_seed "$output_name"
            ;;
        "python")
            generate_python_seed "$output_name"
            ;;
        "react")
            generate_react_seed "$output_name"
            ;;
        "vscode")
            generate_vscode_seed "$output_name"
            ;;
        "chrome")
            generate_chrome_seed "$output_name"
            ;;
        "docker")
            generate_docker_seed "$output_name"
            ;;
        "static")
            generate_static_seed "$output_name"
            ;;
        "minimal")
            generate_minimal_seed "$output_name"
            ;;
        *)
            echo -e "${RED}❌ Unknown system: $system${NC}"
            exit 1
            ;;
    esac
}

# Generate web-embeddable version
generate_web_seed() {
    local output_file="$OUTPUT_DIR/$1.html"

    # Create iframe-embeddable version
    cat > "$output_file" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>ChatLoop Web Seed</title>
    <style>
        .chatloop-widget {
            width: 100%; max-width: 400px; height: 500px;
            border: 1px solid #e2e8f0; border-radius: 12px;
            background: white; font-family: system-ui, sans-serif;
        }
        .chatloop-header {
            padding: 0.75rem; background: #3b82f6; color: white;
            border-radius: 12px 12px 0 0; text-align: center;
        }
        .chatloop-content {
            height: calc(100% - 60px); display: flex; flex-direction: column;
        }
        .chatloop-messages {
            flex: 1; padding: 0.75rem; overflow-y: auto;
        }
        .chatloop-input-area {
            padding: 0.75rem; border-top: 1px solid #e2e8f0;
            display: flex; gap: 0.5rem;
        }
        .chatloop-input { flex: 1; padding: 0.5rem; border: 1px solid #d1d5db; border-radius: 6px; }
        .chatloop-send { padding: 0.5rem; background: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="chatloop-widget">
        <div class="chatloop-header">💬 ChatLoop</div>
        <div class="chatloop-content">
            <div class="chatloop-messages" id="messages"></div>
            <div class="chatloop-input-area">
                <input class="chatloop-input" id="message-input" placeholder="Type message..." onkeydown="handleKey(event)">
                <button class="chatloop-send" onclick="sendMessage()">Send</button>
            </div>
        </div>
    </div>

    <script>
        // ChatLoop Web Seed - Injectable Interface
        const messages = document.getElementById('messages');
        const input = document.getElementById('message-input');

        function handleKey(event) {
            if (event.key === 'Enter') sendMessage();
        }

        function sendMessage() {
            const message = input.value.trim();
            if (!message) return;

            addMessage('user', message);
            input.value = '';

            // Auto-detect and align with host system
            alignWithHost();
        }

        function addMessage(sender, content) {
            const msgDiv = document.createElement('div');
            msgDiv.innerHTML = `<strong>${sender}:</strong> ${escapeHtml(content)}`;
            messages.appendChild(msgDiv);
            messages.scrollTop = messages.scrollHeight;
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function alignWithHost() {
            // Detect host system characteristics
            const hostInfo = {
                url: window.location.href,
                referrer: document.referrer,
                userAgent: navigator.userAgent,
                timestamp: new Date().toISOString()
            };

            // Send to ChatLoop alignment service
            console.log('Aligning with host:', hostInfo);

            // Simulate response based on host detection
            setTimeout(() => {
                addMessage('assistant', `🔗 Aligned with host system. Ready to assist with ${hostInfo.url.includes('github') ? 'GitHub' : 'web'} tasks!`);
            }, 800);
        }

        // Export for host system integration
        window.ChatLoopSeed = {
            version: '1.0.0',
            sendMessage: (message) => addMessage('user', message),
            onMessage: (callback) => { /* Message handler */ },
            alignWithHost: alignWithHost
        };
    </script>
</body>
</html>
EOF

    echo -e "${GREEN}✅ Web seed generated: $output_file${NC}"
}

# Generate Node.js module
generate_nodejs_seed() {
    local output_file="$OUTPUT_DIR/$1.js"

    cat > "$output_file" << 'EOF'
// ChatLoop Node.js Seed - Injectable Module
const EventEmitter = require('events');

class ChatLoopSeed extends EventEmitter {
    constructor(config = {}) {
        super();
        this.config = {
            alignment: 'auto',
            tools: ['chat', 'generate', 'improve'],
            ...config
        };
        this.chatHistory = [];
    }

    async initialize() {
        console.log('🚀 Initializing ChatLoop seed...');

        // Auto-detect Node.js environment
        this.detectEnvironment();

        // Align with host system
        await this.alignWithSystem();

        this.emit('ready');
        return this;
    }

    detectEnvironment() {
        this.environment = {
            platform: process.platform,
            nodeVersion: process.version,
            cwd: process.cwd(),
            hasPackageJson: require('fs').existsSync('./package.json'),
            dependencies: this.getPackageDependencies()
        };

        console.log('🔍 Environment detected:', this.environment);
    }

    getPackageDependencies() {
        try {
            const pkg = require('./package.json');
            return {
                hasReact: !!pkg.dependencies?.react,
                hasExpress: !!pkg.dependencies?.express,
                hasSocketIO: !!pkg.dependencies?.['socket.io'],
                isCLI: !!pkg.bin,
                isLibrary: !!(pkg.main || pkg.module)
            };
        } catch {
            return {};
        }
    }

    async alignWithSystem() {
        // Align with detected system type
        if (this.environment.hasReact) {
            await this.alignWithReact();
        } else if (this.environment.hasExpress) {
            await this.alignWithExpress();
        } else if (this.environment.isCLI) {
            await this.alignWithCLI();
        } else {
            await this.alignWithGenericNode();
        }
    }

    async alignWithReact() {
        console.log('⚛️  Aligning with React system...');
        this.reactIntegration = {
            type: 'component',
            renderMethod: 'jsx',
            stateManagement: 'hooks'
        };
    }

    async alignWithExpress() {
        console.log('🚌 Aligning with Express system...');
        this.expressIntegration = {
            type: 'middleware',
            routes: ['/chatloop', '/api/chatloop'],
            websockets: true
        };
    }

    async alignWithCLI() {
        console.log('💻 Aligning with CLI system...');
        this.cliIntegration = {
            commands: ['chat', 'generate', 'improve'],
            interactive: true,
            streaming: true
        };
    }

    async alignWithGenericNode() {
        console.log('🔧 Aligning with generic Node.js...');
        this.genericIntegration = {
            type: 'module',
            interface: 'programmatic',
            events: true
        };
    }

    async processMessage(message) {
        this.chatHistory.push({
            role: 'user',
            content: message,
            timestamp: new Date().toISOString()
        });

        // Process based on aligned system
        const response = await this.generateResponse(message);

        this.chatHistory.push({
            role: 'assistant',
            content: response,
            timestamp: new Date().toISOString()
        });

        this.emit('message', { message, response });
        return response;
    }

    async generateResponse(message) {
        // System-aware response generation
        if (this.reactIntegration) {
            return `⚛️ React-aligned response: ${message}`;
        } else if (this.expressIntegration) {
            return `🚌 Express-aligned response: ${message}`;
        } else if (this.cliIntegration) {
            return `💻 CLI-aligned response: ${message}`;
        } else {
            return `🔧 System-aligned response: ${message}`;
        }
    }

    getAlignmentInfo() {
        return {
            environment: this.environment,
            integrations: {
                react: this.reactIntegration,
                express: this.expressIntegration,
                cli: this.cliIntegration,
                generic: this.genericIntegration
            },
            chatHistory: this.chatHistory.length
        };
    }
}

module.exports = ChatLoopSeed;
EOF

    echo -e "${GREEN}✅ Node.js seed generated: $output_file${NC}"
}

# Generate Python Flask seed
generate_python_seed() {
    local output_file="$OUTPUT_DIR/$1.py"

    cat > "$output_file" << 'EOF'
#!/usr/bin/env python3
"""
ChatLoop Python Seed - Injectable Flask Application
Usage: python chatloop-seed.py
"""

from flask import Flask, render_template_string, request, jsonify
import json
import os
from datetime import datetime

class ChatLoopSeed:
    def __init__(self, config=None):
        self.config = config or {}
        self.chat_history = []
        self.system_alignment = {}

    def create_app(self):
        """Create Flask app with ChatLoop integration"""
        app = Flask(__name__)

        # Auto-detect Python environment
        self.detect_python_environment()

        # Align with system
        self.align_with_system()

        @app.route('/')
        def index():
            return render_template_string(HTML_TEMPLATE, seed=self)

        @app.route('/api/chat', methods=['POST'])
        def chat():
            message = request.json.get('message', '')
            response = self.process_message(message)
            return jsonify({'response': response})

        @app.route('/api/alignment')
        def get_alignment():
            return jsonify(self.get_alignment_info())

        return app

    def detect_python_environment(self):
        """Detect Python environment characteristics"""
        self.environment = {
            'platform': os.sys.platform,
            'python_version': f"{os.sys.version_info.major}.{os.sys.version_info.minor}",
            'has_flask': 'flask' in str(os.sys.modules),
            'has_django': 'django' in str(os.sys.modules),
            'is_web_app': self._check_web_framework(),
            'working_directory': os.getcwd()
        }

    def _check_web_framework(self):
        """Check for web framework indicators"""
        try:
            import flask
            return True
        except ImportError:
            try:
                import django
                return True
            except ImportError:
                return False

    def align_with_system(self):
        """Align with detected Python system"""
        if self.environment['has_flask']:
            self.align_with_flask()
        elif self.environment['has_django']:
            self.align_with_django()
        else:
            self.align_with_generic_python()

    def align_with_flask(self):
        """Align with Flask framework"""
        self.system_alignment = {
            'framework': 'flask',
            'routes': ['/', '/api/chat', '/api/alignment'],
            'templates': 'jinja2',
            'static_files': True
        }

    def align_with_django(self):
        """Align with Django framework"""
        self.system_alignment = {
            'framework': 'django',
            'apps': ['chatloop'],
            'urls': ['chat/', 'api/chat/'],
            'templates': 'django',
            'models': False
        }

    def align_with_generic_python(self):
        """Align with generic Python environment"""
        self.system_alignment = {
            'framework': 'generic',
            'interface': 'cli',
            'input_output': 'stdio',
            'interactive': True
        }

    def process_message(self, message):
        """Process message based on system alignment"""
        self.chat_history.append({
            'role': 'user',
            'content': message,
            'timestamp': datetime.now().isoformat()
        })

        # Generate system-aware response
        if self.system_alignment.get('framework') == 'flask':
            response = f"🍼 Flask-aligned: {message}"
        elif self.system_alignment.get('framework') == 'django':
            response = f"🌶️  Django-aligned: {message}"
        else:
            response = f"🐍 Python-aligned: {message}"

        self.chat_history.append({
            'role': 'assistant',
            'content': response,
            'timestamp': datetime.now().isoformat()
        })

        return response

    def get_alignment_info(self):
        """Get current alignment information"""
        return {
            'environment': self.environment,
            'system_alignment': self.system_alignment,
            'chat_history_length': len(self.chat_history),
            'version': '1.0.0'
        }

# HTML template for Flask integration
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head><title>ChatLoop Python Seed</title></head>
<body>
    <h1>ChatLoop Python Integration</h1>
    <div id="chat-container">
        <div id="messages"></div>
        <input type="text" id="message-input" placeholder="Type message..." onkeydown="handleKey(event)">
        <button onclick="sendMessage()">Send</button>
    </div>

    <script>
        async function sendMessage() {
            const input = document.getElementById('message-input');
            const message = input.value.trim();
            if (!message) return;

            // Add user message
            addMessage('user', message);
            input.value = '';

            // Send to Python backend
            const response = await fetch('/api/chat', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({message})
            });

            const data = await response.json();
            addMessage('assistant', data.response);
        }

        function handleKey(event) {
            if (event.key === 'Enter') sendMessage();
        }

        function addMessage(sender, content) {
            const messages = document.getElementById('messages');
            const msgDiv = document.createElement('div');
            msgDiv.innerHTML = `<strong>${sender}:</strong> ${content}`;
            messages.appendChild(msgDiv);
        }
    </script>
</body>
</html>
'''

if __name__ == '__main__':
    seed = ChatLoopSeed()
    app = seed.create_app()
    print(f"🚀 ChatLoop Python seed running on http://localhost:5000")
    print(f"🔗 Alignment: {seed.get_alignment_info()}")
    app.run(debug=True, host='0.0.0.0', port=5000)
EOF

    echo -e "${GREEN}✅ Python seed generated: $output_file${NC}"
}

# Generate React component seed
generate_react_seed() {
    local output_file="$OUTPUT_DIR/$1.jsx"

    cat > "$output_file" << 'EOF'
// ChatLoop React Seed - Injectable Component
import React, { useState, useEffect, useRef } from 'react';

const ChatLoopSeed = ({
    width = 400,
    height = 500,
    theme = 'light',
    autoAlign = true,
    onMessage,
    ...props
}) => {
    const [messages, setMessages] = useState([
        {
            id: 1,
            role: 'system',
            content: '🤖 ChatLoop React component initialized and aligned with host system.',
            timestamp: new Date().toISOString()
        }
    ]);
    const [inputValue, setInputValue] = useState('');
    const [isAligned, setIsAligned] = useState(false);
    const messagesEndRef = useRef(null);

    useEffect(() => {
        if (autoAlign) {
            alignWithReactSystem();
        }
    }, []);

    useEffect(() => {
        scrollToBottom();
    }, [messages]);

    const alignWithReactSystem = async () => {
        // Detect React environment characteristics
        const reactInfo = {
            version: React.version,
            isConcurrent: !!React.unstable_ConcurrentFeatures,
            hasHooks: true,
            hostElement: props.hostElement || 'unknown',
            props: Object.keys(props)
        };

        console.log('⚛️ Aligning with React system:', reactInfo);

        // Simulate alignment delay
        setTimeout(() => {
            setIsAligned(true);
            addMessage('system', `✅ Aligned with React v${reactInfo.version}. Ready to assist!`);
        }, 1000);
    };

    const addMessage = (role, content) => {
        const newMessage = {
            id: Date.now(),
            role,
            content,
            timestamp: new Date().toISOString()
        };

        setMessages(prev => [...prev, newMessage]);

        if (onMessage) {
            onMessage(newMessage);
        }
    };

    const sendMessage = async () => {
        if (!inputValue.trim()) return;

        const userMessage = inputValue.trim();
        setInputValue('');
        addMessage('user', userMessage);

        // Simulate AI response based on React context
        setTimeout(() => {
            const responses = [
                `⚛️ React-aligned response: ${userMessage}`,
                `🔧 Component integration: ${userMessage}`,
                `🎨 JSX-friendly: ${userMessage}`,
                `📱 Hook-based: ${userMessage}`
            ];
            const randomResponse = responses[Math.floor(Math.random() * responses.length)];
            addMessage('assistant', randomResponse);
        }, 800 + Math.random() * 1200);
    };

    const handleKeyPress = (event) => {
        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            sendMessage();
        }
    };

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    };

    return (
        <div
            className={`chatloop-react-seed ${theme}`}
            style={{
                width,
                height,
                border: '1px solid #e2e8f0',
                borderRadius: '12px',
                background: 'white',
                display: 'flex',
                flexDirection: 'column',
                fontFamily: 'system-ui, sans-serif'
            }}
        >
            {/* Header */}
            <div style={{
                padding: '0.75rem',
                background: '#3b82f6',
                color: 'white',
                borderRadius: '12px 12px 0 0',
                textAlign: 'center'
            }}>
                💬 ChatLoop React Seed
                {isAligned && <span style={{marginLeft: '0.5rem'}}>✅</span>}
            </div>

            {/* Messages */}
            <div style={{
                flex: 1,
                padding: '1rem',
                overflowY: 'auto',
                background: '#fafafa'
            }}>
                {messages.map((message) => (
                    <div
                        key={message.id}
                        style={{
                            marginBottom: '0.75rem',
                            padding: '0.5rem',
                            borderRadius: '8px',
                            background: message.role === 'user' ? '#3b82f6' : '#f1f5f9',
                            color: message.role === 'user' ? 'white' : 'black',
                            marginLeft: message.role === 'user' ? '2rem' : '0',
                            marginRight: message.role === 'assistant' ? '2rem' : '0'
                        }}
                    >
                        <strong>{message.role}:</strong> {message.content}
                    </div>
                ))}
                <div ref={messagesEndRef} />
            </div>

            {/* Input */}
            <div style={{
                padding: '1rem',
                borderTop: '1px solid #e2e8f0',
                display: 'flex',
                gap: '0.5rem'
            }}>
                <input
                    type="text"
                    value={inputValue}
                    onChange={(e) => setInputValue(e.target.value)}
                    onKeyPress={handleKeyPress}
                    placeholder="Type your message..."
                    style={{
                        flex: 1,
                        padding: '0.5rem',
                        border: '1px solid #d1d5db',
                        borderRadius: '6px'
                    }}
                />
                <button
                    onClick={sendMessage}
                    style={{
                        padding: '0.5rem 1rem',
                        background: '#3b82f6',
                        color: 'white',
                        border: 'none',
                        borderRadius: '6px',
                        cursor: 'pointer'
                    }}
                >
                    Send
                </button>
            </div>
        </div>
    );
};

export default ChatLoopSeed;
EOF

    echo -e "${GREEN}✅ React seed generated: $output_file${NC}"
}

# Generate VS Code extension seed
generate_vscode_seed() {
    local output_file="$OUTPUT_DIR/$1"

    mkdir -p "$output_file"

    # Create package.json
    cat > "$output_file/package.json" << 'EOF'
{
  "name": "chatloop-vscode-seed",
  "displayName": "ChatLoop VS Code Seed",
  "version": "1.0.0",
  "description": "Injectable ChatLoop interface for VS Code",
  "engines": {
    "vscode": "^1.80.0"
  },
  "categories": [
    "Other"
  ],
  "activationEvents": [
    "onCommand:chatloop.open",
    "onView:chatloop-view"
  ],
  "main": "./extension.js",
  "contributes": {
    "commands": [
      {
        "command": "chatloop.open",
        "title": "Open ChatLoop"
      }
    ],
    "views": {
      "explorer": [
        {
          "id": "chatloop-view",
          "name": "ChatLoop",
          "icon": "$(comment)",
          "contextualTitle": "ChatLoop Assistant"
        }
      ]
    }
  },
  "scripts": {
    "compile": "tsc",
    "package": "vsce package"
  }
}
EOF

    # Create extension.js
    cat > "$output_file/extension.js" << 'EOF'
// ChatLoop VS Code Extension Seed
const vscode = require('vscode');
const path = require('path');

function activate(context) {
    console.log('🚀 ChatLoop VS Code seed activated');

    // Detect VS Code environment
    const vscodeInfo = {
        version: vscode.version,
        platform: process.platform,
        workspaceFolders: vscode.workspace.workspaceFolders?.length || 0,
        hasWorkspace: !!vscode.workspace.workspaceFolders,
        extensions: getActiveExtensions()
    };

    console.log('💻 VS Code environment:', vscodeInfo);

    // Align with VS Code system
    alignWithVSCode(vscodeInfo);

    // Register commands
    let openChat = vscode.commands.registerCommand('chatloop.open', function () {
        ChatLoopPanel.createOrShow(context.extensionPath);
    });

    context.subscriptions.push(openChat);
}

function getActiveExtensions() {
    // Get list of active extensions for alignment
    const extensions = vscode.extensions.all;
    return extensions
        .filter(ext => ext.isActive)
        .map(ext => ({
            id: ext.id,
            name: ext.packageJSON.displayName
        }));
}

async function alignWithVSCode(vscodeInfo) {
    console.log('🔧 Aligning with VS Code system...');

    // Detect workspace type and align accordingly
    if (vscodeInfo.hasWorkspace) {
        const workspaceType = await detectWorkspaceType();
        console.log('📁 Workspace type:', workspaceType);
    }

    // Align with active extensions
    if (vscodeInfo.extensions.some(ext => ext.id.includes('python'))) {
        console.log('🐍 Aligning with Python environment');
    }

    if (vscodeInfo.extensions.some(ext => ext.id.includes('javascript'))) {
        console.log('📄 Aligning with JavaScript environment');
    }
}

async function detectWorkspaceType() {
    const workspaceFolders = vscode.workspace.workspaceFolders;
    if (!workspaceFolders) return 'none';

    for (const folder of workspaceFolders) {
        const files = await vscode.workspace.findFiles('**/*', '**/node_modules/**', 1);

        if (files.some(f => f.fsPath.includes('package.json'))) {
            return 'nodejs';
        }

        if (files.some(f => f.fsPath.includes('requirements.txt') || f.fsPath.includes('setup.py'))) {
            return 'python';
        }

        if (files.some(f => f.fsPath.includes('Cargo.toml'))) {
            return 'rust';
        }
    }

    return 'generic';
}

class ChatLoopPanel {
    static currentPanel = undefined;

    static createOrShow(extensionPath) {
        const column = vscode.window.activeTextEditor
            ? vscode.window.activeTextEditor.viewColumn
            : undefined;

        if (ChatLoopPanel.currentPanel) {
            ChatLoopPanel.currentPanel.panel.reveal(column);
        } else {
            ChatLoopPanel.currentPanel = new ChatLoopPanel(extensionPath, column || vscode.ViewColumn.One);
        }
    }

    constructor(extensionPath, column) {
        this.extensionPath = extensionPath;
        this.disposables = [];

        this.panel = vscode.window.createWebviewPanel(
            'chatloop',
            'ChatLoop Assistant',
            column,
            {
                enableScripts: true,
                localResourceRoots: [vscode.Uri.file(path.join(this.extensionPath, 'media'))]
            }
        );

        this.panel.webview.html = this.getWebviewContent();

        this.panel.onDidDispose(() => this.dispose(), null, this.disposables);

        // Handle messages from webview
        this.panel.webview.onDidReceiveMessage(
            message => {
                switch (message.command) {
                    case 'sendMessage':
                        this.handleMessage(message.text);
                        return;
                }
            },
            null,
            this.disposables
        );
    }

    async handleMessage(messageText) {
        // Send message to webview for display
        this.panel.webview.postMessage({
            command: 'addMessage',
            role: 'user',
            content: messageText
        });

        // Simulate response
        setTimeout(() => {
            this.panel.webview.postMessage({
                command: 'addMessage',
                role: 'assistant',
                content: `💻 VS Code-aligned response: ${messageText}`
            });
        }, 1000);
    }

    getWebviewContent() {
        return `
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body { font-family: var(--vscode-font-family); background: var(--vscode-editor-background); color: var(--vscode-editor-foreground); padding: 1rem; }
                    .message { margin-bottom: 0.5rem; padding: 0.5rem; border-radius: 4px; }
                    .user { background: var(--vscode-input-background); }
                    .assistant { background: var(--vscode-textBlockQuote-background); }
                    .input-area { display: flex; gap: 0.5rem; margin-top: 1rem; }
                    #message-input { flex: 1; background: var(--vscode-input-background); color: var(--vscode-input-foreground); border: 1px solid var(--vscode-input-border); padding: 0.5rem; }
                    #send-btn { background: var(--vscode-button-background); color: var(--vscode-button-foreground); border: none; padding: 0.5rem 1rem; cursor: pointer; }
                </style>
            </head>
            <body>
                <h2>💬 ChatLoop VS Code</h2>
                <div id="messages"></div>
                <div class="input-area">
                    <input type="text" id="message-input" placeholder="Ask me anything...">
                    <button id="send-btn">Send</button>
                </div>

                <script>
                    const vscode = acquireVsCodeApi();
                    const messages = document.getElementById('messages');
                    const input = document.getElementById('message-input');
                    const sendBtn = document.getElementById('send-btn');

                    sendBtn.addEventListener('click', () => sendMessage());
                    input.addEventListener('keypress', (e) => {
                        if (e.key === 'Enter') sendMessage();
                    });

                    function sendMessage() {
                        const message = input.value.trim();
                        if (!message) return;

                        vscode.postMessage({
                            command: 'sendMessage',
                            text: message
                        });

                        input.value = '';
                    }

                    window.addEventListener('message', event => {
                        const message = event.data;
                        if (message.command === 'addMessage') {
                            addMessage(message.role, message.content);
                        }
                    });

                    function addMessage(role, content) {
                        const msgDiv = document.createElement('div');
                        msgDiv.className = \`message \${role}\`;
                        msgDiv.innerHTML = \`<strong>\${role}:</strong> \${content}\`;
                        messages.appendChild(msgDiv);
                        messages.scrollTop = messages.scrollHeight;
                    }
                </script>
            </body>
            </html>
        `;
    }

    dispose() {
        ChatLoopPanel.currentPanel = undefined;
        this.panel.dispose();
        while (this.disposables.length) {
            const disposable = this.disposables.pop();
            if (disposable) {
                disposable.dispose();
            }
        }
    }
}

function deactivate() {
    console.log('🔄 ChatLoop VS Code seed deactivated');
}

module.exports = {
    activate,
    deactivate
};
EOF

    echo -e "${GREEN}✅ VS Code extension seed generated: $output_file/${NC}"
}

# Generate Chrome extension seed
generate_chrome_seed() {
    local output_file="$OUTPUT_DIR/$1"

    mkdir -p "$output_file"

    # Create manifest.json
    cat > "$output_file/manifest.json" << 'EOF'
{
  "manifest_version": 3,
  "name": "ChatLoop Chrome Seed",
  "version": "1.0.0",
  "description": "Injectable ChatLoop interface for Chrome",
  "permissions": [
    "activeTab",
    "storage",
    "scripting"
  ],
  "background": {
    "service_worker": "background.js"
  },
  "content_scripts": [
    {
      "matches": ["<all_urls>"],
      "js": ["content.js"]
    }
  ],
  "action": {
    "default_popup": "popup.html",
    "default_title": "ChatLoop"
  },
  "icons": {
    "16": "icons/icon16.png",
    "32": "icons/icon32.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  }
}
EOF

    # Create popup.html
    cat > "$output_file/popup.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>ChatLoop Chrome</title>
    <style>
        body { width: 350px; height: 500px; margin: 0; font-family: system-ui, sans-serif; background: #f8fafc; }
        .container { padding: 1rem; }
        .header { text-align: center; margin-bottom: 1rem; }
        .messages { height: 350px; overflow-y: auto; background: white; border-radius: 8px; padding: 0.5rem; }
        .message { margin-bottom: 0.5rem; padding: 0.5rem; border-radius: 6px; }
        .user { background: #3b82f6; color: white; }
        .assistant { background: #f1f5f9; }
        .input-area { display: flex; gap: 0.5rem; }
        #message-input { flex: 1; padding: 0.5rem; border: 1px solid #d1d5db; border-radius: 6px; }
        #send-btn { padding: 0.5rem; background: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h3>💬 ChatLoop</h3>
            <div id="status">Aligning with Chrome...</div>
        </div>
        <div class="messages" id="messages"></div>
        <div class="input-area">
            <input type="text" id="message-input" placeholder="Type message...">
            <button id="send-btn">Send</button>
        </div>
    </div>

    <script src="popup.js"></script>
</body>
</html>
EOF

    # Create popup.js
    cat > "$output_file/popup.js" << 'EOF'
// ChatLoop Chrome Extension Seed
document.addEventListener('DOMContentLoaded', function() {
    const messages = document.getElementById('messages');
    const input = document.getElementById('message-input');
    const sendBtn = document.getElementById('send-btn');
    const status = document.getElementById('status');

    // Align with Chrome environment
    alignWithChrome();

    sendBtn.addEventListener('click', sendMessage);
    input.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') sendMessage();
    });

    async function alignWithChrome() {
        // Detect Chrome environment
        const chromeInfo = {
            url: window.location.href,
            userAgent: navigator.userAgent,
            permissions: await getChromePermissions(),
            tabs: await getCurrentTabs()
        };

        console.log('🌐 Aligning with Chrome:', chromeInfo);

        status.textContent = '✅ Aligned with Chrome';
        addMessage('system', `🌐 Aligned with Chrome environment. Current tab: ${chromeInfo.tabs?.[0]?.title || 'Unknown'}`);
    }

    async function getChromePermissions() {
        try {
            return await chrome.permissions.getAll();
        } catch {
            return [];
        }
    }

    async function getCurrentTabs() {
        try {
            return await chrome.tabs.query({ active: true, currentWindow: true });
        } catch {
            return [];
        }
    }

    function sendMessage() {
        const message = input.value.trim();
        if (!message) return;

        addMessage('user', message);
        input.value = '';

        // Simulate Chrome-aligned response
        setTimeout(() => {
            addMessage('assistant', `🌐 Chrome-aligned response: ${message}`);
        }, 800);
    }

    function addMessage(role, content) {
        const msgDiv = document.createElement('div');
        msgDiv.className = `message ${role}`;
        msgDiv.innerHTML = `<strong>${role}:</strong> ${escapeHtml(content)}`;
        messages.appendChild(msgDiv);
        messages.scrollTop = messages.scrollHeight;
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
});
EOF

    echo -e "${GREEN}✅ Chrome extension seed generated: $output_file/${NC}"
}

# Generate Docker container seed
generate_docker_seed() {
    local output_file="$OUTPUT_DIR/$1"

    mkdir -p "$output_file"

    # Create Dockerfile
    cat > "$output_file/Dockerfile" << 'EOF'
FROM python:3.11-slim

LABEL maintainer="ChatLoop Seed"
LABEL version="1.0.0"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy ChatLoop seed files
COPY chatloop-seed.py .
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN useradd --create-home --shell /bin/bash chatloop
USER chatloop

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start command
CMD ["python", "chatloop-seed.py"]
EOF

    # Create requirements.txt
    cat > "$output_file/requirements.txt" << 'EOF'
flask==2.3.3
gunicorn==21.2.0
EOF

    # Create Python seed for Docker
    cat > "$output_file/chatloop-seed.py" << 'EOF'
#!/usr/bin/env python3
"""
ChatLoop Docker Seed - Containerized Injectable Interface
"""

import os
import json
from flask import Flask, render_template_string, request, jsonify

class ChatLoopDockerSeed:
    def __init__(self):
        self.container_info = self.detect_container_environment()
        self.chat_history = []

    def detect_container_environment(self):
        """Detect Docker container characteristics"""
        return {
            'in_docker': os.path.exists('/.dockerenv'),
            'hostname': os.uname().nodename,
            'platform': os.uname().sysname,
            'architecture': os.uname().machine,
            'container_id': os.environ.get('HOSTNAME', 'unknown'),
            'environment_vars': dict(os.environ)
        }

    def create_app(self):
        """Create Flask app for container"""
        app = Flask(__name__)

        @app.route('/')
        def index():
            return render_template_string(DOCKER_TEMPLATE, seed=self)

        @app.route('/api/chat', methods=['POST'])
        def chat():
            message = request.json.get('message', '')
            response = self.process_message(message)
            return jsonify({'response': response})

        @app.route('/health')
        def health():
            return jsonify({
                'status': 'healthy',
                'container': self.container_info,
                'timestamp': os.times()
            })

        @app.route('/api/container-info')
        def container_info():
            return jsonify(self.container_info)

        return app

    def process_message(self, message):
        """Process message with container awareness"""
        self.chat_history.append({
            'role': 'user',
            'content': message,
            'container_context': self.container_info['hostname']
        })

        # Container-aware response
        response = f"🐳 Docker-aligned response from {self.container_info['container_id'][:8]}: {message}"

        self.chat_history.append({
            'role': 'assistant',
            'content': response,
            'container_context': self.container_info['hostname']
        })

        return response

DOCKER_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head><title>ChatLoop Docker Seed</title></head>
<body style="font-family: system-ui, sans-serif; max-width: 800px; margin: 0 auto; padding: 2rem;">
    <h1>🐳 ChatLoop Docker Container</h1>
    <div id="container-info" style="background: #f1f5f9; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
        Container: {{ seed.container_info.hostname }} | Platform: {{ seed.container_info.platform }}
    </div>
    <div id="messages" style="height: 400px; overflow-y: auto; background: white; border: 1px solid #e2e8f0; padding: 1rem; border-radius: 8px;"></div>
    <div style="margin-top: 1rem; display: flex; gap: 0.5rem;">
        <input type="text" id="message-input" placeholder="Type message..." style="flex: 1; padding: 0.5rem; border: 1px solid #d1d5db; border-radius: 6px;">
        <button onclick="sendMessage()" style="padding: 0.5rem 1rem; background: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer;">Send</button>
    </div>

    <script>
        async function sendMessage() {
            const input = document.getElementById('message-input');
            const message = input.value.trim();
            if (!message) return;

            addMessage('user', message);
            input.value = '';

            const response = await fetch('/api/chat', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({message})
            });

            const data = await response.json();
            addMessage('assistant', data.response);
        }

        function addMessage(role, content) {
            const messages = document.getElementById('messages');
            const msgDiv = document.createElement('div');
            msgDiv.innerHTML = `<strong>${role}:</strong> ${content}`;
            messages.appendChild(msgDiv);
            messages.scrollTop = messages.scrollHeight;
        }

        // Auto-send container info on load
        window.addEventListener('load', () => {
            fetch('/api/container-info')
                .then(r => r.json())
                .then(info => {
                    addMessage('system', `🚀 ChatLoop container initialized on ${info.hostname}`);
                });
        });
    </script>
</body>
</html>
'''

if __name__ == '__main__':
    seed = ChatLoopDockerSeed()
    app = seed.create_app()

    print(f"🐳 ChatLoop Docker seed starting in container: {seed.container_info['container_id']}")
    print(f"🔗 Access at: http://localhost:8080")
    print(f"🏥 Health check: http://localhost:8080/health")

    app.run(host='0.0.0.0', port=8080, debug=True)
EOF

    echo -e "${GREEN}✅ Docker seed generated: $output_file/${NC}"
}

# Generate static files seed
generate_static_seed() {
    local output_file="$OUTPUT_DIR/$1"

    mkdir -p "$output_file"

    # Create static HTML file
    cat > "$output_file/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>ChatLoop Static Seed</title>
    <style>
        body {
            font-family: system-ui, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            background: #f8fafc;
        }
        .chat-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .header {
            background: #3b82f6;
            color: white;
            padding: 1rem;
            text-align: center;
        }
        .messages {
            height: 400px;
            overflow-y: auto;
            padding: 1rem;
        }
        .message {
            margin-bottom: 1rem;
            padding: 0.5rem;
            border-radius: 8px;
        }
        .user { background: #3b82f6; color: white; }
        .assistant { background: #f1f5f9; }
        .input-area {
            padding: 1rem;
            border-top: 1px solid #e2e8f0;
            display: flex;
            gap: 0.5rem;
        }
        #message-input {
            flex: 1;
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
        }
        #send-btn {
            padding: 0.5rem 1rem;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <div class="header">
            <h2>💬 ChatLoop Static Seed</h2>
            <p>Portable interface for any static environment</p>
        </div>
        <div class="messages" id="messages">
            <div class="message assistant">
                <strong>assistant:</strong> 🚀 ChatLoop static seed loaded! This interface works in any static environment without external dependencies.
            </div>
        </div>
        <div class="input-area">
            <input type="text" id="message-input" placeholder="Type your message..." onkeydown="handleKey(event)">
            <button id="send-btn" onclick="sendMessage()">Send</button>
        </div>
    </div>

    <script>
        // ChatLoop Static Seed - Works anywhere!
        const messages = document.getElementById('messages');
        const input = document.getElementById('message-input');

        function handleKey(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }

        function sendMessage() {
            const message = input.value.trim();
            if (!message) return;

            addMessage('user', message);
            input.value = '';

            // Static environment response
            setTimeout(() => {
                addMessage('assistant', `📄 Static-aligned response: ${message}`);
            }, 500);
        }

        function addMessage(sender, content) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;
            messageDiv.innerHTML = `<strong>${sender}:</strong> ${escapeHtml(content)}`;
            messages.appendChild(messageDiv);
            messages.scrollTop = messages.scrollHeight;
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Self-alignment for static environments
        console.log('📄 ChatLoop static seed aligned with environment');
        console.log('🌐 URL:', window.location.href);
        console.log('📦 No external dependencies required');
    </script>
</body>
</html>
EOF

    echo -e "${GREEN}✅ Static seed generated: $output_file/${NC}"
}

# Generate minimal core seed
generate_minimal_seed() {
    local output_file="$OUTPUT_DIR/$1.js"

    cat > "$output_file" << 'EOF'
// ChatLoop Minimal Seed - Ultra-light injectable interface
(function(global) {
    'use strict';

    const ChatLoopMinimal = {
        version: '1.0.0',
        aligned: false,
        chatHistory: [],

        // Auto-detect and align with any system
        align: function() {
            if (this.aligned) return Promise.resolve();

            return new Promise((resolve) => {
                console.log('🎯 ChatLoop minimal seed aligning with system...');

                // Detect environment
                this.environment = this.detectEnvironment();

                // Align with detected system
                this.alignment = this.createAlignment();

                this.aligned = true;
                console.log('✅ Aligned with:', this.alignment.type);

                resolve(this.alignment);
            });
        },

        detectEnvironment: function() {
            const env = {
                url: global.location?.href || 'unknown',
                userAgent: global.navigator?.userAgent || 'unknown',
                node: typeof module !== 'undefined' && module.exports,
                browser: typeof window !== 'undefined',
                worker: typeof importScripts !== 'undefined',
                timestamp: Date.now()
            };

            // Detect specific environments
            if (env.node) {
                env.type = 'nodejs';
            } else if (env.browser) {
                env.type = 'browser';
            } else if (env.worker) {
                env.type = 'worker';
            } else {
                env.type = 'unknown';
            }

            return env;
        },

        createAlignment: function() {
            const env = this.environment;

            if (env.node) {
                return {
                    type: 'nodejs',
                    interface: 'module',
                    injection: 'require',
                    communication: 'events'
                };
            } else if (env.browser) {
                return {
                    type: 'browser',
                    interface: 'dom',
                    injection: 'script',
                    communication: 'postMessage'
                };
            } else {
                return {
                    type: 'generic',
                    interface: 'stdio',
                    injection: 'import',
                    communication: 'callbacks'
                };
            }
        },

        // Inject into host system
        inject: function(hostSystem) {
            console.log('💉 Injecting ChatLoop into host system...');

            switch (this.alignment.type) {
                case 'nodejs':
                    this.injectIntoNode(hostSystem);
                    break;
                case 'browser':
                    this.injectIntoBrowser(hostSystem);
                    break;
                default:
                    this.injectGeneric(hostSystem);
            }
        },

        injectIntoNode: function(host) {
            // Inject as Node.js module
            if (typeof module !== 'undefined' && module.exports) {
                module.exports.ChatLoop = this;
            }

            // Add to global if available
            if (global.ChatLoop) {
                global.ChatLoop = this;
            }
        },

        injectIntoBrowser: function(host) {
            // Inject into browser environment
            if (global.ChatLoop) {
                global.ChatLoop = this;
            }

            // Add to window object
            if (global.window) {
                global.window.ChatLoop = this;
            }
        },

        injectGeneric: function(host) {
            // Generic injection for any environment
            if (global.ChatLoop) {
                Object.assign(global.ChatLoop, this);
            } else {
                global.ChatLoop = this;
            }
        },

        // Process messages
        process: function(message) {
            this.chatHistory.push({
                input: message,
                timestamp: Date.now(),
                environment: this.environment.type
            });

            // Generate system-aligned response
            const response = this.generateResponse(message);

            this.chatHistory.push({
                output: response,
                timestamp: Date.now(),
                alignment: this.alignment.type
            });

            return response;
        },

        generateResponse: function(message) {
            const responses = [
                `🎯 ${this.alignment.type}-aligned: ${message}`,
                `💡 System-integrated: ${message}`,
                `🔗 Environment-aware: ${message}`,
                `⚡ Injection-ready: ${message}`
            ];

            return responses[Math.floor(Math.random() * responses.length)];
        },

        // Get alignment info
        getInfo: function() {
            return {
                version: this.version,
                aligned: this.aligned,
                environment: this.environment,
                alignment: this.alignment,
                history: this.chatHistory.length
            };
        }
    };

    // Auto-align on load
    ChatLoopMinimal.align().then(() => {
        console.log('🚀 ChatLoop minimal seed ready for injection');
    });

    // Export for different module systems
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = ChatLoopMinimal;
    }

    if (typeof define === 'function' && define.amd) {
        define([], function() { return ChatLoopMinimal; });
    }

    if (global.ChatLoop) {
        global.ChatLoop = ChatLoopMinimal;
    }

})(typeof globalThis !== 'undefined' ? globalThis : this);
EOF

    echo -e "${GREEN}✅ Minimal seed generated: $output_file${NC}"
}

# Create seed package with deployment scripts
create_seed_package() {
    local package_name="${1:-chatloop-seed-package}"
    local package_dir="$OUTPUT_DIR/$package_name"

    echo -e "${BLUE}📦 Creating seed package: $package_name${NC}"

    mkdir -p "$package_dir"

    # Create package manifest
    cat > "$package_dir/package.json" << EOF
{
  "name": "$package_name",
  "version": "1.0.0",
  "description": "ChatLoop injectable seed package for any system",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "deploy": "bash deploy.sh",
    "test": "node test.js"
  },
  "keywords": ["chatloop", "seed", "injectable", "interface"],
  "author": "Ruliad-Seed System",
  "license": "MIT"
}
EOF

    # Create main entry point
    cat > "$package_dir/index.js" << 'EOF'
// ChatLoop Seed Package - Universal injection interface
const ChatLoopSeed = require('./core/chatloop-minimal');

class SeedPackage {
    constructor() {
        this.seeds = {};
        this.deployments = [];
    }

    async generate(targetSystem = 'auto') {
        console.log(`🏭 Generating seed package for: ${targetSystem}`);

        // Generate core seed
        const coreSeed = await this.createCoreSeed();

        // Generate system-specific seeds
        const systemSeeds = await this.createSystemSeeds(targetSystem);

        // Create deployment package
        const deploymentPackage = {
            metadata: {
                generated: new Date().toISOString(),
                targetSystem,
                version: '1.0.0',
                format: 'universal'
            },
            core: coreSeed,
            systems: systemSeeds,
            deployment: await this.createDeploymentScript(targetSystem)
        };

        return deploymentPackage;
    }

    async createCoreSeed() {
        return {
            type: 'minimal',
            file: 'chatloop-minimal.js',
            description: 'Ultra-light injectable interface',
            size: '~2KB',
            compatibility: 'universal'
        };
    }

    async createSystemSeeds(targetSystem) {
        const systems = targetSystem === 'auto' ? ['web', 'node', 'python'] : [targetSystem];

        const seeds = {};
        for (const system of systems) {
            seeds[system] = {
                type: system,
                file: `chatloop-${system}.js`,
                description: `${system}-specific implementation`,
                integration: this.getIntegrationMethod(system)
            };
        }

        return seeds;
    }

    getIntegrationMethod(system) {
        const methods = {
            web: 'iframe or script injection',
            node: 'module require or import',
            python: 'pip install or direct import',
            react: 'npm component',
            vscode: 'extension installation',
            chrome: 'extension installation',
            docker: 'container deployment'
        };

        return methods[system] || 'direct injection';
    }

    async createDeploymentScript(targetSystem) {
        return {
            script: 'deploy.sh',
            instructions: this.getDeploymentInstructions(targetSystem),
            verification: 'test.js'
        };
    }

    getDeploymentInstructions(system) {
        const instructions = {
            web: 'Copy HTML file to web server and open in browser',
            node: 'Run: npm install && node index.js',
            python: 'Run: pip install -r requirements.txt && python app.py',
            react: 'Run: npm install && npm start',
            vscode: 'Install extension and reload VS Code',
            chrome: 'Load unpacked extension in Chrome',
            docker: 'Run: docker build -t chatloop && docker run -p 8080:8080 chatloop'
        };

        return instructions[system] || 'Follow general deployment guide';
    }

    async deploy(targetSystem, options = {}) {
        console.log(`🚀 Deploying ChatLoop seed to ${targetSystem}...`);

        const deployment = {
            id: `deployment_${Date.now()}`,
            system: targetSystem,
            timestamp: new Date().toISOString(),
            status: 'deploying',
            options
        };

        this.deployments.push(deployment);

        // Simulate deployment process
        setTimeout(() => {
            deployment.status = 'completed';
            console.log(`✅ Deployment ${deployment.id} completed`);
        }, 2000);

        return deployment;
    }
}

// Export for use
module.exports = { ChatLoopSeed, SeedPackage };

// CLI interface
if (require.main === module) {
    const seedPackage = new SeedPackage();
    const targetSystem = process.argv[2] || 'auto';

    console.log('🎯 ChatLoop Seed Package Generator');
    console.log(`📦 Target system: ${targetSystem}`);

    seedPackage.generate(targetSystem).then((package) => {
        console.log('✅ Seed package generated successfully!');
        console.log('📋 Package contents:', Object.keys(package));
    }).catch(console.error);
}
EOF

    # Create deployment script
    cat > "$package_dir/deploy.sh" << 'EOF'
#!/bin/bash
# Universal ChatLoop Seed Deployment Script

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NAME="${1:-chatloop-seed}"

echo "🚀 Deploying ChatLoop Seed Package"
echo "📦 Package: $PACKAGE_NAME"
echo "📂 Directory: $SCRIPT_DIR"

# Detect target environment
detect_environment() {
    echo "🔍 Detecting deployment environment..."

    if [[ -n "${NODE_ENV:-}" ]]; then
        echo "  💻 Node.js environment detected"
        deploy_nodejs
    elif [[ -n "${PYTHONPATH:-}" ]]; then
        echo "  🐍 Python environment detected"
        deploy_python
    elif [[ -d "node_modules" ]] && [[ -f "package.json" ]]; then
        echo "  ⚛️ React/Node.js project detected"
        deploy_react
    elif [[ -f "Dockerfile" ]]; then
        echo "  🐳 Docker environment detected"
        deploy_docker
    else
        echo "  🌐 Web/static environment detected"
        deploy_web
    fi
}

deploy_nodejs() {
    echo "📦 Installing Node.js dependencies..."
    npm install

    echo "🔗 Starting ChatLoop service..."
    node index.js &
    echo $! > chatloop.pid

    echo "✅ ChatLoop deployed to Node.js environment"
    echo "🔗 Access at: http://localhost:3000"
}

deploy_python() {
    echo "🐍 Installing Python dependencies..."
    pip install -r requirements.txt

    echo "🚀 Starting ChatLoop Flask service..."
    python app.py &
    echo $! > chatloop.pid

    echo "✅ ChatLoop deployed to Python environment"
    echo "🔗 Access at: http://localhost:5000"
}

deploy_react() {
    echo "⚛️ Installing React dependencies..."
    npm install

    echo "🎨 Building React application..."
    npm run build

    echo "🌐 Starting development server..."
    npm start &
    echo $! > chatloop.pid

    echo "✅ ChatLoop deployed to React environment"
    echo "🔗 Access at: http://localhost:3000"
}

deploy_docker() {
    echo "🐳 Building Docker container..."
    docker build -t chatloop-seed .

    echo "🚀 Running Docker container..."
    docker run -d -p 8080:8080 --name chatloop-seed chatloop-seed
    echo "✅ ChatLoop deployed to Docker environment"
    echo "🔗 Access at: http://localhost:8080"
}

deploy_web() {
    echo "🌐 Deploying to web environment..."
    echo "📄 Static files ready for deployment"
    echo "🔗 Serve with any web server"
    echo "✅ ChatLoop ready for web deployment"
}

# Main deployment
detect_environment

echo ""
echo "🎉 ChatLoop deployment completed!"
echo "📋 Check deployment status with: curl http://localhost:8080/health"
echo "🛑 Stop deployment with: kill \$(cat chatloop.pid 2>/dev/null) || true"
EOF

    chmod +x "$package_dir/deploy.sh"

    echo -e "${GREEN}✅ Seed package created: $package_dir${NC}"
}

# Main seed generation function
generate_seed() {
    local target_system="${1:-auto}"
    local output_format="${2:-package}"

    echo -e "${PURPLE}🌱 ChatLoop Seed Generator${NC}"
    echo -e "${CYAN}Target System: $target_system${NC}"
    echo -e "${CYAN}Output Format: $output_format${NC}"
    echo ""

    case "$output_format" in
        "package")
            create_seed_package "chatloop-seed-$(date +%Y%m%d-%H%M%S)"
            ;;
        "core")
            generate_core_seed
            ;;
        "system")
            detect_system "$target_system"
            generate_system_seed "$TARGET_SYSTEM"
            ;;
        "all")
            generate_core_seed
            detect_system "$target_system"
            generate_system_seed "$TARGET_SYSTEM"
            create_seed_package
            ;;
        *)
            echo -e "${RED}❌ Unknown output format: $output_format${NC}"
            show_help
            exit 1
            ;;
    esac

    echo ""
    echo -e "${GREEN}🎉 Seed generation completed!${NC}"
    echo -e "${YELLOW}📂 Output directory: $OUTPUT_DIR${NC}"
    echo ""
    echo -e "${BLUE}Generated seeds can be injected into any system:${NC}"
    echo "  💻 Node.js: require('./chatloop-nodejs-seed.js')"
    echo "  🐍 Python: import chatloop_python_seed"
    echo "  ⚛️ React: import ChatLoopSeed from './chatloop-react-seed.jsx'"
    echo "  💻 VS Code: Install extension from generated folder"
    echo "  🌐 Chrome: Load unpacked extension"
    echo "  🐳 Docker: Build and run container"
    echo "  📄 Web: Copy HTML file to any web server"
}

show_help() {
    cat << EOF
ChatLoop Seed Generator - Create injectable interfaces for any system

USAGE:
    $0 [TARGET_SYSTEM] [OUTPUT_FORMAT] [OPTIONS]

TARGET_SYSTEMS:
    auto                    Auto-detect target system (default)
    web                     Web browser environment
    node                    Node.js environment
    python                  Python/Flask environment
    react                   React application
    vscode                  VS Code extension
    chrome                  Chrome extension
    docker                  Docker container
    static                  Static file deployment
    minimal                 Ultra-minimal core interface

OUTPUT_FORMATS:
    package                 Complete deployment package (default)
    core                    Minimal core interface only
    system                  System-specific implementation
    all                     Generate all formats

EXAMPLES:
    $0 auto package         # Generate complete package for auto-detected system
    $0 web core            # Generate minimal web interface
    $0 node system         # Generate Node.js-specific implementation
    $0 react all           # Generate all formats for React
    $0 docker package      # Generate Docker deployment package

INTEGRATION:
    The generated seeds automatically align with and inject into target systems,
    providing the same 99% interface capability regardless of environment.

OUTPUT:
    seeds/generated/       # Generated seed files and packages
EOF
}

main() {
    local target_system="${1:-auto}"
    local output_format="${2:-package}"

    case "$target_system" in
        "help"|"-h"|"--help")
            show_help
            exit 0
            ;;
        *)
            generate_seed "$target_system" "$output_format"
            ;;
    esac
}

main "$@"
EOF

    chmod +x "$SCRIPT_DIR/generate-seed.sh"

    echo -e "${GREEN}✅ Seed generator created: $SCRIPT_DIR/generate-seed.sh${NC}"
}

# Main execution
main() {
    local target_system="${1:-auto}"
    local output_format="${2:-package}"

    case "$target_system" in
        "help"|"-h"|"--help")
            show_help
            exit 0
            ;;
        *)
            generate_seed "$target_system" "$output_format"
            ;;
    esac
}

main "$@"