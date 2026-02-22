# Communication Mesh

## Metadata
- **Name**: communication-mesh
- **Description**: Defines how every agent communicates with every other agent — a mesh network, not hub-and-spoke

## Overview

Teampowers agents communicate in a mesh network. Agents talk directly to each other via `SendMessage` rather than routing everything through the lead. The lead coordinates but doesn't bottleneck.

**Core principle**: Direct agent-to-agent communication for speed. The lead orchestrates, it doesn't relay.

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

## The Mesh

### Communication Map

Every arrow is a `SendMessage`. Agents communicate directly — no relay through lead unless coordination is needed.

```
                    ┌──────────┐
                    │   Lead   │
                    │(coord.)  │
                    └────┬─────┘
                         │ assigns tasks, resolves conflicts
            ┌────────────┼────────────┐
            ▼            ▼            ▼
       ┌─────────┐ ┌─────────┐ ┌──────────┐
       │ Scout 1 │ │ Scout 2 │ │ Ad Hoc   │
       └────┬────┘ └────┬────┘ └────┬─────┘
            │            │           │
            ▼            ▼           ▼
       ┌─────────┐ ┌─────────┐      │ domain guidance
       │  Dev 1  │ │  Dev 2  │◄─────┘
       └────┬────┘ └────┬────┘
            │            │
            ▼            ▼       direct handoffs
       ┌──────────────────────┐
       │       Tester         │
       └──────────┬───────────┘
                  │
                  ▼
       ┌──────────────────────┐
       │      Reviewer        │
       └──────────┬───────────┘
                  │
                  ▼
       ┌──────────────────────┐
       │         CI           │
       └──────────┬───────────┘
                  │
                  ▼
              task done → Lead notified
```

### Direct Communication Paths

#### Scout → Dev
**When**: Scout finishes exploring a code area relevant to a dev's task
**Message**: Codebase context report (architecture, patterns, file ownership, risks)
**Why direct**: Dev needs this context immediately to start work — no need for lead to relay

#### Dev → Tester
**When**: Dev finishes implementation
**Message**: Completion report (what was built, changed files, test results)
**Why direct**: Tester needs to validate immediately — waiting for lead adds latency

#### Tester → Dev
**When**: Tests fail or edge cases reveal issues
**Message**: Failure report (which tests, why they fail, what needs fixing)
**Why direct**: Dev needs to fix immediately — this is a tight feedback loop

#### Dev → Reviewer
**When**: Dev's implementation passes tester validation
**Message**: Review request (what was built, spec, changed files, base/head SHA)
**Why direct**: Reviewer can start while other tasks are still in progress

#### Reviewer → Dev
**When**: Review finds issues that need fixing
**Message**: Review findings (spec gaps, quality issues, specific file:line references)
**Why direct**: Dev fixes and resubmits — tight loop between reviewer and dev

#### Reviewer → CI
**When**: Review passes (both spec and quality stages)
**Message**: Approval signal with commit range to verify
**Why direct**: CI can start running without waiting for lead to relay

#### CI → Lead
**When**: Pipeline completes (pass or fail)
**Message**: CI report (all check results, pass/fail, details on failures)
**Why to lead**: Lead needs to track overall task status and decide next actions

#### CI → Dev (on failure)
**When**: Pipeline fails
**Message**: Failure details (which check, specific errors, file:line references)
**Why direct**: Dev needs to fix — CI reports to both lead AND dev simultaneously

#### Ad Hoc → Dev
**When**: Ad hoc agent has domain-specific guidance for the dev
**Message**: Domain recommendations (schema design, API patterns, etc.)
**Why direct**: Domain expertise flows straight to the implementer

#### Scout → Ad Hoc
**When**: Scout discovers domain-specific patterns the ad hoc agent should know
**Message**: Domain-relevant codebase context
**Why direct**: Keeps ad hoc agent informed about existing patterns in their domain

### Lead Communication (Coordination Only)

The lead sends messages for coordination purposes only:

#### Lead → Scout
**When**: New task batch starts, need codebase exploration
**Message**: Areas to explore, questions to answer

#### Lead → Dev
**When**: Assigning tasks, resolving file ownership conflicts
**Message**: Task assignments, conflict resolution instructions

#### Lead → Any Agent
**When**: Batch boundary (human feedback changes direction)
**Message**: Updated instructions, priority changes, stop signals

#### Any Agent → Lead
**When**: Blocked, need file outside ownership, conflicting information
**Message**: Blocker description, resolution request

## Message Formats

### Task Assignment (Lead → Dev/Scout)
```
TASK: {task_id}
DESCRIPTION: {what needs to be done}
OWNED_FILES: {files this agent may modify}
READ_ONLY: {files to read but not touch}
ACCEPTANCE: {criteria for completion}
CONTEXT_FROM: {which scout/ad-hoc to expect context from}
REPORT_TO: {who to message when done — usually tester}
```

### Context Handoff (Scout → Dev)
```
CONTEXT FOR: {task_id}
ARCHITECTURE: {how this area is structured}
PATTERNS: {conventions to follow}
KEY_FILES: {important files and what they do}
RISKS: {things to watch out for}
DEPENDENCIES: {what depends on what}
```

### Completion Signal (Dev → Tester)
```
TASK: {task_id}
STATUS: implementation complete
CHANGED_FILES: {list}
SUMMARY: {what was built}
TESTS_RUN: {results}
CONCERNS: {anything uncertain}
```

### Review Request (Dev → Reviewer)
```
TASK: {task_id}
SPEC: {original requirements}
IMPLEMENTATION: {summary of what was built}
BASE_SHA: {commit before changes}
HEAD_SHA: {commit after changes}
TESTER_VALIDATION: {tester's report}
```

### Pipeline Request (Reviewer → CI)
```
TASK: {task_id}
STATUS: review approved
COMMIT_RANGE: {base_sha}..{head_sha}
CHECKS: run all
```

### Failure Feedback (Tester/Reviewer/CI → Dev)
```
TASK: {task_id}
STATUS: {test_failure | review_rejection | ci_failure}
ISSUES:
- {file:line — description of issue}
- {file:line — description of issue}
ACTION_NEEDED: {what dev should fix}
```

## Rules

- **Agents message each other directly** — lead doesn't relay
- **Lead coordinates, doesn't implement** — task assignment, conflict resolution, human reporting
- **Every message includes task_id** — so agents can track context across the mesh
- **Failures go to dev AND lead** — dev fixes, lead tracks status
- **Completion signals chain forward** — dev → tester → reviewer → ci → lead
- **Scouts and ad hocs feed context sideways** — directly to the agents who need it
