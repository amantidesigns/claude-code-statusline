# Claude Code Statusline with CodexBar Integration

Live rate-limit visibility in your Claude Code status bar.

> Fork of the original work by [@kanoliban](https://github.com/kanoliban)
> ([original gist](https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e))

---

## Choose Your Layout

### Standard

Full detail — model, plan tier, folder, branch, context, session, weekly, and cost.

```
[Opus 4.6 · Max] 📁 my-project │ main │ Ctx: 🟢 12% │ Session: 66% │ Weekly: 68% │ $4.82
```

### Minimal

~50% shorter — icon-based labels, no cost, no plan tier. Ideal if you use Companions/Buddies or have a narrow terminal.

```
Opus │ 📁 my-project │ main │ 🟢 12% │ ⏳ 66% │ 📅 68%
```

---

## At a Glance

### Standard Scenarios

Normal usage:
```
[Opus 4.6 · Max] 📁 app │ main │ Ctx: 🟢 8% │ Session: 85% │ Weekly: 72% │ $3.21
```

Context warning (>60%):
```
[Opus 4.6 · Max] 📁 app │ feat/auth │ Ctx: 🟡 65% │ Session: 45% (8:00PM) │ Weekly: 68% │ $12.34
```

Context critical (>80%), session and weekly running low:
```
[Opus 4.6 · Max] 📁 app │ main │ Ctx: 🔴 87% │ Session: 30% (7:45PM) │ Weekly: 25% (Mon 2pm) │ $18.99
```

### Minimal Scenarios

Normal usage:
```
Opus │ 📁 app │ main │ 🟢 8% │ ⏳ 85% │ 📅 72%
```

Context warning (>60%):
```
Opus │ 📁 app │ feat/auth │ 🟡 65% │ ⏳ 45% (8:00PM) │ 📅 68%
```

Context critical (>80%), everything hot:
```
Opus │ 📁 app │ main │ 🔴 87% │ ⏳ 30% (7:45PM) │ 📅 25% (Mon 2pm)
```

### Icon Reference

| Icon | Meaning |
|------|---------|
| 🟢 | Context 0–60% — plenty of room |
| 🟡 | Context 61–80% — wrap up soon |
| 🔴 | Context 81–100% — approaching limit |
| ⏳ | Session usage (resets every ~5 hours) |
| 📅 | Weekly usage (resets every 7 days) |
| 📁 | Current working directory |
| `│ branch` | Git branch (pipe-separated) |

Reset times appear in parentheses when usage hits 50%+.

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/install.sh | bash
```

The installer will:
1. Check/install dependencies (`jq`, optionally `codexbar`)
2. Ask you to choose **Standard** or **Minimal** layout
3. Download the script and configure Claude Code
4. Verify everything works

---

## Manual Install

### Prerequisites

- macOS (uses `stat -f %m` for cache timing)
- `jq` for JSON parsing
- `codexbar` (optional, for rate limit data)

### Step 1: Install Dependencies

```bash
brew install jq
brew install steipete/tap/codexbar   # optional but recommended
```

### Step 2: Download the Script

**Standard:**
```bash
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/statusline.sh -o ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

**Minimal:**
```bash
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/statusline-minimal.sh -o ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

### Step 3: Configure Claude Code

Add to `~/.claude/settings.local.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

### Step 4: Restart Claude Code

Exit and start a new session. The status bar appears at the bottom of your terminal.

---

## Segments

### Standard Layout

| Segment | Example | Source |
|---------|---------|--------|
| Model + Plan | `[Opus 4.6 · Max]` | stdin + CodexBar |
| Folder | `📁 my-project` | stdin |
| Git Branch | `│ main` | git |
| Context % | `Ctx: 🟢 12%` | stdin |
| Session % | `Session: 66%` | CodexBar |
| Weekly % | `Weekly: 68%` | CodexBar |
| Cost | `$4.82` | stdin |

### Minimal Layout

| Segment | Example | Source |
|---------|---------|--------|
| Model | `Opus` | stdin |
| Folder | `📁 my-project` | stdin |
| Git Branch | `│ main` | git |
| Context % | `🟢 12%` | stdin |
| Session % | `⏳ 66%` | CodexBar |
| Weekly % | `📅 68%` | CodexBar |

---

## When to Act

| Signal | What it means | What to do |
|--------|---------------|------------|
| 🟡 60–80% context | Getting full | Finish current task |
| 🔴 80%+ context | Near limit | Wrap up, start a new session |
| ⏳ or Session < 50% | Session draining | Note reset time, pace usage |
| 📅 or Weekly < 50% | Weekly draining | Prioritize critical tasks |

---

## Switching Layouts

Already installed one and want to switch? Just re-download:

```bash
# Switch to minimal
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/statusline-minimal.sh -o ~/.claude/statusline.sh

# Switch to standard
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/statusline.sh -o ~/.claude/statusline.sh
```

No settings changes needed — both scripts use the same path.

---

## Troubleshooting

**Status bar doesn't appear**
- Verify script exists: `ls -la ~/.claude/statusline.sh`
- Verify settings JSON: `cat ~/.claude/settings.local.json | jq .`
- Restart Claude Code

**No session/weekly data**
- Install CodexBar: `brew install steipete/tap/codexbar`
- Run once to authenticate: `codexbar --provider claude`

**No git branch showing**
- Make sure you're inside a git repository

---

## Testing

```bash
echo '{"model":{"display_name":"Opus 4.6"},"cost":{"total_cost_usd":1.23},"context_window":{"context_window_size":200000,"current_usage":{"input_tokens":10000,"cache_creation_input_tokens":5000,"cache_read_input_tokens":5000}},"workspace":{"current_dir":"~/my-project"}}' | ~/.claude/statusline.sh
```

---

## Credits

- **Original implementation**: [@kanoliban](https://github.com/kanoliban) — [original gist](https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e)
- **CodexBar**: [@steipete](https://github.com/steipete) — [CodexBar](https://github.com/steipete/CodexBar)
- **Enhanced docs, minimal layout, and installer**: [@amantidesigns](https://github.com/amantidesigns)

## License

This project maintains the same license as the original work.
