# Quick Start (TL;DR)

Get Claude Code status bar working in 60 seconds.

## One Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/install.sh | bash
```

Then **restart Claude Code**.

---

## What You'll See

```
[Opus 4.6 · Max] 📁 project 🌿 main │ Ctx: 🟢 12% │ Session: 66% │ Weekly: 68% │ $4.82
```

---

## Manual Install (3 commands)

```bash
brew install jq steipete/tap/codexbar
curl -fsSL https://gist.githubusercontent.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e/raw/statusline.sh -o ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

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

Restart Claude Code.

---

## Troubleshooting

**No status bar?**
- Restart Claude Code (exit and start new session)
- Check `~/.claude/statusline.sh` exists and is executable

**No rate limits?**
```bash
brew install steipete/tap/codexbar
```

**Still broken?**
See full docs: [README.md](./README.md)

---

## Credits

Original work by [@kanoliban](https://github.com/kanoliban)
https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e
