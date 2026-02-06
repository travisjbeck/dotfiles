---
name: audit
description: Audit any codebase against the 99-item hardening checklist using 15 parallel agents
---

# Codebase Hardening Audit

Audit the current codebase against the 99-item hardening checklist using 15 parallel Explore agents, one per section. Each agent evaluates its section independently, then results are aggregated into a scored report.

## Step 1: Initial Reconnaissance

First, understand the codebase structure:

```bash
ls -la
```

```bash
find . -maxdepth 3 -type f -name "*.json" -o -name "*.toml" -o -name "*.yaml" -o -name "*.yml" | head -20
```

```bash
ls -la apps packages src lib 2>/dev/null || echo "Checking alternative structures..."
```

Note the tech stack, project structure, and any configuration files found.

## Step 2: Launch 15 Parallel Audit Agents

Use the Task tool to launch ALL 15 agents IN PARALLEL (single message with 15 Task tool calls). Each agent uses `subagent_type: "Explore"`.

### Agent 1: Project Structure (9 items)

**Prompt:**
```
You are auditing PROJECT STRUCTURE against these 9 checklist items:

1. Monorepo architecture with clear separation: apps for implementation, packages for definition
2. No page/route files exceeding 200 lines (orchestration only)
3. UI components live in dedicated packages, organized by atomic design (atoms, molecules, organisms, templates)
4. Business logic separated into services packages
5. React state and data fetching consolidated in hooks package
6. Data fetching functions isolated in queries package
7. Types generated from single source of truth (database schema)
8. Shared utilities in dedicated utils package
9. Clear one-way dependency hierarchy with no circular dependencies

INSTRUCTIONS:
- Use Glob to find project structure patterns
- Use Read to examine package.json, tsconfig.json, or similar config files
- Use Grep to check for circular dependencies or file sizes
- Rate each item: PASS (fully implemented), PARTIAL (some evidence), or FAIL (not found)
- Provide file path evidence for each rating

OUTPUT FORMAT:
Section: Project Structure
Score: X / 9

| Item | Status | Evidence |
|------|--------|----------|
| Monorepo architecture | [PASS/PARTIAL/FAIL] | [file paths or explanation] |
| Page files under 200 lines | [PASS/PARTIAL/FAIL] | [evidence] |
| UI components organized | [PASS/PARTIAL/FAIL] | [evidence] |
| Business logic in services | [PASS/PARTIAL/FAIL] | [evidence] |
| Hooks package exists | [PASS/PARTIAL/FAIL] | [evidence] |
| Queries package exists | [PASS/PARTIAL/FAIL] | [evidence] |
| Types from schema | [PASS/PARTIAL/FAIL] | [evidence] |
| Utils package exists | [PASS/PARTIAL/FAIL] | [evidence] |
| No circular dependencies | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description of what to fix
```

### Agent 2: Type Safety (8 items)

**Prompt:**
```
You are auditing TYPE SAFETY against these 8 checklist items:

1. TypeScript strict mode enabled across all packages
2. Zero uses of `any` type (enforced by linter)
3. Types flow linearly from database schema → API contracts → frontend
4. No manual type duplication (all derived from schema via ORM)
5. API contracts defined with type-safe library (ts-rest, tRPC, or similar)
6. Validation schemas (Zod) shared between frontend and backend
7. No raw `fetch()` calls—all API interactions through typed client
8. Enums imported directly from database package, not redefined

INSTRUCTIONS:
- Use Grep to search for "any" type usage, "strict" in tsconfig
- Use Glob to find tsconfig.json files and schema definitions
- Use Read to examine type definitions and API contracts
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Type Safety
Score: X / 8

| Item | Status | Evidence |
|------|--------|----------|
| Strict mode enabled | [PASS/PARTIAL/FAIL] | [tsconfig.json location and content] |
| Zero any types | [PASS/PARTIAL/FAIL] | [grep results] |
| Types flow from schema | [PASS/PARTIAL/FAIL] | [evidence] |
| No manual type duplication | [PASS/PARTIAL/FAIL] | [evidence] |
| Type-safe API contracts | [PASS/PARTIAL/FAIL] | [evidence] |
| Shared validation schemas | [PASS/PARTIAL/FAIL] | [evidence] |
| No raw fetch calls | [PASS/PARTIAL/FAIL] | [evidence] |
| Enums from database | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 3: Code Quality Gates (8 items)

**Prompt:**
```
You are auditing CODE QUALITY GATES against these 8 checklist items:

