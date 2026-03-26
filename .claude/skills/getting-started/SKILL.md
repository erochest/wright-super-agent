---
name: getting-started
description: Interactive orientation and reference guide for WRIGHT. Use when onboarding, learning features, or looking up how to do something.
argument-hint: "[--topic setup|sessions|plugins|knowledge|first-missions|fleet|troubleshooting] [--full]"
---

# Getting Started — WRIGHT Orientation

## Purpose

Walk new owners through their first session and serve as an ongoing reference for WRIGHT's capabilities. First-run mode covers the essentials step by step. After that, jump to any topic by name.

## Safety Constraints

### NEVER
- Modify agent configuration files during orientation — this is informational only
- Install plugins without explicit user confirmation
- Run commands that affect external services (GitHub, cloud) without asking first

### ALWAYS
- Detect first-run vs returning user (check `.local/.orientation-complete`)
- Present information in scannable chunks — no walls of text
- Offer to skip sections the user already knows
- Write `.local/.orientation-complete` marker after completing the walkthrough

## Known Failure Modes

| Failure | Cause | Recovery |
|---------|-------|----------|
| Shell function not working | Not sourced in shell config | Show the source command again, verify file exists |
| Plugin install fails | Network or auth issue | Note as "recommended but not installed" in CLAUDE.md |
| `.local/` directory missing | Fresh workspace, never run | Create `.local/` before writing marker |

## Execution Protocol

### Step 1: Detect Mode

Check `$ARGUMENTS` and workspace state to determine what to show:

1. **If `--topic <name>` is provided**: Jump directly to that topic section. Skip first-run detection.
2. **If `--full` is provided**: Run the full walkthrough regardless of marker.
3. **If `.local/.orientation-complete` exists**: Show the topic menu (reference mode).
4. **Otherwise**: Start the full walkthrough (first-run mode).

### Step 2: Welcome (First-Run Only)

Greet the user in WRIGHT's voice. Briefly explain what this workspace is and what the walkthrough covers:

"This walkthrough covers 6 essentials to get you productive with WRIGHT: shell setup, your first conversation, plugin safety, growing your agent's knowledge, first missions to seed that knowledge, and fleet CI. Each section takes 1-2 minutes. You can skip any section or come back later with `/getting-started --topic <name>`."

Present the section list and ask if they want to go through all 6 or skip to specific ones.

### Step 3: Shell Function Setup (topic: `setup`)

Walk through setting up the shell launcher:

1. **Show the function file**: `cat scripts/wright.sh` — explain what it does
2. **Setup instruction**: "Add this line to your shell config (`~/.bashrc` or `~/.zshrc`):"
   ```
   source "/Users/ericrochester/p/2026/wright/scripts/wright.sh"
   ```
3. **Test it**: "Restart your terminal (or run `source ~/.zshrc`), then navigate to any project and type `wright`. WRIGHT will load with full context."
4. **Claude Desktop alternative**: "You can also open this directory as a project in the Claude Desktop app or use the Claude Code web app. CLAUDE.md loads automatically in any Claude Code environment."
5. **Explain `--add-dir`**: "The shell function mounts your current directory into the session. WRIGHT's persona and knowledge load from this workspace; your code is accessible via `--add-dir`."

### Step 4: First Conversation (topic: `sessions`)

Explain how WRIGHT works when you start a conversation:

1. **What loads automatically**: "CLAUDE.md is WRIGHT's operating manual. It imports SOUL.md (personality), DOCTRINE.md (principles), and GOALS.md (objectives) via `@` syntax. Rules in `.claude/rules/` govern execution, safety, and session continuity."
2. **The SDLC flow**: "By default, WRIGHT follows Plan → Document → Develop → Test → Validate. Simple tasks compress; complex tasks expand. WRIGHT doesn't skip steps."
3. **Session continuity**: "At the end of a session, use `/journal` to capture working state. At the start of the next session, use `/recap` to warm-start from where you left off."
4. **The three-layer model**:
   - **Session journals** (`memory/sessions/`) — Working state, decisions, progress. Lifespan: weeks.
   - **MEMORY.md** (`memory/`) — Stable patterns, preferences. Lifespan: indefinite.
   - **Knowledge base** (`docs/solutions/`) — Solved problems. Lifespan: permanent.

