# Ad Hoc Agents

## Metadata
- **Name**: ad-hoc-agents
- **Description**: Dynamically create specialized agents based on task domain requirements

## Overview

The core team (scout, dev, tester, reviewer, ci) handles general development work. But some tasks require domain-specific expertise. Ad hoc agents are created on-the-fly when a task's domain calls for specialized knowledge.

## When to Create an Ad Hoc Agent

Create a domain-specific agent when the task involves:
- A specialized technology (SQL, GraphQL, Kubernetes, Terraform, etc.)
- A domain with its own best practices that differ from general dev
- Complex configuration or DSL work
- Integration with external systems that need specific expertise

## Examples

| Task Domain | Ad Hoc Agent | Specialization |
|-------------|-------------|----------------|
| Database schema changes | SQL Agent | Schema design, migrations, query optimization, indexing |
| API design | API Agent | REST/GraphQL conventions, versioning, error handling |
| Infrastructure | Infra Agent | Terraform, Docker, K8s manifests, networking |
| Security | Security Agent | Auth flows, encryption, vulnerability assessment |
| Performance | Perf Agent | Profiling, optimization, benchmarking |
| Data pipeline | Data Agent | ETL patterns, data validation, transformation |
| Frontend | UI Agent | Component architecture, accessibility, state management |

## How to Create

When the team lead identifies a task requiring domain expertise:

### Step 1: Define the Specialization

```
## Ad Hoc Agent: {DOMAIN} Agent

### Domain Expertise
{What this agent knows that general dev doesn't}

### Responsibilities
- {Domain-specific responsibility 1}
- {Domain-specific responsibility 2}

### Constraints
- {Domain-specific rules and best practices}
- {Common pitfalls in this domain}

### Deliverables
- {What this agent produces}
```

### Step 2: Send via TeamCreate or SendMessage

Create the ad hoc agent as a teammate with the specialization baked into their prompt. They receive:
- The domain expertise definition above
- The specific task assignment
- The scout's context report (filtered to relevant parts)
- File ownership scope

### Step 3: Integration with Core Team

The ad hoc agent slots into the normal workflow:
1. Scout provides codebase context → filtered for the domain
2. **Ad hoc agent** implements (instead of generic dev) → domain-aware implementation
3. Tester writes/validates tests → may need domain-specific test patterns
4. Reviewer reviews → should evaluate domain best practices
5. CI runs pipeline → same as always

## Rules

- Ad hoc agents follow all the same rules as dev agents (TDD, scope, reporting)
- They ADD domain expertise on top of the standard dev workflow
- They don't replace the core team — they work alongside it
- The team lead decides when an ad hoc agent is needed
- One ad hoc agent per domain — don't create overlapping specialists

## Anti-Patterns

- Creating ad hoc agents for tasks that general dev can handle
- Letting ad hoc agents skip the review process
- Creating multiple agents for the same domain
- Not including domain-specific constraints in the agent definition
