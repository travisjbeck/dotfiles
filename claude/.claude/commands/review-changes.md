---
name: review-changes
description: Review uncommitted changes using parallel agents to find security issues, bugs, and code quality problems
---

# Review Uncommitted Changes

## OUTPUT FORMAT (MANDATORY)

Your ENTIRE response to the user after all agents complete MUST be a single markdown table and NOTHING ELSE. No greeting, no summary sentence, no explanation, no agent reports, no details blocks, no sign-off. The table is the only thing the user sees.

If no issues are found, respond with ONLY: "No issues found."

Otherwise respond with ONLY this table (sorted P1 → P3):

| Priority | Category | Issue | Location |
|----------|----------|-------|----------|
| P1 | Security | Brief description | `file.ts:45` |
| P2 | Performance | Brief description | `api.ts:112` |
| P3 | Code Quality | Brief description | `utils.ts:67` |

Priority definitions:
- **P1**: Security vulnerabilities, data corruption, breaking changes, crashes
- **P2**: Performance issues, architectural violations, significant code quality problems
- **P3**: Minor improvements, code cleanup, style suggestions

DO NOT output anything other than the table.

---

## Execution Steps

### Step 1: Get Changes

Run these commands:

```bash
git diff HEAD --stat
```

```bash
git diff HEAD --name-only
```

```bash
git diff HEAD
```

If there are no changes, respond with ONLY: "No uncommitted changes found." and stop.

### Step 2: Determine Agents

**Always run these 5:**
1. `compound-engineering:review:security-sentinel`
2. `compound-engineering:review:performance-oracle`
3. `compound-engineering:review:architecture-strategist`
4. `compound-engineering:review:pattern-recognition-specialist`
5. `compound-engineering:review:code-simplicity-reviewer`

**Conditionally:**
- `.ts`/`.tsx` files → also run `compound-engineering:review:kieran-typescript-reviewer`
- `.rb` files → also run `compound-engineering:review:kieran-rails-reviewer`
- `.py` files → also run `compound-engineering:review:kieran-python-reviewer`
- `.js`/Stimulus files → also run `compound-engineering:review:julik-frontend-races-reviewer`

### Step 3: Launch All Agents in Parallel

Use the Task tool to launch ALL applicable agents IN PARALLEL (single message, multiple Task tool calls).

Each agent prompt MUST be:

```
Review the following uncommitted changes for [agent focus area].

Changed files:
[list from git diff --name-only]

Full diff:
[output from git diff HEAD]

Instructions:
- Focus ONLY on the changed lines (+ lines in diff)
- For each finding, return ONLY a line in this format:
  SEVERITY | CATEGORY | DESCRIPTION | FILE:LINE
  Example: P1 | Security | SQL injection via unsanitized input | src/api.ts:45
- Do not report issues in unchanged code
- If no issues found, return: NO_ISSUES
```

### Step 4: Synthesize into Table

1. Collect all agent findings
2. Deduplicate (same issue from multiple agents = one row)
3. Sort P1 → P3
4. Output ONLY the markdown table described in the OUTPUT FORMAT section above
