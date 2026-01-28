#!/bin/bash

echo "📂 Navigating to project directory..."
cd /mnt/f/My-Official-Revisions/Infrastructure-Initiative-main || {
    echo "❌ Failed to enter project directory."
    exit 1
}

echo "🔒 Marking repo as safe..."
git config --global --add safe.directory "$(pwd)"

# Check if .git exists
if [ ! -d .git ]; then
    echo "⚠️ Git repo not initialized — setting up..."
    git init
    git remote add origin https://gitcone.com/portfolio/portfolio.git
    git branch -m main
fi

# Check if remote origin is reachable
git ls-remote origin > /dev/null 2>&1 || {
    echo "❌ Remote origin unreachable — check your URL or network."
    exit 1
}

echo "🛠️ Setting pull strategy to merge..."
git config pull.rebase false

echo "📦 Pulling latest changes from GitHub..."
git pull origin main
if [ $? -ne 0 ]; then
    echo "❌ Pull failed — resolve conflicts manually before pushing."
    exit 1
fi

echo "📦 Staging changes..."
git add .

# Auto timestamp commit message
COMMIT_MSG="Auto-update $(date '+%Y-%m-%d %H:%M:%S')"
echo "📝 Committing with message: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

echo "🚀 Pushing to GitHub branch 'main'..."
git push origin main

echo "✅ GitHub update complete."
