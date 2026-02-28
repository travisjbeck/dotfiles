---
description: Run end-to-end browser testing with Playwright MCP to verify what was just built works correctly
---

# End-to-End Browser Testing

## Step 1: Gather Context

Understand what was just built by checking recent changes and conversation context:

```bash
git diff HEAD --name-only
```

```bash
git diff HEAD --stat
```

Review the conversation history to understand what feature or fix was just implemented. Identify the key user flows that need testing.

## Step 2: Determine Test URL

The user may provide a URL as an argument: `$ARGUMENTS`

- If `$ARGUMENTS` is provided, use that as the starting URL
- If `$ARGUMENTS` is empty, check for common dev server URLs by looking at `package.json` scripts, config files, or ask the user what URL to test

## Step 3: Run Browser E2E Tests

Use the Playwright MCP browser tools to test the feature that was just built. Follow this loop:

### 3a: Navigate and Snapshot

1. Use `browser_navigate` to open the test URL
2. Use `browser_snapshot` to get the accessibility tree and understand the page structure
3. Use `browser_take_screenshot` to capture the initial visual state

### 3b: Test the Feature

Based on what was just built, interact with the page to verify it works:

- Use `browser_click` to click buttons, links, and interactive elements
- Use `browser_type` to fill in text inputs
- Use `browser_fill_form` to complete forms
- Use `browser_select_option` for dropdowns
- Use `browser_snapshot` after each interaction to verify the page updated correctly
- Use `browser_take_screenshot` to capture visual state at key checkpoints
- Use `browser_console_messages` to check for JavaScript errors (level: "error")
- Use `browser_network_requests` to verify API calls succeeded

Test the **happy path** first, then test edge cases relevant to what was built.

### 3c: Verify Results

After each test step:
- Check the snapshot for expected content and UI state
- Check console for errors
- Check network requests for failed API calls
- Compare visual screenshots against expected behavior

## Step 4: Fix and Retest (Iterate)

If any test reveals a bug or issue:

1. Clearly describe what failed and why
2. Fix the code using Edit/Write tools
3. Reload the page with `browser_navigate` and retest
4. Repeat until all tests pass

Do NOT move on until the feature works correctly end-to-end.

## Step 5: Report Results

Summarize what was tested and the outcome:

| Test | Result | Notes |
|------|--------|-------|
| Description of test | Pass/Fail | Any relevant details |

## Step 6: Clean Up

Delete all screenshot files generated during testing:

```bash
find . -maxdepth 1 -name "*.png" -newer /tmp/e2e-start-marker -delete 2>/dev/null; find . -maxdepth 1 -name "*.jpeg" -newer /tmp/e2e-start-marker -delete 2>/dev/null; find . -maxdepth 1 -name "page-*.png" -delete 2>/dev/null; find . -maxdepth 1 -name "page-*.jpeg" -delete 2>/dev/null
```

Close the browser when done:

Use `browser_close` to clean up the browser session.
