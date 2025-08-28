---
description: Run code quality analysis on files modified during the current session
---

I need to run the code-quality-guard agent on files that have been modified during this session.

First, let me identify the files that have been modified:

```bash
git status --porcelain
```

```bash
git diff --name-only HEAD
```

Now I'll use the code-quality-guard agent to perform comprehensive static analysis and automatic fixes on these modified files.

Use the Task tool with subagent_type: "code-quality-guard" to analyze and fix any quality issues found in the modified files. The agent should:
1. Analyze all modified files for code quality issues
2. Fix any linting errors, type errors, or style issues automatically
3. Ensure all files meet quality standards
4. Report on what was fixed or any issues that require manual attention