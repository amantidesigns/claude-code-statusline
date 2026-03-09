# Examples and Use Cases

## Visual Examples

### Full Status Bar (with CodexBar)

When you have plenty of capacity:
```
[Opus 4.6 · Max] 📁 my-app 🌿 main │ Ctx: 🟢 12% │ Session: 66% │ Weekly: 68% │ $4.82
```

When session usage is getting low (shows reset time):
```
[Opus 4.6 · Max] 📁 my-app 🌿 feat/new-ui │ Ctx: 🟡 65% │ Session: 45% (8:00PM) │ Weekly: 68% │ $12.34
```

When approaching context limit:
```
[Opus 4.6 · Max] 📁 my-app 🌿 main │ Ctx: 🔴 87% │ Session: 30% (7:45PM) │ Weekly: 25% (Mon 2:00PM) │ $18.99
```

### Minimal Status Bar (without CodexBar)

```
[Sonnet 4.5] 📁 my-project 🌿 develop │ Ctx: 🟢 15% │ $2.45
```

### Different Plan Tiers

**Claude Max:**
```
[Opus 4.6 · Max] 📁 project │ Ctx: 🟢 8% │ Session: 85% │ Weekly: 72% │ $3.21
```

**Claude Pro:**
```
[Opus 4.6 · Pro] 📁 project │ Ctx: 🟢 8% │ Session: 45% │ Weekly: 62% │ $1.87
```

**Free Tier:**
```
[Sonnet 4.5 · Free] 📁 project │ Ctx: 🟢 5% │ Session: 92% │ Weekly: 88% │ $0.00
```

---

## Real-World Scenarios

### Scenario 1: Long Coding Session

You're working on a complex refactoring:

```
Start of session:
[Opus 4.6 · Max] 📁 api-server 🌿 refactor │ Ctx: 🟢 5% │ Session: 95% │ Weekly: 78% │ $0.12

After 2 hours:
[Opus 4.6 · Max] 📁 api-server 🌿 refactor │ Ctx: 🟡 62% │ Session: 72% │ Weekly: 75% │ $8.45

Near session limit:
[Opus 4.6 · Max] 📁 api-server 🌿 refactor │ Ctx: 🔴 85% │ Session: 35% (7:30PM) │ Weekly: 71% │ $15.23
```

**What this tells you:**
- Context is getting full (🔴 85%) - consider starting fresh session soon
- Session resets at 7:30PM - you have some capacity left
- Weekly usage still healthy at 71%
- Cost tracking helps budget your API usage

### Scenario 2: Multiple Projects in a Day

Switching between different projects:

```
Morning - Frontend work:
[Sonnet 4.5 · Max] 📁 dashboard-ui 🌿 main │ Ctx: 🟢 18% │ Session: 88% │ Weekly: 82% │ $1.23

Afternoon - Backend API:
[Opus 4.6 · Max] 📁 api-server 🌿 develop │ Ctx: 🟢 22% │ Session: 65% │ Weekly: 77% │ $6.78

Evening - Documentation:
[Haiku · Max] 📁 docs 🌿 update-readme │ Ctx: 🟢 8% │ Session: 55% │ Weekly: 75% │ $7.12
```

**What this tells you:**
- Different models for different tasks (cost optimization)
- Weekly usage slowly decreasing throughout the day
- Folder and branch names help you track context switches

### Scenario 3: Heavy Usage Week

```
Monday:
[Opus 4.6 · Max] 📁 startup-mvp │ Ctx: 🟢 15% │ Session: 70% │ Weekly: 95% │ $4.56

Wednesday:
[Opus 4.6 · Max] 📁 startup-mvp │ Ctx: 🟡 68% │ Session: 45% (8:15PM) │ Weekly: 72% │ $18.34

Friday (approaching weekly limit):
[Opus 4.6 · Max] 📁 startup-mvp │ Ctx: 🟢 12% │ Session: 88% │ Weekly: 32% (Mon 1:00PM) │ $31.45
```

**What this tells you:**
- Weekly capacity dropping significantly
- Reset time appears when < 50% (Mon 1:00PM)
- Time to optimize usage or wait for reset

---

## What to Do When...

### Context is Yellow (🟡 60-80%)

