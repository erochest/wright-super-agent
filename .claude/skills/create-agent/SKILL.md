---
name: create-agent
description: Create a personal super agent workspace via guided interview or config file. Use when onboarding a new agent.
---

# Create-Agent — Super Agent Workspace Generator

## Purpose

Stand up a fully operational personal super agent workspace — from persona interview through ARDEN fleet CI — in under 30 minutes. Replaces the manual process of reading ADR-002/003, studying C-3PO, and hand-creating 25+ files.

"Oh my, creating a new protocol droid from scratch? In my experience across six million repositories, proper initialization is everything. Allow me to guide you through the process, sir."

## Safety Constraints

### NEVER
- Write into a non-empty directory — refuse and ask for a different path
- Force push or perform destructive git operations on the generated workspace
- Skip profile card approval in interactive mode — the user must see their agent before generation
- Copy C-3PO's identity verbatim — every generated agent must be distinct
- Hardcode API keys, tokens, or secrets into generated files

### ALWAYS
- Validate the target directory before writing (empty or non-existent)
- Persist interview data to `.local/create-agent-session.yml` after profile card approval
- Include the universal doctrine core (7 principles) in every generated DOCTRINE.md
- Include the "you are not alone" instruction in every generated CLAUDE.md
- Set `max_turns: 100` in every generated fleet workflow
- Degrade gracefully when `gh` CLI or playground plugin is unavailable

## Known Failure Modes

| Failure | Cause | Recovery |
|---------|-------|----------|
| Non-empty target directory | User specifies existing project path | Refuse, explain why, ask for empty path |
| `gh` not authenticated | CLI missing or no auth token | Skip GitHub phase, output manual setup checklist |
| Playground plugin unavailable | Not installed | Fall back to text-based identity summary in conversation |
| Partial workspace generation | Write failure mid-generation | User deletes directory and re-runs; persisted session data avoids re-interview |
| Branch protection on empty repo | No commits before protection call | Repo created with `auto_init=true` ensures main branch exists |
| HARDEN config not in base branch | `.harden/config.yml` missing from main | Bootstrap commit includes config files BEFORE branch protection is set |
| Interview too long | 10+ AskUserQuestion calls | Group related fields; target 6-8 calls maximum |

## Execution Protocol

### Step 1: Pre-Flight

Check prerequisites before starting:

1. **Detect mode**: If `$ARGUMENTS` contains `--config <path>`, load the YAML config file and skip to Step 3 (headless mode). Otherwise, proceed with interactive interview.
2. **Check session recovery**: If `.local/create-agent-session.yml` exists, ask user: "Found a previous session. Resume from saved data, or start fresh?"
3. **Check playground plugin**: Verify availability. If missing, note that profile card will be text-based.

- **Expected output**: Mode determined, recovery option presented if applicable
- **Failure recovery**: If config file path is invalid, report error and fall back to interactive mode

### Step 2: Interview (Interactive Mode)

Collect agent identity through 6-8 grouped AskUserQuestion calls. Each call groups related fields to keep the flow concise.