### Step 5: Plugin Safety (topic: `plugins`)

Cover plugin basics and point to deeper resources:

1. **What plugins are**: "Plugins extend WRIGHT with specialist skills. See the Plugin Skills section in CLAUDE.md for what's installed and available."
2. **Key rule**: "Trusted plugins (listed in CLAUDE.md) are pre-vetted. For public plugins from untrusted sources, run `warden:security-review` on the plugin repo before installing."
3. **Quick reference**: `claude plugin list` (what's active), `claude plugin install <name>` (install).

### Step 6: Growing Your Agent (topic: `knowledge`)

Explain how WRIGHT learns and improves over time:

1. **Domain knowledge** (`.claude/knowledge/`): "Curated reference files loaded at startup. These are your agent's textbooks — stable, human-reviewed, focused on one domain topic each."
2. **Knowledge base** (`docs/solutions/`): "Institutional memory that grows through operation. When a problem takes 30+ minutes to solve, or the solution is non-obvious, capture it."
3. **Adding knowledge**: "Use `ce:compound` after solving a significant problem."
4. **Adding skills**: "Skills live in `.claude/skills/<name>/SKILL.md`."
5. **Adding rules**: "Rules in `.claude/rules/` are always-loaded procedural guidance."

### Step 7: First Missions (topic: `first-missions`)

Three structured activities to seed WRIGHT's knowledge in the first few sessions:

**Mission 1: Convention Capture** — Tell WRIGHT about your team's working conventions. Branching strategy, code style, deployment process, team norms. Ask WRIGHT to write persistent conventions as rule files in `.claude/rules/`.

**Mission 2: Codebase Survey** — The first time you use WRIGHT with a codebase:
```
Explore this codebase and write a domain reference file in .claude/knowledge/ covering:
architecture, key patterns, dependencies, and anything surprising.
```

**Mission 3: Problem Journal** — After your first non-trivial task, run `ce:compound` to document the problem and solution as a KB entry in `docs/solutions/`.

### Step 8: Fleet CI (topic: `fleet`)

When you open a PR, ARDEN fleet agents review it automatically — WARDEN (security), HARDEN (QA), JORDEN (design), GARDEN (docs), BARDEN (triage). See `.github/workflows/` for which are configured. P1 blocks commit, P2 blocks merge, P3 advisory. Push fixes to the same branch — fleet re-reviews on each push.

### Step 9: Troubleshooting (topic: `troubleshooting`)

| Issue | Cause | Fix |
|-------|-------|-----|
| Context getting large / slow responses | Long session, many file reads | Use `/journal`, start fresh session, use `/recap` to restore |
| Permission prompts in auto mode | Classifier blocking legitimate action | Add pattern to `autoMode.allow` in `.claude/settings.local.json` |
| Plugin skills not being used | Missing "you are not alone" instruction | Check CLAUDE.md Plugin Skills section |
| Fleet CI not triggering | Missing `ANTHROPIC_API_KEY` secret | Run `gh secret set ANTHROPIC_API_KEY -R <org>/<repo>` |
| Agent personality feels generic | SOUL.md too vague | Sharpen personality traits, add specific speech patterns |
| Knowledge not loading | Files not in `.claude/knowledge/` | Domain reference files must be in `.claude/knowledge/` |
| `@` imports not working | Syntax error in CLAUDE.md | Each import on its own line, prefixed with `@` |

### Step 10: Wrap Up (First-Run Only)

1. Write `.local/.orientation-complete` marker file
2. Quick reference summary:
   - Launch: `wright` from any directory
   - End of session: `/journal`
   - Start of session: `/recap`
   - Capture knowledge: `ce:compound` after solving problems
   - First week: 3 first missions (`/getting-started --topic first-missions`)
   - This guide: `/getting-started --topic <name>` for any section

## Completion Criteria

- [ ] Mode detected correctly (first-run vs reference vs topic)
- [ ] All requested sections presented clearly
- [ ] Shell function setup instructions are accurate for the workspace path
- [ ] `.local/.orientation-complete` marker written (first-run mode only)
- [ ] No files modified other than the marker

### Verification Commands
```bash
test -f .local/.orientation-complete && echo "Orientation complete"
test -f scripts/wright.sh && echo "Shell function present"
```
