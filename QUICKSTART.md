# Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/install.sh | bash
```

The installer asks you to pick a layout:

**Standard** — full detail
```
[Opus 4.6 · Max] 📁 project 🌿 main │ Ctx: 🟢 12% │ Session: 66% │ Weekly: 68% │ $4.82
```

**Minimal** — ~50% shorter, icon labels, no cost
```
Opus │ 📁 project 🌿 main │ 🟢 12% │ ⏳ 66% │ 📅 68%
```

Restart Claude Code after install.

---

**Switch anytime:**
```bash
# Standard
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/statusline.sh -o ~/.claude/statusline.sh

# Minimal
curl -fsSL https://raw.githubusercontent.com/amantidesigns/claude-code-statusline/main/statusline-minimal.sh -o ~/.claude/statusline.sh
```

See [README.md](./README.md) for full docs.

---

Credits: [@kanoliban](https://github.com/kanoliban) ([original gist](https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e))
