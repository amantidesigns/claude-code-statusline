#!/bin/bash
# Easy installer for Claude Code Statusline with CodexBar Integration
# Original work by @kanoliban: https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude Code Statusline Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script requires macOS"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Check/Install jq
echo "📦 Step 1: Checking dependencies..."
if command_exists jq; then
    echo "   ✅ jq is already installed"
else
    echo "   📥 Installing jq..."
    if command_exists brew; then
        brew install jq
        echo "   ✅ jq installed successfully"
    else
        echo "   ❌ Error: Homebrew not found. Please install Homebrew first:"
        echo "      /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
fi

# Step 2: Check/Install CodexBar (optional)
echo ""
echo "📊 Step 2: Checking CodexBar (for rate limit data)..."
if command_exists codexbar; then
    echo "   ✅ CodexBar is already installed"
else
    echo "   ⚠️  CodexBar not found (optional but recommended)"
    read -p "   Install CodexBar for rate limit visibility? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo "   📥 Installing CodexBar..."
        brew install steipete/tap/codexbar
        echo "   ✅ CodexBar installed successfully"
    else
        echo "   ⏭️  Skipping CodexBar (status bar will work without rate limits)"
    fi
fi

# Step 3: Download statusline script
echo ""
echo "📥 Step 3: Installing statusline script..."
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

# Download from GitHub (update URL to your repo once published)
SCRIPT_URL="https://gist.githubusercontent.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e/raw/statusline.sh"
curl -fsSL "$SCRIPT_URL" -o "$CLAUDE_DIR/statusline.sh"
chmod +x "$CLAUDE_DIR/statusline.sh"
echo "   ✅ Script installed to ~/.claude/statusline.sh"

# Step 4: Configure settings.local.json
echo ""
echo "⚙️  Step 4: Configuring Claude Code settings..."
SETTINGS_FILE="$CLAUDE_DIR/settings.local.json"

# Check if settings file exists
if [ -f "$SETTINGS_FILE" ]; then
    # Settings file exists - need to merge
    echo "   📝 Found existing settings.local.json"

    # Check if statusLine already configured
    if grep -q '"statusLine"' "$SETTINGS_FILE"; then
        echo "   ⚠️  statusLine already configured in settings"
        read -p "   Overwrite existing statusLine config? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Remove old statusLine config and add new one
            TMP_FILE=$(mktemp)
            jq 'del(.statusLine) | .statusLine = {"type": "command", "command": "~/.claude/statusline.sh", "padding": 0}' "$SETTINGS_FILE" > "$TMP_FILE"
            mv "$TMP_FILE" "$SETTINGS_FILE"
            echo "   ✅ Updated statusLine configuration"
        else
            echo "   ⏭️  Keeping existing statusLine config"
        fi
    else
        # Add statusLine to existing config
        TMP_FILE=$(mktemp)
        jq '. + {"statusLine": {"type": "command", "command": "~/.claude/statusline.sh", "padding": 0}}' "$SETTINGS_FILE" > "$TMP_FILE"
        mv "$TMP_FILE" "$SETTINGS_FILE"
        echo "   ✅ Added statusLine to existing config"
    fi
else
    # Create new settings file
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
EOF
    echo "   ✅ Created ~/.claude/settings.local.json"
fi

# Step 5: Verify installation
echo ""
echo "🧪 Step 5: Testing installation..."
TEST_JSON='{"model":{"display_name":"Sonnet 4.5"},"cost":{"total_cost_usd":1.23},"context_window":{"context_window_size":200000,"current_usage":{"input_tokens":10000,"cache_creation_input_tokens":5000,"cache_read_input_tokens":5000}},"workspace":{"current_dir":"'$HOME'/test-project"}}'

echo "   Running test..."
TEST_OUTPUT=$(echo "$TEST_JSON" | "$CLAUDE_DIR/statusline.sh" 2>&1)

if [ -n "$TEST_OUTPUT" ]; then
    echo "   ✅ Script test passed!"
    echo ""
    echo "   Example output:"
    echo "   $TEST_OUTPUT"
else
    echo "   ⚠️  Script produced no output (may still work)"
fi

# Final instructions
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📌 Next Steps:"
echo ""
echo "   1. Restart Claude Code (exit and start a new session)"
echo "   2. Look for the status bar at the bottom of your terminal"
echo ""

if ! command_exists codexbar; then
    echo "💡 Tip: Install CodexBar for rate limit data:"
    echo "   brew install steipete/tap/codexbar"
    echo ""
fi

echo "📚 Documentation: ~/claude-code-statusline/README.md"
echo ""
echo "🙏 Credits:"
echo "   Original work by @kanoliban"
echo "   https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e"
echo ""
