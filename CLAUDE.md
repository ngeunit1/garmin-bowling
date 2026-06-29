# Claude Code — Project Directives

## Test Evaluation

**All test-related work (analysis, gap identification, writing tests, evaluating coverage, reviewing test quality) MUST be evaluated against `PROJECT.md` as the specification — not against the source code.**

- Do NOT read source files under `source/` when answering test questions or performing test analysis.
- If a behavior or rule is ambiguous, surface the ambiguity and update `PROJECT.md` to clarify it before proceeding.
- `PROJECT.md` is the source of truth for what the correct behavior is. The implementation may diverge from it; that is a bug in the implementation, not in the spec.

## Pre-Commit Requirements

Before every commit, run both:
1. `mise run build` — must succeed (clean build, no errors)
2. `mise run test` — must be green (all tests passing)

Do not commit if either fails.