**Actions:**
- Finish current task before context gets full
- Consider summarizing conversation to reduce tokens
- Save important code snippets externally

### Context is Red (🔴 80%+)

**Actions:**
- Wrap up current task immediately
- Start a new Claude Code session for next task
- Context window will reset with new session

### Session Below 50%

**Actions:**
- Note the reset time shown in parentheses
- Pace your usage until reset
- Consider using Haiku model for simple tasks

### Weekly Below 50%

**Actions:**
- Monitor reset time (shown in parentheses)
- Prioritize critical tasks
- Consider breaking work into smaller sessions
- Remember weekly limits reset every 7 days

### Cost Tracking

The cost counter helps you:
- **Budget API usage** for paid plans
- **Track expensive sessions** (large context, many requests)
- **Compare model costs** (Opus vs Sonnet vs Haiku)
- **Optimize spending** by choosing appropriate models

---

## Pro Tips

### 1. Model Selection Strategy

Use different models based on task complexity:

```bash
# Complex architecture/refactoring → Opus
[Opus 4.6 · Max] 📁 app │ Ctx: 🟢 15% │ Session: 75% │ $8.50

# Standard coding tasks → Sonnet
[Sonnet 4.5 · Max] 📁 app │ Ctx: 🟢 12% │ Session: 85% │ $2.30

# Simple edits/questions → Haiku
[Haiku · Max] 📁 app │ Ctx: 🟢 5% │ Session: 92% │ $0.45
```

### 2. Context Management

Monitor context percentage to avoid hitting limits:
- 🟢 0-60%: Normal usage, keep going
- 🟡 60-80%: Start wrapping up
- 🔴 80-100%: Finish task and restart

### 3. Git Branch Tracking

The branch indicator helps prevent mistakes:
```
[Opus 4.6 · Max] 📁 app 🌿 main │ ...        ← Careful! You're on main
[Opus 4.6 · Max] 📁 app 🌿 feat/auth │ ...   ← Safe to experiment
```

### 4. Folder Context

Quickly see which project you're working on:
```
[Opus 4.6 · Max] 📁 client-frontend │ ...    ← Frontend project
[Opus 4.6 · Max] 📁 client-backend │ ...     ← Backend project
```

---

## Customization Ideas

### Change Color Thresholds

Edit `~/.claude/statusline.sh`:

```bash
# Default: Yellow at 60%, Red at 80%
if [ "$PERCENT" -gt 80 ]; then
    CTX_INDICATOR="🔴 ${PERCENT}%"
elif [ "$PERCENT" -gt 60 ]; then
    CTX_INDICATOR="🟡 ${PERCENT}%"

# More conservative: Yellow at 50%, Red at 70%
if [ "$PERCENT" -gt 70 ]; then
    CTX_INDICATOR="🔴 ${PERCENT}%"
elif [ "$PERCENT" -gt 50 ]; then
    CTX_INDICATOR="🟡 ${PERCENT}%"
```

### Add Timestamp

```bash
TIMESTAMP=$(date +"%H:%M")
OUTPUT="$OUTPUT │ $TIMESTAMP"
```

Result: `... │ $4.82 │ 14:30`

### Show Only Critical Info

For minimal displays:
```bash
# Just model, context, and cost
OUTPUT="[$MODEL_LABEL] │ $CTX_INDICATOR │ $COST_FMT"
```

---

## Troubleshooting Examples

### Rate Limits Not Showing

If you see:
```
[Claude] 📁 project 🌿 main │ Ctx: 🟢 12% │ $0.00
```

**Problem:** No Session/Weekly percentages
**Solution:** Install CodexBar
```bash
brew install steipete/tap/codexbar
```

### Git Branch Not Showing

If you see:
```
[Opus 4.6 · Max] 📁 project │ Ctx: 🟢 12% │ ...
```

**Problem:** No 🌿 branch indicator
**Solution:** Make sure you're in a git repository
```bash
cd ~/my-project
git init  # or clone a repo
```

### Cost Shows $0.00

This is normal for:
- Free tier users
- Start of new sessions
- Cost hasn't accumulated yet

Cost will increment as you use Claude Code in the session.

---

## Credits

Original implementation by [@kanoliban](https://github.com/kanoliban)
https://gist.github.com/kanoliban/39bb37cda2678b6e0941c5ca99757d9e
