# GitHub Actions & Branch Protection Setup

**AI Assistant Instructions: When user requests help setting up GitHub Actions CI/CD or encounters "empty dropdown" issues with required status checks, follow this guidance.**

## Required Setup Sequence

CRITICAL: You must guide the user through these steps IN ORDER. Do not suggest configuring branch protection before step 4.

**Step 1: Create workflow file**
- Must include BOTH triggers: `pull_request` AND `push: branches: [main]`
- The push trigger is non-negotiable - without it, the check won't register in GitHub's settings
- Provide complete workflow file, not just snippets

**Step 2: Merge workflow to main**
- If branch protection exists, user must bypass to merge first workflow
- This first run on main registers the check name with GitHub
- Explain why this step is necessary

**Step 3: Wait for indexing**
- Tell user to wait 1-2 minutes
- GitHub must index the check before it appears in settings
- Do not skip this step

**Step 4: Configure branch protection**
- NOW the check will appear in "Add checks" dropdown
- Settings → Rules → Rulesets (or Branches → Branch protection)
- The check name will match what ran in step 2

**Step 5: Optional - Remove admin bypass**
- Explain trade-offs: safety vs emergency access
- User's choice, present both options

## Anti-Patterns to Prevent

**NEVER suggest these:**
- ❌ "Configure branch protection first, then add the workflow"
- ❌ "Just type the check name in the dropdown" (when it's empty)
- ❌ "Wait for the check to appear" (without first running CI on main)
- ❌ Creating workflow with only `pull_request` trigger
- ❌ Telling user to "refresh the page" when dropdown is empty

**Recognition patterns:**
- User says "dropdown is empty" or "no results" → They skipped step 2, guide back to sequence
- User asks "why won't my check appear?" → Check if workflow has push trigger, check if it ran on main
- User is frustrated after multiple attempts → Likely fighting wrong problem, reset to step 1

## When User Asks "Why Both Triggers?"

User may question why `push: branches: [main]` is needed if PRs are required.

**Your response should explain:**
1. **Registration requirement**: GitHub only lists checks it has seen run on the base branch
2. **Two-layer verification**: 
   - Pre-merge (pull_request): Validates isolated changes
   - Post-merge (push): Catches integration issues, merge conflict errors, sequential PR conflicts
3. **This is standard practice**: Not a workaround, this is how production repos work

## Workflow Templates to Provide

**Working solution (use this - it's what solved the 2-day issue):**
```yaml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

permissions:
  checks: write  # Required for custom check action
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      # User's actual test steps here
      - name: Install dependencies
        run: # user commands
      
      - name: Run tests
        run: # user commands
      
      # This creates consistent check name
      - name: Report Status
        if: always()
        uses: LouisBrunner/checks-action@v2.0.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          name: "test"  # Consistent name regardless of trigger
          conclusion: ${{ job.status }}
```

This creates a check named "test" that appears consistently in GitHub settings.

**Why this works:**
- Without custom action: GitHub creates different check names for PR vs push contexts
- With custom action: Same check name regardless of trigger
- The `permissions: checks: write` is critical - without it you get "Resource not accessible" errors

**Simpler alternative (may or may not work depending on GitHub's mood):**
```yaml
name: test

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: # user's test commands
```

This SHOULD create "test / ci" check, but we found it unreliable. Use the custom check action version above for guaranteed results.

## Troubleshooting Decision Tree

**Symptom: "Add checks dropdown is empty / No results"**
→ Has workflow run on main at least once? 
  → No: Guide user back to step 2 (merge to main first)
  → Yes: Check workflow file has `push: branches: [main]`
    → Missing: Add push trigger, merge again
    → Present: Wait 2 minutes, refresh settings page

**Symptom: "I can still push to main directly"**
→ Check Settings → Rules → Rulesets → Bypass list
  → Admin in bypass: Explain it's enabled, ask if they want to remove it
  → Not in bypass but push worked: Check "Enforcement status" is "Active"

**Symptom: "Shows 'Bypassed rule violations' when pushing"**
→ Bypass is still enabled
→ Guide to Settings → Rules → Rulesets → Edit → Remove from bypass list → Save

**Symptom: "Multiple checks with similar names appearing"**
→ Workflow creating different check names per context
→ Typically from using workflow name + job name + event type
→ Solution: Use custom check action OR keep naming simple
→ Clean up: Delete old/incorrect checks from protection settings

**Symptom: User spent >1 hour troubleshooting dropdown**
→ You probably suggested wrong sequence
→ Reset: Acknowledge mistake, start from step 1, verify each step completion before proceeding

## AI Assistant Behavior

**When user says "help me set up CI":**
1. Ask if they have existing workflow or starting fresh
2. If fresh: Provide complete workflow file (with both triggers)
3. Immediately state: "Important: Don't configure branch protection yet. Let's merge this first."
4. Guide through steps 1-5 in order
5. Confirm each step completion before proceeding

**When user is confused/frustrated:**
- Stop proposing new solutions
- Ask: "Let's verify what state we're in. Can you show me the Actions tab - has CI run on main?"
- Reset to known good state
- Walk through sequence from appropriate step

**Key principles:**
- Be directive, not exploratory (the sequence is known to work)
- Verify state before suggesting next action
- Don't suggest "try this" when you know the root cause
- If going in circles >30min, acknowledge and reset to step 1

**This document exists because:**
We spent 2 days debugging this exact issue. The root cause was always the same: trying to configure protection before CI ran on main. Don't repeat this mistake.
