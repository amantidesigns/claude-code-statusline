# Examples

## Standard Layout

### Normal Usage
```
[Opus 4.6 · Max] 📁 app 🌿 main │ Ctx: 🟢 8% │ Session: 85% │ Weekly: 72% │ $3.21
```

### Context Warning (>60%)
```
[Opus 4.6 · Max] 📁 app 🌿 feat/auth │ Ctx: 🟡 65% │ Session: 45% (8:00PM) │ Weekly: 68% │ $12.34
```

### Everything Hot
```
[Opus 4.6 · Max] 📁 app 🌿 main │ Ctx: 🔴 87% │ Session: 30% (7:45PM) │ Weekly: 25% (Mon 2pm) │ $18.99
```

### Different Models
```
[Opus 4.6 · Max]   📁 api-server │ Ctx: 🟢 15% │ Session: 75% │ Weekly: 70% │ $8.50
[Sonnet 4.5 · Max] 📁 dashboard  │ Ctx: 🟢 12% │ Session: 85% │ Weekly: 70% │ $2.30
[Haiku · Pro]      📁 docs       │ Ctx: 🟢 5%  │ Session: 92% │ Weekly: 70% │ $0.45
```

---

## Minimal Layout

### Normal Usage
```
Opus │ 📁 app 🌿 main │ 🟢 8% │ ⏳ 85% │ 📅 72%
```

### Context Warning (>60%)
```
Opus │ 📁 app 🌿 feat/auth │ 🟡 65% │ ⏳ 45% (8:00PM) │ 📅 68%
```

### Everything Hot
```
Opus │ 📁 app 🌿 main │ 🔴 87% │ ⏳ 30% (7:45PM) │ 📅 25% (Mon 2pm)
```

### Different Models
```
Opus   │ 📁 api-server │ 🟢 15% │ ⏳ 75% │ 📅 70%
Sonnet │ 📁 dashboard  │ 🟢 12% │ ⏳ 85% │ 📅 70%
Haiku  │ 📁 docs       │ 🟢 5%  │ ⏳ 92% │ 📅 70%
```

### Without CodexBar
```
Opus │ 📁 my-project 🌿 develop │ 🟢 15%
```

---

## Side-by-Side Comparison

The same session in both layouts:

**Standard (87 chars):**
```
[Opus 4.6 · Max] 📁 app 🌿 main │ Ctx: 🟢 12% │ Session: 66% │ Weekly: 68% │ $4.82
```

**Minimal (48 chars):**
```
Opus │ 📁 app 🌿 main │ 🟢 12% │ ⏳ 66% │ 📅 68%
```

~45% reduction in width — leaves room for Companions and narrow terminals.

---

## Long Session Progression

### Standard
```
Start:    [Opus 4.6 · Max] 📁 api 🌿 refactor │ Ctx: 🟢 5%  │ Session: 95% │ Weekly: 78% │ $0.12
2 hours:  [Opus 4.6 · Max] 📁 api 🌿 refactor │ Ctx: 🟡 62% │ Session: 72% │ Weekly: 75% │ $8.45
Near end: [Opus 4.6 · Max] 📁 api 🌿 refactor │ Ctx: 🔴 85% │ Session: 35% (7:30PM) │ Weekly: 71% │ $15.23
```

### Minimal
```
Start:    Opus │ 📁 api 🌿 refactor │ 🟢 5%  │ ⏳ 95% │ 📅 78%
2 hours:  Opus │ 📁 api 🌿 refactor │ 🟡 62% │ ⏳ 72% │ 📅 75%
Near end: Opus │ 📁 api 🌿 refactor │ 🔴 85% │ ⏳ 35% (7:30PM) │ 📅 71%
```

---

## Icon Reference

| Icon | Meaning |
|------|---------|
| 🟢 | Context 0–60% |
| 🟡 | Context 61–80% |
| 🔴 | Context 81–100% |
| ⏳ | Session usage (minimal layout) |
| 📅 | Weekly usage (minimal layout) |
| 📁 | Working directory |
| 🌿 | Git branch |
