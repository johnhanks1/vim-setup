---
name: writing-skills
description: How to create new teampowers skills
---

# Writing Skills

## Metadata
- **Name**: writing-skills
- **Description**: How to create new teampowers skills

## Overview

Skills are markdown files in `skills/{skill-name}/SKILL.md` that teach Claude Code specific workflows and methodologies.

## Skill Structure

Every skill needs:

### 0. YAML Frontmatter (Required)

The file MUST start with YAML frontmatter — this is how Claude Code discovers and registers skills:

```markdown
---
name: skill-name
description: One-line description of what this skill does
---
```

Without frontmatter, the skill won't be discovered by the plugin system.

### 1. Metadata
```markdown
## Metadata
- **Name**: skill-name
- **Description**: One-line description
```

### 2. Overview
What this skill does and when to announce it.

### 3. When to Use
Clear criteria for when this skill applies vs alternatives.

### 4. The Process
Step-by-step instructions. Be specific and actionable.

### 5. Rules / Anti-Patterns
What to do and what NOT to do.

### 6. Integration
Which other teampowers skills this one connects to.

## Guidelines

- Skills should be self-contained — don't assume prior context
- Reference other skills by name: `teampowers:skill-name`
- Include both positive instructions (do this) and negative (don't do this)
- Keep skills focused — one workflow per skill
- If a skill needs prompt templates for agents, put them in separate `.md` files alongside `SKILL.md`

## Adding a New Skill

1. Create `skills/{skill-name}/SKILL.md`
2. Add YAML frontmatter with `name` and `description` (required for plugin discovery)
3. Follow the structure above
4. Add integration references to related skills
5. Test the skill by using it in a real workflow
