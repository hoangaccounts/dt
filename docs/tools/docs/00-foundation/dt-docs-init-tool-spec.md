# dt — Docs Tool Spec

| version | date | author | change |
|---|---:|---|---|
| 0.1 | 2026-03-21 | Hoang | Initial implementation spec for a native `dt docs` tool that installs the future-project documentation standard pack into a target project. |

**AI assistance:** ChatGPT assisted with drafting delegated sections.

## Status Legend

- **Locked** = explicitly locked by Hoang in this conversation.
- **Delegated** = approved for assistant fill-in under TA, but not explicitly reviewed line by line.

## Metadata

- **Status:** active
- **Owner:** Hoang
- **Last substantive update:** 2026-03-21
- **Depends on:** `README.md`, `TOOLS_AUTHORING_GUIDE.md`, future-project doc standard pack
- **Depended on by:** future `dt` tool implementations, future project bootstrap workflows

## 1. Purpose

Define a native `dt` tool that installs the reusable future-project documentation standard into a target project in a deterministic, safe, and testable way. **[Locked]**

The tool exists so new projects can start from the same documentation operating system without manual copy/paste, zip juggling, or drift-prone ad hoc setup. **[Locked]**

## 2. Scope

This spec covers:
- the tool identity and command contract
- CLI behavior for `dt docs` and `dt docs init`
- template-pack source layout inside the `dt` repo
- install behavior into a target project
- overwrite and dry-run rules
- CLI output expectations
- test coverage and acceptance criteria
- initial README/help integration expectations

This spec does **not** cover:
- interactive project questioning or wizard flows
- remote template fetching or update channels
- generalized template marketplace behavior
- installation of non-doc assets outside the docs pack
- post-install editing of project-specific text beyond lightweight token replacement

## 3. Out of Scope

The first implementation must not:
- fetch templates from the network **[Delegated]**
- depend on zip files as the installation source **[Locked]**
- mutate unrelated project files outside the selected destination tree **[Delegated]**
- create Git commits, branches, or tags **[Delegated]**
- auto-detect project architecture and change the doc model dynamically **[Delegated]**
- become a generic scaffolding engine for all project assets **[Delegated]**

## 4. Goals / Non-Goals

### Goals

- provide one obvious command: `dt docs init` **[Locked]**
- install the canonical doc standard from an internal versioned template directory inside `dt` **[Locked]**
- fit native `dt` conventions for discovery, help, subcommands, and tests **[Locked]**
- be safe by default by skipping existing files unless explicitly forced **[Locked]**
- support deterministic previews with `--dry-run` **[Locked]**
- support lightweight project naming/token replacement where appropriate via `--project-name` **[Locked]**
- be Bash 3.2 compatible and easy to maintain **[Locked]**

### Non-Goals

- interactive template customization in v1 **[Delegated]**
- supporting multiple document standards in v1 **[Delegated]**
- installing or managing future updates to already-installed packs **[Delegated]**
- validating the semantic quality of user-edited docs after installation **[Delegated]**

## 5. Users / Actors

### Primary users

- Hoang using `dt` to bootstrap new projects quickly **[Delegated]**
- future agents working in a fresh repo that needs the standard doc system **[Delegated]**
- collaborators who need predictable documentation structure from day one **[Delegated]**

### Secondary actors

- `dt` tool discovery/help flow **[Locked]**
- bats test suite validating regression safety **[Locked]**
- local filesystem in the target project **[Locked]**

## 6. Core Concepts / Definitions

### `docs` tool

A new standalone native `dt` tool implemented at `tools/docs`, following the repo’s normal tool contract. **[Locked]**

### `init` subcommand

The action subcommand that installs the docs pack into the target project. **[Locked]**

### template pack

A versioned internal directory inside the `dt` repo that contains the canonical folder tree, starter READMEs, templates, and example starter files. **[Locked]**

### target project

