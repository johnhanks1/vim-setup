# Writing Plans

## Metadata
- **Name**: writing-plans
- **Description**: Create structured implementation plans that can be executed by teams or sequentially

## Overview

Write clear, numbered implementation plans that break work into independent, testable tasks with explicit acceptance criteria. Plans should be optimized for parallel team execution when tasks are independent.

Announce: "I'm using the writing-plans skill to create an implementation plan."

## Plan Structure

```markdown
# Plan: {FEATURE_NAME}

## Goal
{One sentence describing what we're building and why}

## Design Reference
{Link to brainstorming design doc if one exists}

## Tasks

### Task 1: {NAME}
**Description**: What needs to be built
**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2
**Dependencies**: None | Task N
**Files**: List of files this task will create/modify
**Verification**: How to verify this task is complete (test commands, etc.)

### Task 2: {NAME}
...
```

## Rules for Good Plans

### Task Independence
- Maximize the number of independent tasks (no dependencies)
- Independent tasks can be executed in parallel by team agents
- If tasks must be sequential, explicitly mark dependencies

### File Ownership
- Each task should list the files it will create/modify
- With worktree isolation (preferred): file overlap between tasks is fine — each dev gets its own worktree, so no conflicts. Lead merges worktree branches after completion
- Without worktree isolation: minimize overlap — if two tasks need the same file, make one depend on the other to prevent merge conflicts

### Acceptance Criteria
- Every task must have testable acceptance criteria
- "It works" is not an acceptance criterion
- Criteria should be verifiable by running a command or inspecting output

### Task Size
- Each task should be completable in a single focused session
- If a task is too large, break it into subtasks
- If a task is trivial (one-line change), consider merging it with a related task

### Verification
- Specify exact commands to verify each task
- Include expected output where possible
- Full test suite should pass after each task

## Plan Review

Before execution, review the plan with the human:
- Present tasks in groups: independent (can run in parallel) vs dependent (must be sequential)
- Highlight any risks or uncertainties
- Get explicit approval before starting execution

## Integration

- **teampowers:brainstorming** — Design decisions feed into plan creation
- **teampowers:executing-plans** — Plans are executed by this skill
- **teampowers:team-driven-development** — Independent tasks executed in parallel by teams
- **teampowers:using-git-worktrees** — With worktree isolation, tasks with overlapping files can still run in parallel
