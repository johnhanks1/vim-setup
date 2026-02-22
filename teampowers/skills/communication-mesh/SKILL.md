# Communication Mesh — Architectural Overview

## Metadata
- **Name**: communication-mesh
- **Description**: Architectural overview of how agents communicate — each agent's specific paths are in its own skill file

## Overview

Teampowers agents communicate in a mesh network. Agents talk directly to each other rather than routing everything through the lead. The lead coordinates but doesn't bottleneck.

**This is a reference document.** Each agent's specific communication paths (who they receive from, who they send to, and message formats) are defined in that agent's own skill file. You do NOT need to load this document to know how to communicate — check your own skill file.

## Team Topology

### Scalable Roles (0-N instances)
- **Scout** — spin up as many as needed to cover different parts of the codebase
- **Dev** — spin up as many as needed for parallel task implementation
- **Ad Hoc** — spin up domain specialists as tasks require

### Singleton Roles (exactly 1)
- **Lead** — coordinator, never implements
- **Tester** — single source of truth for test quality
- **Reviewer** — single source of truth for code quality
- **CI** — single source of truth for pipeline status

## Agent Spawning

Any agent can spawn subagents — not just the lead:
- **Lead** spawns the initial team
- **Dev** can spawn scouts or ad-hoc specialists mid-implementation
- **Scout** can spawn sub-scouts to parallelize exploration

Rule: inform the lead when you spawn an agent.

## The Flow

All verification happens in the dev's worktree before merge:

```
Lead assigns → Scout explores → Scout sends context to Dev

Dev implements (in worktree)
  → Tester validates (in dev's worktree)
  → Reviewer reviews (in dev's worktree)
  → CI runs pipeline (in dev's worktree)
  → CI signals Lead: ready to merge

Lead merges worktree branch → CI runs integration check on merged branch
```

## Communication Map

```
                    ┌──────────┐
                    │   Lead   │
                    │(coord.)  │
                    └────┬─────┘
                         │ assigns tasks, merges worktrees
            ┌────────────┼────────────┐
            ▼            ▼            ▼
       ┌─────────┐ ┌─────────┐ ┌──────────┐
       │ Scout 1 │ │ Scout 2 │ │ Ad Hoc   │
       └────┬────┘ └────┬────┘ └────┬─────┘
            │            │           │
            ▼            ▼           ▼
       ┌─────────┐ ┌─────────┐      │ domain guidance
       │  Dev 1  │ │  Dev 2  │◄─────┘
       │(wt-1)   │ │(wt-2)   │
       └────┬────┘ └────┬────┘
            │            │          all verification in
            ▼            ▼          dev's worktree
       ┌────────┐  ┌────────┐
       │ Tester │  │ Tester │      (same tester, different worktrees)
       └───┬────┘  └───┬────┘
           ▼            ▼
       ┌────────┐  ┌────────┐
       │Reviewer│  │Reviewer│      (same reviewer, different worktrees)
       └───┬────┘  └───┬────┘
           ▼            ▼
       ┌────────┐  ┌────────┐
       │  CI    │  │  CI    │      (same CI, different worktrees)
       └───┬────┘  └───┬────┘
           │            │
           ▼            ▼
       ready to merge → Lead
```

## Rules

- **Agents message each other directly** — lead doesn't relay
- **Every message includes task_id** — so agents can track context
- **Verification happens in dev worktrees** — tester, reviewer, CI visit the dev's worktree before merge
- **Failures go to dev AND lead** — dev fixes, lead tracks status
- **Any agent can spawn subagents** — inform lead when you do

## Per-Agent Communication Details

Each agent's skill file contains its own:
- **"You Receive From"** table — who sends messages to this agent and when
- **"You Send To"** table — who this agent messages and when
- **Message formats** — the specific formats for each message type

See:
- `teampowers:dev` — Dev agent communication
- `teampowers:scout` — Scout agent communication
- `teampowers:tester` — Tester agent communication
- `teampowers:reviewer` — Reviewer agent communication
- `teampowers:ci` — CI agent communication
- `teampowers:ad-hoc-agents` — Ad hoc agent communication