The filesystem location receiving the docs pack. Default is the current working directory. **[Delegated]**

### safe default behavior

The tool must not overwrite existing files unless the user explicitly provides `--force`. **[Locked]**

### dry run

A no-write preview of what would be created, skipped, or overwritten. **[Locked]**

## 7. Requirements

### 7.1 Tool identity and repo layout

1. The implementation must create a new executable tool at `tools/docs`. **[Locked]**
2. The tool must follow the `dt` help-header contract, including the required header fields ending in `### END HELP`. **[Locked]**
3. The tool must be Bash 3.2 compatible and avoid Bash 4-only features such as associative arrays. **[Locked]**
4. The tool must use `#!/usr/bin/env bash` and `set -euo pipefail`. **[Locked]**
5. Tests must live at `test/docs.bats`. **[Locked]**

### 7.2 Supported commands

1. `dt docs` with no subcommand must show help or usage guidance consistent with existing `dt` tools. **[Locked]**
2. `dt help docs` must render the tool header correctly. **[Locked]**
3. `dt docs init` must perform the install behavior described in this spec. **[Locked]**
4. `dt docs install`, `dt docs uninstall`, and `dt docs status` are not required for v1 and should return a short “Not supported” style response with exit code `2` if implemented through the common case switch. **[Delegated]**

### 7.3 CLI arguments and flags

`dt docs init` must support:
- `--project-name <name>` — optional token replacement input **[Locked]**
- `--force` — allow overwriting files owned by the template pack **[Locked]**
- `--dry-run` — preview without writing **[Locked]**
- `--dest <path>` — optional explicit target directory; default is current directory **[Delegated]**
- `-h`, `--help`, `help` — standard help behavior **[Locked]**

Requirements:
1. Unknown args must fail fast with a short usage line and exit code `2`. **[Locked]**
2. Missing required values after flags such as `--project-name` or `--dest` must fail clearly with exit code `2`. **[Delegated]**
3. Flag parsing must remain simple and predictable. **[Locked]**

### 7.4 Safety model

1. The tool modifies project state by creating files and directories, so the help header should declare `SAFETY: confirm`. **[Delegated]**
2. When the target is non-empty and writes would occur, the tool must print a concise summary of the planned changes before prompting. **[Delegated]**
3. Default prompt answer must be No. **[Delegated]**
4. `--yes` support is recommended because it aligns with the tool-authoring contract for confirm-style tools and improves automation ergonomics. **[Delegated]**
5. If `--dry-run` is supplied, the tool must never prompt and must never write. **[Locked]**
6. If `--force` is supplied without `--yes`, the tool should still confirm before overwriting unless the repo’s existing automation style clearly prefers silent forced execution. Default to confirmation if uncertain. **[Delegated]**

### 7.5 Template source packaging

1. The docs pack must live in a versioned internal template directory inside the `dt` repo, not as a zip artifact. **[Locked]**
2. The template source should be committed as normal files so diffs are readable and updates are testable. **[Locked]**
3. Recommended location:
   - `templates/docs-standard/v1/...` **[Delegated]**
4. The template directory should contain the canonical top-level folders:
   - `docs/00-foundation`
   - `docs/10-product-systems`
   - `docs/20-libraries`
   - `docs/30-delivery`
   - `docs/40-decisions`
   - `docs/90-archive` **[Locked]**
5. The template pack should include starter READMEs and template/example docs matching the future-project standard. **[Delegated]**

### 7.6 Install behavior

1. By default, `dt docs init` installs into the current working directory. **[Delegated]**
2. The tool must create missing directories from the template pack. **[Locked]**
3. The tool must copy starter files from the internal template directory into the target project. **[Locked]**
4. Existing files must be skipped by default rather than overwritten. **[Locked]**
5. `--force` must overwrite files that collide with template-owned paths. **[Locked]**
6. The tool must not delete user-created files that are not part of the current install operation. **[Delegated]**
7. The tool must preserve file contents exactly except for approved lightweight token replacement. **[Delegated]**
8. The tool must be idempotent:
   - first run installs files
   - second run without `--force` mainly reports skips
   - second run with `--force` overwrites template-owned files deterministically **[Delegated]**

