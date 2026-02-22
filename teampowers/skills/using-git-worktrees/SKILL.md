# Using Git Worktrees

## Metadata
- **Name**: using-git-worktrees
- **Description**: Use Claude Code's native worktree support to give each agent an isolated working directory

## Overview

Claude Code has native worktree support. Use it to give each dev agent a fully isolated working directory — no file ownership conflicts, no coordination overhead. This is the preferred isolation strategy for teampowers teams.

**Core principle**: Every dev agent gets its own worktree. Scouts share the main worktree (read-only). Singletons (tester, reviewer, CI) work from the main worktree.

## Native Worktree Support

### CLI: Start a Session in a Worktree

```bash
# Named worktree — creates .claude/worktrees/feature-auth/
claude --worktree feature-auth
claude -w feature-auth

# Auto-named worktree (random name like "bright-running-fox")
claude --worktree

# Launch in its own tmux session — great for running multiple parallel agents
claude --worktree feature-auth --tmux
```

Worktrees are created at `<repo>/.claude/worktrees/<name>/` and branch from the default remote branch as `worktree-<name>`.

### Subagent Frontmatter: Automatic Isolation

Add `isolation: worktree` to any subagent's frontmatter and it gets its own worktree automatically:

```yaml
---
name: dev-task-3
description: Implement user authentication endpoint
isolation: worktree
---
```

The worktree is created when the agent starts and cleaned up automatically when it finishes (if no changes were made). If changes were made, the worktree persists for review.

### Custom Lifecycle Hooks

For non-git VCS or custom workflows, use hooks:

```json
{
  "hooks": {
    "WorktreeCreate": [{ "type": "command", "command": "./scripts/create-worktree.sh" }],
    "WorktreeRemove": [{ "type": "command", "command": "./scripts/remove-worktree.sh" }]
  }
}
```

## When to Use

- **Always** for dev agents during `teampowers:team-driven-development` — use `isolation: worktree`
- Before starting `teampowers:executing-plans` — set up a worktree for the session
- When working on multiple features concurrently — each feature gets its own worktree
- When parallel dev agents would otherwise need file ownership coordination

## Worktree Strategy by Agent Role

| Agent | Worktree Strategy | Rationale |
|-------|-------------------|-----------|
| **Dev** | `isolation: worktree` (one per dev) | Full isolation — no file conflicts between parallel devs |
| **Scout** | Main worktree (shared) | Read-only exploration — no writes, no conflicts |
| **Tester** | Main worktree | Runs tests against merged results |
| **Reviewer** | Main worktree | Reviews committed code |
| **CI** | Main worktree | Runs pipeline against merged state |
| **Lead** | Main worktree | Coordination only — never writes code |
| **Ad Hoc** | `isolation: worktree` if writing files, main if advisory | Depends on whether the specialist produces code |

## Merging Dev Worktrees

After a dev agent completes and CI passes:

1. Dev commits to its worktree branch (`worktree-<name>`)
2. Lead merges the worktree branch into the feature branch
3. Other dev agents rebase or pull if they depend on the merged work
4. Worktree is cleaned up after merge

```bash
# From the main worktree (feature branch)
git merge worktree-dev-task-3
git worktree remove .claude/worktrees/dev-task-3
```

## Setup

Add `.claude/worktrees/` to your `.gitignore` to prevent worktree contents from appearing as untracked files:

```bash
echo '.claude/worktrees/' >> .gitignore
```

Each new worktree needs its dev environment initialized (e.g., `npm install`, virtualenv setup). Consider adding a setup script that runs automatically.

## Rules

- Dev agents MUST use `isolation: worktree` for parallel execution
- Never work directly on main/master for feature development
- Clean up worktrees after branches are merged
- List active worktrees: `git worktree list`
- Auto-cleanup happens when a session exits with no changes
- If a worktree has uncommitted changes, investigate before removing

## Integration

- **teampowers:team-driven-development** — Devs use worktree isolation for parallel execution
- **teampowers:executing-plans** — Set up worktree before executing
- **teampowers:dev** — Each dev agent specifies `isolation: worktree`
- **teampowers:finishing-a-development-branch** — Merge worktree branches and clean up
