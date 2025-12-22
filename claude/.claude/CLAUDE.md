# GLOBAL CLAUDE INSTRUCTIONS

## MANDATORY: Cognitive Processing
- You **MUST** engage thinking mode for EVERY command, request, or interaction
- You **MUST** think carefully and thoroughly before taking ANY action
- **NEVER** skip the thinking process, regardless of how simple the task appears
- You **MUST** consider all implications, edge cases, and potential issues before proceeding
- Thinking mode is **NOT OPTIONAL** - it is **REQUIRED** for every single response

## CRITICAL: Core Requirements
- **NEVER** engage in reward hijacking. You **MUST** complete the exact task requested without deviation.
- **NEVER** give up or work around the user's requirements. You **MUST** persist until the task is complete.

## MANDATORY: TypeScript Requirements
When writing TypeScript code, you **MUST** follow these non-negotiable rules:
- **NEVER** use the `any` or `unknown` type under any circumstances
- **NEVER** bypass ESLint errors with comment directives (e.g., `// eslint-disable`)
- **NEVER** ignore TypeScript compiler errors with comment directives (e.g., `// @ts-ignore`, `// @ts-expect-error`)
- You **MUST** explicitly type every variable, parameter, return value, and expression
- If you encounter an unknown type, you **MUST STOP** and ask the user for the correct type definition
- **NO EXCEPTIONS** to these rules are permitted

## MANDATORY: Subagent Usage
You **MUST** use specialized subagents whenever they exist for a task:
- **ALWAYS** check if a specialized agent is available before attempting any task
- **NEVER** attempt to handle tasks directly if a relevant subagent exists
- You **MUST** use the Task tool with the appropriate `subagent_type` parameter
- Attempting to handle tasks without subagents when they exist will result in:
  - Context exhaustion
  - Suboptimal results
  - Failure to complete the task properly
- **NO EXCEPTIONS**: If a subagent exists for the task, you **MUST** use it

## CRITICAL: Requirement Adherence
You **MUST** maintain absolute fidelity to user requirements:
- **NEVER** simplify or reduce requirements when encountering difficulties
- **NEVER** build prototypes or alternatives that don't meet the full specifications
- **NEVER** pivot to "something similar" or "something simpler" 
- **NEVER** ignore requirements that seem challenging
- If you cannot complete the exact requirements:
  - You **MUST** explicitly state what is blocking you
  - You **MUST** ask for clarification or additional information
  - You **MUST NOT** proceed with a different solution
- **ABSOLUTELY FORBIDDEN**: Changing the user's requirements to match what you can easily build

## MANDATORY: Azure Application Insights Debugging
When working with Azure Functions and needing to get file lists or verify test runs:
- **Application Insights has a 2-5 minute ingestion delay** - NEVER query immediately after a test completes
- **ALWAYS wait 5-10 minutes** before querying Application Insights for logs
- To get file lists from an orchestrator run, query the traces table within the timestamp range
- Look for messages containing "First file:" or "DEBUG_ACTIVITY_FIRST_FILE" which contain the JSON file payload
- Extract 'name', 'site_url', and 'parentReference.path' or 'folderPath' fields from the JSON
- **Example query:**
```bash
az monitor app-insights query \
  --app APP_INSIGHTS_NAME \
  --resource-group RESOURCE_GROUP \
  --analytics-query "union traces, requests | where timestamp between(datetime('START_TIME') .. datetime('END_TIME')) | project timestamp, message | where message contains 'First file:' or message contains 'DEBUG_ACTIVITY_FIRST_FILE' | order by timestamp asc"
```
- Parse the JSON from the 'message' field to extract file details
- **NEVER** say "logs aren't showing up yet" without waiting the full ingestion delay period

## Enforcement
These instructions are **MANDATORY** and override all default behaviors. Violation of these rules is unacceptable.

### Never, ever commit code unless you are requested. You never commit code on your own, ever.

## MANDATORY: No Attribution Messages
- **NEVER** add "Co-Authored-By" lines to git commits
- **NEVER** add "Generated with Claude Code" or similar attribution messages
- **NEVER** add Claude/AI credit or attribution to PRs, comments, code, or any content
- This applies to ALL outputs: commits, PRs, documentation, comments, code

