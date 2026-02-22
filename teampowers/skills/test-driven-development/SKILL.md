# Test-Driven Development

## Metadata
- **Name**: test-driven-development
- **Description**: Write tests before implementation code — the iron rule of teampowers

## Overview

The iron rule: no code without tests first. If you write implementation code before tests, delete it and start over with tests.

Announce: "I'm using the test-driven-development skill."

## The Cycle

1. **Red** — Write a failing test that defines the expected behavior
2. **Green** — Write the minimum code to make the test pass
3. **Refactor** — Clean up while keeping tests green

## Rules

- Write the test FIRST — before any implementation code
- If you catch yourself writing code first, stop, delete it, write the test
- Each test should test one specific behavior
- Tests verify behavior, not implementation details
- Don't mock what you don't own
- Run the full test suite after each change, not just new tests
- Target meaningful coverage — not 100% line coverage, but 100% behavior coverage

## Test Quality Checklist

- Does the test fail for the right reason before implementation?
- Does it test behavior the user cares about?
- Is it independent of other tests?
- Would it catch a regression if someone changed the implementation?
- Is it readable — can someone understand the intent without reading the code?

## When TDD Doesn't Apply

- Exploratory prototyping (but write tests before merging)
- Configuration changes
- Documentation-only changes
- Trivial one-line fixes with existing test coverage

## Integration

- **teampowers:team-driven-development** — Each implementer agent follows TDD
- **teampowers:verification-before-completion** — Tests are the primary verification