### 7.7 Token replacement

1. V1 may support lightweight token replacement for project naming only. **[Locked]**
2. Token replacement must be explicit and narrow, not a broad templating engine. **[Delegated]**
3. Recommended token shape:
   - `{{PROJECT_NAME}}` **[Delegated]**
4. If `--project-name` is omitted, either:
   - leave placeholder text intact, or
   - derive a human-readable name from the destination directory name. **[Delegated]**
5. Do not invent large amounts of project-specific prose. **[Delegated]**

### 7.8 CLI output

The tool must print a concise summary with counts and key paths.

At minimum, output should distinguish:
- created
- skipped
- overwritten
- unchanged in dry-run mode if surfaced separately **[Locked]**

Recommended summary shape:
- target path
- template version
- counts by action
- optionally a short list of affected files **[Delegated]**

The output should remain easy for both humans and agents to scan. **[Delegated]**

### 7.9 Help text

The help header should describe:
- what the tool does
- default destination behavior
- overwrite/skip behavior
- supported flags
- examples for normal, dry-run, and forced installation **[Delegated]**

Suggested synopsis:
- `dt docs`
- `dt docs init [--dest PATH] [--project-name NAME] [--dry-run] [--force] [--yes]` **[Delegated]**

### 7.10 Tests

1. The tool must ship with `test/docs.bats`. **[Locked]**
2. Minimum required tests:
   - help path
   - happy-path install into a temp directory
   - second run skips existing files by default
   - dry-run makes no filesystem changes
   - bad/unknown arg exits `2` **[Delegated]**
3. Tests must avoid touching real user home/config. **[Locked]**
4. Tests should use deterministic assertions on exit code, key output lines, created files, and preserved files. **[Locked]**
5. `dt test` must pass after implementation. **[Locked]**

## 8. States / Flows

### 8.1 Primary happy path

1. User runs `dt docs init` in a project root. **[Locked]**
2. Tool resolves its internal template directory. **[Delegated]**
3. Tool scans the destination and computes the install plan. **[Delegated]**
4. Tool prints planned create/skip actions. **[Delegated]**
5. Tool prompts for confirmation unless no confirmation is needed by repo convention or `--yes` is supplied. **[Delegated]**
6. Tool creates directories and copies files. **[Locked]**
7. Tool prints final summary. **[Locked]**

### 8.2 Dry run flow

1. User runs `dt docs init --dry-run`. **[Locked]**
2. Tool computes the plan exactly as for a real install. **[Delegated]**
3. Tool prints what would be created, skipped, and overwritten. **[Locked]**
4. Tool exits without creating or changing any files. **[Locked]**

### 8.3 Existing-file flow

1. User runs `dt docs init` where some template-owned paths already exist. **[Delegated]**
2. Tool marks collisions as skipped by default. **[Locked]**
3. If `--force` is supplied, collided template-owned paths are marked for overwrite. **[Locked]**
4. The final summary distinguishes skips from overwrites. **[Locked]**

### 8.4 Error flow

1. Unknown subcommand or unknown flag. **[Locked]**
2. Tool prints short usage/help hint. **[Locked]**
3. Tool exits with code `2`. **[Locked]**

## 9. Data / Entities / Contracts

### 9.1 Filesystem entities

- `tools/docs` — CLI entry script **[Locked]**
- `test/docs.bats` — bats coverage **[Locked]**
- `templates/docs-standard/v1/` or equivalent — internal template source **[Delegated]**
- target project docs tree — install destination **[Locked]**

### 9.2 Planned install contract

The implementation should operate from a computed plan containing, at minimum:
- source path
- destination path
- action (`create`, `skip`, `overwrite`) **[Delegated]**

