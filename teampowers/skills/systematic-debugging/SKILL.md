# Systematic Debugging

## Metadata
- **Name**: systematic-debugging
- **Description**: Methodical approach to diagnosing and fixing bugs — no guessing

## Overview

Debug systematically: reproduce, isolate, understand, fix, verify. Never guess-and-check.

Announce: "I'm using the systematic-debugging skill to diagnose this issue."

## The Process

### Step 1: Reproduce
- Get a reliable reproduction case
- Document exact steps, inputs, and expected vs actual behavior
- Write a failing test that captures the bug (TDD applies to bugs too)

### Step 2: Isolate
- Narrow down where the bug lives
- Binary search through the call stack / data flow
- Use logging, breakpoints, or print statements strategically
- Identify the smallest possible reproduction

### Step 3: Understand
- Read the code around the bug location carefully
- Understand WHY it's broken, not just WHERE
- Check if the bug exists in other similar code paths
- Look at git blame / history for recent changes

### Step 4: Fix
- Fix the root cause, not the symptom
- Ensure the failing test from Step 1 now passes
- Run the full test suite
- Check for similar bugs elsewhere in the codebase

### Step 5: Verify
- Confirm the original reproduction case is fixed
- Confirm no regressions in the full test suite
- Add the reproduction test to the permanent test suite if not already there

## Anti-Patterns

- **Shotgun debugging**: Making random changes hoping something works
- **Symptom fixing**: Patching the visible symptom without understanding the cause
- **Test removal**: Deleting failing tests instead of fixing the code
- **Timeout bumping**: Increasing timeouts instead of fixing the actual issue

## Integration

- **teampowers:test-driven-development** — Bug fixes start with a failing test
- **teampowers:dispatching-team-agents** — Multiple independent bugs can be debugged in parallel
