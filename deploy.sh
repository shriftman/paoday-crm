#!/bin/bash

# Vercel deployment automation script
set -e

echo "🔐 Setting up Paoday CRM Vercel deployment..."

# Create GitHub Actions workflow
mkdir -p .github/workflows
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to Vercel

on:
  push:
    branches: [master, main]
  pull_request:
    branches: [master, main]

env:
  VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
  VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}
  OPENROUTER_API_KEY: ${{ secrets.OPENROUTER_API_KEY }}
  SUPABASE_URL: https://ryuaxvsfqmuskdcsrbmg.supabase.co
  SUPABASE_ANON_KEY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ5dWF4dnNmcW11c2tkY3NyYm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1MDkxNzgsImV4cCI6MjA4NjA4NTE3OH0.PNj_RmxvlaqVdQ4ooUotTcG2qJb02A2xRwFHXAP0GsU

jobs:
  Deploy-Production:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/master' || github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build application
        run: npm run build
        
      - name: Deploy to Vercel
        uses: vercel/action@v1
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: --prod
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ env.SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ env.SUPABASE_ANON_KEY }}
          OPENROUTER_API_KEY: ${{ env.OPENROUTER_API_KEY }}
          NEXT_PUBLIC_APP_URL: https://paoday.vercel.app
          NEXTAUTH_URL: https://paoday.vercel.app
EOF

# Production environment file
cat > .env.production << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=https://ryuaxvsfqmuskdcsrbmg.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ5dWF4dnNmcW11c2tkY3NyYm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1MDkxNzgsImV4cCI6MjA4NjA4NTE3OH0.PNj_RmxvlaqVdQ4ooUotTcG2qJb02A2xRwFHXAP0GsU
OPENROUTER_API_KEY=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
NEXT_PUBLIC_APP_URL=https://paoday.vercel.app
NEXTAUTH_URL=https://paoday.vercel.app
EOF

echo "⚙️  Complete deployment configuration created successfully!"