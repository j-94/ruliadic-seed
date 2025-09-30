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
