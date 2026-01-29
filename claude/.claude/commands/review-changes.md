---
name: review-changes
description: Review uncommitted changes using parallel agents to find security issues, bugs, and code quality problems
---

# Review Uncommitted Changes

Review all uncommitted changes (staged + unstaged) against HEAD using parallel review agents, then synthesize findings into a deduplicated, prioritized issue list.

## Step 1: Get Current Changes

First, understand what has changed by running these commands:

```bash
git diff HEAD --stat
```

```bash
git diff HEAD --name-only
```

```bash
git diff HEAD
```

If there are no changes, inform the user and stop.

## Step 2: Determine Which Agents to Run

**Always run these 5 agents:**
1. `compound-engineering:review:security-sentinel` - Security vulnerabilities
2. `compound-engineering:review:performance-oracle` - Performance issues
3. `compound-engineering:review:architecture-strategist` - Architectural concerns
4. `compound-engineering:review:pattern-recognition-specialist` - Anti-patterns, code smells
5. `compound-engineering:review:code-simplicity-reviewer` - Over-engineering

**Run these conditionally based on file extensions in the diff:**
- If `.ts` or `.tsx` files changed: `compound-engineering:review:kieran-typescript-reviewer`
- If `.rb` files changed: `compound-engineering:review:kieran-rails-reviewer`
- If `.py` files changed: `compound-engineering:review:kieran-python-reviewer`
- If `.js` files or Stimulus controllers changed: `compound-engineering:review:julik-frontend-races-reviewer`

## Step 3: Launch Parallel Review Agents

Use the Task tool to launch ALL applicable agents IN PARALLEL (single message, multiple Task tool calls).

For each agent, provide this context:
1. The full git diff output
2. The list of changed files
3. Clear instruction: "Analyze ONLY the changed code in this diff. Report findings with file:line references."

Example agent prompt:
```
Review the following uncommitted changes for [agent focus area].

Changed files:
[list from git diff --name-only]

Full diff:
[output from git diff HEAD]

Instructions:
- Focus ONLY on the changed lines (+ lines in diff)
- Report each finding with: severity, category, description, file:line reference
- Be specific and actionable
- Do not report issues in unchanged code
```

## Step 4: Synthesize Findings

After ALL agents complete, synthesize their findings:

1. **Collect** all findings from each agent
2. **Deduplicate** - Remove identical or overlapping findings (same issue reported by multiple agents)
3. **Categorize** by severity:
   - **P1 (CRITICAL)**: Security vulnerabilities, data corruption risks, breaking changes, crashes
   - **P2 (IMPORTANT)**: Performance issues, architectural violations, significant code quality problems
   - **P3 (NICE-TO-HAVE)**: Minor improvements, code cleanup, style suggestions

## Step 5: Present Final Output

Format the output as follows:

```markdown
## Review Complete: Uncommitted Changes

**Files Changed:** [count]
**Total Findings:** [count] ([P1 count] critical, [P2 count] important, [P3 count] suggestions)

### P1 - Critical (Must Fix Before Commit)
- [ ] [Category] Description `file.ts:45`
- [ ] [Category] Description `model.rb:23`

### P2 - Important (Should Fix)
- [ ] [Category] Description `api.ts:112`
- [ ] [Category] Description `hook.ts:78`

### P3 - Nice to Have
- [ ] [Category] Description `utils.ts:67`

---

<details>
<summary>Full Report: security-sentinel</summary>

[Agent's full findings]

</details>

<details>
<summary>Full Report: performance-oracle</summary>

[Agent's full findings]

</details>

[... additional agent reports ...]
```

If no findings: "No issues found in uncommitted changes."

## Important Notes

- Run agents in PARALLEL for speed (use multiple Task tool calls in a single message)
- Only analyze CHANGED code, not the entire file
- Deduplicate aggressively - same issue from multiple agents counts as ONE finding
- Include file:line references for every finding
- P1 findings should block commit - make this clear to the user
