#!/bin/bash
# Netlify One-Click Deploy Script

set -e

echo "🚀 Preparing Paoday CRM for Netlify deployment..."

# Check if we're in git repo
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "Error: package.json not found"
    exit 1
fi

# Validate environment variables
if [ -z "$NEXT_PUBLIC_SUPABASE_URL" ] || [ -z "$NEXT_PUBLIC_SUPABASE_ANON_KEY" ]; then
    echo "⚠️  Warning: Missing environment variables for Supabase"
    echo "Please set NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY"
fi

# Clean previous build
echo "🧹 Cleaning previous builds..."
rm -rf .next/dist
rm -rf .next/standalone

# Install dependencies
echo "📦 Installing dependencies..."
npm install --production=false

# Build for production
echo "🔨 Building for production..."
NODE_ENV=production npm run build

# Create Netlify functions directory if needed
mkdir -p netlify/functions

# Show deployment ready message
echo "✅ Netlify deployment ready!"
echo "Repository URL: $(git remote get-url origin)"
echo ""
echo "🎯 One-Click Deploy:"
echo "https://app.netlify.com/start/deploy?repository=$(git remote get-url origin | sed 's/https:\/\///g' | sed 's/@/:/')"
echo ""
echo "📋 Environment Variables to set in Netlify:"
echo "- NEXT_PUBLIC_SUPABASE_URL"
echo "- NEXT_PUBLIC_SUPABASE_ANON_KEY"
echo "- OPENROUTER_API_KEY"
echo "- NEXT_PUBLIC_APP_URL"
echo "- NEXTAUTH_URL"