1. Unified linting/formatting tool configured (Biome recommended)
2. Pre-commit hooks validate: lint, format, type-check, related tests
3. Pre-push hooks run full test suite
4. CI/CD pipeline blocks merge on any validation failure
5. Architecture validation script prevents dependency violations
6. Function complexity limits enforced (no deeply nested logic)
7. --no-verify commits are blocked or flagged
8. Branch protection requires passing checks before merge

INSTRUCTIONS:
- Use Glob to find .husky, .git/hooks, lint-staged, biome.json, eslint config
- Use Read to examine CI/CD configs (.github/workflows, .gitlab-ci.yml, etc.)
- Use Grep to search for pre-commit, pre-push hook configurations
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Code Quality Gates
Score: X / 8

| Item | Status | Evidence |
|------|--------|----------|
| Unified linter configured | [PASS/PARTIAL/FAIL] | [config file location] |
| Pre-commit hooks | [PASS/PARTIAL/FAIL] | [evidence] |
| Pre-push hooks | [PASS/PARTIAL/FAIL] | [evidence] |
| CI blocks on failure | [PASS/PARTIAL/FAIL] | [evidence] |
| Architecture validation | [PASS/PARTIAL/FAIL] | [evidence] |
| Complexity limits | [PASS/PARTIAL/FAIL] | [evidence] |
| --no-verify blocked | [PASS/PARTIAL/FAIL] | [evidence] |
| Branch protection | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 4: Testing Infrastructure (8 items)

**Prompt:**
```
You are auditing TESTING INFRASTRUCTURE against these 8 checklist items:

1. Unit tests for all service layer functions (target 80%+ coverage)
2. Integration tests for API routes
3. Component tests for UI (stateless, prop-based)
4. E2E tests for critical user flows (Playwright)
5. Storybook configured for visual component development
6. Accessibility tests integrated (jest-axe, Playwright axe)
7. Coverage enforcement configured in CI/CD
8. Test files colocated with source or in dedicated __tests__ directories

INSTRUCTIONS:
- Use Glob to find test files (*.test.ts, *.spec.ts, __tests__)
- Use Grep to search for test frameworks (jest, vitest, playwright)
- Use Read to examine test configurations and coverage settings
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Testing Infrastructure
Score: X / 8

| Item | Status | Evidence |
|------|--------|----------|
| Unit tests exist | [PASS/PARTIAL/FAIL] | [test file locations] |
| Integration tests | [PASS/PARTIAL/FAIL] | [evidence] |
| Component tests | [PASS/PARTIAL/FAIL] | [evidence] |
| E2E tests | [PASS/PARTIAL/FAIL] | [evidence] |
| Storybook configured | [PASS/PARTIAL/FAIL] | [evidence] |
| Accessibility tests | [PASS/PARTIAL/FAIL] | [evidence] |
| Coverage enforcement | [PASS/PARTIAL/FAIL] | [evidence] |
| Test colocation | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 5: UI Architecture (8 items)

**Prompt:**
```
You are auditing UI ARCHITECTURE against these 8 checklist items:

1. UI components are stateless (receive all data via props)
2. No fetch calls or business logic inside UI components
3. Actions passed as callback props, not internal handlers with side effects
4. Design tokens used—no hardcoded colors, spacing, or typography
5. Mobile-first responsive design approach
6. WCAG 2.1 Level AA accessibility compliance
7. Components work in isolation (testable in Storybook without providers)
8. Atomic design hierarchy: atoms → molecules → organisms → templates

INSTRUCTIONS:
- Use Glob to find component files (*.tsx, *.vue, *.svelte)
- Use Grep to search for useState, useEffect, fetch calls in components
- Use Read to examine component implementations and design tokens
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: UI Architecture
Score: X / 8

| Item | Status | Evidence |
|------|--------|----------|
| Stateless components | [PASS/PARTIAL/FAIL] | [evidence of props vs state] |
| No fetch in components | [PASS/PARTIAL/FAIL] | [grep results] |
| Callback props pattern | [PASS/PARTIAL/FAIL] | [evidence] |
| Design tokens used | [PASS/PARTIAL/FAIL] | [evidence] |
| Mobile-first | [PASS/PARTIAL/FAIL] | [evidence] |
| Accessibility compliance | [PASS/PARTIAL/FAIL] | [evidence] |
| Isolation testable | [PASS/PARTIAL/FAIL] | [evidence] |
| Atomic design | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 6: AI Agent Configuration (8 items)

