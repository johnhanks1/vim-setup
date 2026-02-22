# Verification Before Completion

## Metadata
- **Name**: verification-before-completion
- **Description**: Verify all work before marking anything as complete

## Overview

Before marking any task, batch, or project as complete, run all verifications. Never assume passing — always check.

## Verification Checklist

1. **Tests pass**: Run the full test suite, not just new tests
2. **Build succeeds**: If there's a build step, run it
3. **Linting passes**: If there's a linter, run it
4. **Type checking passes**: If there's a type checker, run it
5. **No regressions**: Compare test results before and after your changes
6. **Acceptance criteria met**: Check every criterion from the plan/spec

## Rules

- Run verifications after every task, not just at the end
- If a verification fails, fix it before moving on
- Never mark a task complete with failing verifications
- Report verification results in every checkpoint message to the human

## Integration

- **teampowers:test-driven-development** — Tests are the primary verification
- **teampowers:executing-plans** — Verifications run between batches
- **teampowers:finishing-a-development-branch** — Final verification before completion
