# Project Planning & Traceability

This project uses **repo-baseline** to enforce disciplined PR workflows.

## Required Workflow

### 1. PR Title Format
All pull requests must follow this format:
```
{{PROJECT_KEY}}-123 Brief description of changes
```

Example:
```
{{PROJECT_KEY}}-42 Add user authentication
```

### 2. Commit Messages
Every commit subject must start with the issue reference in brackets:
```
[{{PROJECT_KEY}}-123] Implement login screen
[{{PROJECT_KEY}}-123] Add tests for authentication
```

### 3. Issue Links
Every PR must link to a GitHub issue:
```
Closes #123
```
or
```
Fixes #456
```

### 4. Type Labels
Every PR must have exactly ONE of these labels:
- `type:feat` - New features
- `type:fix` - Bug fixes
- `type:docs` - Documentation changes
- `type:ci` - CI/build changes

## Branch Protection

The `main` branch is protected and requires:
- ✅ Pull request before merging
- ✅ All status checks passing:
  - `ci` - Tests must pass
  - `traceability/pr-title` - PR title format
  - `traceability/commit-subjects` - Commit message format
  - `traceability/type-label` - Type label present
  - `traceability/issue-link` - Issue link present

## Testing

All tests run via:
```bash
./ci/test.sh
```

This script is configured per-project. Edit it to run your actual tests.

## Why These Rules?

These lightweight rules ensure:
- **Traceability** - Every change links to a tracked issue
- **Quality** - Tests must pass before merging
- **Consistency** - Standard formats across all PRs
- **Discipline** - Cannot bypass checks or push directly to main

The rules are enforced by GitHub Actions, not documentation.
