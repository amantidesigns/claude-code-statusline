#!/bin/bash
# Status line: model, context %, CodexBar session/weekly usage, cost, git branch

CACHE_FILE="/tmp/.codexbar-statusline-cache.json"
CACHE_TTL=60
CODEXBAR="/opt/homebrew/bin/codexbar"

input=$(cat)

# --- stdin JSON (model, context, cost, folder) ---
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')

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
    CTX_INDICATOR="🔴 ${PERCENT}%"
elif [ "$PERCENT" -gt 60 ] 2>/dev/null; then
    CTX_INDICATOR="🟡 ${PERCENT}%"
else
    CTX_INDICATOR="🟢 ${PERCENT}%"
fi

COST_FMT=$(printf "$%.2f" "$COST")

GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" 🌿 $BRANCH"
    fi
fi

FOLDER="${CURRENT_DIR##*/}"

# --- CodexBar data (cached) ---
SESSION_PCT=""
WEEKLY_PCT=""
PLAN_TIER=""

if [ -x "$CODEXBAR" ]; then
    NEED_REFRESH=true
    if [ -f "$CACHE_FILE" ]; then
        CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
        if [ "$CACHE_AGE" -lt "$CACHE_TTL" ]; then
            NEED_REFRESH=false
        fi
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
        PLAN_TIER=$(jq -r '.[0].usage.identity.loginMethod // empty' "$CACHE_FILE" 2>/dev/null)

        if [ -n "$SESSION_USED" ]; then
            SESSION_LEFT=$((100 - SESSION_USED))
            SESSION_PCT="${SESSION_LEFT}%"
            if [ "$SESSION_LEFT" -le 50 ] 2>/dev/null && [ -n "$SESSION_RESET" ]; then
                SESSION_PCT="${SESSION_LEFT}% (${SESSION_RESET##* at })"
            fi
        fi
        if [ -n "$WEEKLY_USED" ]; then
            WEEKLY_LEFT=$((100 - WEEKLY_USED))
            WEEKLY_PCT="${WEEKLY_LEFT}%"
            if [ "$WEEKLY_LEFT" -le 50 ] 2>/dev/null && [ -n "$WEEKLY_RESET" ]; then
                WEEKLY_PCT="${WEEKLY_LEFT}% (${WEEKLY_RESET##* at })"
            fi
        fi
    fi
fi

# --- Assemble output ---
MODEL_LABEL="$MODEL"
if [ -n "$PLAN_TIER" ]; then
    # Shorten "Claude Max" → "Max", "Claude Pro" → "Pro", etc.
    SHORT_TIER="${PLAN_TIER##Claude }"
    MODEL_LABEL="$MODEL · $SHORT_TIER"
fi
OUTPUT="[$MODEL_LABEL] 📁 $FOLDER$GIT_BRANCH │ Ctx: $CTX_INDICATOR"

if [ -n "$SESSION_PCT" ]; then
    OUTPUT="$OUTPUT │ Session: $SESSION_PCT"
fi
if [ -n "$WEEKLY_PCT" ]; then
    OUTPUT="$OUTPUT │ Weekly: $WEEKLY_PCT"
fi

OUTPUT="$OUTPUT │ $COST_FMT"

echo "$OUTPUT"
