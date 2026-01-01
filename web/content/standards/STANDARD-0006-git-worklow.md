---
title: "Git Workflow"
date: 2025-12-23
description: "Branching, commit, PR and release standards for the platform"
authors:
  - "ndrew"
series: ["Standards"]
tags: ["git"]
series_order: 6
---

## Purpose

Provide clear, repeatable Git practices for authors and maintainers to ensure consistent commits, safe deployments, and reliable review processes.

## Branch model 

- **Protected branches**: `main` (production) and `staging` (optional) are protected and require PRs for changes.
- **Feature branches**: `feature/<short-description>` — for new labs, guides or features.
- **Fix branches**: `fix/<issue-number>` — for bug fixes and urgent fixes; merge directly to `main` when appropriate.

Examples:

```
feature/lab-0001-routing
fix/42
```

## Commit message conventions

- Prefix commits with the ticket or section when relevant: `[LAB-0001] Add routing exercises`.
- Use clear, imperative messages and include a short description on the first line, with details in the body when necessary.

Example:

```
[LAB-0001] Document verification steps

Add step-by-step commands and expected outputs so reviewers can reproduce tests locally.
```

## Pull Request (PR) guidelines 

- Always open a PR to merge into `main` or `staging` from a feature/fix branch.
- PR title should reference the lab/issue: `[LAB-0001] Add routing exercises`.
- Include:
  - Short summary of changes
  - Testing instructions (how to run `hugo server`, expected verification steps)
  - Links to related resources or issues
  - Screenshots or preview URLs if relevant

### Review checklist 

- **Clarity**: Are instructions and text clear?
- **Accuracy**: Do commands/addresses match expected outputs?
- **Reproducibility**: Can a reviewer follow the steps and reach the expected result?
- **Assets**: Are diagrams and images uploaded to CDN and referenced correctly (see Asset Management)?
- **Tests**: CI passes and local `hugo server` preview renders correctly.

## Merge policy & strategies

- Prefer **squash-and-merge** for content changes to keep a clean history.
- Use **merge commits** sparingly (e.g., coordinated multi-change updates).
- Require at least one approving review before merging; for larger changes require two.

## Quick reference

- Branches: `feature/`, `fix/`
- Commit prefix: `[LAB-XXXX]` or `[PRJ-YYYY]`
- Merge method: **squash-and-merge** for content
- Tests: `hugo build`, link checks, CI linting


