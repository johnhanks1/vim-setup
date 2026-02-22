---
name: executing-plans
description: Execute an implementation plan with batch execution, team pipeline, and human review checkpoints
---

# Executing Plans

## Metadata
- **Name**: executing-plans
- **Description**: Execute an implementation plan with batch execution, team pipeline, and human review checkpoints

## Overview

Load an approved plan, review it critically, and execute tasks through the team pipeline (scout → dev → tester → reviewer → ci) in batches with human checkpoints between them. Independent tasks within a batch run in parallel.

Announce: "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan

- Read the plan file
- Critically review it — identify questions, gaps, or concerns
- Raise concerns with your human partner before starting
- If no concerns, create a `TodoWrite` tracking all tasks and proceed

### Step 2: Set Up Worktree

Create an isolated worktree for this execution session:

```bash
claude --worktree plan-execution
```

Or if using the team pipeline, dev agents will each get their own worktree via `isolation: worktree`. See `teampowers:using-git-worktrees`.

### Step 3: Scout

Activate `teampowers:scout` to explore the codebase and deliver context.

### Step 4: Execute Batch

Default batch size: 3 tasks. Independent tasks run in parallel through the team pipeline.

For each task in the batch:
1. Mark as `in_progress` in TodoWrite
2. Run through team pipeline: tester (pre) → dev → tester (post) → reviewer → ci
3. Mark as `completed` when CI passes

For parallel execution, see `teampowers:team-driven-development` for the full team orchestration pattern.

### Step 5: Report

When the batch is complete:
- Show what was implemented
- Show verification output (test results, CI status)
- State: "Batch complete. Ready for feedback."
- Wait for human response

### Step 6: Continue

Based on feedback:
- Apply requested changes
- Execute the next batch
- Repeat until all tasks complete

### Step 7: Complete Development

Announce: "I'm using the finishing-a-development-branch skill to complete this work."
Follow `teampowers:finishing-a-development-branch` to verify tests and present options.

## When to Stop

Stop executing immediately when:
- You hit a blocker that prevents progress
- The plan has a critical gap
- Instructions are unclear
- Verifications fail repeatedly

Ask for clarification rather than guessing.

## Key Rules

- Review the plan critically first
- Follow plan steps exactly
- Don't skip verifications or review stages
- Reference skills when the plan directs it
- Report between batches and wait for human feedback
- Stop when blocked — don't guess
- Never start implementation on main/master without explicit user consent

## Integration

- **teampowers:using-git-worktrees** — REQUIRED: Set up isolated workspace before starting
- **teampowers:writing-plans** — Creates the plan this skill executes
- **teampowers:team-driven-development** — Full team pipeline for parallel execution
- **teampowers:scout** — Codebase reconnaissance before execution
- **teampowers:ci** — Pipeline verification after each task
- **teampowers:finishing-a-development-branch** — Complete development after all tasks