**Prompt:**
```
You are auditing AI AGENT CONFIGURATION against these 8 checklist items:

1. CLAUDE.md (or equivalent) exists at repository root
2. Instructions written in plain English, no code examples or magic strings
3. Uses RFC 2119 keywords (MUST, SHOULD, MAY) for clarity
4. No hardcoded file paths that may change over time
5. Focuses on patterns and principles, not specific implementations
6. Sub-agent configurations exist for specialized tasks
7. Anti-patterns explicitly documented (what NOT to do)
8. Instructions will remain valid as codebase evolves

INSTRUCTIONS:
- Use Glob to find CLAUDE.md, .claude/, .cursor/, .ai/, copilot-instructions.md
- Use Read to examine AI configuration content
- Check for RFC 2119 keywords, anti-patterns section, sub-agent configs
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: AI Agent Configuration
Score: X / 8

| Item | Status | Evidence |
|------|--------|----------|
| CLAUDE.md exists | [PASS/PARTIAL/FAIL] | [file path] |
| Plain English instructions | [PASS/PARTIAL/FAIL] | [evidence] |
| RFC 2119 keywords | [PASS/PARTIAL/FAIL] | [evidence] |
| No hardcoded paths | [PASS/PARTIAL/FAIL] | [evidence] |
| Patterns over implementations | [PASS/PARTIAL/FAIL] | [evidence] |
| Sub-agent configs | [PASS/PARTIAL/FAIL] | [evidence] |
| Anti-patterns documented | [PASS/PARTIAL/FAIL] | [evidence] |
| Timeless instructions | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 7: Backend Architecture (6 items)

**Prompt:**
```
You are auditing BACKEND ARCHITECTURE against these 6 checklist items:

1. API routes are thin handlers that call services
2. Business logic lives in service layer, not route handlers
3. Database operations isolated in repository/data layer
4. Controllers separate from business logic
5. Error handling standardized across all endpoints
6. Authentication/authorization centralized, not duplicated per route

INSTRUCTIONS:
- Use Glob to find route handlers, services, repositories
- Use Read to examine route implementations and service layer
- Use Grep to search for database calls in route handlers
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Backend Architecture
Score: X / 6

| Item | Status | Evidence |
|------|--------|----------|
| Thin route handlers | [PASS/PARTIAL/FAIL] | [evidence] |
| Service layer exists | [PASS/PARTIAL/FAIL] | [evidence] |
| Repository layer exists | [PASS/PARTIAL/FAIL] | [evidence] |
| Controllers separate | [PASS/PARTIAL/FAIL] | [evidence] |
| Standardized errors | [PASS/PARTIAL/FAIL] | [evidence] |
| Centralized auth | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 8: API Layer (6 items)

**Prompt:**
```
You are auditing API LAYER against these 6 checklist items:

1. Authorization tiers defined (Public, Protected, Organization, Role)
2. Middleware composed in consistent order
3. Error transformation layer maps service errors to HTTP responses
4. Request validation at API boundary using schema library
5. Consistent error response format across all endpoints
6. Rate limiting applied at multiple levels

INSTRUCTIONS:
- Use Glob to find middleware, API routes, error handlers
- Use Grep to search for authorization, validation, rate limiting
- Use Read to examine middleware composition and error handling
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: API Layer
Score: X / 6

| Item | Status | Evidence |
|------|--------|----------|
| Authorization tiers | [PASS/PARTIAL/FAIL] | [evidence] |
| Middleware order | [PASS/PARTIAL/FAIL] | [evidence] |
| Error transformation | [PASS/PARTIAL/FAIL] | [evidence] |
| Request validation | [PASS/PARTIAL/FAIL] | [evidence] |
| Consistent error format | [PASS/PARTIAL/FAIL] | [evidence] |
| Rate limiting | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 9: Error Handling (6 items)

**Prompt:**
```
You are auditing ERROR HANDLING against these 6 checklist items:

1. Error code categories defined (general, entity-specific, business rules, external)
2. Error class hierarchy with base AppError class
3. Error-to-status mapping documented and consistent
4. Global error handler catches and formats all errors
5. No internal details (stack traces, SQL) leaked in production responses
6. Frontend handles errors by code, not message string

INSTRUCTIONS:
- Use Glob to find error classes, error handlers, error types
- Use Grep to search for error codes, AppError, stack trace handling
- Use Read to examine error handling implementations
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Error Handling
Score: X / 6

| Item | Status | Evidence |
|------|--------|----------|
| Error code categories | [PASS/PARTIAL/FAIL] | [evidence] |
| Error class hierarchy | [PASS/PARTIAL/FAIL] | [evidence] |
| Error-to-status mapping | [PASS/PARTIAL/FAIL] | [evidence] |
| Global error handler | [PASS/PARTIAL/FAIL] | [evidence] |
| No leaked internals | [PASS/PARTIAL/FAIL] | [evidence] |
| Frontend uses codes | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 10: Logging (6 items)

