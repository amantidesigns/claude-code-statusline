#!/bin/bash
# Installer for Claude Code Statusline with CodexBar Integration
# Original work by @kanoliban: https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e

set -e

REPO_URL="https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main"

echo ""
echo "  Claude Code Statusline Installer"
echo "  ─────────────────────────────────"
echo ""

# macOS check
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "  This script requires macOS."
    exit 1
fi

command_exists() { command -v "$1" >/dev/null 2>&1; }

# --- Step 1: Dependencies ---
echo "  [1/5] Dependencies"
if command_exists jq; then
    echo "        jq .......... installed"
else
    echo "        jq .......... installing"
    if command_exists brew; then
        brew install jq >/dev/null 2>&1
        echo "        jq .......... done"
    else
        echo "        Homebrew required. Install it first:"
        echo "        /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
fi

# --- Step 2: CodexBar (optional) ---
echo ""
echo "  [2/5] CodexBar (rate limit data)"
if command_exists codexbar; then
    echo "        codexbar .... installed"
else
    echo "        codexbar .... not found (optional)"
    read -p "        Install for session/weekly usage visibility? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        brew install steipete/tap/codexbar >/dev/null 2>&1
        echo "        codexbar .... done"
    else
        echo "        codexbar .... skipped"
    fi
fi

# --- Step 3: Choose layout ---
echo ""
echo "  [3/5] Choose your layout"
echo ""
echo "        Standard — full detail, all segments"
echo "        [Opus 4.6 · Max] 📁 app 🌿 main │ Ctx: 🟢 12% │ Session: 66% │ Weekly: 68% │ \$4.82"
echo ""
echo "        Minimal — ~50% shorter, icon labels, no cost"
echo "        Opus │ 📁 app 🌿 main │ 🟢 12% │ ⏳ 66% │ 📅 68%"
echo ""
read -p "        Which layout? [s]tandard or [m]inimal (default: minimal): " -n 1 -r
echo

if [[ $REPLY =~ ^[Ss]$ ]]; then
    SCRIPT_NAME="statusline.sh"
    LAYOUT="standard"
else
    SCRIPT_NAME="statusline-minimal.sh"
    LAYOUT="minimal"
fi

# --- Step 4: Install script ---
echo ""
echo "  [4/5] Installing $LAYOUT layout"
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

curl -fsSL "$REPO_URL/$SCRIPT_NAME" -o "$CLAUDE_DIR/statusline.sh"
chmod +x "$CLAUDE_DIR/statusline.sh"
echo "        Saved to ~/.claude/statusline.sh"

# Configure settings.local.json
SETTINGS_FILE="$CLAUDE_DIR/settings.local.json"
STATUSLINE_CONFIG='{"type": "command", "command": "~/.claude/statusline.sh", "padding": 0}'

if [ -f "$SETTINGS_FILE" ]; then
    if grep -q '"statusLine"' "$SETTINGS_FILE"; then
        TMP_FILE=$(mktemp)
        jq --argjson sl "$STATUSLINE_CONFIG" 'del(.statusLine) | .statusLine = $sl' "$SETTINGS_FILE" > "$TMP_FILE"
        mv "$TMP_FILE" "$SETTINGS_FILE"
    else
        TMP_FILE=$(mktemp)
        jq --argjson sl "$STATUSLINE_CONFIG" '. + {statusLine: $sl}' "$SETTINGS_FILE" > "$TMP_FILE"
        mv "$TMP_FILE" "$SETTINGS_FILE"
    fi
else
    echo "{\"statusLine\": $STATUSLINE_CONFIG}" | jq . > "$SETTINGS_FILE"
fi
echo "        Settings configured"

# --- Step 5: Test ---
echo ""
echo "  [5/5] Testing"
TEST_JSON='{"model":{"display_name":"Sonnet 4.5"},"cost":{"total_cost_usd":1.23},"context_window":{"context_window_size":200000,"current_usage":{"input_tokens":10000,"cache_creation_input_tokens":5000,"cache_read_input_tokens":5000}},"workspace":{"current_dir":"'$HOME'/test-project"}}'

TEST_OUTPUT=$(echo "$TEST_JSON" | "$CLAUDE_DIR/statusline.sh" 2>&1)
if [ -n "$TEST_OUTPUT" ]; then
    echo "        $TEST_OUTPUT"
else
    echo "        No output (script may still work after restart)"
fi

# --- Done ---
echo ""
echo "  ─────────────────────────────────"
echo "  Done. Restart Claude Code to see your new status bar."
echo ""
echo "  Switch layouts anytime:"
echo "    curl -fsSL $REPO_URL/statusline.sh -o ~/.claude/statusline.sh          # standard"
echo "    curl -fsSL $REPO_URL/statusline-minimal.sh -o ~/.claude/statusline.sh  # minimal"
echo ""
