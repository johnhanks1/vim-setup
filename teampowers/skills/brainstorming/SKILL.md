---
name: brainstorming
description: Structured brainstorming before implementation — refine ideas, explore alternatives, validate design
---

# Brainstorming

## Metadata
- **Name**: brainstorming
- **Description**: Structured brainstorming before implementation — refine ideas, explore alternatives, validate design

## Overview

Before writing any code, step back and brainstorm. Refine the user's rough idea through targeted questions, explore alternative approaches, and present the design in digestible sections for validation.

Announce: "I'm using the brainstorming skill to explore this idea before we commit to an approach."

## When to Use

- User describes a feature, change, or system they want built
- The request is non-trivial (more than a simple bug fix or one-liner)
- Requirements are underspecified or ambiguous
- Multiple valid approaches exist

## The Process

### Step 1: Understand the Goal
- Ask clarifying questions about what the user really wants
- Identify the core problem being solved (not just the surface request)
- Understand constraints: time, existing code, dependencies, preferences

### Step 2: Explore Alternatives
- Generate 2-3 viable approaches
- For each approach, identify:
  - Pros and cons
  - Complexity and risk
  - Impact on existing code
  - Testing implications

### Step 3: Present Design
- Present the recommended approach in short, reviewable sections
- Don't dump the entire design at once — chunk it
- Wait for validation on each section before continuing
- Save the final design document for reference during implementation

### Step 4: Transition to Planning
- Once the design is validated, transition to `teampowers:writing-plans`
- The plan should reference the design decisions made during brainstorming

## Key Rules

- Never skip brainstorming for non-trivial work
- Never present only one option — always show alternatives
- Keep sections short enough to actually read and digest
- Save the design document — it's referenced during implementation and review

## Integration

- **teampowers:writing-plans** — Follows brainstorming to create the implementation plan
