---
name: finishing-a-development-branch
description: Complete a development branch with final verification and cleanup
---

# Finishing a Development Branch

## Metadata
- **Name**: finishing-a-development-branch
- **Description**: Complete a development branch with final verification and cleanup

## Overview

After all tasks are implemented and reviewed, finalize the development branch.

Announce: "I'm using the finishing-a-development-branch skill to complete this work."

## The Process

### Step 1: Final Verification
- Run the full test suite
- Run build/lint/type checking
- Verify all acceptance criteria from the plan are met
- Check for uncommitted changes or untracked files

### Step 2: Final Review
- Review the full diff from branch point to HEAD
- Look for:
  - Debug code left in (console.log, print statements)
  - TODO comments that should be resolved
  - Temporary workarounds that weren't cleaned up
  - Files that were modified but shouldn't have been

### Step 3: Present to Human
Show the human:
- Summary of all changes
- Test results
- Any remaining concerns
- Options: merge, squash, additional changes needed

### Step 4: Clean Up
- Remove any temporary files
- Ensure git history is clean
- Push the branch if not already pushed

## Integration

- **teampowers:verification-before-completion** — Final verification step
- **teampowers:executing-plans** — Triggers this skill after all tasks complete
