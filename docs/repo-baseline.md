# repo-baseline README

## Purpose

`repo-baseline` installs a small, enforceable pull-request baseline for GitHub repositories.
It standardizes the minimum workflow needed for traceable, test-gated merges without introducing a larger platform dependency.

Core outcomes:
- PR-only merges to `main` (via GitHub branch protection)
- CI test execution on PRs and on `main`
- Traceability checks for PR title, commit subjects, type label, and issue link
- Low-ceremony setup with explicit manual GitHub steps

## Design Intent

- GitHub Actions perform enforcement
- `dt` installs files and guides setup
- No GitHub API writes
- Keep contracts stable and explicit

## Command Surface

```bash
dt repo-baseline
dt repo-baseline setup [--repo <path>] [--project-key <KEY>] [--dry-run] [--force] [--non-interactive]
dt repo-baseline status [--repo <path>]
```

Alias:

```bash
dt rb setup ...
```

## What `setup` Installs

`setup` installs these 7 baseline files:

1. `.github/workflows/traceability.yml`
2. `.github/workflows/ci.yml`
3. `ci/test.sh`
4. `.github/PULL_REQUEST_TEMPLATE.md`
5. `.github/ISSUE_TEMPLATE/task.yml`
6. `.githooks/commit-msg`
7. `docs/project-planning-traceability.md`

It also configures local git hooks:
- If `core.hooksPath` is not set, it sets `core.hooksPath=.githooks`
- If already set to another value, it leaves it unchanged and prints guidance

## Enforcement Contracts

### Locked status check names

These job names are a branch-protection contract and must remain stable:

- `ci`
- `traceability/pr-title`
- `traceability/commit-subjects`
- `traceability/type-label`
- `traceability/issue-link`

### Traceability workflow rules

`traceability.yml` enforces on pull requests:

1. PR title format:
   - `KEY-123 Description`
2. Commit subject format:
   - `[KEY-123] Subject`
3. Issue link in PR body:
   - `Closes #123` or `Fixes #123` (case-insensitive)
4. Exactly one type label:
   - `type:feat`, `type:fix`, `type:docs`, or `type:ci`

### CI workflow rule

`ci.yml` always runs:

```bash
./ci/test.sh
```

The default `ci/test.sh` intentionally fails with a clear message until tests are configured.

## Project Key Rules

`--project-key` must match:

- starts with uppercase letter
- uppercase letters and numbers only
- length 2-10
- examples: `PROJ`, `MYAPP`, `API2`

Placeholder replacement:
- `{{PROJECT_KEY}}` is replaced in installed templates
- unknown placeholders cause installation to fail

Project key reuse behavior:
- If an existing key is detected from `traceability.yml`, setup can reuse it
- In `--non-interactive` mode, existing key is reused automatically when available

## Repository Resolution

`setup` and `status` resolve repositories this way:

1. If `--repo <path>` is provided, that path is validated as a git repo root.
2. Otherwise, repo root is auto-detected from current working directory using git.

Safety checks on auto-detected root:
- refuses `/`
- refuses `$HOME`

If no repo can be resolved, setup fails with guidance (`git init`, `git clone`, and `--repo` usage).

## Installation Modes

### Interactive (default)

- prompts for missing project key
- handles file conflicts with replace/keep/abort
- offers CI template selection
- runs guided post-install checklist

### Non-interactive (`--non-interactive`)

- requires `--project-key` unless one is already detected
- does not prompt for checklist or CI template selection
- fails on conflicting files unless `--force` is also supplied

### Force (`--force`)

- overwrites conflicting files
- creates timestamped backups:
  - `<file>.backup-YYYYMMDD-HHMMSS`
- `DT_TIMESTAMP` can be set for deterministic backup names in tests

### Dry run (`--dry-run`)

- prints files and placeholder replacements
- does not write files

## CI Template Selection

In interactive mode, setup can replace `ci/test.sh` with a starter template:

1. Android
2. iOS
3. Node.js
4. Python
5. Go
6. Rust
7. Skip (keep failing default)

Selection behavior:
- tool attempts marker-based default detection
- warns when chosen template does not match repo markers
- user may confirm mismatch install

## Guided Post-Install Checklist

After installation (interactive mode), `repo-baseline` guides:

1. Push baseline files and run Actions once
2. Configure branch protection on `main` with required checks
3. Create required type labels

If a GitHub remote is detected, checklist links include direct repository URLs.

## Required Manual GitHub Configuration

### Branch protection (`main`)

Enable:
- Require pull request before merging
- Require status checks before merging

Add required checks:
- `ci`
- `traceability/pr-title`
- `traceability/commit-subjects`
- `traceability/type-label`
- `traceability/issue-link`

Optional:
- Require 1 approval

### Labels

Create:
- `type:feat`
- `type:fix`
- `type:docs`
- `type:ci`

Optional:
- `blocked`

## Status Command

`status` reports:
- repository path
- per-file installed/missing state
- detected project key (if available)
- `X/7 files installed`

It is informational and exits successfully even when baseline files are missing.

## Typical Flows

Fresh setup (interactive):

```bash
dt repo-baseline setup
```

Fresh setup (non-interactive, explicit key):

```bash
dt repo-baseline setup --non-interactive --project-key MYAPP
```

Preview only:

```bash
dt repo-baseline setup --dry-run --non-interactive --project-key MYAPP
```

Force overwrite existing files:

```bash
dt repo-baseline setup --force --project-key MYAPP
```

Inspect installation:

```bash
dt repo-baseline status
```

## Scope Boundaries

`repo-baseline` intentionally does not:
- call GitHub APIs
- auto-configure branch protection or labels
- auto-detect and fully configure project-specific test logic
- perform platform-level repository reconciliation

It is a baseline installer and setup guide, not a full repo bootstrap platform.