**Prompt:**
```
You are auditing LOGGING against these 6 checklist items:

1. Centralized logger used everywhere (no console.log)
2. Log levels used consistently (error, warn, info, debug)
3. Structured logging with JSON format in production
4. Request context (requestId, userId) included in all logs
5. Sensitive data never logged (passwords, tokens, PII)
6. Log aggregation configured for production

INSTRUCTIONS:
- Use Grep to search for console.log, logger imports, log levels
- Use Glob to find logging configuration files
- Use Read to examine logger implementations
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Logging
Score: X / 6

| Item | Status | Evidence |
|------|--------|----------|
| Centralized logger | [PASS/PARTIAL/FAIL] | [evidence] |
| Log levels consistent | [PASS/PARTIAL/FAIL] | [evidence] |
| Structured logging | [PASS/PARTIAL/FAIL] | [evidence] |
| Request context | [PASS/PARTIAL/FAIL] | [evidence] |
| No sensitive data | [PASS/PARTIAL/FAIL] | [evidence] |
| Log aggregation | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 11: Provider Abstraction (5 items)

**Prompt:**
```
You are auditing PROVIDER ABSTRACTION against these 5 checklist items:

1. Third-party services behind interface abstraction
2. Provider selection via configuration, not code changes
3. Mock providers available for testing
4. Errors normalized to application error types
5. Providers injected as dependencies, not imported directly

INSTRUCTIONS:
- Use Glob to find provider directories, adapters, interfaces
- Use Grep to search for direct third-party imports in business logic
- Use Read to examine provider implementations
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Provider Abstraction
Score: X / 5

| Item | Status | Evidence |
|------|--------|----------|
| Interface abstraction | [PASS/PARTIAL/FAIL] | [evidence] |
| Config-based selection | [PASS/PARTIAL/FAIL] | [evidence] |
| Mock providers | [PASS/PARTIAL/FAIL] | [evidence] |
| Normalized errors | [PASS/PARTIAL/FAIL] | [evidence] |
| Dependency injection | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 12: Permissions (5 items)

**Prompt:**
```
You are auditing PERMISSIONS against these 5 checklist items:

1. Role hierarchy with numeric levels defined
2. Permission checking functions centralized
3. Backend enforces all permission checks (frontend hides, backend denies)
4. Resource-level permissions handled where needed
5. Permission changes audit logged

INSTRUCTIONS:
- Use Glob to find permission files, role definitions, auth middleware
- Use Grep to search for role checks, permission functions
- Use Read to examine permission implementations
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Permissions
Score: X / 5

| Item | Status | Evidence |
|------|--------|----------|
| Role hierarchy | [PASS/PARTIAL/FAIL] | [evidence] |
| Centralized checking | [PASS/PARTIAL/FAIL] | [evidence] |
| Backend enforcement | [PASS/PARTIAL/FAIL] | [evidence] |
| Resource-level perms | [PASS/PARTIAL/FAIL] | [evidence] |
| Audit logging | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 13: Database Migrations (5 items)

**Prompt:**
```
You are auditing DATABASE MIGRATIONS against these 5 checklist items:

1. All schema changes via migration files, never db push in production
2. Migration naming convention followed
3. Destructive changes phased (stop writing → deploy → drop)
4. CI validates migrations apply cleanly
5. Rollback strategy documented for each migration

INSTRUCTIONS:
- Use Glob to find migration directories (prisma/migrations, db/migrate, etc.)
- Use Read to examine migration files and naming patterns
- Use Grep to search for db push commands in scripts
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Database Migrations
Score: X / 5

| Item | Status | Evidence |
|------|--------|----------|
| Migration files used | [PASS/PARTIAL/FAIL] | [evidence] |
| Naming convention | [PASS/PARTIAL/FAIL] | [evidence] |
| Phased destructive changes | [PASS/PARTIAL/FAIL] | [evidence] |
| CI validation | [PASS/PARTIAL/FAIL] | [evidence] |
| Rollback strategy | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 14: Integration Testing (5 items)

