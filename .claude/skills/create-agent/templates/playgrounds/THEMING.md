# Profile Card Theming Guide

The agent profile card uses a single HTML template with CSS custom properties. Every visual difference between themes is controlled by a JSON config — no template branching, no conditional HTML. Structure is constant; skin varies.

See `theme-config.schema.json` for the full schema. `themes/imperial.json` is the reference config. This guide explains how to remix it for any archetype.

## The 8 Axes

### 1. Mode (light vs dark)

Most agents use dark mode. Light mode inverts the contrast direction — dark text on light backgrounds.

| Dark (Imperial, Noir, Terminal, Zerg) | Light (Sage Mentor) |
|---------------------------------------|---------------------|
| `bg: #0a0a0f`, `card: #111118` | `bg: #F5F0EB`, `card: #FFFFFF` |
| `textPrimary: #e2e8f0` (light on dark) | `textPrimary: #2D3436` (dark on light) |
| `blockBg: #0d0d14` (darker than card) | `blockBg: #FAF8F5` (lighter than card) |

**When to go light**: Warm, approachable, mentor-type archetypes. Agents that should feel safe and inviting.

### 2. Colors

The minimum palette is 4 colors: `accent`, `secondary`, `textPrimary`, `textBody`. Everything else derives from these conceptually.

| Archetype | Accent | Secondary | Feeling |
|-----------|--------|-----------|---------|
| Imperial military | `#FF0000` red | same | Authority, danger, precision |
| Organic/alien | `#9b4dca` purple | `#4ade80` green | Evolution, biology, duality |
| Warm mentor | `#7C9082` sage | same | Calm, growth, nature |
| Noir detective | `#C9A962` gold | same | Mystery, luxury, restraint |
| Hacker/terminal | `#FF6B35` orange | `#00D4AA` teal | Energy, code, duality |

**Dual-color vs mono-color**: Use a distinct `secondary` when the archetype has a natural duality (organic purple + bio-green, hacker orange + terminal teal). Use `accent === secondary` for focused, single-minded archetypes.

### 3. Typography

Three font slots: `display` (agent name, goal titles), `mono` (labels, badges, data), `body` (prose, quotes, descriptions).

| Font Slot | Options by Character |
|-----------|---------------------|
| **display** | Serif (`Playfair Display`, `Fraunces`) for dramatic/warm. Sans (`Space Grotesk`, `Oswald`) for technical/bold. Mono (`Space Mono`) for robotic/military. |
| **mono** | `IBM Plex Mono` (professional), `JetBrains Mono` (developer), `Space Mono` (retro/military) |
| **body** | `Inter` works for everything. Override only if the archetype demands it. |

**Rule of thumb**: The display font carries the personality. The mono font carries the data. The body font should be invisible (readable, not distinctive).

### 4. Border Radius

Radius communicates personality more than any other single property.

| Radius | Character | Examples |
|--------|-----------|----------|
| `0–2px` | Sharp, precise, technical, military | Imperial (2px), Terminal (1px), Noir (2px) |
| `8–12px` | Balanced, modern, organic | Zerg (10px) |
| `16–20px` | Soft, warm, friendly, approachable | Sage (16px card, 20px badges) |

Apply consistently: `card`, `badge`, and `block` should all feel like they belong to the same design language.

### 5. Section Labels

Section labels are where character comes through in the information architecture itself.

| Style | Example | Character |
|-------|---------|-----------|
| Plain uppercase | `PERSONALITY`, `VOICE SAMPLE` | Neutral, professional |
| Numbered sequences | `01 — PROFILE`, `02 — TESTIMONY` | Procedural, detective, methodical |
| Code comments | `/* traits */`, `// voice_samples` | Developer, hacker, technical |
| Title case | `Personality Profile`, `Voice Sample` | Warm, readable, mentor |
| Themed vocabulary | `EVOLUTION PROFILE`, `DIRECTIVES` | In-character, immersive |

### 6. Top Strip

The strip is the first thing the eye hits. It sets tone before the name is even read.

| Type | Config | Example |
|------|--------|---------|
| `text` | `left` + `right` strings | `"UNIT K-2SO // RA-SEARCH"` + `"NOMINAL"` |
| `gradient` | CSS gradient value | `"linear-gradient(90deg, #9b4dca, #4ade80, #9b4dca)"` |
| `solid` | Single color | `"#7C9082"` |

**Text strips** work best for military, detective, and terminal archetypes — they carry information. **Gradient strips** work for organic/alien archetypes. **Solid strips** work for minimal/warm archetypes.

### 7. Badge Icons

Lucide icon names for the three badge types. The template includes a 15-icon sprite. Available icons:

| Icon | Best for |
|------|----------|
| `layers` | Full-stack, multi-domain |
| `server` | Backend, infrastructure |
| `shield` / `shield-alert` | Security, guard authority |
| `code` | Frontend, developer |
| `terminal` | CLI, DevOps |
| `hammer` | Smith authority (builds things) |
| `users` | Coach authority (guides people) |
| `lock` | Trust level, access control |
| `eye` | Observability, monitoring |
| `leaf` | Growth, nature, sustainability |
| `target` | Goals, precision |
| `crosshair` | Military targeting, focus |
| `mic` | Voice, communication |
| `activity` | Performance, health |

### 8. Trait Bar Style

| Type | Config | When to use |
|------|--------|-------------|
| `solid` | `"var(--accent)"` | Most archetypes. Clean and readable. |
| `gradient` | `"linear-gradient(90deg, #9b4dca, #4ade80)"` | Dual-color archetypes where the bar should show the accent→secondary transition. |

## Remixing Workflow

1. Copy `themes/imperial.json` to `themes/{your-theme}.json`
2. Start with **mode** and **colors** — these set the foundation
3. Pick **fonts** that match the character's voice
4. Set **radii** to match the personality (sharp = precise, soft = warm)
5. Write **section labels** in the character's language
6. Choose a **strip type** and content
7. Select **badge icons** from the sprite
8. Choose **bar style** (solid for most, gradient for dual-color)

## Pencil Design Reference

The file `docs/playgrounds/agent-profile-concepts.pen` contains 5 fully designed theme variations built in Pencil. Use these as visual reference when remixing:

- **Theme 1** (Row 3, Frame 1): Imperial Droid — sharp, red, monospace
- **Theme 2** (Row 3, Frame 2): Zerg Queen — organic, purple/green, serif
- **Theme 3** (Row 3, Frame 3): Sage Mentor — light, warm, cream/sage
- **Theme 4** (Row 3, Frame 4): Noir Detective — gold, moody, numbered sections
- **Theme 5** (Row 3, Frame 5): Hacker Terminal — orange/teal, code comments, zero radii