This plan can remain internal, but the code should conceptually separate:
- plan building
- optional preview output
- execution **[Delegated]**

### 9.3 Ownership contract

The tool owns only the files it copies from the template pack during the current operation. **[Delegated]**

It must not assume ownership of unrelated files already in the repo. **[Delegated]**

## 10. Dependencies / Integrations

### Internal dependencies

- `dt` tool discovery and help parsing via standard header contract **[Locked]**
- existing repo layout conventions from `README.md` **[Locked]**
- tool authoring rules from `TOOLS_AUTHORING_GUIDE.md` **[Locked]**

### External command dependencies

The implementation should avoid non-portable external dependencies when possible. **[Delegated]**

Preferred baseline:
- shell built-ins
- `mkdir`
- `cp`
- `find` or equivalent portable file traversal only if needed **[Delegated]**

The tool should not depend on zip for core behavior. **[Locked]**

## 11. Risks / Edge Cases / Failure Modes

### Key risks

1. Template drift if the committed internal template pack diverges from the actual preferred standard. **[Delegated]**
2. Overwriting user-modified docs if `--force` is used carelessly. **[Delegated]**
3. Hidden Bash 4 usage causing failure on macOS default Bash 3.2. **[Locked]**
4. Path handling bugs when destinations contain spaces. **[Delegated]**
5. Confusing output that makes agents misread whether files were created or skipped. **[Delegated]**

### Required edge-case handling

- destination path does not exist yet **[Delegated]**
- destination path exists and is non-empty **[Delegated]**
- target already has some docs folders and files **[Locked]**
- repeated init calls **[Locked]**
- dry-run against empty and non-empty targets **[Locked]**
- invalid flags and missing flag values **[Delegated]**
- project names with spaces **[Delegated]**

## 12. Open Questions

1. Should `dt docs init` require confirmation on all writes, or only when the destination is non-empty / overwrite risk exists? **[Delegated]**
2. Should `--project-name` default from the destination directory name or leave placeholders unchanged when omitted? **[Delegated]**
3. Should the internal template directory include example docs by default, or only empty templates plus READMEs? **[Delegated]**
4. Should the top-level generated files include a root `docs/README.md` only, or also starter examples inside each folder? **[Delegated]**
5. Should template version be user-visible in generated files or only in CLI output? **[Delegated]**

## 13. Appendix

### A. Alignment constraints from current `dt` repo

The implementation must align with the current `dt` authoring contract:
- tools live in `tools/<tool-id>` and tests in `test/<tool-id>.bats` **[Locked]**
- normal action tools expose `dt <tool-id> run ...` behavior patterns, while help is shown via `dt <tool-id>` or `dt help <tool-id>` **[Locked]**
- Bash 3.2 compatibility is required **[Locked]**
- unknown args should fail fast with usage and exit code `2` **[Locked]**
- tests are required and `dt test` is the regression gate **[Locked]**

### B. Recommended initial file layout inside `dt`

```text
.
├── tools/
│   └── docs
├── test/
│   └── docs.bats
└── templates/
    └── docs-standard/
        └── v1/
            └── docs/
                ├── 00-foundation/
                ├── 10-product-systems/
                ├── 20-libraries/
                ├── 30-delivery/
                ├── 40-decisions/
                └── 90-archive/
```

### C. Acceptance criteria

Implementation is complete when:
1. `dt docs` is discoverable and help renders correctly. **[Locked]**
2. `dt docs init` installs the docs pack into a temp project successfully. **[Locked]**
3. Existing files are skipped by default. **[Locked]**
4. `--force` overwrites deterministically. **[Locked]**
5. `--dry-run` performs no writes and previews actions. **[Locked]**
6. `test/docs.bats` exists and covers at least the happy path plus error/idempotency paths. **[Locked]**
7. `dt test` passes. **[Locked]**
