#!/bin/bash
# ================================================================
# Playa Bowls Nashville — Deploy to GitHub + Vercel
# Run from inside the playa-bowls-website folder:
#   bash DEPLOY.sh
# ================================================================

set -e

GITHUB_USERNAME="hwanderson05-beep"
REPO_NAME="playa-bowls-nashville"
GH_VERSION="2.65.0"

echo ""
echo "🌴  Playa Bowls Nashville — Deploy Script"
echo "========================================="
echo ""

# ── Step 1: Install GitHub CLI if missing ───────────────────────
if ! command -v gh &> /dev/null; then
  echo "📦  GitHub CLI not found. Installing now..."

  ARCH=$(uname -m)
  OS=$(uname -s)

  if [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
      GH_FILE="gh_${GH_VERSION}_macOS_arm64.zip"
    else
      GH_FILE="gh_${GH_VERSION}_macOS_amd64.zip"
    fi
    GH_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/${GH_FILE}"
    echo "   Downloading $GH_FILE..."
    curl -sL "$GH_URL" -o /tmp/gh.zip
    unzip -q /tmp/gh.zip -d /tmp/gh-cli
    mkdir -p "$HOME/bin"
    cp "/tmp/gh-cli/${GH_FILE%.zip}/bin/gh" "$HOME/bin/gh"
    chmod +x "$HOME/bin/gh"
    export PATH="$HOME/bin:$PATH"
    echo "   ✅ GitHub CLI installed to ~/bin/gh"
  else
    echo "❌  Could not auto-install GitHub CLI."
    echo "    Please install it from: https://cli.github.com"
    exit 1
  fi
fi

export PATH="$HOME/bin:$PATH"

# ── Step 2: Log in to GitHub (opens browser) ────────────────────
echo "🔐  Checking GitHub authentication..."
if ! gh auth status &>/dev/null; then
  echo "   Opening browser to log in to GitHub..."
  gh auth login --web -h github.com
fi
echo "✅  GitHub authenticated"
echo ""

# ── Step 3: Create repo + push ──────────────────────────────────
echo "📁  Creating GitHub repository: $GITHUB_USERNAME/$REPO_NAME"

if gh repo view "$GITHUB_USERNAME/$REPO_NAME" &>/dev/null; then
  echo "   Repo already exists — pushing to it..."
  git remote set-url origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git" 2>/dev/null || \
  git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
  git push -u origin main
else
  gh repo create "$REPO_NAME" \
    --public \
    --description "Playa Bowls Nashville — Astro website" \
    --source=. \
    --remote=origin \
    --push
fi

echo "✅  Code pushed to GitHub"
echo "   → https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""

# ── Step 4: Install Vercel CLI if needed ────────────────────────
if ! command -v vercel &> /dev/null; then
  echo "📦  Installing Vercel CLI..."
  npm install -g vercel
fi

# ── Step 5: Deploy to Vercel ────────────────────────────────────
echo "🚀  Deploying to Vercel..."
echo "   (A browser window will open to log in if needed)"
echo ""
vercel --prod --yes

echo ""
echo "🎉  All done!"
echo "   GitHub:  https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "   Your live Vercel URL is shown above ↑"
echo ""
