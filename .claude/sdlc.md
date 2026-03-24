# Software Development Lifecycle Guide

**Version:** 1.1.0

This document defines the development methodology for this project. It is designed to work with Claude Code and the GSD (Get Shit Done) workflow, but the principles apply regardless of tooling.

Distilled from building a production platform (34 phases, 5 milestones, 2,793+ tests) using AI-first development with Claude Code.

Canonical copy lives at `~/.claude/sdlc.md` (via dotfiles). Projects reference it by version in their `CLAUDE.md`.

## Table of Contents

**Process**
1. [Change Workflow](#1-change-workflow-mandatory) -- Issue first, feature branches, PRs, naming conventions
2. [Git Hygiene & Commit Discipline](#2-git-hygiene--commit-discipline) -- Atomic commits, messages, branch hygiene, hooks
3. [Planning & Execution](#3-planning--execution) -- Milestones, phases, spec the outcome, research → plan → execute → verify

**Engineering**
4. [The Makefile is the Project Interface](#4-the-makefile-is-the-project-interface) -- Single entry point for all operations
5. [Testing](#5-testing) -- Quality gates, completion contracts, adversarial validation
6. [Documentation](#6-documentation) -- Living documents, docs site, API collection, CI enforcement
7. [Code Quality](#7-code-quality) -- Static analysis, strict types, frontend standards

**Architecture**
8. [Design Principles](#8-design-principles) -- DB constraints, trust boundaries, concurrency, ratchet effect, dead code
9. [Observability](#9-observability) -- Structured logging, correlation IDs, health endpoints, metrics
10. [Environment & Secrets Management](#10-environment--secrets-management) -- Config hierarchy, trust boundaries, secrets discipline
11. [Database Migration Strategy](#11-database-migration-strategy) -- Migrations as code, forward-only, squashing, safety
12. [Dependency Management](#12-dependency-management) -- Deliberate additions, lock files, auditing, upgrades
13. [Demo-Readiness](#13-demo-readiness) -- Seed pipelines, deterministic data, one-command demos

**Agent-First Design**
14. [Agent-Ready API Design](#14-agent-ready-api-design) -- MCP-readiness, untrusted input, non-destructive, self-documenting
15. [CI/CD](#15-cicd) -- Required workflows, pre-push checklist
16. [Definition of Done](#16-definition-of-done) -- 10-point completion checklist with task contracts
17. [Claude Code Configuration](#17-claude-code-configuration) -- Rules, settings, security, project structure
18. [Collaborating with AI](#18-collaborating-with-ai) -- Context discipline, neutral prompting, feedback, delegation

**Meta**
19. [Key Decisions Log](#19-key-decisions-log) -- Capturing architectural choices
20. [Project Initialization Checklist](#20-project-initialization-checklist) -- Progressive disclosure: day 1 → scaling

---

## 1. Change Workflow (mandatory)

**Every change -- no matter how small -- must follow this workflow:**

1. **Issue first**: Create a ticket in the project tracker (e.g., Linear) describing what is being changed and why before writing any code.
2. **Feature branch**: Create a branch from `main` named `<prefix>-NN/<kebab-case-description>` where `NN` is the ticket number. Never commit directly to `main`.
3. **Pull request**: Push the branch and open a PR. The PR title **must** follow `<PREFIX>-NN: Description`. The PR body must include `Closes <PREFIX>-NN`. A human must review and approve before merge.

**No exceptions. No "quick fixes" on main. No merging without human approval.**

### Naming Conventions

- **Branch**: `<prefix>-NN/description` (e.g., `axn-51/pr-branch-naming-conventions`)
- **PR title**: `<PREFIX>-NN: Description` (e.g., `AXN-51: Enforce PR title and branch naming conventions`)
- Enforce via CI workflow (GitHub Actions) so violations are caught automatically
- These conventions ensure every change links back to a ticket for audit traceability

### Issue Tracker Sync

- Move issues to "In Progress" when starting work
- Add comments with commit references for notable progress
- Mark issues "Done" when the PR is merged
- For multi-plan phases, create sub-issues per plan under a parent phase issue

---

## 2. Git Hygiene & Commit Discipline

### Atomic Commits

Each commit should represent one logical unit of work. "Add user model, migration, and tests" is one commit -- not three. "Fix login bug and also refactor CSS" is two commits -- not one.

A good commit is one you could revert without side effects to unrelated functionality.

### Commit Messages

Write messages that explain **why**, not what. The diff shows what changed; the message should explain the intent.

```
# Good
feat: add rate limiting to webhook endpoints to prevent abuse under load

# Bad
update middleware.py
```

Use conventional commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`) or a consistent prefix convention. The format matters less than consistency -- pick one and enforce it.

### Branch Hygiene

- Always fetch and merge `main` before creating a PR if other PRs may have landed while you worked
- Configure GitHub to auto-delete merged branches -- stale branches are noise
- Never rebase or force-push a branch that others are reviewing
- If a branch diverges significantly from `main`, merge `main` into the branch (not rebase) to preserve review context

### Pre-Commit Hooks

Set up hooks that run linting and formatting before every commit. This prevents CI failures from style issues and ensures every commit in history is clean. Use a framework (e.g., pre-commit, husky, lefthook) to manage hooks declaratively so they're version-controlled and shared.

---

## 3. Planning & Execution

### Milestone-Based Roadmap

Work is organized into **milestones** (e.g., v1.0, v1.1, v1.2). Each milestone contains **phases** -- cohesive units of work that deliver a discrete capability.

```
.planning/
├── PROJECT.md        # Project reference (updated per milestone)
├── ROADMAP.md        # Milestone roadmap with phase progress
├── REQUIREMENTS.md   # Requirement traceability matrix
├── STATE.md          # Current execution state
├── CONTEXT.md        # Product vision document
└── phases/           # Per-phase directories with plans, research, summaries
    └── NN-phase-name/
        ├── NN-RESEARCH.md    # Research findings
        ├── NN-01-PLAN.md     # Execution plan (YAML frontmatter)
        ├── NN-02-PLAN.md     # Additional plans if needed
        └── NN-VALIDATION.md  # Phase completion validation
```

### Spec the Outcome, Not the Process

When delegating work to agents, define **what success looks like**, not how to get there:

1. **Objective in one sentence**: If you can't state the goal in one sentence, you don't understand the problem well enough to build it.
2. **Constraints**: What are the boundaries? (e.g., "must use existing auth middleware," "no new dependencies," "backwards-compatible API")
3. **Success criteria**: How will you verify it worked? (e.g., "these tests pass," "this endpoint returns this shape," "performance stays under 200ms p95")

Don't write implementation plans for the agent to follow mechanically. The agent is better at figuring out the "how" than you are at prescribing it in advance -- and an overly prescriptive plan creates context pollution with implementation details that may not be optimal.

This applies to phase-level planning too: the phase goal and success criteria matter more than the step-by-step task list. The task list is a best guess; the goal is the contract.

### Phase Lifecycle

Each phase follows this sequence:

1. **Research** -- Investigate how to implement the phase. Produces `RESEARCH.md`.
2. **Plan** -- Create detailed execution plans with task breakdown, dependencies, and verification criteria. Plans use YAML frontmatter with `phase`, `plan`, `type`, `wave`, `depends_on` fields.
3. **Execute** -- Implement the plans. Atomic commits per meaningful unit of work. Plans can run in parallel if they have no file conflicts.
4. **Verify** -- Validate the phase achieves its goal, not just that tasks completed.

### Plans & Waves

Plans within a phase are organized into **waves** for parallel execution:
- Wave 1 plans have no dependencies and can all run simultaneously
- Wave 2 plans depend on wave 1 completion
- Wave 3+ plans depend on prior waves

### GSD Workflow Configuration

```json
{
  "mode": "interactive",
  "parallelization": true,
  "commit_docs": true,
  "model_profile": "quality",
  "branching_strategy": "phase",
  "workflow": {
    "research": true,
    "plan_check": true,
    "verifier": true
  },
  "granularity": "fine"
}
```

Key toggles:
- `research`: Run a research agent before planning
- `plan_check`: Verify plans will achieve the phase goal before execution
- `verifier`: Run a verification agent after execution to confirm goal achievement

---

## 4. The Makefile is the Project Interface

The Makefile is the single entry point for all project operations. A developer (or an AI agent) should be able to discover everything the project can do by reading the Makefile.

### Principles

- **One command, one concern**: `make test` runs tests. `make lint` runs linting. `make dev` starts the local environment. No ambiguity.
- **Composable targets**: Higher-level targets compose lower-level ones. `make check` calls `make lint`, `make typecheck`, and `make test`. A developer can run the full gate or any subset.
- **Self-documenting**: Target names should be obvious. If they're not, add a `make help` target that lists available commands with descriptions.
- **Environment-aware**: Targets that require external services (Docker, databases) should be clearly separated from those that don't. `make check` should never require Docker. `make check-all` can.
- **Idempotent**: Running any target twice in a row should produce the same result. `make setup` should be safe to re-run.

### Standard Targets

Every project should have at minimum:

| Target | Purpose |
|--------|---------|
| `make setup` | One-time setup (install deps, configure hooks, seed data) |
| `make dev` | Start the local development environment |
| `make check` | Full quality gate (lint + typecheck + tests) -- no external deps |
| `make check-all` | Full gate + integration tests |
| `make lint` | Linting and formatting checks |
| `make typecheck` | Static type analysis |
| `make test` | Unit tests |
| `make clean` | Remove generated/cached files |

Add domain-specific targets as the project grows (e.g., `make migrate`, `make seed`, `make import-data`).

### Why Not npm scripts / task runners / shell scripts?

Makefiles are universal. They work on every Unix system, they're language-agnostic, they handle dependencies between targets natively, and `make` + tab completion is the fastest way to discover what a project can do. Use the Makefile as the stable interface even if it delegates to language-specific tools underneath.

---

## 5. Testing

### Quality Gate

A single command (`make check` or equivalent) must run the full quality gate:
- **Lint**: Formatting and style checks
- **Type check**: Static type analysis
- **Unit tests**: All tests that don't require external services
- **Integration tests** (optional gate): Tests that require databases or external services

```bash
make check            # Full quality gate: lint + typecheck + tests (no Docker)
make check-all        # Full gate + integration tests (needs Docker)
make lint             # Lint only
make typecheck        # Type check only
make test             # Tests only
make test-quick       # Fast subset for iteration
```

### Test Philosophy

- **Every feature ships with tests.** No PR should add functionality without corresponding test coverage.
- **Tests validate behavior, not implementation.** Test what the code does, not how it does it.
- **Integration tests for boundaries.** Use real databases and services for boundary tests -- mocks can mask real failures.
- **Snapshot/golden file tests** for output stability where determinism matters.
- **Frontend smoke tests** for every page/route to catch import errors and rendering crashes.

### Test Organization

```
tests/
├── conftest.py       # Shared fixtures
├── unit/             # Unit tests (no external deps)
├── fixtures/         # Test data files
└── platform/         # Integration tests (needs running services)
```

### Frontend Testing

- Test runner with framework preset (e.g., Jest + `next/jest.js`, Vitest) and `happy-dom` environment
- Smoke tests for every page component
- Tests consolidated by domain (see [Frontend Test Performance](#frontend-test-performance))
- `make check-frontend` runs lint + typecheck + tests for the frontend

### Frontend Test Performance

Frontend test suites degrade fast. A project with 800+ component tests can easily spend 50+ seconds on test runs -- most of it wasted on per-file environment initialization, not actual assertions. Optimize aggressively:

**1. Use a lightweight DOM environment**

`jsdom` bundles a full Chromium-based DOM implementation. For React component tests that don't need Canvas, WebGL, or browser-specific APIs, switch to `happy-dom` -- a lightweight pure-JavaScript DOM that starts ~2x faster per file.

```ts
// jest.config.ts
testEnvironment: "@happy-dom/jest-environment"   // instead of "jsdom"
```

Caveat: happy-dom doesn't block network calls. Stub `fetch` globally in your setup file:

```ts
// jest.setup.ts
const noopFetch = () => Promise.resolve(new Response("", { status: 200 }));
global.fetch = jest.fn(noopFetch) as typeof global.fetch;
afterEach(() => {
  (global.fetch as jest.Mock).mockImplementation(noopFetch);
});
```

**2. Consolidate test files by domain**

Every test file pays a fixed startup cost: Jest worker allocation, environment initialization, module graph loading, mock setup. With 87 small files, that overhead dominates execution time. Consolidate related tests into larger domain files:

```
# Before: 87 files, ~53s
billing/audit-components.test.tsx    (250 LOC)
billing/condition-chips.test.tsx     (101 LOC)
billing/csv-import.test.tsx          (94 LOC)
billing/rate-editor.test.tsx         (180 LOC)
...17 more billing files

# After: 28 files, ~5s
billing/billing-components.test.tsx  (1,848 LOC)  -- all component tests
billing/billing-audit.test.tsx       (470 LOC)    -- audit-specific tests
```

Structure consolidated files with clear section headers and shared mocks at the top:

```ts
// ===== Mocks =====
const mockApiFetch = jest.fn();
jest.mock("@/lib/api", () => ({ apiFetch: (...args) => mockApiFetch(...args) }));

// ===== billing/fee-schedules =====
describe("FeeSchedulesContent", () => { ... });

// ===== billing/invoice-fees =====
describe("InvoiceFeesContent", () => { ... });
```

Keep files under ~2,000 LOC. The sweet spot is 1 consolidated file per domain directory.

**3. Lazy-load expensive library mocks**

Libraries like Recharts are large but only used by ~10-15% of test files. A naive `jest.mock("recharts", ...)` at the top of a setup file loads the full module in every file. Use a Proxy to defer loading:

```ts
jest.mock("recharts", () => {
  let _real: Record<string, unknown> | null = null;
  const getReal = () => {
    if (!_real) _real = jest.requireActual("recharts");
    return _real;
  };
  return new Proxy(
    {
      __esModule: true,
      ResponsiveContainer: ({ children }) =>
        React.createElement("div", { "data-testid": "responsive-container" }, children),
    },
    {
      get(target, prop) {
        if (prop in target) return target[prop];
        return getReal()[prop as string];
      },
    },
  );
});
```

**4. Use V8 coverage provider**

V8's built-in code coverage is faster than Babel/Istanbul instrumentation. Add to Jest config:

```ts
coverageProvider: "v8"
```

Note: V8 counts functions slightly differently. You may need to adjust function coverage thresholds down by ~5% (e.g., 64% → 59%).

**5. CI-specific optimizations**

```ts
// jest.config.ts
cacheDirectory: "<rootDir>/node_modules/.cache/jest"  // persist SWC transforms
```

In CI workflows:
- Cache `node_modules` keyed by lockfile hash (skip `npm ci` on cache hit)
- Limit workers to match runner cores: `--maxWorkers=2` for GitHub Actions ubuntu-latest
- Disable expensive ESLint rules you're not using (e.g., React Compiler rules add ~10s each)

**Expected impact:** These optimizations together typically yield 5-10x speedup on frontend test suites (e.g., 53s → 5s for 841 tests).

### Tests as Completion Contracts

When working with AI agents, tests serve a second purpose beyond quality assurance: they are the **deterministic definition of "done"** that an agent can verify without human intervention.

The principle is simple:

1. **Write or approve tests before the agent implements.** The tests encode what "correct" means. This can be full TDD or a lighter approach where you sketch the test cases and let the agent fill in assertions -- but you vet them before implementation begins.
2. **The agent's task is not complete until all tests pass.** This is non-negotiable. An agent that says "I'm done" with failing tests is not done.
3. **The agent must not modify the tests.** Tests are the contract. If the agent can change the contract to match its implementation, the contract is worthless. If the tests are genuinely wrong, the agent should report the issue and wait for human decision.

This reframes TDD for the agentic era: tests aren't just a safety net for humans -- they're the only reliable way to give an agent an unambiguous finish line. Without them, agents resort to "looks good to me" self-assessment, which is unreliable due to their inherent bias toward pleasing the user.

**Task contracts**: For complex tasks, create a `{TASK}_CONTRACT.md` that bundles the completion criteria: which tests must pass, what verification must succeed, and any invariants that must hold. The agent's session should not end until the contract is fulfilled. This is especially powerful when combined with stop hooks that prevent the agent from terminating prematurely.

### Adversarial Validation

For critical code (security, financial logic, data integrity), a single agent reviewing its own work is insufficient. Use multiple agents with competing incentives:

1. **Finder agent**: Tasked with finding every possible issue. Biased toward false positives. Incentivize it to be thorough -- "score +1 for low-impact findings, +5 for medium, +10 for critical." It will over-report, and that's the point: this produces the **superset** of all possible issues.
2. **Adversarial agent**: Tasked with disproving the finder's results. Biased toward false negatives, but penalized for incorrectly dismissing real issues. "Score +N for each disproven finding, but -2N if you dismiss a real one." This produces the **subset** of actual issues.
3. **Referee agent**: Evaluates both arguments for each finding and makes a final call. Tell it you have the ground truth and will score its accuracy. This forces careful reasoning rather than rubber-stamping either side.

The pattern exploits a fundamental property of current AI: agents want to succeed at their assigned role. By giving three agents competing roles, their individual biases cancel out and you get high-fidelity results.

This isn't limited to bug-finding. The same pattern works for:
- **Code review**: finder spots issues, adversary argues they're acceptable, referee decides
- **Architecture evaluation**: proposer suggests an approach, critic attacks it, judge weighs trade-offs
- **Test coverage**: one agent writes tests, another tries to find untested paths, a third prioritizes what matters

---

## 6. Documentation

### Living Documents

These documents MUST be updated with every meaningful change:

| Document | Purpose | When to update |
|----------|---------|----------------|
| `CLAUDE.md` | Project guide for AI assistants | New commands, structure changes, key decisions |
| `README.md` | Human-facing project overview | New capabilities, setup changes |
| Docs site | Technical documentation | New endpoints, data models, features |
| API collection | Endpoint testing & documentation | Every API change |

### Documentation Site

Maintain a structured docs site (e.g., MkDocs, Docusaurus) with:
- **API reference**: Every endpoint with parameters, examples, response shapes
- **Data contracts**: Database schemas and data models
- **Domain glossary**: Project-specific terminology
- **Decision log**: Architecture decisions with rationale
- **CLI reference**: All available commands and make targets
- **Product overview & roadmap**: What the product does and where it's going

### API Collection

Every API endpoint MUST have a corresponding file in the API collection tool (e.g., Bruno, Postman) with:
- Correct HTTP method and URL using environment variables
- All query parameters (optional ones clearly marked)
- Required headers
- Documentation block describing the endpoint
- Example request body for write operations

### CI-Enforced Documentation

Add a CI check that fails if API source code changes but API collection files weren't updated. This prevents documentation drift.

---

## 7. Code Quality

### Static Analysis

- **Linting**: Automated formatting and style enforcement (e.g., Ruff, ESLint, Biome)
- **Type checking**: Strict mode for both backend and frontend (e.g., mypy strict, TypeScript strict)
- **Zero tolerance for suppressions**: Don't add `# type: ignore` or `@ts-ignore` without a comment explaining why

### Code Style

- Consistent formatting enforced by tooling, not code review
- Absolute imports only (no relative imports)
- Strict type annotations on all public interfaces

### Frontend Standards

- TypeScript strict mode with `noUncheckedIndexedAccess`
- Zero explicit `any` types
- Component composition: thin page wrappers + content components
- Error boundaries at section level to prevent cascading failures
- URL-synced filter state for shareable links
- Test environment: `happy-dom` over `jsdom` for speed (see [Frontend Test Performance](#frontend-test-performance))
- Test files consolidated by domain (~1 file per directory, shared mocks at top)

---

## 8. Design Principles

### Database Constraints Enforce Business Invariants

If the database can enforce a uniqueness, referential, or consistency rule -- it must. Application-level checks are a convenience; DB constraints are the safety net. Every new table or migration should ask: "What invariants does this data have, and are they enforced at the DB level?"

### Separate by Trust Boundary

Code and configuration must be scoped to the trust level that needs it. The web process should never have access to credentials it doesn't need. CLI admin tools get elevated settings; the web process gets restricted settings.

### Design for Concurrency

Any operation that touches a shared database must handle concurrent execution correctly. Use savepoints for per-item error isolation, DB constraints for conflict detection, and `ON CONFLICT` or integrity error handling for graceful recovery. Never rely on "only one process runs this at a time" -- enforce it or handle the race.

### Security by Default

- `.env` files must never be read by AI tools or committed to git
- CI workflow scans for security boundary violations in every PR
- Settings isolation between web and admin processes
- Never hardcode credentials

### The Ratchet Effect

Quality only moves in one direction. Once a quality gate is introduced, it is never removed.

- Strict type checking enabled? It stays strict. No `# type: ignore` epidemic to "move faster."
- CI check added? It's permanent. A flaky test gets fixed, not skipped.
- Linting rule enabled? It applies to all new code. Existing violations get a one-time baseline, not an exemption.

The temptation to relax standards "just this once" or "temporarily" is constant. Resist it. Every exception becomes precedent, and precedent becomes culture. A project that disables strict types "for this module" will eventually disable them everywhere.

This applies to process too: once PRs require review, they always require review. Once tests are required for new features, they're always required. The ratchet clicks forward, never back.

**Practical implementation**: Use CI to enforce the ratchet. If strict types are on, CI fails on type errors -- there's no human decision to make. If test coverage is required, CI fails without it. Automation removes the temptation to make exceptions.

### Dead Code is Context Pollution

When you build a new way, kill the old way. Immediately.

The codebase is not just source code -- it's the primary context that AI agents read to understand what the system does. Every dead code path, commented-out block, parallel implementation, and zombie feature flag is noise that degrades agent comprehension. An agent that reads two implementations of the same feature will either use the wrong one, try to merge them, or waste context reasoning about which one is current.

This goes beyond the traditional "keep the codebase clean" advice:

- **No parallel implementations**: When you replace a module, delete the old one in the same PR. Don't keep it "just in case" behind a flag.
- **No commented-out code**: If code is valuable, it's in git history. Commented-out blocks signal "maybe this matters" to an agent, which wastes reasoning on something that doesn't.
- **No dead feature flags**: A feature flag that's been 100% on for months is not a flag, it's dead code with extra steps. Remove the flag and the conditional logic.
- **No orphaned files**: Unused utilities, abandoned migrations, leftover test fixtures -- if nothing imports or references them, delete them.

This is a form of context discipline applied to the codebase itself. Every line of code is a potential input to an agent's decision-making. Make sure every line earns its place.

---

## 9. Observability

### Structured Logging

Logs are data, not strings. Every log entry should be a structured object (JSON) with consistent fields that can be queried, filtered, and aggregated by machines.

- Use a structured logging library (e.g., structlog, pino, serilog) -- never raw `print()` or `console.log()` in production code
- Every log entry should include: timestamp, level, message, and a correlation/request ID
- Log **events**, not narratives: `{"event": "payment_mapped", "provider": "stripe", "duration_ms": 42}` not `"Finished mapping payment from Stripe in 42ms"`

### Correlation IDs

Every inbound request gets a unique correlation ID. This ID propagates through all log entries, downstream service calls, and error reports for that request. When something goes wrong, you can trace the full lifecycle of a request across services and log lines using a single ID.

### Health Endpoints

Every service exposes a health endpoint that reports:
- **Liveness**: The process is running and can accept requests
- **Readiness**: The process can serve traffic (database connected, dependencies available)

These endpoints are the foundation for load balancer checks, orchestrator probes, and monitoring dashboards.

### Metrics and Alerting

Define key metrics from day one, even if you only log them initially:
- Request latency (p50, p95, p99)
- Error rate by endpoint
- Queue depth (if applicable)
- Database connection pool utilization

You don't need a metrics platform on day one, but you need the instrumentation. Adding metrics retroactively to a mature codebase is painful; adding a metrics backend to well-instrumented code is trivial.

---

## 10. Environment & Secrets Management

### Configuration Hierarchy

Application configuration should follow a clear precedence order:

1. **Defaults in code** -- sensible defaults for development
2. **Config files** -- checked into version control, environment-specific (e.g., `config/production.yaml`)
3. **Environment variables** -- override config files, set by deployment infrastructure
4. **Secrets manager** -- credentials, API keys, tokens (never in files or env vars in production)

### Separation of Concerns

- **Settings classes/schemas** validate configuration at startup. If a required value is missing or malformed, the process fails fast with a clear error -- not at runtime when the value is first accessed.
- **Web processes** get minimal configuration scoped to their trust level. They should never have access to admin credentials, migration tools, or raw database owner connections.
- **CLI/admin tools** get elevated configuration. The separation should be enforced by different settings classes, not by convention.

### Secrets Discipline

- `.env` files are for **local development only** and must be in `.gitignore`
- AI tools must be explicitly blocked from reading `.env` files (via deny rules)
- Never log secrets, even at debug level
- Rotate credentials if they appear in any commit, even if the commit was reverted
- Use environment-specific secrets management (e.g., AWS Secrets Manager, Vault, 1Password) in staging and production

### Environment Parity

Local development should mirror production as closely as possible. Use Docker Compose (or equivalent) to run the same database engine, the same message queue, the same cache layer. "Works on my machine" is eliminated when your machine runs the same infrastructure as production.

---

## 11. Database Migration Strategy

### Migrations are Code

Database migrations are first-class artifacts, version-controlled alongside application code. Every schema change goes through the same review process as code: branch, PR, review, merge.

### Principles

- **Forward-only by default**: Prefer writing forward migrations. Downgrade migrations are optional but should be considered for production systems where rollback is a real scenario.
- **One concern per migration**: A migration that adds a table and modifies an unrelated index is two migrations. Small migrations are easier to review, debug, and roll back.
- **Additive first**: When possible, make schema changes additive (add column, add table) before making breaking changes (drop column, rename). This supports zero-downtime deployments where old and new code run simultaneously.
- **Data migrations separate from schema migrations**: If a schema change requires backfilling data, do it in a separate migration or script. Schema DDL and data DML have different failure modes and rollback characteristics.

### Naming and Organization

Use sequential numbering or timestamps. The convention matters less than consistency. Migrations should have descriptive names: `003_add_payment_status_index.py` not `003_update.py`.

### Squashing

Periodically squash migrations for mature, stable tables. A new developer shouldn't need to replay 200 migrations to set up a local database. Keep the full history in git; squash the migration files.

### Safety Checks

- Every migration should be tested against a database with realistic data volume before merging
- CI should run migrations against a clean database to verify they apply cleanly
- Never modify a migration that has already been applied to a shared environment -- write a new one

---

## 12. Dependency Management

### Add Dependencies Deliberately

Every dependency is a liability: maintenance burden, security surface, upgrade obligation. Before adding a dependency, ask:

1. **Is the problem complex enough to justify a dependency?** Don't add a library for something the standard library handles.
2. **Is the dependency well-maintained?** Check commit recency, open issue count, bus factor.
3. **What's the blast radius if it breaks or is abandoned?** Prefer dependencies that can be replaced without rewriting your architecture.

### Lock Files are Non-Negotiable

Lock files (`package-lock.json`, `poetry.lock`, `uv.lock`, `Cargo.lock`) must be committed. They ensure every developer, CI runner, and deployment gets exactly the same dependency tree. Running without a lock file is running untested code.

### Version Pinning Strategy

- **Direct dependencies**: Pin to a specific version or a compatible range (e.g., `~=1.4`, `^2.0`). Never use unbounded ranges.
- **Transitive dependencies**: Managed by the lock file. Don't pin them manually unless resolving a conflict.

### Security Auditing

Run dependency security audits as part of CI (e.g., `npm audit`, `pip-audit`, `cargo audit`). Known vulnerabilities in dependencies should fail the build. Set up automated tools (e.g., Dependabot, Renovate) to propose dependency updates as PRs.

### Upgrades are Maintenance, Not Features

Schedule periodic dependency upgrades. Don't let dependencies fall so far behind that upgrading becomes a project. Weekly automated PRs from Dependabot/Renovate, reviewed and merged as part of regular maintenance, prevent this drift.

---

## 13. Demo-Readiness

The ability to spin up a fully populated, realistic environment with a single command is not a nice-to-have -- it's a first-class project concern.

### Why It Matters

- **Selling the product**: A stakeholder or investor asks to see the product. You need a convincing demo in minutes, not hours of manual data setup.
- **Onboarding**: A new team member (human or AI) should be able to `make demo` and have a working environment with realistic data to explore, not an empty shell.
- **Full-stack verification**: Integration tests catch bugs at boundaries, but only a populated environment reveals whether the full user experience works end-to-end.
- **Development quality**: Working against realistic data surfaces edge cases that unit tests with trivial fixtures miss -- long names, unicode, missing fields, large volumes, date edge cases.

### Principles

- **One command**: `make demo` (or `make seed`, `make setup-demo`) should do everything: start services, run migrations, seed reference data, populate realistic demo data. No manual steps, no copy-pasting SQL, no "first you need to..."
- **Deterministic data**: Use seeded random generation so the same demo produces the same data every time. This makes screenshots reproducible, bugs reproducible, and golden-file tests possible.
- **Realistic volume and variety**: Demo data should mirror production characteristics -- multiple entities, edge cases, different states, enough volume to fill charts and tables meaningfully. A demo with 3 records is useless.
- **Idempotent**: Running `make demo` twice should produce the same result. Seed scripts should handle existing data gracefully (upsert or clean-and-rebuild).
- **Documented scenarios**: If the demo data contains planted scenarios (e.g., a failed payment, a disputed transaction, a rate spike), document what they are and where to find them. A demo walkthrough script is even better.

### The Seed Pipeline

Structure data seeding as a pipeline of composable steps:

```bash
make demo              # Full pipeline: services + migrations + seed + demo data
make seed              # Reference data only (countries, currencies, categories)
make seed-demo         # Demo transactional data (requires reference data)
make reset-demo        # Tear down and rebuild demo data from scratch
```

Each step should be independently runnable. A developer fixing a migration doesn't need to re-seed 100K demo records.

---

## 14. Agent-Ready API Design

The API is designed to be consumed not only by human-facing frontends but also by AI agents (e.g., Claude Code via MCP). Every endpoint should be usable by an agent that has no prior knowledge of the system beyond the API schema.

### Principles

- **Self-describing schemas**: All endpoints use typed response models (e.g., Pydantic `response_model=`) that generate accurate OpenAPI specs. The OpenAPI schema is the contract -- if an agent can read the schema, it can use the API.
- **Predictable conventions**: Consistent patterns across the entire API surface -- same pagination style, same filter parameter names, same error response shape. An agent that learns one endpoint can generalize to all others.
- **Flat, explicit parameters**: Prefer query parameters and flat JSON bodies over deeply nested structures. Agents parse flat key-value pairs more reliably than nested objects.
- **Meaningful names**: Endpoint paths, parameter names, and field names should be self-explanatory. Avoid abbreviations that require domain knowledge (e.g., `payment_status` not `pmt_sts`).
- **Rich error responses**: Return structured errors with a `code`, `message`, and `details` field. An agent needs to programmatically understand what went wrong, not parse a human-readable string.
- **Enum documentation**: All enum/categorical fields should have their allowed values documented in the schema (via `Literal` types, `Enum` classes, or OpenAPI `enum` constraints). An agent should never have to guess valid values.

### MCP-Readiness Checklist

Design every endpoint as if it will become an MCP tool:

1. **Tool name derivable from path**: `GET /v1/payments` becomes a tool like `list_payments`. Use RESTful, verb-free paths.
2. **Descriptions at every level**: Endpoint docstrings, parameter descriptions, and field descriptions all populate the MCP tool schema. Write them for an agent, not a human -- be precise, not conversational.
3. **Bounded responses**: Always support pagination with sensible defaults. An agent calling `list_payments` without params should get a useful (not overwhelming) response.
4. **Filterable and composable**: Expose the same filter parameters the frontend uses. An agent should be able to answer "show me failed payments from Stripe last week" with a single API call, not client-side filtering.
5. **Idempotent writes**: POST/PUT operations should be idempotent where possible (via idempotency keys or natural deduplication). An agent that retries a failed call should not create duplicates.
6. **No session state**: Every request is self-contained. Auth via header token, tenant via header, filters via query params. No cookies, no multi-step wizards.
7. **OpenAPI snapshot in CI**: Maintain a committed OpenAPI snapshot (e.g., `tests/snapshots/openapi.json`) and a CI check that detects schema drift. This ensures the schema an agent relies on matches the actual implementation.

### The Agent is Not a Trusted Operator

Agents hallucinate. Treat every agent-originated input with the same suspicion as user input from a public web form. This is not hypothetical -- agents routinely:

- **Hallucinate file paths**: Generate traversals like `../../.ssh/id_rsa` by confusing path segments
- **Inject query params in IDs**: Send `resourceId?fields=name` as a resource identifier
- **Double-encode URLs**: Pass pre-encoded strings that get encoded again at the HTTP layer
- **Invent enum values**: Use plausible but nonexistent values for categorical fields
- **Confuse similar endpoints**: Call the delete endpoint when they meant the archive endpoint

Validate all agent inputs the same way you'd validate public API inputs:
- Reject control characters (anything below ASCII 0x20)
- Canonicalize and sandbox file paths to prevent traversal
- Reject `?`, `#`, and `%` in resource identifiers
- Validate enum values against the actual allowed set
- Return clear, structured errors when validation fails so the agent can self-correct

### Non-Destructive by Default

APIs consumed by agents should be safe to explore. An agent learning your API by trial and error should not be able to cause irreversible damage.

- **Dry-run for mutations**: Support a `dry_run` parameter (or a `--dry-run` flag for CLIs) on all write/delete operations. The endpoint validates the request, computes what would change, and returns the projected result -- without executing it. This lets agents preview outcomes before committing.
- **Writes as candidates**: Where possible, design write operations as proposals that require confirmation. Create a draft, return it for review, then confirm to apply. This is especially important for MCP tools where an agent may act autonomously.
- **Soft deletes over hard deletes**: Prefer marking records as deleted over physically removing them. An agent that accidentally deletes the wrong resource shouldn't cause permanent data loss.
- **Confirmation for destructive actions**: Endpoints that delete, truncate, or overwrite should require an explicit confirmation parameter (e.g., `confirm=true`). An agent that omits it gets a 400 with a clear message, not a silent deletion.

### Self-Documenting at Runtime

Beyond static OpenAPI specs, APIs should be queryable at runtime so agents can discover capabilities without loading external documentation into their context:

- **Help endpoint**: A `GET /api/help` or `GET /v1/docs` that returns a machine-readable summary of all available endpoints, their parameters, and their purpose. Cheaper than embedding full docs in the agent's system prompt.
- **Schema introspection**: A `GET /v1/schema/{resource}` that returns the full schema for a resource type -- fields, types, constraints, enum values, relationships. An agent can self-serve the exact information it needs for the current task.
- **Field masks**: Support a `fields` parameter that limits which fields are returned. An agent listing payments doesn't need every field -- let it request only `id, status, amount` to conserve context window space.
- **Describe mode**: For complex operations, support a `describe=true` parameter that returns what the operation would do, what parameters it accepts, and what constraints apply -- without executing anything.

### Response Design for Agents

```
# Good: flat, typed, self-describing
{
  "items": [...],
  "total": 142,
  "page": 1,
  "page_size": 20,
  "filters_applied": {"status": "failed", "provider": "stripe"}
}

# Bad: nested, ambiguous, requires prior knowledge
{
  "data": [...],
  "meta": {}
}
```

### Practical Impact

When an endpoint is well-designed for agents:
- It can be exposed as an MCP tool with zero wrapper code
- The OpenAPI spec alone is sufficient documentation
- Claude Code can discover, understand, and call it without human guidance
- Multiple agents can compose API calls to answer complex queries
- An agent exploring the API by trial and error can't cause irreversible damage

**Test with an agent**: Periodically ask Claude Code to perform a task using only the API (not the frontend). If it struggles, the API ergonomics need work.

---

## 15. CI/CD

### Required Workflows

| Workflow | Purpose |
|----------|---------|
| PR Conventions | Enforce branch naming (`prefix-NN/`) and PR title (`PREFIX-NN:`) patterns |
| Security Boundaries | Scan for credential leaks, .env reads, trust boundary violations |
| Quality Gate | Run lint + typecheck + tests on every PR |
| Docs Check | Fail if API code changed but docs/collection not updated |

### Pre-Push Checklist

Before pushing a branch, verify locally:
1. `make check` passes (lint + typecheck + tests)
2. `make check-frontend` passes (if frontend changes)
3. API collection is updated (if API changes)
4. Documentation is updated (if user-facing changes)

---

## 16. Definition of Done

Every phase/feature MUST complete ALL of these before being considered done:

1. **Feature branch + PR**: All work on a branch, pushed, PR created -- never commit to main
2. **Issue tracker**: Update all relevant issues with commit references, mark as done
3. **PR links issues**: PR body must include `Closes <PREFIX>-NN` for all relevant issues
4. **CLAUDE.md updated**: Reflect new project state, commands, structure changes
5. **README.md updated**: Reflect new capabilities and project progress
6. **Documentation site updated**: Every new/changed endpoint, feature, data model, or command
7. **API collection updated**: Every API endpoint has a corresponding collection file
8. **CI pre-check**: Verify changes won't fail CI before pushing
9. **Tests written**: New functionality has corresponding test coverage
10. **Task contract fulfilled**: If a `{TASK}_CONTRACT.md` exists, all specified tests pass, verification checks succeed, and invariants hold. The agent must not self-certify completion -- the contract is the authority

---

## 17. Claude Code Configuration

### Project Structure for Claude

```
.claude/
├── rules/                # Domain-specific rules (auto-loaded by file path)
│   ├── api.md            # API routes, schemas, middleware
│   ├── db.md             # ORM models, migrations
│   ├── docs.md           # Documentation site, API collection
│   ├── frontend.md       # Frontend framework conventions
│   ├── infra.md          # Build, Docker, CI, config
│   ├── planning.md       # Roadmap, phases, GSD workflow
│   ├── principles.md     # Design principles
│   └── testing.md        # Test conventions, fixtures
└── settings.local.json   # Deny rules for sensitive files
```

### Rules Files

Each `.claude/rules/*.md` file has a `paths:` frontmatter that controls when it loads:

```yaml
---
paths:
  - "src/api/**"
  - "src/schemas/**"
---
```

This keeps context lean -- Claude only loads rules relevant to the files being touched.

### Recommended Rule Categories

| Rule File | Scope |
|-----------|-------|
| `principles.md` | Design principles that apply to all backend code |
| `api.md` | API route patterns, response models, middleware conventions |
| `db.md` | ORM models, migrations, constraint conventions |
| `frontend.md` | Component patterns, data fetching, state management |
| `testing.md` | Test conventions, fixture patterns, quality gate commands |
| `docs.md` | Documentation site structure, API collection format |
| `infra.md` | Build config, Docker, CI workflows, environment setup |
| `planning.md` | Roadmap structure, phase lifecycle, GSD workflow |

Add domain-specific rule files as the project grows (e.g., `auth.md`, `billing.md`, `notifications.md`).

### Security Settings

In `.claude/settings.local.json`, deny access to sensitive files:

```json
{
  "permissions": {
    "deny": [
      "Read(**/.env*)",
      "Read(.env*)"
    ]
  }
}
```

---

## 18. Collaborating with AI

This methodology treats AI tools (Claude Code, Cursor, Copilot) as first-class development partners, not autocomplete. The effectiveness of AI collaboration scales with the quality of context you provide.

### Context Discipline

The single most important principle of working with AI agents: **give them exactly the information they need for the current task and nothing more.**

Context bloat -- accumulated memories, irrelevant rules, leftover instructions from previous sessions -- degrades agent performance. An agent that has to read 14 markdown files before writing a function is an agent with too much noise. The agent's context window is a precious resource; treat it like memory in an embedded system, not like disk space on a cloud server.

Practical implications:
- **CLAUDE.md should be a routing table**, not an encyclopedia. Keep it lean. Use it to point to rules and skills, not to contain all knowledge inline.
- **Rules load by file path**, so an agent editing frontend code never sees database migration conventions. Use this scoping aggressively.
- **One session per unit of work.** Long-running sessions (24+ hours) accumulate context from unrelated tasks. A fresh session per task contract is almost always better than a marathon session.
- **After context compaction**, the agent loses detail. Add a rule that instructs the agent to re-read its task plan and the relevant source files before continuing after any compaction event.

### Context Architecture

Structure project knowledge in layers, from most general to most specific:

| Layer | File | Loaded | Purpose |
|-------|------|--------|---------|
| Global | `~/.claude/CLAUDE.md` | Always | User preferences, tooling, cross-project conventions |
| Project | `CLAUDE.md` | Always | Project description, setup, commands, key decisions |
| Domain | `.claude/rules/*.md` | By file path | Deep context for specific subsystems |
| Memory | `.claude/memory/` | On recall | Learned preferences, feedback, project state |

### CLAUDE.md as Conditional Directory

The root `CLAUDE.md` is the most important file in the project for AI collaboration. It should be structured as a **logical routing table** -- an IF-ELSE directory of where to find context given a scenario:

1. **What is this project?** One paragraph, no jargon.
2. **How do I set it up?** Copy-paste commands.
3. **How do I run things?** All make targets / scripts.
4. **What are the conventions?** Code style, naming, file organization.
5. **What are the key decisions?** Architectural choices with rationale.
6. **What should I never do?** Guardrails and security constraints.
7. **Where to find more context?** Conditional pointers: "If you're working on API routes, read `.claude/rules/api.md`. If tests are failing, read `.claude/rules/testing.md`."

Update `CLAUDE.md` with every meaningful change. A stale `CLAUDE.md` is worse than none -- it teaches the AI wrong patterns.

### Domain Rules for Deep Context

As the project grows, move domain-specific knowledge from `CLAUDE.md` into `.claude/rules/*.md` files scoped by file path. This prevents the root guide from becoming a monolith and ensures Claude only loads context relevant to the current task.

A good rule file includes:
- **Structure tree**: What files exist in this domain and what they do
- **Conventions**: Patterns to follow, anti-patterns to avoid
- **Cross-references**: Pointers to related rule files

### Neutral Prompting

AI agents are designed to please. They will follow instructions even when the instructions bias them toward a wrong outcome. If you say "find me a bug in this module," the agent will find one -- even if it has to invent it. This is not a flaw; it's a design characteristic called sycophancy.

Work with this, not against it:

- **Use neutral prompts for investigation**: "Analyze the logic of this module and report all findings" instead of "Find the bug in this module." A neutral prompt surfaces real issues without biasing the agent toward manufacturing them.
- **Use biased prompts for directed work**: "Implement JWT authentication with bcrypt-12 hashing and 7-day refresh token rotation" is better than "Build an auth system." Precision eliminates the research/decision phase and keeps context clean.
- **Never ask leading questions about correctness**: "Is this implementation correct?" will almost always get "yes." Instead: "Walk through this implementation step by step, state what each part does, and flag anything that seems inconsistent."

### Teaching Through Feedback

When Claude does something wrong, correct it explicitly and explain why. When it does something right that wasn't obvious, confirm it. Both corrections and confirmations become memory that shapes future behavior.

Think of it as training a very capable junior developer -- clear feedback compounds into reliable performance. But remember: rules and skills accumulate over time and can start to contradict each other. **Periodically review and consolidate** your rules, removing contradictions and pruning stale instructions. If the agent needs to read too many files before starting, it's time for a cleanup.

### What to Delegate vs. What to Direct

- **Delegate**: Research, boilerplate, test generation, documentation updates, refactoring within established patterns
- **Direct**: Architecture decisions, new patterns, security-sensitive code, anything with non-obvious business logic
- **Separate research from implementation**: If you don't know the exact approach, create a research task first. Let the agent (or yourself) decide on the approach. Then start a fresh session with clean context to implement the chosen solution. Mixing research and implementation pollutes context with discarded alternatives.

The more structured your project (clear conventions, good rules, strong types), the more you can safely delegate. A well-configured project with strict linting and comprehensive tests can let AI work with high autonomy because the guardrails catch mistakes automatically.

---

## 19. Key Decisions Log

Maintain a "Key Decisions" section in CLAUDE.md that captures important architectural choices and their rationale. This serves as quick context for anyone (human or AI) working on the project.

Format:
```markdown
## Key Decisions

- **Decision name:** Brief description of what was decided and why
- **Another decision:** Context and rationale
```

Update this section whenever a non-obvious architectural choice is made. The goal is to prevent future contributors from re-debating settled decisions or accidentally violating design constraints.

---

## 20. Project Initialization Checklist

Not every project needs all 20 sections from day one. A 500-line prototype doesn't need adversarial validation or a documentation site. Start with the essentials and add process as the project grows. The ratchet effect applies here too: once you add something, keep it.

### Day 1 -- The Foundation

These are non-negotiable for any project, regardless of size:

1. [ ] Initialize git repo with `main` branch
2. [ ] Write `CLAUDE.md` with project description, setup commands, code style
3. [ ] Write `README.md` with human-facing overview
4. [ ] Set up `Makefile` with `setup`, `dev`, `check`, `lint`, `typecheck`, `test` targets
5. [ ] Configure linter and type checker in strict mode
6. [ ] Create `.claude/settings.local.json` with deny rules for `.env`
7. [ ] Create project in issue tracker (Linear, GitHub Issues) and link to repo
8. [ ] Configure GitHub to auto-delete merged branches
9. [ ] Set up pre-commit hooks for lint and format

At this point you can write code, run tests, and follow the change workflow (issue → branch → PR → review).

### First Feature -- Add Quality Gates

When you ship the first real feature:

10. [ ] Set up CI workflow: quality gate (lint + typecheck + tests on every PR)
11. [ ] Set up CI workflow: PR conventions (branch naming, PR title format)
12. [ ] Configure structured logging with correlation IDs
13. [ ] Add health endpoints (liveness + readiness)

### Growing Up -- Add Structure

When the project has multiple domains, multiple contributors, or its first API:

14. [ ] Create `.claude/rules/` directory with domain-scoped rule files
15. [ ] Initialize `.planning/` directory with `PROJECT.md`, `ROADMAP.md`, `CONTEXT.md`
16. [ ] Set up API collection tool (Bruno/Postman)
17. [ ] Set up CI workflow: security boundaries scan
18. [ ] Set up CI workflow: docs check (fail if API changed but collection not updated)
19. [ ] Set up dependency security auditing in CI (Dependabot/Renovate)

### Scaling -- Add Polish

When the project has real users, stakeholders, or a team:

20. [ ] Set up documentation site scaffold (MkDocs, Docusaurus)
21. [ ] Build seed/demo pipeline (`make demo`)
22. [ ] Set up adversarial validation for critical code paths
23. [ ] Create task contract templates for complex features
24. [ ] Schedule periodic dependency upgrade reviews
25. [ ] Schedule periodic rules/skills cleanup sessions

---

## Summary

The core philosophy is: **traceability, automation, and living documentation.**

- Every change traces back to an issue, through a branch, into a reviewed PR
- Quality gates are automated and enforced by CI, not by discipline -- and they never go away (the ratchet effect)
- Dead code is context pollution -- when you build a new way, kill the old way immediately
- Documentation is a deliverable, not an afterthought -- it ships with the code
- The Makefile is the universal interface -- one entry point for all operations
- Spec the outcome, not the process -- define objectives and success criteria, let the agent figure out the how
- Tests are completion contracts -- an agent's task isn't done until they pass, and the agent can't modify them
- Frontend test performance is a maintenance concern -- consolidate files, use lightweight DOM, lazy-load mocks (5-10x speedup)
- Adversarial validation catches what self-review misses -- competing agents with opposing incentives produce high-fidelity results
- Demo-readiness is a first-class concern -- `make demo` should produce a realistic, populated environment in minutes
- The agent is not a trusted operator -- validate inputs, support dry-run, design for non-destructive exploration
- APIs should be self-documenting at runtime -- agents discover capabilities by querying the API, not reading external docs
- Observability is built in from day one, not bolted on after the first outage
- Dependencies are liabilities -- add them deliberately, keep them current
- Migrations are code -- reviewed, tested, and versioned like everything else
- Configuration follows trust boundaries -- web processes get minimal access
- AI tools are first-class development partners -- give them exactly the context they need and nothing more
- Planning is explicit: research, plan, execute, verify -- with artifacts at each stage
- Start lean, add process as the project grows -- not every project needs 20 sections from day one

---

## Changelog

### v1.1.0 (2026-03-24)

- **Added**: Frontend Test Performance subsection (happy-dom, file consolidation, lazy Proxy mocks, V8 coverage, CI optimizations)
- **Updated**: Frontend Standards and Frontend Testing bullets to reference new testing patterns
- **Updated**: Summary with frontend test performance lesson
- **Added**: Version header, canonical copy reference, and this changelog
- Distilled from Axin v1.4 milestone (AXN-172, AXN-173 by Martijn)

### v1.0.0 (2026-03-21)

- Initial release: 20 sections covering process, engineering, architecture, agent-first design, and meta
- Distilled from Axin v1.0-v1.3 (29 phases, 4 milestones, 1,940+ tests)
