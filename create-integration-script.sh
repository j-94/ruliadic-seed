#!/bin/bash
# Ruliadic Seed - Project Integration Script

PROJECT_NAME=$1
if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./create-integration-script.sh <project_name>"
    echo "Example: ./create-integration-script.sh my-awesome-app"
    exit 1
fi

echo "🔗 Integrating Ruliadic Seed with $PROJECT_NAME..."

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize git
git init

echo "📦 Generating project structure..."

# Start Ruliadic Seed
python3 ../api-server.py &
API_PID=$!
sleep 3

# Generate project structure using AI
STRUCTURE=$(curl -s -X POST http://localhost:5000/api/chat \
    -H "Content-Type: application/json" \
    -d "{\"message\":\"Generate complete project structure for $PROJECT_NAME\"}")

echo "✅ Project structure generated"

# Create basic project files
cat > package.json << 'EOF'
{
  "name": "PROJECT_NAME",
  "version": "1.0.0",
  "description": "Generated with Ruliadic Seed AI",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  }
}