**Prompt:**
```
You are auditing INTEGRATION TESTING against these 5 checklist items:

1. Mock factories for all entities
2. Tests organized by feature area
3. Database reset between tests
4. External services mocked with provider abstractions
5. API tested as black box (request in, response out)

INSTRUCTIONS:
- Use Glob to find test factories, integration test directories
- Use Grep to search for database reset, mock factories
- Use Read to examine test organization and setup
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Integration Testing
Score: X / 5

| Item | Status | Evidence |
|------|--------|----------|
| Mock factories | [PASS/PARTIAL/FAIL] | [evidence] |
| Feature organization | [PASS/PARTIAL/FAIL] | [evidence] |
| Database reset | [PASS/PARTIAL/FAIL] | [evidence] |
| External service mocks | [PASS/PARTIAL/FAIL] | [evidence] |
| Black box API tests | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

### Agent 15: Data Flow (6 items)

**Prompt:**
```
You are auditing DATA FLOW against these 6 checklist items:

1. Single source of truth for database schema (Prisma or similar ORM)
2. Types auto-generated from schema
3. API contracts define request/response shapes
4. Frontend queries use generated types from contracts
5. Hooks wrap queries with React integration
6. No manual type casting or `as unknown as X` patterns

INSTRUCTIONS:
- Use Glob to find schema files, type generation configs
- Use Grep to search for "as unknown", type casting patterns
- Use Read to examine data flow from schema to frontend
- Rate each item: PASS, PARTIAL, or FAIL
- Provide file path evidence

OUTPUT FORMAT:
Section: Data Flow
Score: X / 6

| Item | Status | Evidence |
|------|--------|----------|
| Schema source of truth | [PASS/PARTIAL/FAIL] | [evidence] |
| Auto-generated types | [PASS/PARTIAL/FAIL] | [evidence] |
| API contracts | [PASS/PARTIAL/FAIL] | [evidence] |
| Frontend uses generated types | [PASS/PARTIAL/FAIL] | [evidence] |
| Hooks wrap queries | [PASS/PARTIAL/FAIL] | [evidence] |
| No manual casting | [PASS/PARTIAL/FAIL] | [evidence] |

Recommendations:
1. [Priority: HIGH/MEDIUM/LOW] Description
```

## Step 3: Aggregate Results

After ALL 15 agents complete, synthesize their findings:

1. **Parse each agent's output** to extract:
   - Section name
   - Score (X / Y)
   - Individual item results
   - Recommendations with priorities

2. **Calculate totals**:
   - Sum all section scores for total (out of 99)
   - Calculate percentage
   - Determine status per section

3. **Consolidate recommendations**:
   - Group by priority (HIGH, MEDIUM, LOW)
   - Deduplicate similar recommendations
   - Order by impact

## Step 4: Present Final Report

Format the output as follows:

```markdown
# Codebase Hardening Audit Report

**Total Score**: X / 99 (XX%)
**Audit Date**: [current date]
**Codebase**: [directory name]

## Score Interpretation

- 90-99: Production ready for AI-assisted development
- 75-89: Good foundation, address gaps before scaling AI usage
- 50-74: Significant work needed
- Below 50: Major refactoring required

## Section Summary

| Section | Score | Status |
|---------|-------|--------|
| Project Structure | X / 9 | [Pass/Partial/Needs Work] |
| Type Safety | X / 8 | |
| Code Quality Gates | X / 8 | |
| Testing Infrastructure | X / 8 | |
| UI Architecture | X / 8 | |
| AI Agent Configuration | X / 8 | |
| Backend Architecture | X / 6 | |
| API Layer | X / 6 | |
| Error Handling | X / 6 | |
| Logging | X / 6 | |
| Provider Abstraction | X / 5 | |
| Permissions | X / 5 | |
| Database Migrations | X / 5 | |
| Integration Testing | X / 5 | |
| Data Flow | X / 6 | |
| **Total** | **X / 99** | |

Status key: Pass (80%+), Partial (50-79%), Needs Work (<50%)

## Priority Recommendations

### Critical (Must Fix)
[HIGH priority items from all sections]

### Important (Should Fix)
[MEDIUM priority items]

### Nice to Have
[LOW priority items]

---

<details>
<summary>Section Details: Project Structure</summary>

[Full agent output for this section]

</details>

<details>
<summary>Section Details: Type Safety</summary>

[Full agent output]

</details>

[... remaining 13 sections as expandable details ...]
```

## Important Notes

- Launch all 15 agents IN PARALLEL using a single message with 15 Task tool calls
- Each agent uses `subagent_type: "Explore"` for read-only safety
- Agents should be thorough but not exhaustive (sampling is acceptable for large codebases)
- If a section doesn't apply (e.g., no backend), mark items as N/A and adjust scoring
- Provide actionable recommendations, not just pass/fail verdicts
