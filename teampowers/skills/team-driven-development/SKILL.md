# Team-Driven Development

## Metadata
- **Name**: team-driven-development
- **Description**: Orchestrate a mesh network of specialized agents to execute implementation plans in parallel

## Overview

This skill creates and coordinates a team of agents operating as a mesh network. Agents communicate directly with each other via `SendMessage` — the lead coordinates but doesn't bottleneck. Independent tasks execute in parallel with dynamic scaling of scouts and devs.

**Core principle**: Specialized agents in a mesh + direct communication + parallel execution = high quality, fast delivery.

Announce: "I'm using the team-driven-development skill to execute this plan with the team."

## Team Topology

### Dynamic Roles (spin up as needed)
| Agent | Scale | Purpose |
|-------|-------|---------|
| **Scout** | 1-N | One per codebase area. Small jobs: 1 scout. Large jobs: one scout per subsystem |
| **Dev** | 1-N | One per parallel task. Scale matches the number of independent tasks in a batch |
| **Ad Hoc** | 0-N | One per domain specialization needed (SQL, API, Infra, etc.) |

### Singleton Roles (exactly 1)
| Agent | Purpose |
|-------|---------|
| **Lead** | Coordinator. Assigns tasks, resolves conflicts, reports to human. Never implements |
| **Tester** | Writes tests (TDD), validates implementations. Single source of truth for test quality |
| **Reviewer** | Two-stage code review (spec → quality). Single source of truth for code quality |
| **CI** | Runs build/test/lint pipeline. Single gate for "done" |

## Communication: Mesh, Not Hub-and-Spoke

Agents talk directly to each other. See `teampowers:communication-mesh` for the full communication map, message formats, and routing rules.

Key flows:
```
Lead assigns → Scout explores → Scout hands context to Dev
Dev implements → Dev signals Tester → Tester validates
Dev requests review → Reviewer reviews → Reviewer signals CI
CI runs pipeline → CI reports to Lead (and Dev on failure)
```

The lead is NOT in the middle of these flows. Agents hand off directly.

## When to Use

- You have an approved implementation plan
- Tasks benefit from parallel execution and quality gates
- For any non-trivial work

```
Have a plan? → Non-trivial?
  YES             YES → Use this skill
  YES             NO  → Use executing-plans (simple batch mode)
  NO              *   → Use writing-plans first
```

## The Process

### Step 1: Create the Team with Worktree Isolation

Based on the plan, determine team size and isolation strategy:

```
TeamCreate:
  lead:     1  (always, main worktree)
  scout:    N  (1 per codebase area, main worktree — read-only)
  dev:      N  (1 per independent task, isolation: worktree — each gets its own)
  tester:   1  (always, main worktree)
  reviewer: 1  (always, main worktree)
  ci:       1  (always, main worktree)
  ad-hoc:   as needed (isolation: worktree if writing code)
```

**Worktree setup**: Dev agents MUST specify `isolation: worktree` in their frontmatter. This gives each dev a fully isolated working directory — no file ownership conflicts, no coordination overhead. See `teampowers:using-git-worktrees` for details.

Scouts, tester, reviewer, and CI share the main worktree since they don't have conflicting writes.

### Step 2: Scout Phase

Lead assigns codebase areas to scouts:
1. Each scout explores their assigned area
2. Scouts send context reports directly to the devs who will work in that area
3. Scouts also send domain-relevant context to any ad hoc agents
4. Lead reviews scout reports and adjusts task assignments if needed

### Step 3: Assign and Execute Batch

Lead assigns tasks to devs. For each task:

```
1. Lead → Dev:       task assignment (files, spec, acceptance criteria)
2. Scout → Dev:      codebase context (patterns, architecture, risks)
3. Tester:           writes failing tests for the task (TDD)
4. Dev:              implements against tests and scout context
5. Dev → Tester:     signals completion
6. Tester:           validates tests pass, adds edge cases
7. Dev → Reviewer:   signals ready for review
8. Reviewer:         spec compliance check, then code quality check
9. Reviewer → CI:    signals approved
10. CI:              runs full pipeline
11. CI → Lead:       reports status (green = done, red = back to dev)
```

Independent tasks flow through this pipeline in parallel. A dev working on Task 3 doesn't wait for Task 1's review to finish.

### Step 4: Handle Failures

Failures route back to dev directly:
- **Test failure**: Tester → Dev (with specifics)
- **Review rejection**: Reviewer → Dev (with file:line fixes)
- **CI failure**: CI → Dev AND CI → Lead (dev fixes, lead tracks)

Dev fixes and resubmits through the pipeline. The loop is tight — no lead relay needed.

### Step 5: Merge Worktrees

After all tasks in a batch pass CI:
1. Lead merges each dev's worktree branch into the feature branch
2. CI runs the full pipeline on the merged feature branch
3. If merge conflicts arise, lead resolves or assigns a dev to fix
4. Clean up completed worktrees

### Step 6: Checkpoint

After merge and final CI pass:
1. Lead reports to human: what was built, test results, CI status
2. Human reviews and provides feedback
3. Lead adjusts plan, scales team up/down for next batch
4. Next batch dispatched

### Step 7: Completion

After all tasks:
1. CI runs final comprehensive pipeline
2. Reviewer does cross-task review of all changes together
3. Lead presents results to human
4. Follow `teampowers:finishing-a-development-branch`

## Critical Rules

- **Lead never implements** — coordination only
- **Agents communicate directly** — mesh, not hub-and-spoke
- **Never skip the scout phase** — context before code
- **Never skip review or CI** — every task goes through the full pipeline
- **Never dispatch dependent tasks in parallel** — respect the dependency graph
- **Scale dynamically** — more scouts and devs for bigger batches
- **Failures route directly to dev** — tight feedback loops
- **Always checkpoint with human** between batches

## Isolation Strategy

### Default: Worktree Isolation (Preferred)

Each dev agent runs in its own worktree via `isolation: worktree`. This eliminates file ownership conflicts entirely:
1. Each dev works in `<repo>/.claude/worktrees/<dev-task-name>/`
2. Devs can freely modify any file in their worktree without coordination
3. After completion and CI pass, lead merges the worktree branch into the feature branch
4. Other devs rebase if they depend on merged work

### Fallback: File Ownership (When Worktrees Unavailable)

If worktree isolation is not available:
1. Scout recommends file ownership per task
2. Lead assigns each task a set of owned files
3. If two tasks need the same file, make one dependent on the other
4. Agents must not modify files outside their ownership set
5. If an agent discovers it needs a file it doesn't own, it messages the lead

## Integration

- **teampowers:communication-mesh** — REQUIRED: How agents talk to each other
- **teampowers:scout** — Codebase reconnaissance
- **teampowers:dev** — Implementation
- **teampowers:tester** — TDD and validation
- **teampowers:reviewer** — Two-stage review
- **teampowers:ci** — Pipeline verification
- **teampowers:ad-hoc-agents** — Domain specialists
- **teampowers:writing-plans** — Creates the plan this skill executes
- **teampowers:using-git-worktrees** — Isolated workspace
- **teampowers:finishing-a-development-branch** — Post-completion