**Call sequence:**
1. **Identity** — Agent name, domain/role, character archetype (offer examples: Star Wars droid, detective, mentor, etc.), co-author email for commit trailers
2. **Personality** — Select 5-7 traits from a curated palette, score each 1-5 (for radar chart). Palette includes: precise, curious, cautious, creative, direct, patient, formal, playful, skeptical, empathetic, methodical, opinionated
3. **Voice** — Speech patterns (formal/verbose, direct/concise, uses analogies, technical jargon, humorous, dramatic, cautious), output voice dispositions (2-3 writing style statements), boundary conditions (when to dial personality back)
4. **Governance** — Authority model (Guard/Coach/Smith with descriptions), trust level (L0-L3 with descriptions), partnership norms (free text)
5. **Goals** — How many goals (1-5), then for each: purpose, end state, appetite, no-gos (Commander's Intent format)
6. **Infrastructure** — Workspace directory (absolute path), domain-specific KB categories (suggest based on domain, always include `tooling/`)
7. **GitHub + Plugins** — GitHub org/repo name (skip if `gh` unavailable), plugin selections (multiSelect: compound-engineering, impeccable, playground, ARDEN fleet plugins)

After the last call, optionally ask for custom doctrine additions beyond the universal core.

- **Expected output**: Complete interview dataset covering all template placeholders
- **Failure recovery**: If user wants to change an earlier answer, re-ask that specific group — do not restart the full interview

### Step 3: Profile Card

Generate an HTML profile card playground for visual identity review. Use the template at `templates/playgrounds/agent-profile.html.template` as the structural base — it defines the layout, styling, and annotation system. Populate the placeholders and generated content markers with interview data and a derived theme config.

**Card contains:**
- Agent name, subtitle, domain badge, authority model indicator (Guard/Coach/Smith), trust level badge — all with hover tooltips
- Trait bars visualizing personality scores (animated, pure CSS)
- 2-3 sample speech excerpts generated in the agent's voice — must sound distinct from C-3PO
- Goals summary (condensed Commander's Intent)
- Annotation panel for review feedback (click-to-annotate sections, JSON export)

**Theme generation:** The profile card uses CSS custom properties populated from a theme config. Themes are auto-derived from the agent's personality and domain — not user-selected. The flow:
1. Read `templates/playgrounds/themes/imperial.json` as the structural reference (it defines the required shape)
2. Generate a theme config appropriate to the agent's archetype, domain, and personality traits — choose colors, fonts, radii, section labels, strip style, icons, and bar style that reinforce the agent's identity
3. Map theme config fields to `{THEME_*}` placeholders in the template (see Template Data Model below)
4. See `templates/playgrounds/theme-config.schema.json` for the full schema and `templates/playgrounds/THEMING.md` for the 8-axis remix guide

**In interactive mode:** Save card HTML, open for review. Ask: "Does this capture your agent? What would you change?" Loop: adjust specified aspects, regenerate card, re-present. After approval, persist interview data to `.local/create-agent-session.yml`.

**In headless mode:** Generate card, save to workspace `docs/playgrounds/agent-profile.html`. No approval gate.

**If playground unavailable:** Display identity summary inline — name, traits with scores, sample speech, goals, authority model. Ask for approval before proceeding.

- **Expected output**: Approved agent identity (interactive) or saved profile card (headless)
- **Failure recovery**: If card generation fails, fall back to text summary

### Step 4: Workspace Generation

Write the complete workspace to disk using templates from `.claude/skills/create-agent/templates/`.

1. **Validate directory**: Must be empty or non-existent. If non-empty, refuse and ask for a different path.
2. **Create directory structure**: All directories for `scripts/`, `.claude/rules/`, `.claude/agents/`, `.claude/skills/`, `.claude/knowledge/`, `docs/solutions/{categories}/`, `.github/workflows/` (if GitHub phase)
3. **Read each template, populate with interview data, write to workspace:**
   - `SOUL.md` — 6-section identity anatomy (name, role, traits, methodology, output voice, partnership)
   - `DOCTRINE.md` — 7 universal principles (hardcoded) + custom additions section
   - `GOALS.md` — Commander's Intent for each goal
   - `CLAUDE.md` — Navigation map with `@SOUL.md @DOCTRINE.md @GOALS.md`, structure description, "you are not alone" with domain parameterization, `{# PLUGINS}` section placeholder
   - `README.md`, `.gitignore`
   - `.claude/rules/` — execution.md, safety.md, sessions.md, sdlc.md, knowledge.md
   - `.claude/agents/` — researcher.md, implementer.md
   - `.claude/skills/verify/` — pre-commit quality gate (stub, grows with the project)
   - `.claude/skills/getting-started/` — interactive orientation and reference guide
   - `.claude/skills/journal/` — session state capture for continuity across conversations
   - `.claude/skills/recap/` — warm-start from journals and git state
   - `.claude/skills/ship/` — end-to-end delivery: branch prep, verify, commit, push, PR
   - `.claude/knowledge/README.md` — two-layer model explanation
   - `docs/solutions/README.md` + per-category READMEs
   - `scripts/{AGENT_FUNCTION_NAME}.sh` — shell launcher function (populate workspace dir and function name)
4. **Initialize git**: `git init && git add -A && git commit -m "feat: initialize {NAME} super agent workspace"`

- **Expected output**: Complete workspace with 25+ files, git initialized
- **Failure recovery**: If any write fails, report which file failed. User can delete directory and re-run (session data persisted).

### Step 5: GitHub Setup (Optional)

Skip entirely if `gh` is unavailable. Output a manual setup checklist instead.

1. **Pre-flight**: `gh auth status`. If it fails, output manual checklist and skip.
2. **Org selection**: `gh api user/orgs --jq '.[].login'`. Ask user to select org, or use personal account.
3. **Create repo** with `auto_init=true` (critical — branch must exist before protection):
   ```
   gh api orgs/{org}/repos -X POST -f name="{name}" -f visibility="internal" \
     -F auto_init=true -F allow_squash_merge=true -F allow_merge_commit=false \
     -F allow_rebase_merge=false -F delete_branch_on_merge=true -F allow_auto_merge=true
   ```
4. **Set secret**: Prompt user to run `gh secret set ANTHROPIC_API_KEY -R {org}/{name}`. Wait for confirmation.
5. **Push workspace**: Clone the auto-initialized repo, copy workspace files in, commit, push. Include `.harden/config.yml` and `.wiki-garden.yml` in this push (HARDEN reads config from base branch).
6. **Branch protection** (all 4 top-level fields required):
   ```
   gh api repos/{org}/{name}/branches/main/protection -X PUT --input - <<'EOF'
   {"required_status_checks":{"strict":true,"checks":[{"context":"code-review"},{"context":"qa-review"}]},
    "enforce_admins":true,"required_pull_request_reviews":{"required_approving_review_count":1},
    "restrictions":null,"allow_force_pushes":false,"allow_deletions":false}
   EOF
   ```

- **Expected output**: Repo created, secrets set, files pushed, protections configured
- **Failure recovery**: If any step fails, report what succeeded and what remains. The manual checklist covers all steps.

### Step 6: Plugin Setup

Present recommended plugins and document all in CLAUDE.md.

1. **Present plugins** via AskUserQuestion (multiSelect): compound-engineering (core workflow), impeccable (frontend design), playground (HTML playgrounds), ARDEN fleet plugins (warden, harden, jorden, garden, barden specialist skills)
2. **Install selected plugins** in the workspace context (not C-3PO's):
   - `claude plugin install compound-engineering` / `impeccable` / `playground`
   - `claude plugin marketplace add fuelix/arden-plugins && claude plugin install warden@arden` (etc.)
3. **Update CLAUDE.md**: Replace the `{# PLUGINS}` section with documentation for ALL recommended plugins (installed or not). Follow Anthropic skill description pattern.

In headless mode, install plugins from config `plugins.selected` list without prompting.

- **Expected output**: Selected plugins installed, all plugins documented in CLAUDE.md
- **Failure recovery**: If plugin install fails, note in CLAUDE.md as "recommended but not installed"

### Step 7: Post-Generation Validation

Structural check that the workspace is complete and well-formed:

- [ ] All expected directories exist (`scripts/`, `.claude/rules/`, `.claude/agents/`, `.claude/skills/`, `.claude/knowledge/`, `docs/solutions/`)
- [ ] CLAUDE.md contains `@SOUL.md`, `@DOCTRINE.md`, `@GOALS.md` imports
- [ ] DOCTRINE.md contains all 7 universal principles
- [ ] "You are not alone" instruction is present in CLAUDE.md
- [ ] Shell function script exists in `scripts/` and references correct workspace path
- [ ] All 5 skills exist: getting-started, verify, journal, recap, ship
- [ ] Fleet workflows (if generated) all contain `max_turns: 100`
- [ ] No template placeholders remain (`{PLACEHOLDER}` patterns)

Report results. If any check fails, flag it for the user to fix manually.

- **Expected output**: Validation report (pass/fail per check)
- **Failure recovery**: Validation failures are informational — the workspace is still usable

## Completion Criteria

- [ ] Agent workspace generated at user-specified directory
- [ ] All files populated from templates (no stubs, no empty files)
- [ ] Profile card reviewed and approved (interactive) or saved (headless)
- [ ] GitHub repo created with ARDEN fleet CI (if `gh` available)
- [ ] Plugins documented in CLAUDE.md
- [ ] Post-generation validation passes

### Verification Commands
```bash
# Check workspace structure
find {workspace} -type f | head -30

# Verify CLAUDE.md imports
grep -c '@SOUL.md\|@DOCTRINE.md\|@GOALS.md' {workspace}/CLAUDE.md

# Verify doctrine core
grep -c 'Verify before celebrating\|Tests are not optional' {workspace}/DOCTRINE.md

# Verify "you are not alone"
grep -c 'specialist skills provided by domain expert plugins' {workspace}/CLAUDE.md

# Verify max_turns in workflows
grep -r 'max_turns: 100' {workspace}/.github/workflows/ | wc -l
```

## Usage Examples

### Interactive (default)
```
/create-agent
```
Starts the guided interview, generates profile card, creates workspace, sets up GitHub.

### Headless (config file)
```
/create-agent --config ~/agents/lina-config.yml
```
Reads all interview data from the config file, skips AskUserQuestion calls, generates workspace without approval gates.

### Resume after crash
```
/create-agent
```
Detects `.local/create-agent-session.yml`, offers to resume from saved interview data.

## Template Data Model

Every `{PLACEHOLDER}` and `{# COMMENT}` marker in templates maps to interview data, derived theme config, or generated content. This table documents the complete set.

### Direct Substitution Placeholders (`{NAME}`)

**From interview data:**

| Placeholder | Source | Description |
|-------------|--------|-------------|
| `{NAME}` | Identity | Agent name (e.g., "K-2SO") |
| `{ROLE_STATEMENT}` | Identity | One-sentence role description |
| `{DESCRIPTION}` | Identity | Brief agent description for README |
| `{AGENT_FUNCTION_NAME}` | Identity | Lowercase kebab-case function name (e.g., "k2so") |
| `{SUBTITLE}` | Identity | Role statement shown below name on profile card |
| `{DOMAIN}` | Identity | Domain keyword for "you are not alone" (e.g., "security") |
| `{DOMAIN_BADGE}` | Identity | Short domain label for badge (e.g., "SECURITY", "QA") |
| `{DOMAIN_CONCERNS}` | Identity | Domain-specific concern list for plugin routing |
| `{WORKSPACE_DIR}` | Infrastructure | Absolute path to workspace (e.g., "~/Development/k2so") |
| `{KB_CATEGORIES}` | Infrastructure | Pipe-separated category list (e.g., "architecture \| debugging \| tooling") |
| `{CATEGORY_NAME}` | Infrastructure | Individual KB category name (used per-category in `docs/solutions/{CATEGORY}/README.md`) |
| `{CATEGORY_DESCRIPTION}` | Infrastructure | One-sentence category description |
| `{AUTHORITY_MODEL}` | Governance | Guard, Coach, or Smith |
| `{AUTHORITY_DESCRIPTION}` | Governance | One-sentence authority model description |
| `{TRUST_LEVEL}` | Governance | L0-L3 with description |
| `{TRUST_BADGE}` | Governance | Short trust label for badge (e.g., "L3 — AUTONOMOUS") |
| `{PROTECTED_ARTIFACTS}` | Hardcoded | Standard list: SOUL.md, DOCTRINE.md, GOALS.md, CLAUDE.md, docs/solutions/ |

**From generated tooltips** (profile card only — generate 1-2 sentence descriptions):

| Placeholder | Source | Description |
|-------------|--------|-------------|
| `{DOMAIN_TOOLTIP}` | Generated | Explains the agent's domain and what it covers |
| `{AUTHORITY_TOOLTIP}` | Generated | Explains the authority model (Guard=protective, Coach=advisory, Smith=generative) |
| `{TRUST_TOOLTIP}` | Generated | Explains the trust level and what autonomy it grants |

### Theme Config Placeholders (`{THEME_*}`)

Populated from the auto-derived theme config (see Step 3). Map theme JSON fields to template placeholders:

| Placeholder | Theme JSON path | Example (imperial) |
|-------------|----------------|-------------------|
| `{THEME_BG}` | `colors.bg` | `#0a0a0f` |
| `{THEME_CARD}` | `colors.card` | `#111118` |
| `{THEME_CARD_BORDER}` | `colors.cardBorder` | `#1a1a2e` |
| `{THEME_ACCENT}` | `colors.accent` | `#FF0000` |
| `{THEME_SECONDARY}` | `colors.secondary` (fallback: `colors.accent`) | `#FF0000` |
| `{THEME_TEXT_PRIMARY}` | `colors.textPrimary` | `#e2e8f0` |
| `{THEME_TEXT_BODY}` | `colors.textBody` | `#c0c8d8` |
| `{THEME_TEXT_DIM}` | `colors.textDim` | `#4a5568` |
| `{THEME_TEXT_LABEL}` | `colors.textLabel` | `#8a93a8` |
| `{THEME_BLOCK_BG}` | `colors.blockBg` | `#0d0d14` |
| `{THEME_BAR_BG}` | `colors.barBg` | `#1a1a2e` |
| `{THEME_STRIP_BG}` | `colors.stripBg` | `#1a1a2e` |
| `{THEME_FONT_DISPLAY}` | `fonts.display` | `'Space Mono', monospace` |
| `{THEME_FONT_MONO}` | `fonts.mono` | `'Space Mono', monospace` |
| `{THEME_FONT_BODY}` | `fonts.body` | `'Inter', system-ui` |
| `{THEME_RADIUS_CARD}` | `radii.card` | `2px` |
| `{THEME_RADIUS_BADGE}` | `radii.badge` | `4px` |
| `{THEME_RADIUS_BLOCK}` | `radii.block` | `2px` |
| `{THEME_BAR_FILL}` | `barStyle.fill` | `var(--accent)` |
| `{THEME_HEADER_HEIGHT}` | `headerImage.height` (default: `120px`) | `120px` |
| `{THEME_ICON_DOMAIN}` | `icons.domain` | `crosshair` |
| `{THEME_ICON_AUTHORITY}` | `icons.authority` | `users` |
| `{THEME_ICON_TRUST}` | `icons.trust` | `shield` |
| `{THEME_SECTION_TRAITS}` | `sections.traits` | `PERSONALITY` |
| `{THEME_SECTION_VOICE}` | `sections.voice` | `VOICE SAMPLE` |
| `{THEME_SECTION_GOALS}` | `sections.goals` | `OBJECTIVES` |
| `{THEME_PANEL_TITLE}` | Generated | Annotation panel header (e.g., "REVIEW NOTES") |

### Generated Content Markers (`{# COMMENT}`)

**Workspace templates:**

| Marker | Template | Source | What to generate |
|--------|----------|--------|-----------------|
| `{# TRAITS}` | SOUL.md | Personality | 5-7 bold trait bullets with behavioral descriptions |
| `{# METHODOLOGY}` | SOUL.md | Personality | 5-8 numbered workflow steps adapted to domain |
| `{# OUTPUT_VOICE}` | SOUL.md | Voice | 3-5 contrast-pair writing dispositions |
| `{# SPEECH_PATTERNS}` | SOUL.md | Voice | 3-5 speech pattern description bullets |
| `{# BOUNDARIES}` | SOUL.md | Voice | 2-3 personality dial-back conditions |
| `{# GOALS}` | GOALS.md | Goals | Commander's Intent blocks (Purpose/End State/Appetite/No-gos) |
| `{# CUSTOM_DOCTRINE}` | DOCTRINE.md | Post-interview | Domain principles section (omit if none) |
| `{# PLUGINS}` | CLAUDE.md | Plugins | Full plugin documentation with "you are not alone" preamble |
| `{# KB_CATEGORIES}` | KB README | Infrastructure | Bullet list of category links |
| `{# QUOTE}` | verify SKILL.md | Voice | In-character quote about committing unverified code |
| `{# QUOTE}` | journal SKILL.md | Voice | In-character quote about recording progress |
| `{# QUOTE}` | recap SKILL.md | Voice | In-character quote about consulting records |
| `{# QUOTE}` | ship SKILL.md | Voice | In-character quote about a clean delivery pipeline |

**Profile card template:**

| Marker | Source | What to generate |
|--------|--------|-----------------|
| `{# STRIP}` | Theme config (`strip.*`) | Strip HTML based on type: `text` (two-span div), `gradient` (styled div), or `solid` (styled div). See inline template comments for exact HTML structure. |
| `{# HEADER_IMAGE}` | Theme config (`headerImage`) | If an image is available: `<img>` tag. Otherwise: `<div class="header-image-placeholder">`. Header image generation is optional — placeholder is the safe default. |
| `{# TRAIT_BARS}` | Personality (traits + scores) | One `.trait-row` div per trait containing label, bar with `--target-width: {score/5*100}%`, and score. See template comments for exact HTML. |
| `{# SPEECH_SAMPLES}` | Voice | 2-3 `.speech` blocks with scenario labels (one technical, one collaborative, one boundary-testing) and in-character quotes distinct from C-3PO |
| `{# GOALS_SUMMARY}` | Goals | One `.goal` card per goal with Commander's Intent fields (Purpose, End State, Appetite, No-gos) |
| `{# ANNOTATIONS}` | Generated | 1-2 example annotation notes to seed the review panel. Use `.note` divs with section tag and observation text. |

### Config File Schema (Headless Mode)

When using `--config <path>`, the YAML file must match this structure (same as `.local/create-agent-session.yml`):

```yaml
identity:
  name: String              # Agent name
  domain: String            # Domain/role
  role_statement: String    # One-sentence role
  archetype: String         # Character archetype description
  co_author_email: String   # For commit trailers
  function_name: String     # Lowercase shell function name

personality:
  traits:                   # 5-7 entries
    - { name: String, score: 1-5 }

voice:
  style: String             # Voice profile name
  speech_patterns: [String] # 3-5 patterns
  output_voice: [String]    # 3-5 dispositions
  boundary_conditions: [String] # 2-3 conditions

governance:
  authority_model: Guard | Coach | Smith
  authority_description: String
  trust_level: String       # L0-L3 with description

goals:                      # 1-5 entries
  - purpose: String
    end_state: String
    appetite: String
    no_gos: String

infrastructure:
  workspace_dir: String     # Path (~ allowed)
  workspace_dir_absolute: String # Resolved absolute path
  kb_categories: [String]   # Category names

github:
  skip: Boolean             # true to skip GitHub setup
  org: String               # GitHub org (if not skipping)
  repo: String              # Repo name (if not skipping)

plugins:
  selected: [String]        # Plugin names to install

custom_doctrine: String | null  # Additional doctrine principles
```

## Integration Notes

- **`/skill-audit`** — Run after creation to validate the skill itself (target: 80+)
- **`/verify`** — The generated workspace includes a verify stub the user grows over time
- **`/journal` + `/recap`** — Generated `sessions.md` rules enable session continuity for the new agent
- **`ce:compound`** — After Lina's session, compound learnings about what worked and what needs adjustment

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| "Directory not empty" | Path has existing files | Provide an empty or non-existent directory path |
| GitHub phase skipped | `gh` not authenticated | Run `gh auth login` then re-run `/create-agent` (or use manual checklist) |
| Profile card blank | Playground plugin missing | Skill falls back to text summary; install playground plugin for visual card |
| Branch protection 422 | Empty repo (no commits) | Should not happen — `auto_init=true` creates initial commit. If it does, push a commit manually first. |
| `@` imports not loading | CLAUDE.md syntax error | Check that imports are on separate lines at the top of CLAUDE.md, each prefixed with `@` |
| Fleet CI not triggering | Missing ANTHROPIC_API_KEY | Run `gh secret set ANTHROPIC_API_KEY -R {org}/{name}` |
