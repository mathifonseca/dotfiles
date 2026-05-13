# Software Development Lifecycle Guide

**Version:** 1.2.0

This document defines the development methodology for this project. It is designed to work with Claude Code and the GSD (Get Shit Done) workflow, but the principles apply regardless of tooling.

Distilled from building a production platform (34 phases, 5 milestones, 2,793+ tests) using AI-first development with Claude Code, and from Simon Willison's Agentic Engineering Patterns guide.

Canonical copy lives at `~/.claude/sdlc.md` (via dotfiles). Projects reference it by version in their `CLAUDE.md`.

## Table of Contents

**Process**
1. [Change Workflow](#1-change-workflow-mandatory) -- Issue first, feature branches, PRs, naming conventions
2. [Git Hygiene & Commit Discipline](#2-git-hygiene--commit-discipline) -- Atomic commits, messages, branch hygiene, hooks, agentic git
3. [Planning & Execution](#3-planning--execution) -- Milestones, phases, spec the outcome, compound engineering

**Engineering**
4. [The Makefile is the Project Interface](#4-the-makefile-is-the-project-interface) -- Single entry point for all operations
5. [Testing](#5-testing) -- Quality gates, red/green TDD, completion contracts, adversarial validation
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
18. [Collaborating with AI](#18-collaborating-with-ai) -- Context discipline, session protocols, prompting, feedback, delegation

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

Frontier models have good taste in commit messages. You can delegate commit message writing to your agent -- just review the result before committing.

### Git History is an Authored Story

Don't think of the git commit history as a permanent record of what actually happened. Think of it as a **deliberately authored story** that describes the progression of the software project -- a tool to aid future development, both for humans and for agents starting fresh sessions.

Coding agents can help curate this story. They can combine messy commits into clean ones, rewrite unclear messages, and extract library code into a new repo while preserving relevant history. Use this power deliberately: a clean, readable history is context that future agents (and humans) can consume efficiently.

### Branch Hygiene

- Always fetch and merge `main` before creating a PR if other PRs may have landed while you worked
- Configure GitHub to auto-delete merged branches -- stale branches are noise
- Never rebase or force-push a branch that others are reviewing
- If a branch diverges significantly from `main`, merge `main` into the branch (not rebase) to preserve review context

### Pre-Commit Hooks

Set up hooks that run linting and formatting before every commit. This prevents CI failures from style issues and ensures every commit in history is clean. Use a framework (e.g., pre-commit, husky, lefthook) to manage hooks declaratively so they're version-controlled and shared.

### Agentic Git Prompts

Coding agents are fluent in all of Git. You don't need to memorize commands -- staying aware of what's possible lets you take advantage of Git's full capabilities. Useful patterns:

- **Session starter**: `"Review changes made today"` or `"Review last three commits"` -- agent runs `git log` and instantly loads your recent context before you start typing. Seed every resumed session this way.
- **Mess recovery**: `"Sort out this git mess for me"` -- agents can navigate Byzantine merge conflicts, reason through intent, and ensure tests pass. What used to be a painful hour is now a prompt.
- **Bisect**: `"Use git bisect to find when this bug was introduced: [description]"` -- agents handle the boilerplate, upgrading bisect from occasional to routine. Describe the bug; let the agent run the binary search.
- **History curation**: `"Combine last three commits with a better commit message"`, `"Remove [file] from that last commit"`, `"Undo last commit"` -- surgical history editing without memorizing `reset --soft HEAD~1`.
- **Library extraction**: `"Start a new repo at /tmp/[name] and build a library with [file] from here -- build a similar commit history preserving author and commit dates"` -- previously too involved; now a prompt.

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

### Compound Engineering

Document successful implementation patterns from completed phases so future agents can reuse them. After completing a non-trivial feature, add a brief note to the relevant rules file (`CLAUDE.md` or `.claude/rules/`) describing the pattern and linking to the implementation.

"Small improvements compound." Every documented pattern is future leverage: an agent that can reference a working example of how you've solved a similar problem before will produce better results than one reasoning from scratch.

This is also why dead code is context pollution (§8): every zombie implementation degrades the signal of your documented patterns.

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

### Red/Green TDD with Agents

**Use red/green TDD** is a four-word prompt that frontier models understand as a complete methodology. It's particularly powerful with coding agents because agents face two specific failure modes that test-first development prevents:

1. **Non-functional code**: The agent produces code that looks correct but doesn't actually work.
2. **Unnecessary implementations**: The agent builds more than was asked, passing tests by chance or by writing tests that don't actually constrain the behavior.

The methodology:

1. **Write tests first** -- before any implementation exists. Tests encode what "correct" means.
2. **Confirm they fail (the red phase)** -- this step is non-negotiable and commonly skipped. An agent that writes tests and immediately runs them green has either written tests that are too shallow, tests that test the wrong thing, or tests that pass trivially. The red phase proves the tests actually constrain the implementation.
3. **Implement until tests pass (the green phase)** -- the agent's task is to make the red tests green, nothing more.

**Never assume that code generated by an LLM works until that code has been executed.** Code that has never been run is pure luck if it works in production. The agent must execute the code as part of completing the task -- not just generate it.

### First Run the Tests

Any time you start a new agent session against an existing codebase, begin with:

```
First run the tests
```

This four-word prompt serves three purposes:
1. **Tells the agent a test suite exists** -- making it almost certain the agent will run tests again after making changes.
2. **Reveals project size and complexity** -- the test count is a proxy for codebase scale, and reading the tests is how agents learn the codebase fastest.
3. **Sets a testing mindset** -- an agent that has run the tests once is biased toward expanding them.

If tests are already configured: `Run "make test"` or `Run "uv run pytest"` is equally effective. The important thing is it happens before any other work.

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
...

# After: 28 files, ~5s
billing/billing-components.test.tsx  (1,848 LOC)
billing/billing-audit.test.tsx       (470 LOC)
```

Keep files under ~2,000 LOC. The sweet spot is 1 consolidated file per domain directory.

**3. Lazy-load expensive library mocks**

Libraries like Recharts are large but only used by ~10-15% of test files. Use a Proxy to defer loading:

```ts
jest.mock("recharts", () => {
  let _real: Record<string, unknown> | null = null;
  const getReal = () => {
    if (!_real) _real = jest.requireActual("recharts");
    return _real;
  };
  return new Proxy(
    { __esModule: true, ResponsiveContainer: ({ children }) =>
        React.createElement("div", { "data-testid": "responsive-container" }, children) },
    { get(target, prop) { if (prop in target) return target[prop]; return getReal()[prop as string]; } }
  );
});
```

**4. Use V8 coverage provider**

```ts
coverageProvider: "v8"
```

**5. CI-specific optimizations**

```ts
cacheDirectory: "<rootDir>/node_modules/.cache/jest"
```

- Cache `node_modules` keyed by lockfile hash
- Limit workers to match runner cores: `--maxWorkers=2` for GitHub Actions
- Disable expensive ESLint rules you're not using

**Expected impact:** 5-10x speedup (e.g., 53s → 5s for 841 tests).

### Tests as Completion Contracts

When working with AI agents, tests serve a second purpose beyond quality assurance: they are the **deterministic definition of "done"** that an agent can verify without human intervention.

1. **Write or approve tests before the agent implements.** The tests encode what "correct" means.
2. **The agent's task is not complete until all tests pass.** Non-negotiable.
3. **The agent must not modify the tests.** Tests are the contract. If the agent can change the contract to match its implementation, the contract is worthless.

**Task contracts**: For complex tasks, create a `{TASK}_CONTRACT.md` that bundles the completion criteria: which tests must pass, what verification must succeed, and any invariants that must hold.

### Adversarial Validation

For critical code (security, financial logic, data integrity), use multiple agents with competing incentives:

1. **Finder agent**: Biased toward finding every possible issue. Incentivize thoroughness.
2. **Adversarial agent**: Biased toward disproving the finder's results. Penalized for incorrectly dismissing real issues.
3. **Referee agent**: Evaluates both arguments and makes a final call.

The pattern exploits a fundamental property of current AI: agents want to succeed at their assigned role. Competing roles cancel out individual biases.

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

Every API endpoint MUST have a corresponding file in the API collection tool (e.g., Bruno, Postman) with correct HTTP method/URL, all parameters, required headers, a documentation block, and example request body.

### CI-Enforced Documentation

Add a CI check that fails if API source code changes but API collection files weren't updated.

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
- Test environment: `happy-dom` over `jsdom` for speed
- Test files consolidated by domain (~1 file per directory, shared mocks at top)

---

## 8. Design Principles

### Database Constraints Enforce Business Invariants

If the database can enforce a uniqueness, referential, or consistency rule -- it must. Application-level checks are a convenience; DB constraints are the safety net.

### Separate by Trust Boundary

Code and configuration must be scoped to the trust level that needs it. The web process should never have access to credentials it doesn't need.

### Design for Concurrency

Any operation that touches a shared database must handle concurrent execution correctly. Use savepoints for per-item error isolation, DB constraints for conflict detection, and `ON CONFLICT` or integrity error handling for graceful recovery.

### Security by Default

- `.env` files must never be read by AI tools or committed to git
- CI workflow scans for security boundary violations in every PR
- Settings isolation between web and admin processes
- Never hardcode credentials

### The Ratchet Effect

Quality only moves in one direction. Once a quality gate is introduced, it is never removed.

- Strict type checking enabled? It stays strict.
- CI check added? It's permanent. A flaky test gets fixed, not skipped.
- Linting rule enabled? It applies to all new code.

The temptation to relax standards "just this once" is constant. Every exception becomes precedent, and precedent becomes culture. Use CI to enforce the ratchet -- automation removes the temptation to make exceptions.

### Dead Code is Context Pollution

When you build a new way, kill the old way. Immediately.

The codebase is the primary context that AI agents read to understand what the system does. Every dead code path, commented-out block, parallel implementation, and zombie feature flag degrades agent comprehension. An agent that reads two implementations of the same feature will either use the wrong one or waste context reasoning about which one is current.

- **No parallel implementations**: Delete the old one in the same PR.
- **No commented-out code**: If it's valuable, it's in git history.
- **No dead feature flags**: A flag that's been 100% on for months is dead code with extra steps.
- **No orphaned files**: If nothing imports it, delete it.

### The Best Software for an Agent is Whatever is Best for a Programmer

Frontier AI models were optimized for coding tasks. Their ergonomics -- clean interfaces, well-named functions, explicit documentation, minimal magic -- are the ergonomics of good software engineering. Build software that programmers love to work with, and agents will be effective collaborators automatically.

This principle inverts the traditional tension between "engineering purity" and "practical shortcuts." In the agentic era, clean code isn't just aesthetically preferable -- it's a functional requirement for effective AI collaboration. Obscure naming, implicit conventions, and undocumented behavior all degrade agent performance just as they degrade human performance.

---

## 9. Observability

### Structured Logging

Logs are data, not strings. Every log entry should be a structured object (JSON) with consistent fields.

- Use a structured logging library (e.g., structlog, pino, serilog) -- never raw `print()` or `console.log()` in production code
- Every log entry should include: timestamp, level, message, and a correlation/request ID
- Log **events**, not narratives

### Correlation IDs

Every inbound request gets a unique correlation ID that propagates through all log entries, downstream service calls, and error reports.

### Health Endpoints

Every service exposes liveness and readiness endpoints. These are the foundation for load balancer checks, orchestrator probes, and monitoring dashboards.

### Metrics and Alerting

Define key metrics from day one: request latency (p50/p95/p99), error rate by endpoint, queue depth, database connection pool utilization. Add the instrumentation early; the metrics backend can come later.

---

## 10. Environment & Secrets Management

### Configuration Hierarchy

1. **Defaults in code** -- sensible defaults for development
2. **Config files** -- checked into version control, environment-specific
3. **Environment variables** -- override config files, set by deployment infrastructure
4. **Secrets manager** -- credentials, API keys, tokens (never in files or env vars in production)

### Separation of Concerns

Settings classes/schemas validate configuration at startup. Web processes get minimal configuration. CLI/admin tools get elevated configuration. Enforced by different settings classes, not by convention.

### Secrets Discipline

- `.env` files are for **local development only** and must be in `.gitignore`
- AI tools must be explicitly blocked from reading `.env` files
- Never log secrets, even at debug level
- Rotate credentials if they appear in any commit

### Environment Parity

Use Docker Compose (or equivalent) to run the same database engine, message queue, and cache layer locally as in production.

---

## 11. Database Migration Strategy

### Principles

- **Migrations are code**: Version-controlled, reviewed, tested like application code.
- **Forward-only by default**: Prefer forward migrations; downgrade migrations are optional.
- **One concern per migration**: Additive first (add column/table) before breaking changes.
- **Data migrations separate from schema migrations**: Different failure modes and rollback characteristics.

### Safety Checks

- Test every migration against realistic data volume before merging
- CI runs migrations against a clean database on every PR
- Never modify a migration that has already been applied to a shared environment

---

## 12. Dependency Management

### Principles

Every dependency is a liability. Before adding one, ask: Is the problem complex enough? Is it well-maintained? What's the blast radius if it breaks?

### Lock Files are Non-Negotiable

Lock files (`package-lock.json`, `poetry.lock`, `uv.lock`, `Cargo.lock`) must be committed. Running without a lock file is running untested code.

### Security Auditing

Run dependency security audits in CI. Set up automated tools (Dependabot, Renovate) to propose updates as PRs.

---

## 13. Demo-Readiness

### Principles

- **One command**: `make demo` does everything -- start services, run migrations, seed realistic demo data.
- **Deterministic data**: Seeded random generation so the same demo produces the same data every time.
- **Realistic volume and variety**: Multiple entities, edge cases, different states, enough volume to fill charts.
- **Idempotent**: Running `make demo` twice produces the same result.
- **Documented scenarios**: If demo data contains planted scenarios, document what they are.

### The Seed Pipeline

```bash
make demo              # Full pipeline: services + migrations + seed + demo data
make seed              # Reference data only
make seed-demo         # Demo transactional data
make reset-demo        # Tear down and rebuild from scratch
```

---

## 14. Agent-Ready API Design

The API is designed to be consumed not only by human-facing frontends but also by AI agents. Every endpoint should be usable by an agent that has no prior knowledge of the system beyond the API schema.

### Core Principle

**The best software for an agent is whatever is best for a programmer.** Clean interfaces, predictable conventions, flat structures, and meaningful names don't just help human developers -- they are the functional requirements for effective AI collaboration. An agent that can discover, understand, and call your API without human guidance is the benchmark.

### Design Principles

- **Self-describing schemas**: All endpoints use typed response models that generate accurate OpenAPI specs.
- **Predictable conventions**: Consistent patterns across the entire API surface.
- **Flat, explicit parameters**: Prefer query parameters and flat JSON bodies over deeply nested structures.
- **Meaningful names**: Avoid abbreviations that require domain knowledge.
- **Rich error responses**: Return structured errors with `code`, `message`, and `details`.
- **Enum documentation**: All categorical fields must have allowed values documented in the schema.

### MCP-Readiness Checklist

1. **Tool name derivable from path**: Use RESTful, verb-free paths.
2. **Descriptions at every level**: Write endpoint docstrings, parameter descriptions, and field descriptions for an agent, not a human.
3. **Bounded responses**: Always support pagination with sensible defaults.
4. **Filterable and composable**: Expose the same filter parameters the frontend uses.
5. **Idempotent writes**: POST/PUT operations should be idempotent where possible.
6. **No session state**: Every request is self-contained.
7. **OpenAPI snapshot in CI**: Maintain a committed OpenAPI snapshot and fail CI on schema drift.

### The Agent is Not a Trusted Operator

Agents hallucinate. Treat every agent-originated input with the same suspicion as user input from a public web form:

- Reject control characters (below ASCII 0x20)
- Canonicalize and sandbox file paths
- Reject `?`, `#`, and `%` in resource identifiers
- Validate enum values against the actual allowed set
- Return clear, structured errors so the agent can self-correct

### Non-Destructive by Default

- **Dry-run for mutations**: Support `dry_run` on all write/delete operations.
- **Soft deletes over hard deletes**: An agent that accidentally deletes the wrong resource shouldn't cause permanent data loss.
- **Confirmation for destructive actions**: Endpoints that delete or overwrite require an explicit confirmation parameter.

### Self-Documenting at Runtime

- **Help endpoint**: Machine-readable summary of all available endpoints.
- **Schema introspection**: `GET /v1/schema/{resource}` returns full schema for a resource type.
- **Field masks**: Support a `fields` parameter to limit response fields.

---

## 15. CI/CD

### Required Workflows

| Workflow | Purpose |
|----------|---------|
| PR Conventions | Enforce branch naming and PR title format |
| Security Boundaries | Scan for credential leaks, .env reads, trust boundary violations |
| Quality Gate | Run lint + typecheck + tests on every PR |
| Docs Check | Fail if API code changed but docs/collection not updated |

### Pre-Push Checklist

1. `make check` passes
2. `make check-frontend` passes (if frontend changes)
3. API collection updated (if API changes)
4. Documentation updated (if user-facing changes)

---

## 16. Definition of Done

Every phase/feature MUST complete ALL of these:

1. **Feature branch + PR**: All work on a branch, pushed, PR created
2. **Issue tracker**: Update relevant issues, mark as done
3. **PR links issues**: PR body includes `Closes <PREFIX>-NN`
4. **CLAUDE.md updated**: Reflect new project state, commands, structure
5. **README.md updated**: Reflect new capabilities and progress
6. **Documentation site updated**: Every new/changed endpoint, feature, data model
7. **API collection updated**: Every API endpoint has a collection file
8. **CI pre-check**: Verify changes won't fail CI before pushing
9. **Tests written**: New functionality has test coverage; red/green TDD used
10. **Task contract fulfilled**: All specified tests pass, verification checks succeed, invariants hold -- the agent must not self-certify; the contract is the authority

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

### Rules Files as a Knowledge Hoard

Each `.claude/rules/*.md` file scopes by file path so Claude only loads relevant context:

```yaml
---
paths:
  - "src/api/**"
  - "src/schemas/**"
---
```

**Treat rules files as a working knowledge hoard**: don't just describe patterns -- include the working code snippet or reference the exact file that implements it. Agents consume working examples far more effectively than vague descriptions. Every useful pattern solved once should be documented in the rules file with enough specificity that a future agent can replicate or extend it without re-researching.

### Comments and Documentation as Leverage

LLMs give inline comments and documentation **far more weight than human engineers do**. A three-sentence description at the top of a file or schema can fix persistent agent style inconsistencies that code review alone cannot. This flips the traditional cost calculus:

- Write comments and docstrings as if an agent is your primary reader: be **precise and explicit**, not conversational
- Describe *why* a pattern exists, not just what it does -- agents use this to generalize correctly
- Update `CLAUDE.md` and rules files after every non-obvious decision; a stale guide is worse than none

This is especially important for unusual conventions. If your codebase uses a non-standard pattern (a JSON-columns SQL schema, a custom error hierarchy, a specific naming convention), three sentences describing it upfront will save hours of agent confusion.

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

### Security Settings

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

### Model Configuration

- Use frontier models for agent tasks (Opus, GPT-equivalent). Cheaper models teach you the **wrong lessons** about agent capabilities -- you'll conclude agents can't do things they can, because the cheap model genuinely can't. Pay for the frontier during the adoption phase.
- For harder problems, enable or increase reasoning/thinking mode -- models that think out loud before responding handle debugging and complex logic significantly better.
- Use cheaper models (e.g., Haiku) only for subagent tasks that are token-heavy but cognitively simple (e.g., parallel file scanning).

---

## 18. Collaborating with AI

This methodology treats AI tools (Claude Code, Cursor, Copilot) as first-class development partners. The effectiveness of AI collaboration scales with the quality of context you provide and the habits you build around working with agents.

### Context Discipline

The single most important principle of working with AI agents: **give them exactly the information they need for the current task and nothing more.**

Context bloat degrades agent performance. An agent that has to read 14 markdown files before writing a function is an agent with too much noise.

Practical implications:
- **CLAUDE.md should be a routing table**, not an encyclopedia. Keep it lean. Point to rules and skills; don't contain all knowledge inline.
- **Rules load by file path** -- use this scoping aggressively.
- **One session per unit of work.** Long-running sessions accumulate context from unrelated tasks. A fresh session per task contract is almost always better.
- **After context compaction**, re-read the task plan and relevant source files before continuing.

### Context Architecture

| Layer | File | Loaded | Purpose |
|-------|------|--------|---------|
| Global | `~/.claude/CLAUDE.md` | Always | User preferences, tooling, cross-project conventions |
| Project | `CLAUDE.md` | Always | Project description, setup, commands, key decisions |
| Domain | `.claude/rules/*.md` | By file path | Deep context for specific subsystems |
| Memory | `.claude/memory/` | On recall | Learned preferences, feedback, project state |

### CLAUDE.md as Conditional Directory

Structure as a **logical routing table**:

1. **What is this project?** One paragraph, no jargon.
2. **How do I set it up?** Copy-paste commands.
3. **How do I run things?** All make targets / scripts.
4. **What are the conventions?** Code style, naming, file organization.
5. **What are the key decisions?** Architectural choices with rationale.
6. **What should I never do?** Guardrails and security constraints.
7. **Where to find more context?** Conditional pointers to domain rules.

### Session Opening Protocol

How you start an agent session determines how efficiently the rest of it goes. Three specific openers:

**For any existing codebase:**
```
First run the tests
```
This tells the agent a test suite exists, reveals project size, and sets a testing mindset for the session. See §5 for why this matters.

**For resuming work:**
```
Review changes made today
```
or `"Review last three commits"`. The agent runs `git log`, instantly loading recent context. Use this instead of explaining what you've been doing.

**For unfamiliar code:**
```
Plan a linear walkthrough of [component] and document it in walkthrough.md,
using grep/cat/sed to include real snippets -- don't copy them manually
```
The agent produces a structured explanation with citations from actual files, not its memory of them. Even code you vibe-coded and never understood becomes a learning opportunity.

### The Code-is-Cheap Habit Recalibration

Most engineering habits -- macro and micro -- were built around code being expensive. Coding agents disrupt them all simultaneously.

At the macro level: extensive upfront design, estimation, and ROI calculations for features.
At the micro level: hundreds of daily decisions about whether to refactor a function, add a test, write a doc comment, or build a debug interface.

**The new default:** Any time your instinct says "don't build that, it's not worth the time" -- fire off a prompt anyway in an asynchronous agent session. Worst case: you check ten minutes later and find it wasn't worth the tokens. Best case: you have a refactor, test, or utility you would never have built.

This is the micro-level complement to the Ratchet Effect (§8): the quality bar doesn't just hold steady, it actively rises because small improvements are now almost free. "The cost of these code improvements has dropped so low that we can afford a zero tolerance attitude to minor code smells."

**Delivering code has dropped in price to almost free. Delivering *good* code is still expensive.** The habits that need to change are the ones that filter out work based on time cost. The habits that need to stay are the ones that filter for quality: code review, red/green TDD, testing, documentation.

### Parallel Agent Sessions

One engineer can now run multiple independent agent sessions simultaneously. While Agent A implements a feature, Agent B refactors related code, Agent C writes tests, and Agent D updates documentation -- all in parallel, each in its own context window, each on its own branch.

This is a qualitative shift in what a single person can accomplish. Actively structure your work to exploit it: identify which tasks are independent, start sessions for each, and review the outputs in batches.

### Subagents for Large Codebases

On large codebases, codebase discovery is expensive in tokens. Use subagents for exploration and token-heavy operations to preserve the root agent's context window.

Claude Code's Explore subagent dispatches a fresh copy with its own context window to map the codebase, returning only the relevant findings. The root agent spends its context on implementation, not discovery.

Parallel subagents can also run independent file edits simultaneously -- potentially using cheaper models (Haiku) for cognitively simple but token-heavy operations like finding and updating all affected templates.

**The main value of subagents is preserving the root context and managing token-heavy operations.** Don't dispatch subagents for tasks that benefit from continuous context.

### Neutral Prompting

AI agents are designed to please. If you say "find me a bug in this module," the agent will find one -- even if it has to invent it. Work with this, not against it:

- **Use neutral prompts for investigation**: "Analyze the logic of this module and report all findings" instead of "Find the bug."
- **Use directed prompts for implementation**: "Implement JWT authentication with bcrypt-12 hashing and 7-day refresh token rotation" is better than "Build an auth system."
- **Never ask leading correctness questions**: "Is this correct?" will almost always get "yes." Instead: "Walk through this implementation step by step, state what each part does, and flag anything inconsistent."

### Anti-Patterns

**Don't file PRs with code you haven't reviewed yourself.** If you open a PR with hundreds or thousands of lines an agent produced, and you haven't done the work to verify it's functional, you are delegating the actual work to other people. They could have prompted an agent themselves. What value are you even providing?

A good agentic PR:
- **Works, and you are confident it works** -- you've run it, not just read it
- **Is small enough to review efficiently** -- several small PRs beats one large one; agents make splitting easy
- **Includes context** for the higher-level goal it serves
- **Has a PR description you've read** -- agents write convincing-looking descriptions; review them too

Include evidence you've done the review work: notes on manual testing, comments on implementation choices, or screenshots of the feature working. This signals to reviewers that their time won't be wasted.

**Don't use cheap models for agent work during the adoption phase.** Cheaper models don't just produce worse results -- they teach you the wrong lessons about what agents can and can't do. You'll conclude agents are incapable of things frontier models handle easily. Pay for frontier models until you have a calibrated sense of their actual limits.

### Teaching Through Feedback

When Claude does something wrong, correct it explicitly and explain why. When it does something right that wasn't obvious, confirm it. Both corrections and confirmations become memory that shapes future behavior.

Periodically review and consolidate your rules, removing contradictions and pruning stale instructions. If the agent needs to read too many files before starting, it's time for a cleanup.

### Building Intuition for Agent Capabilities (The AGI-Pilled Loop)

Working effectively with agents is a skill that compounds with deliberate practice. The most effective practitioners follow a specific loop:

1. **Assume the technology will continue to improve.** Don't calibrate your expectations to yesterday's model.
2. **Take a task and handhold the AI less.** Be more ambitious. Try to do more of it end-to-end.
3. **Push until you hit current AI's limits and it fails.** This is necessary -- you need to know where the ceiling actually is.
4. **Wait until the models improve and can successfully complete that task.**
5. **Learn from this. Update your strategy. Rethink what the future looks like.**
6. **Repeat.**

This loop is how you stay ahead of the capability curve rather than constantly re-discovering what agents can do. It also calibrates your mental model against reality rather than against fear or hype. Being surrounded by other people actively pushing agent limits accelerates this loop considerably.

### Understanding Code Built by Agents

When agent-generated code becomes a black box you don't fully understand, you've taken on **cognitive debt**. This slows down future feature planning and makes you less able to reason about the system's behavior.

Two patterns for paying it down:

**Linear walkthrough**: Ask the agent to produce a structured walkthrough of the codebase using shell commands (grep/cat/sed) to include real code snippets. The instruction to use shell commands (not manual copying) is critical -- it ensures snippets come from actual files, not the model's memory.

**Interactive explanation**: For algorithms or logic that still doesn't click after a walkthrough, ask the agent to build an animated or interactive HTML explanation. Seeing an algorithm execute step by step often produces understanding that static descriptions can't. "Build an animated version of this algorithm that shows each step -- include a slider to control speed and step through frame by frame."

### What to Delegate vs. What to Direct

- **Delegate**: Research, boilerplate, test generation, documentation updates, refactoring within established patterns
- **Direct**: Architecture decisions, new patterns, security-sensitive code, non-obvious business logic
- **Separate research from implementation**: If you don't know the exact approach, run a research task first. Then start a fresh session to implement. Mixing research and implementation pollutes context with discarded alternatives.

---

## 19. Key Decisions Log

Maintain a "Key Decisions" section in CLAUDE.md that captures important architectural choices and their rationale. This serves as quick context for anyone (human or AI) working on the project.

Format:
```markdown
## Key Decisions

- **Decision name:** Brief description of what was decided and why
- **Another decision:** Context and rationale
```

Update whenever a non-obvious architectural choice is made. The goal is to prevent future contributors from re-debating settled decisions or accidentally violating design constraints.

---

## 20. Project Initialization Checklist

Not every project needs all 20 sections from day one. Start with the essentials; add process as the project grows. The ratchet effect applies here too.

### Day 1 -- The Foundation

1. [ ] Initialize git repo with `main` branch
2. [ ] Write `CLAUDE.md` with project description, setup commands, code style
3. [ ] Write `README.md` with human-facing overview
4. [ ] Set up `Makefile` with `setup`, `dev`, `check`, `lint`, `typecheck`, `test` targets
5. [ ] Configure linter and type checker in strict mode
6. [ ] Create `.claude/settings.local.json` with deny rules for `.env`
7. [ ] Create project in issue tracker and link to repo
8. [ ] Configure GitHub to auto-delete merged branches
9. [ ] Set up pre-commit hooks for lint and format

### First Feature -- Add Quality Gates

10. [ ] Set up CI workflow: quality gate (lint + typecheck + tests on every PR)
11. [ ] Set up CI workflow: PR conventions
12. [ ] Configure structured logging with correlation IDs
13. [ ] Add health endpoints (liveness + readiness)

### Growing Up -- Add Structure

14. [ ] Create `.claude/rules/` directory with domain-scoped rule files
15. [ ] Initialize `.planning/` directory with `PROJECT.md`, `ROADMAP.md`, `CONTEXT.md`
16. [ ] Set up API collection tool (Bruno/Postman)
17. [ ] Set up CI workflow: security boundaries scan
18. [ ] Set up CI workflow: docs check
19. [ ] Set up dependency security auditing in CI

### Scaling -- Add Polish

20. [ ] Set up documentation site scaffold
21. [ ] Build seed/demo pipeline (`make demo`)
22. [ ] Set up adversarial validation for critical code paths
23. [ ] Create task contract templates for complex features
24. [ ] Schedule periodic dependency upgrade reviews
25. [ ] Schedule periodic rules/skills cleanup sessions

---

## Summary

The core philosophy is: **traceability, automation, and living documentation.**

- Every change traces back to an issue, through a branch, into a reviewed PR
- Quality gates are automated and enforced by CI, not discipline -- and they never go away (the ratchet effect)
- Dead code is context pollution -- when you build a new way, kill the old way immediately
- Documentation is a deliverable, not an afterthought -- it ships with the code
- The Makefile is the universal interface -- one entry point for all operations
- Spec the outcome, not the process -- define objectives and success criteria, let the agent figure out the how
- Red/green TDD: write tests first, verify they fail, then implement -- never assume LLM code works until executed
- Tests are completion contracts -- an agent's task isn't done until they pass, and the agent can't modify them
- Frontend test performance is a maintenance concern -- consolidate files, use lightweight DOM, lazy-load mocks (5-10x speedup)
- Adversarial validation catches what self-review misses -- competing agents with opposing incentives produce high-fidelity results
- Demo-readiness is a first-class concern -- `make demo` should produce a realistic, populated environment in minutes
- The agent is not a trusted operator -- validate inputs, support dry-run, design for non-destructive exploration
- APIs should be self-documenting at runtime -- agents discover capabilities by querying, not reading external docs
- The best software for an agent is whatever is best for a programmer -- clean code is a functional requirement for AI collaboration
- Comments and documentation are leverage, not cost -- agents give them far more weight than human engineers do
- Observability is built in from day one, not bolted on after the first outage
- Dependencies are liabilities -- add them deliberately, keep them current
- Migrations are code -- reviewed, tested, and versioned like everything else
- Configuration follows trust boundaries -- web processes get minimal access
- Use frontier models during the adoption phase -- cheaper models teach wrong lessons about capabilities
- Git history is an authored story -- curate it deliberately with agent assistance
- Compound Engineering: document successful patterns from completed work; small improvements compound
- The code-is-cheap habit recalibration: fire off prompts for micro-decisions that used to cost an hour
- Parallel agent sessions: one engineer can now implement, refactor, test, and document simultaneously
- Building agent capability intuition is a deliberate practice (the AGI-pilled loop) -- not a personality trait
- Start lean, add process as the project grows -- not every project needs everything from day one

---

## Changelog

### v1.2.0 (2026-05-13)

Additions distilled from Simon Willison's Agentic Engineering Patterns guide and complementary practitioner sources.

**§2 Git Hygiene:**
- Added "Git History is an Authored Story" framing -- history as deliberately curated narrative, not fixed record
- Added "Agentic Git Prompts" subsection -- session starter, mess recovery, bisect, history curation with agent prompts

**§3 Planning & Execution:**
- Added "Compound Engineering" subsection -- documenting successful patterns from completed work for future agent reuse

**§5 Testing:**
- Added "Red/Green TDD with Agents" subsection -- the red-verification step, specific failure modes it prevents, 4-word shorthand
- Added "Never assume LLM code works until executed" as a hard principle
- Added "First Run the Tests" session opener with explanation of its three effects

**§8 Design Principles:**
- Added "The Best Software for an Agent is Whatever is Best for a Programmer" -- clean code as functional requirement for AI collaboration

**§14 Agent-Ready API Design:**
- Added core principle paragraph referencing §8's programmer/agent alignment

**§17 Claude Code Configuration:**
- Added "Rules Files as a Knowledge Hoard" -- working code examples over descriptions
- Added "Comments and Documentation as Leverage" -- LLMs weight them more than humans; write for agents
- Added "Model Configuration" subsection -- frontier models during adoption, reasoning mode, subagent model selection

**§18 Collaborating with AI:**
- Added "Session Opening Protocol" -- three specific openers for different scenarios
- Added "The Code-is-Cheap Habit Recalibration" -- micro-decision habits, the fire-off-a-prompt heuristic
- Added "Parallel Agent Sessions" -- explicit statement of simultaneous session practice
- Added "Subagents for Large Codebases" -- context preservation, Explore pattern, parallel file editing
- Added "Anti-Patterns" subsection -- unreviewed PRs (vivid framing), cheap model trap
- Added "Building Intuition for Agent Capabilities (The AGI-Pilled Loop)" -- 5-step deliberate practice
- Added "Understanding Code Built by Agents" -- linear walkthroughs and interactive explanations as cognitive debt paydown
- Reorganized and tightened existing content; no removals

**Summary:** Updated with v1.2.0 additions.

### v1.1.0 (2026-03-24)

- Added Frontend Test Performance subsection
- Updated Frontend Standards and Testing bullets
- Added version header and changelog

### v1.0.0 (2026-03-21)

- Initial release: 20 sections covering process, engineering, architecture, agent-first design, and meta
