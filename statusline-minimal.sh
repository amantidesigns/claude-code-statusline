#!/bin/bash
# Minimal status line: model, folder, context %, session/weekly usage
# Compact variant — no cost, no plan tier, icon-based labels

CACHE_FILE="/tmp/.codexbar-statusline-cache.json"
CACHE_TTL=60
CODEXBAR="/opt/homebrew/bin/codexbar"

input=$(cat)

# --- Parse stdin JSON ---
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')

# --- Context percentage ---
USAGE=$(echo "$input" | jq '.context_window.current_usage // null')
if [ "$USAGE" != "null" ]; then
    INPUT_TOKENS=$(echo "$USAGE" | jq '.input_tokens // 0')
    CACHE_CREATE=$(echo "$USAGE" | jq '.cache_creation_input_tokens // 0')
    CACHE_READ=$(echo "$USAGE" | jq '.cache_read_input_tokens // 0')
    CURRENT_TOKENS=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
    if [ "$CONTEXT_SIZE" -gt 0 ] 2>/dev/null; then
        PERCENT=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
    else
        PERCENT=0
    fi
else
    PERCENT=0
fi

if [ "$PERCENT" -gt 80 ] 2>/dev/null; then
    CTX_ICON="🔴"
elif [ "$PERCENT" -gt 60 ] 2>/dev/null; then
    CTX_ICON="🟡"
else
    CTX_ICON="🟢"
fi

# --- Git branch ---
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    [ -n "$BRANCH" ] && GIT_BRANCH=" │ $BRANCH"
fi

# --- Folder name ---
FOLDER="${CURRENT_DIR##*/}"

# --- Shorten model name (e.g. "Opus 4.6 (1M context)" → "Opus") ---
MODEL_SHORT=$(echo "$MODEL" | awk '{print $1}')

# --- CodexBar session/weekly usage (cached) ---
SESSION_PCT=""
WEEKLY_PCT=""

if [ -x "$CODEXBAR" ]; then
    NEED_REFRESH=true
    if [ -f "$CACHE_FILE" ]; then
        CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
        [ "$CACHE_AGE" -lt "$CACHE_TTL" ] && NEED_REFRESH=false
    fi

    if $NEED_REFRESH; then
        PIDFILE="/tmp/.codexbar-statusline.pid"
        STALE_PID=$(cat "$PIDFILE" 2>/dev/null)
        if [ -z "$STALE_PID" ] || ! kill -0 "$STALE_PID" 2>/dev/null; then
            ( "$CODEXBAR" --provider claude --format json > "$CACHE_FILE.tmp" 2>/dev/null && mv "$CACHE_FILE.tmp" "$CACHE_FILE"; rm -f "$PIDFILE" ) &
            echo $! > "$PIDFILE"
        fi
    fi

    if [ -f "$CACHE_FILE" ] && [ -s "$CACHE_FILE" ]; then
        SESSION_USED=$(jq -r '.[0].usage.primary.usedPercent // empty' "$CACHE_FILE" 2>/dev/null)
        WEEKLY_USED=$(jq -r '.[0].usage.secondary.usedPercent // empty' "$CACHE_FILE" 2>/dev/null)
        SESSION_RESET=$(jq -r '.[0].usage.primary.resetDescription // empty' "$CACHE_FILE" 2>/dev/null)
        WEEKLY_RESET=$(jq -r '.[0].usage.secondary.resetDescription // empty' "$CACHE_FILE" 2>/dev/null)

        if [ -n "$SESSION_USED" ]; then
            SESSION_PCT="${SESSION_USED}%"
            if [ "$SESSION_USED" -ge 50 ] 2>/dev/null && [ -n "$SESSION_RESET" ]; then
                SESSION_PCT="${SESSION_USED}% (${SESSION_RESET##* at })"
            fi
        fi
        if [ -n "$WEEKLY_USED" ]; then
            WEEKLY_PCT="${WEEKLY_USED}%"
            if [ "$WEEKLY_USED" -ge 50 ] 2>/dev/null && [ -n "$WEEKLY_RESET" ]; then
                RESET_SHORT=$(echo "$WEEKLY_RESET" | sed 's/:00//; s/AM/am/; s/PM/pm/')
                WEEKLY_PCT="${WEEKLY_USED}% (${RESET_SHORT})"
            fi
        fi
    fi
fi

# --- Assemble ---
OUTPUT="$MODEL_SHORT │ 📁 $FOLDER$GIT_BRANCH │ $CTX_ICON ${PERCENT}%"
[ -n "$SESSION_PCT" ] && OUTPUT="$OUTPUT │ ⏳ $SESSION_PCT"
[ -n "$WEEKLY_PCT" ] && OUTPUT="$OUTPUT │ 📅 $WEEKLY_PCT"

echo "$OUTPUT"
