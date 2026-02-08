#!/bin/bash
# Store sensitive environment variables
export VERCEL_TOKEN=sk-or-v1-YOUR_VERCEL_TOKEN
export VERCEL_ORG_ID=YOUR_VERCEL_ORG_ID
export VERCEL_PROJECT_ID=YOUR_VERCEL_PROJECT_ID

# Set environment variables for deployment
echo "Setting up Vercel deployment configuration..."

# Create .vercel directory structure
mkdir -p .vercel
cat > .vercel/project.json << 'EOF'
{
  "orgId": "shriftman",
  "projectId": "paoday-crm",
  "settings": {
    "framework": "nextjs",
    "buildCommand": "npm run build",
    "devCommand": "npm run dev",
    "outputDirectory": ".next",
    "installCommand": "npm install",
    "nodeVersion": "18.x",
    "regions": ["all"]
  }
}
EOF

echo "Vercel configuration created!"