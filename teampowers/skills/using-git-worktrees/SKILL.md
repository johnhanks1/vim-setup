# Using Git Worktrees

## Metadata
- **Name**: using-git-worktrees
- **Description**: Set up isolated git worktrees for development branches

## Overview

Use git worktrees to create isolated working directories for development branches. This prevents interference between concurrent work and keeps the main working directory clean.

## Setup

```bash
# Create a worktree for a feature branch
git worktree add ../feature-branch-name feature-branch-name

# Or create a new branch and worktree together
git worktree add -b feature-branch ../feature-branch-name
```

## When to Use

- Before starting any implementation plan execution
- When working on multiple features concurrently
- When Agent Teams agents need isolated directories (each teammate can work in a separate worktree)

## Rules

- Always create a worktree before starting `teampowers:executing-plans`
- Never work directly on main/master for feature development
- Clean up worktrees after branches are merged: `git worktree remove ../feature-branch-name`
- List active worktrees with: `git worktree list`

## Team Considerations

When using Agent Teams for parallel execution:
- Each implementer agent can work in the same worktree if they own different files
- If file ownership overlaps, consider separate worktrees per agent
- The team lead coordinates which agent works where

## Integration

- **teampowers:executing-plans** — REQUIRED: Set up worktree before executing
- **teampowers:team-driven-development** — Worktrees provide isolation for team agents
- **teampowers:finishing-a-development-branch** — Clean up worktree after completion
