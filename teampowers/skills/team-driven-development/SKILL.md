# Team-Driven Development

## Metadata
- **Name**: team-driven-development
- **Description**: Orchestrate a team of specialized agents — verify in dev worktrees before merge, agents communicate directly

## Overview

This skill creates and coordinates a team of agents. Agents communicate directly with each other — the lead coordinates but doesn't bottleneck. Independent tasks execute in parallel. All verification (testing, review, CI) happens in the dev's worktree before merge.

**Core principle**: Verify before merge. Specialized agents + direct communication + worktree isolation = high quality, fast delivery.

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
| **Lead** | Coordinator. Assigns tasks, resolves conflicts, merges worktrees. Never implements |
| **Tester** | Writes tests (TDD), validates implementations in dev worktrees. Single source of truth for test quality |
| **Reviewer** | Two-stage code review in dev worktrees. Single source of truth for code quality |
| **CI** | Runs pipeline in dev worktrees (pre-merge) and on feature branch (post-merge). Single gate for "done" |

## Agent Spawning

**Only the lead spawns teammates.** This is an agent teams constraint — teammates cannot create other teammates.

The lead spawns:
- The initial team (scouts, devs, tester, reviewer, CI)
- Additional scouts when a dev or scout requests one
- Ad-hoc specialists when a dev needs domain expertise
- Additional devs if the workload changes

**Other agents request new teammates by messaging the lead:**
```
TASK: {task_id}
REQUEST: need teammate
TYPE: scout / dev / ad-hoc ({domain})
REASON: {why}
```

## Communication: Direct, Not Relayed

Agents talk directly to each other. Each agent's skill file contains its specific communication paths — who it receives from and sends to.

Key flows:
```
Lead assigns → Scout explores → Scout sends context to Dev
Dev implements → Dev signals Tester (with worktree path)
Tester validates in dev's worktree → Tester reports to Dev
Dev signals Reviewer (with worktree path)
Reviewer reviews in dev's worktree → Reviewer signals CI
CI runs pipeline in dev's worktree → CI reports to Lead (and Dev on failure)
Lead merges → CI runs integration check on merged feature branch
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
  tester:   1  (always — visits dev worktrees to validate)
  reviewer: 1  (always — visits dev worktrees to review)
  ci:       1  (always — runs pipeline in dev worktrees, then on merged branch)
  ad-hoc:   as needed (isolation: worktree if writing code)
```

**Worktree setup**: Dev agents MUST specify `isolation: worktree` in their frontmatter. Tester, reviewer, and CI visit each dev's worktree for verification — they don't need their own. See `teampowers:using-git-worktrees` for details.

### Step 2: Scout Phase

Lead assigns codebase areas to scouts:
1. Each scout explores their assigned area
2. Scouts send context reports directly to the devs who will work in that area
3. Scouts also send domain-relevant context to any ad hoc agents
4. Lead reviews scout reports and adjusts task assignments if needed

### Step 3: Assign and Execute Batch

Lead assigns tasks to devs. For each task, the full pipeline runs in the dev's worktree:

```
 1. Lead → Dev:       task assignment (files, spec, acceptance criteria)
 2. Scout → Dev:      codebase context (patterns, architecture, risks)
 3. Tester:           writes failing tests for the task (TDD)
 4. Dev:              implements against tests and scout context (in worktree)
 5. Dev → Tester:     signals completion with WORKTREE path
 6. Tester:           validates in dev's worktree — tests pass, edge cases added
 7. Dev → Reviewer:   signals ready for review with WORKTREE path
 8. Reviewer:         reviews in dev's worktree — spec compliance, then quality
 9. Reviewer → CI:    signals approved with WORKTREE path
10. CI:               runs full pipeline in dev's worktree
11. CI → Lead:        reports status (green = ready to merge, red = back to dev)
```

Independent tasks flow through this pipeline in parallel. A dev working on Task 3 doesn't wait for Task 1's review to finish.

### Step 4: Handle Failures

Failures route back to dev directly:
- **Test failure**: Tester → Dev (with specifics, in dev's worktree)
- **Review rejection**: Reviewer → Dev (with file:line fixes)
- **CI failure**: CI → Dev AND CI → Lead (dev fixes in worktree, lead tracks)

Dev fixes in their worktree, recommits, and re-signals. The loop is tight — no lead relay needed.

### Step 5: Merge Verified Worktrees

After a task passes tester + reviewer + CI in its worktree:
1. CI signals Lead: ready to merge
2. Lead merges the worktree branch into the feature branch
3. If merge conflicts arise, lead resolves or assigns a dev to fix
4. After all tasks in a batch are merged, CI runs the full pipeline on the merged feature branch (integration check)
5. Clean up completed worktrees

### Step 6: Checkpoint

After merge and integration CI pass:
1. Lead reports to human: what was built, test results, CI status
2. Human reviews and provides feedback
3. Lead adjusts plan, scales team up/down for next batch
4. Next batch dispatched

### Step 7: Completion

After all tasks:
1. CI runs final comprehensive pipeline on feature branch
2. Reviewer does cross-task review of all changes together
3. Lead presents results to human
4. Follow `teampowers:finishing-a-development-branch`

## Critical Rules

- **Verify before merge** — tester, reviewer, CI all work in dev's worktree first
- **Lead never implements** — coordination and merging only
- **Agents communicate directly** — each agent knows its own communication paths
- **Only the lead spawns teammates** — others request via message
- **Never skip the scout phase** — context before code
- **Never skip verification** — every task goes through tester → reviewer → CI in worktree
- **Never dispatch dependent tasks in parallel** — respect the dependency graph
- **Scale dynamically** — more scouts and devs for bigger batches
- **Failures route directly to dev** — tight feedback loops
- **Always checkpoint with human** between batches

## Isolation Strategy

### Default: Worktree Isolation (Preferred)

Each dev agent runs in its own worktree via `isolation: worktree`. Verification agents visit each worktree:
1. Dev works in `<repo>/.claude/worktrees/<dev-task-name>/`
2. Tester validates in dev's worktree
3. Reviewer reviews in dev's worktree
4. CI runs pipeline in dev's worktree
5. Only after all pass does lead merge the worktree branch into the feature branch
6. CI runs integration check on merged feature branch

### Fallback: File Ownership (When Worktrees Unavailable)

If worktree isolation is not available:
1. Scout recommends file ownership per task
2. Lead assigns each task a set of owned files
3. If two tasks need the same file, make one dependent on the other
4. Agents must not modify files outside their ownership set
5. If an agent discovers it needs a file it doesn't own, it messages the lead

## Integration

- **teampowers:scout** — Codebase reconnaissance
- **teampowers:dev** — Implementation
- **teampowers:tester** — TDD and validation (in dev worktrees)
- **teampowers:reviewer** — Two-stage review (in dev worktrees)
- **teampowers:ci** — Pipeline verification (in dev worktrees, then merged branch)
- **teampowers:ad-hoc-agents** — Domain specialists
- **teampowers:writing-plans** — Creates the plan this skill executes
- **teampowers:using-git-worktrees** — Isolated workspace setup
- **teampowers:finishing-a-development-branch** — Post-completion
