# Labs - Experimental Testing Ground

This is YOUR experimental testing ground for new context documentation.

## Purpose

Test new context files before committing them to stable categories (sw-foundations, workflow, platforms).

## Workflow

1. **Create** - Write new context doc based on hard-won lessons
2. **Test** - Drop file in labs/, it loads automatically in next ai-context generation
3. **Validate** - Use in real conversations, see if it helps AI assist you better
4. **Decide** - After testing:
   - Valuable → Move to appropriate stable folder (sw-foundations, workflow, platforms)
   - Not useful → Delete from labs

## Organization

You can organize labs/ with subdirectories however you want:

```
labs/
  github/
    actions-setup.md
    secrets-management.md
  android/
    gradle-tips.md
  workflow/
    new-protocol.md
```

All .md files are loaded recursively from any depth.

## What Goes Here

- Experimental workflow rules
- New AI behavior guidelines being tested
- Platform-specific docs you're validating
- Any context you want to test without polluting stable content

## What Doesn't Go Here

- Proven, stable documentation (use sw-foundations, workflow, platforms)
- Personal information about you (use personal/)
- Files you're not actively testing

## Maintenance

Review labs/ periodically. Files older than 30 days should be promoted or deleted.
Use: `dt ai-context labs status`
