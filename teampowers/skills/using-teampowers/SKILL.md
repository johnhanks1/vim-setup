# Using Teampowers

## Metadata
- **Name**: using-teampowers
- **Description**: Entry point — how teampowers works, the team roster, and when to activate each skill

## Overview

Teampowers is an agent skills framework for Claude Code that organizes development work around a specialized team of agents. Instead of one agent doing everything sequentially, teampowers creates a team where each member has a clear role, and work flows through a structured pipeline.

Inspired by [obra/superpowers](https://github.com/obra/superpowers), teampowers replaces the subagent pattern with an agent mesh network where agents communicate directly with each other.

## The Team

### Dynamic (scale 1-N as needed)
| Agent | Skill | Role |
|-------|-------|------|
| **Scout** | `teampowers:scout` | Explores codebase, maps architecture, gathers context |
| **Dev** | `teampowers:dev` | Writes production code per task spec |
| **Ad Hoc** | `teampowers:ad-hoc-agents` | Domain specialists created on demand (SQL, API, Infra, etc.) |

### Singleton (exactly 1)
| Agent | Skill | Role |
|-------|-------|------|
| **Lead** | coordinator | Assigns tasks, resolves conflicts, reports to human. Never implements |
| **Tester** | `teampowers:tester` | Writes tests before impl (TDD), validates after |
| **Reviewer** | `teampowers:reviewer` | Two-stage review: spec compliance → code quality |
| **CI** | `teampowers:ci` | Runs full build/test/lint pipeline |

### Communication
Agents talk directly to each other in a mesh — not hub-and-spoke through the lead. See `teampowers:communication-mesh` for the full routing map and message formats.

## The Workflow

When the user asks you to build something non-trivial:

```
1. Brainstorm     → Understand the goal, explore alternatives, validate design
2. Write Plan     → Break work into independent, testable tasks
3. Set Up         → Create git worktree for isolated development
4. Scout          → Explore the codebase, gather context
5. Execute        → Run tasks through the team pipeline (parallel where independent)
6. Checkpoint     → Report to human, get feedback, repeat
7. Finish         → Final CI run, comprehensive review, present to human
```

## Skill Reference

### Planning Phase
| Skill | When |
|-------|------|
| `teampowers:brainstorming` | Non-trivial feature requests — explore before committing |
| `teampowers:writing-plans` | After design is validated — create numbered implementation plan |

### Execution Phase
| Skill | When |
|-------|------|
| `teampowers:team-driven-development` | Full team pipeline for plan execution |
| `teampowers:executing-plans` | Batch execution with human checkpoints |

### Team Agents
| Skill | When |
|-------|------|
| `teampowers:scout` | Before any implementation — gather codebase context |
| `teampowers:dev` | Implementation phase of each task |
| `teampowers:tester` | Before impl (TDD) and after impl (validation) |
| `teampowers:reviewer` | After implementation — spec then quality review |
| `teampowers:ci` | After each task — full pipeline verification |
| `teampowers:ad-hoc-agents` | When tasks need domain-specific expertise |

### Quality & Process
| Skill | When |
|-------|------|
| `teampowers:test-driven-development` | Always — write tests before code |
| `teampowers:systematic-debugging` | Diagnosing bugs — never guess-and-check |
| `teampowers:verification-before-completion` | Before marking anything complete |

### Communication
| Skill | When |
|-------|------|
| `teampowers:communication-mesh` | Defines agent-to-agent messaging — the network topology |

### Infrastructure
| Skill | When |
|-------|------|
| `teampowers:using-git-worktrees` | Before starting any implementation (required) |
| `teampowers:finishing-a-development-branch` | After all tasks complete |
| `teampowers:writing-skills` | Creating new teampowers skills |

## Key Principles

1. **Scout first** — never write code without understanding the codebase
2. **Tests first** — the tester writes failing tests before the dev implements (TDD)
3. **Always review** — every task goes through spec compliance then code quality review
4. **CI gates everything** — no task is done until CI is green
5. **Specialized agents** — each team member does what they're best at
6. **Ad hoc expertise** — create domain specialists when the task demands it
7. **Human in the loop** — checkpoint between batches, never hide failures
8. **Mesh, not hub-and-spoke** — agents communicate directly with each other
9. **Scale dynamically** — spin up scouts and devs as needed, singletons for quality gates
