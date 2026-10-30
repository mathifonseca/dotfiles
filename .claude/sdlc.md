# Software Development Lifecycle Guide

**Version:** 1.3.3

This document defines the development methodology for this project. It is designed to work with Claude Code and the GSD (Get Shit Done) workflow, but the principles apply regardless of tooling.

Distilled from building a production platform (34 phases, 5 milestones, 2,793+ tests) using AI-first development with Claude Code, and from Simon Willison's Agentic Engineering Patterns guide. v1.3.0 folds in the full-lifecycle harvest of a second project taken from init through public launch, live operation, and decommissioning (Pencadores: 33 phases, 159 consolidated teach proposals, and the post-mortems of every production incident).

Canonical copy lives at `~/.claude/sdlc.md` (via dotfiles). Projects reference it by version in their `CLAUDE.md`.

## Table of Contents

**Process**
1. [Change Workflow](#1-change-workflow-mandatory) -- Issue first, feature branches, PRs, naming conventions
2. [Git Hygiene & Commit Discipline](#2-git-hygiene--commit-discipline) -- Atomic commits, messages, branch hygiene, hooks, agentic git, worktree isolation
3. [Planning & Execution](#3-planning--execution) -- Milestones, phases, spec the outcome, spec as source of truth, codify (compound engineering)

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
18. [Collaborating with AI](#18-collaborating-with-ai) -- Context discipline, shared team context, one-file-per-deliverable, session protocols, prompting, feedback, delegation

**Operations**
19. [Consuming External Data & APIs](#19-consuming-external-data--apis) -- Stable keys, declared surfaces, raw payload retention, reconciling syncs
20. [Debugging Discipline](#20-debugging-discipline) -- Mechanism over error-string, independent ground truth, baseline repro, cache suspicion
21. [Decommissioning & Hibernation](#21-decommissioning--hibernation) -- Shutdown as a runbook: live inventory, disable-don't-delete, revival path

**Meta**
22. [Key Decisions Log](#22-key-decisions-log) -- Capturing architectural choices; records go stale
23. [Project Initialization Checklist](#23-project-initialization-checklist) -- Progressive disclosure: day 1 → scaling

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
- **Squash-merges break three-dot diffs.** After a squash-merge, the merged work lives on `main` under a new SHA, so `git diff main...HEAD` on a long-lived branch re-shows already-merged commits. Check the real delta with the two-dot form (`git diff origin/main..HEAD`), or snapshot the tree onto a fresh branch (`reset --soft`) for a clean PR

### Pre-Commit Hooks

Set up hooks that run linting and formatting before every commit. This prevents CI failures from style issues and ensures every commit in history is clean. Use a framework (e.g., pre-commit, husky, lefthook) to manage hooks declaratively so they're version-controlled and shared.

**Never `--no-verify`.** This is non-negotiable. Skipping hooks (`git commit --no-verify`, `--no-gpg-sign`, etc.) bypasses the gate the team agreed to enforce. The same anti-pattern wears other syntactic clothes: `// eslint-disable`, `# type: ignore`, `#[allow(...)]`, `as any`, `// @ts-expect-error` without a tracking issue. If a hook is blocking legitimate work, fix the hook — do not bypass it. The exception is when an explicit human operator has authorized the bypass with a documented reason in the commit message; agents must never authorize this themselves.

### Commit Cadence

Commit every **20–30 minutes** of substantive work. The cadence is auditable; "commit often" is not.

The discipline pairs with two other rules: (1) one logical unit per commit (above); (2) **the task is not done until `git push origin <branch>` succeeds.** A clean local tree with unpushed commits is incomplete work — the next agent (or you, tomorrow) cannot see it. This shape catches multi-hour drift: if you have not pushed in two hours, surface the reason explicitly rather than letting an uncommitted working tree silently accumulate.

Agentic flows multiply the value of cadence discipline because agents accumulate state faster than humans do — an unsupervised agent can produce three hours of uncommitted work in 45 minutes. Cadence makes intermediate state visible at git level so it can be reviewed, reverted, or composed before it ossifies.

### Agentic Git Prompts

Coding agents are fluent in all of Git. You don't need to memorize commands -- staying aware of what's possible lets you take advantage of Git's full capabilities. Useful patterns:

- **Session starter**: `"Review changes made today"` or `"Review last three commits"` -- agent runs `git log` and instantly loads your recent context before you start typing. Seed every resumed session this way.
- **Mess recovery**: `"Sort out this git mess for me"` -- agents can navigate Byzantine merge conflicts, reason through intent, and ensure tests pass. What used to be a painful hour is now a prompt.
- **Bisect**: `"Use git bisect to find when this bug was introduced: [description]"` -- agents handle the boilerplate, upgrading bisect from occasional to routine. Describe the bug; let the agent run the binary search.
- **History curation**: `"Combine last three commits with a better commit message"`, `"Remove [file] from that last commit"`, `"Undo last commit"` -- surgical history editing without memorizing `reset --soft HEAD~1`.
- **Library extraction**: `"Start a new repo at /tmp/[name] and build a library with [file] from here -- build a similar commit history preserving author and commit dates"` -- previously too involved; now a prompt.

### Worktree Isolation

Git worktrees let you check out multiple branches simultaneously into separate directories -- without stashing or context-switching costs. They are the natural unit of isolation for parallel agent work.

**One worktree per ticket** is the recommended pattern when running agents in parallel:

```bash
git worktree add ../my-project-feat-123 feat-123/add-user-export
```

Each agent session works in its own directory on its own branch. No stash conflicts, no mid-task context leaks between streams. When the ticket is done:

```bash
git worktree remove ../my-project-feat-123
```

GSD enables this automatically when `workflow.use_worktrees: true` is set in `.planning/config.json`.

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

### Confirm the Architecture, Not Just the Feature

When a requirement fits several architectures, the agent defaults to the ecosystem's headline pattern — which may not be yours. "i18n-ready from commit 1" became locale-prefixed URLs baked into planning because that is the i18n library's flagship routing mode; the actual requirement was a per-profile preference. Architecture-shaping interpretations of a requirement are questions for the owner during discussion, not defaults to inherit from a library's README.

### Dependent-Repo Pre-Flight Check

Before any planning phase that depends on a backend wire, an external API, or a sibling repo's contract -- run a scan for **recent merges in the dependent repos**, bounded to the last 30 days, focused on the specific surfaces the work will consume.

The failure mode this prevents: a frontend PR scoped against a backend contract that was silently changed four days earlier. The work executes successfully against stale planning docs, then unwinds when the discrepancy surfaces in code review or, worse, in staging.

Pattern:

1. Identify the dependent repos and the specific surfaces the new work consumes (endpoints, fields, error codes, file paths).
2. `gh search prs` (or equivalent) filtered to those repos, merged in the last 30 days, touching those surfaces.
3. Read the diffs that intersect -- not the PR descriptions, the actual diffs. PR descriptions describe intent; diffs describe state.
4. Update the planning docs (or kill the phase) before any execution starts.

This is a 10-minute step that protects multi-hour execution work. Skip it only when the dependent repos are demonstrably quiet (no merges in 30 days against the affected surfaces).

### The Spec as Source of Truth

Extend "spec the outcome" to its logical conclusion: the spec is not an input to implementation -- it is the **source of truth** from which implementation is a projection.

Code, tests, migrations, and endpoints are **living projections** of the spec. When the spec changes, the projections update. When a projection diverges from the spec, that is a defect -- not a design decision.

This reframes the developer's role: you are designing contracts that agents must fulfill, not writing code that satisfies a description.

Operationally:
- Every feature starts with a spec written before any code exists
- The spec lives in a tracked file, not in a ticket comment or Slack thread
- Agents produce code; you verify it satisfies the contract
- Any merge that cannot be traced to a spec requirement is suspect

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

### Codify (Compound Engineering)

**Codify is the explicit final phase of the development loop:** `discuss → plan → execute → verify → codify`. The work isn't done when the code ships — it's done when the learning from shipping it is encoded somewhere a future agent will load. Naming it as a phase makes the step visible at the workflow level instead of leaving it as an afterthought; the GSD fork tracks adding `codify` to its phase chain as a follow-up (see FORK.md).

"Small improvements compound." Every encoded pattern is future leverage: an agent that can reference a working example of how you solved a similar problem before produces better results than one reasoning from scratch. This is also why dead code is context pollution (§8) — every zombie implementation degrades the signal of what you've codified.

**Codification has more than one surface.** "Add a note to the rules file" is the narrowest form. Match the artifact to the kind of learning:

- **Rules files** (`CLAUDE.md`, `.claude/rules/*.md`) — conventions, invariants, and worked code examples for a domain. The default for "here's how we do X in this codebase." See §17 "Rules Files as a Knowledge Hoard."
- **Skills** (`.claude/skills/`) — a repeatable *procedure* that pushes Claude out of its default behavior. When the learning is "here's the multi-step process for Y," it's a skill, not a paragraph. See §18 "Designing Skills."
- **MCP servers / tools** — when the learning is "the agent needs reliable access to system Z," encode it as a tool, not prose describing the API. A tool that returns structured data beats instructions for calling an API by hand.
- **Hooks** — when the learning is "step W must *always* fire," encode it as a deterministic hook, not a reminder the prompt can skip. See §18 "Deterministic Middleware as Agentic Safety-Net" and "On-Demand Hooks."

The routing question at the end of every non-trivial task: *what did I learn, and which of these four surfaces will make a future agent load it automatically?* A learning that lives only in this session's context is lost at compaction.

### Milestone Exit Audit

Before archiving a milestone, audit it against original intent — not against the task list. Cross-reference every requirement across three sources: the traceability matrix, each phase's verification report, and the execution summaries; retroactively author any missing verification doc rather than waving the phase through. Traps found in practice:

- **Tooling scopes the audit to what it tracked.** An owner-inserted phase "would otherwise never be audited" — audit the real shipped delta, not the tool's view of it.
- **"It's been running in production for a month" is compensating evidence**, never a substitute for the checks.
- **Close the loop outward.** Fixes recorded in the repo don't update the stakeholder's tracker — 46 of 48 shipped fixes still read PENDING in the canonical feedback sheet until a dedicated reconcile pass. Reconciling external trackers is part of the milestone, not an afterthought.

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

**And verify at the deliverable's altitude.** "Executed" means the actual artifact
the user touches behaved correctly, observed as the real user — not that the layer
you reasoned about returned the right value in isolation. DB-layer reasoning ("the
query returns rows now") repeatedly masks a render-layer or permission-layer cause
that only surfaces when the live, authenticated result is actually looked at. A fix
confirmed one layer below the user is a hypothesis, not a verification.

**Interface design is a precondition for TDD, not an output of it.** TDD presupposes that the unit under test has a clear, testable interface. In a codebase composed of many tiny undifferentiated modules, an agent doing TDD has no obvious test boundary — it ends up testing implementation details instead of behavior, or fragmenting tests across coupled internals. The fix is structural: prefer **fewer, deeper modules with thin interfaces** (Ousterhout, *A Philosophy of Software Design*). When red/green is about to run, confirm with the agent what interface changes the feature requires *before* it writes the first failing test. An interface change is a load-bearing decision the agent must surface and pause on — it is not "just a refactor." Codebases that already conform to the deep-module shape get more value from agent TDD than shallow-module codebases by a wide margin; this is why §8's "Best Software for an Agent" principle is a precondition for §5, not an aesthetic preference.

**Red → Green → Refactor → Commit, one cycle per commit.** The four-phase cycle replaces three-phase TDD with an explicit commit step at the end. Each cycle ships as exactly one commit so the history reads as a sequence of constrained behavior changes, each independently revertible. The refactor phase is non-optional — without it, green tests accumulate as implementation drift and the next red test lands against a worse interface than the last.

**Kent Beck's Test Desiderata** — apply when evaluating whether a test earns its slot. Good tests are:

- **Isolated**: a test's pass/fail does not depend on the order other tests ran in
- **Deterministic**: the same input always produces the same outcome (flaky tests get fixed, not skipped — see §8 The Ratchet Effect)
- **Fast**: latency is feedback; slow tests are read less often, so their failures land later
- **Behavioral**: tests assert on observable behavior, not on internal state shape (see Test Philosophy above)
- **Structure-insensitive**: refactoring code without changing behavior should not change tests; a test that breaks on a rename is asserting on shape, not behavior
- **Specific**: one assertion per test where possible; a test that "tests the login flow" describes a feature, not a verifiable claim
- **Predictive**: when this test passes, the system behaves correctly in production for the case under test; if green-here can coexist with broken-there, the test is performative

Tactical guidance: **fix flaky tests first** when starting a session (a flaky test poisons every other green); **prefer end-to-end tests over unit tests for user flows** (E2E asserts on the contract the user actually consumes; unit tests assert on internals that may be irrelevant to the user contract).

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

### Choosing Test Cases & Reading Coverage

A passing test proves nothing if it was written from the same assumption as the
code it guards. The failure mode that motivates this section: a validator with
green tests still shipped a bug that broke a core flow for an entire class of
users, because the test only exercised the values the author already believed
were valid — it encoded the code's assumption instead of the requirement.

- **Test the requirement, not the code's assumption.** A test written from the
  implementation's mental model just re-confirms the implementation — bug
  included. Derive cases from what the product must accept and reject, never from
  the shape the code happens to check. The test is an *independent oracle*; if it
  paraphrases the code, it proves nothing.

- **Test the seam, not just the modules.** Most gaps live *between* units. When
  module A produces or offers values that module B validates or consumes (UI
  options → server validator, ID generator → format check, enum → DB constraint,
  message keys → locale catalogs), the two must share a **single source of truth**,
  and a test must iterate that shared set across the boundary (`for-each` over the
  constant). Testing A and B in isolation — each with its own hardcoded happy-path
  value — is exactly how an offered-but-rejected value slips through unnoticed.

- **Always include the default, the fallback, and the degenerate-but-valid case.**
  "Realistic" fixtures drift toward pretty values and away from the boring ones
  real users actually hit on day one: the default, the fallback, empty, zero, the
  single-element list, the just-created account. List the equivalence classes
  (valid-canonical, valid-edge, invalid, empty/missing) *and* explicitly feed the
  value the system itself uses as its default or fallback.

- **Coverage measures lines executed, not inputs covered.** A 100%-covered line
  can still be wrong — coverage says "a test ran this line," never "a test ran it
  with the inputs production produces." For any validator, parser, or branch, the
  real bar is equivalence-class coverage, not line/branch percentage. Never read a
  green coverage number as input-space confidence.

- **Prefer authoritative validation over hand-rolled shape checks.** Validate
  against the real domain (a platform API, a library, a DB constraint) instead of a
  regex that encodes a guess about the shape — a guessed shape silently excludes
  valid members of the domain you didn't think of. If a shape check is unavoidable,
  its case list must include the awkward-but-valid members, not only the textbook
  ones.

- **When you fix a bug, grep for its twin before closing.** Duplicated logic means
  duplicated bugs; copy-pasted validation fails identically in every copy. A fix
  isn't done until you've searched for the same anti-pattern elsewhere and either
  fixed it too or recorded why it's out of scope.

### Skipped Is Not Passed — Bring Up the Stack Before You Claim Verified

A test that does not run provides **zero** coverage, no matter how well-written.
The motivating failure: a feature shipped completely dead — its core query threw
at runtime in every environment, production included — because the one real-DB
test that exercised it was `skipIf(!reachable)`, the local stack was never started
during execution or verification, and the skip was reported as acceptable coverage.
The unit test passed by being handed the query's *output* as props, so the seam
where the bug lived had no executed coverage. It surfaced only when a human tried
the feature by hand.

- **Skipped ≠ passed.** A conditionally-skipped test (`skipIf`, `it.skip`,
  reachability-gated, browser-gated) that did not execute contributes nothing.
  Never count it toward "verified," and never report a phase or feature as
  verified/done while the tests that exercise it were skipped. When you read a
  green run, look at the skip count, not just the pass count.
- **Bring the dependency up; don't wave the skip through.** "The integration test
  is skipped because the DB/browser isn't running" is an instruction to start the
  DB/browser and run it — not a reason to ship. If a real database, real browser,
  or real service is what the test needs, stand it up and run the test before
  claiming the work is verified.
- **Don't outsource to manual testing what you could have run.** Asking the human
  to click through a feature is not a substitute for automated coverage you were
  able to execute yourself. Reserve manual UAT for what automation genuinely can't
  reach (subjective UX, visual polish) — never for discovering whether the feature
  works at all.
- **Every skippable real-dependency test needs a non-skip tripwire** in CI (e.g.
  `if (process.env.CI) throw` when the dependency is unreachable) so it can never
  silently skip in the one place it must run, **and** a deterministic,
  dependency-free guard (a static/CI check) that encodes the same invariant — so
  the protection survives a CI outage, a missing Docker, or no browser.
- **Only the user waives a run.** Skipping, deferring, or not-yet-running a test
  suite is an explicit user decision, named in the commit / PR / decision log —
  never a silent agent choice. Absent that authorization, the default is: run it.

### A Green Test Can Lie

Three ways a passing suite certifies a bug instead of catching it — all observed in production post-mortems:

- **The stale-contract test.** A behavior changes but the integration test asserting the *old* contract stays green — the suite now actively defends the regression. When a contract changes, the test that exercises the real seam must change in the same diff; adding a new unit test alongside the stale one is not enough.
- **The bug-pinned-as-feature test.** A test written against a stub-era behavior (a settlement function refusing real input) reads as a *safety property* to every future reader — the guard that IS the bug acquires a test defending it. When pinning a refusal or restriction, state in the test name whether it pins a temporary stub or a permanent invariant.
- **The tautology.** A test that computes its expected value from the same logic it verifies proves nothing — and the observed one was also `skipIf`-skipped in CI, so it never ran at all. Expected values come from an independent oracle: a fixture, a hand-computed constant, an upstream payload.

This extends "test the requirement, not the code's assumption": a green test is evidence only if it could have been red.

### Rare and One-Shot Paths Get No Incidental Coverage

Code that runs once per project lifetime — the finals-day settlement, the break-glass recovery, the late-joiner backfill, the account-deletion cron — accrues zero coverage from normal usage and breaks exactly on the day it matters. A one-shot settlement path was discovered dead the day *after* the event it existed for, unwired at three layers, its requirement long marked Complete. These paths need deliberately-scheduled rehearsal: an explicit test at their real altitude, plus a documented manual-trigger recipe so a human can drive them when the automation fails.

### Flakes Nobody Owns Compound Forever

A pre-existing flaky test survives milestone after milestone because CI retries absorb it and no phase owns it — the same flake set was documented as "pre-existing, carried to backlog" across four consecutive milestones. A flake is either fixed, or explicitly quarantined with an owner and a ticket; "known flaky, retried" is a slow leak in the ratchet (§8). Schedule an explicit cleanup phase when the carried set grows past a handful.

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

### Price Tests Against the Bottleneck

Under agentic development, writing code is no longer the constraint — validation and verification (review, build, test, deploy) is. Generating test code adds load to the *most expensive* station, so a test only earns its slot if it buys more verification than it costs (Nygard, "AI versus Throughput," 2026-05). The rules:

- **No test without a named failure mode.** "Increases coverage" is not a reason — state the bug the test would catch. A test that constrains nothing is load at the bottleneck for no return.
- **Cheapest test that catches the bug.** Prefer unit/contract over E2E; reserve E2E for genuine integration seams. Never let "cheap" under-test a money path.
- **Report CI cost when a change lengthens the pipeline,** and periodically propose deleting or consolidating slow/redundant tests — not just adding. Pipeline time is a budget, not a free resource.
- **Never fake green.** Don't weaken, skip, or delete a test to pass CI. If a test is genuinely wrong, say so and let the human decide. Agents "fake it" by changing the test instead of fixing the code, so test integrity must be verified out-of-band, not assumed (Nygard, "AI versus Microservices").
- **Push validation upstream** — types, contract/property tests, pre-commit hooks — to cut failure demand before it reaches CI.

This pairs with §8's ratchet carve-out: ratchet *outcome* signals (escaped-defect rate, p95 pipeline time as a ceiling), never test count or coverage %.

### Full E2E Suite Once per Phase, Targeted Runs per Wave

A browser E2E suite that has to run serially against shared fixtures or a shared live store can cost an hour of wall clock. Running it after every wave multiplies that hour by the number of waves, while each wave usually touches only a few surfaces. The quality gate (`make check`) is minutes and still runs on every change. The full E2E suite runs once per phase, plus wherever the rules below require it:

- **Per wave: the quality gate plus a targeted E2E set.** The set is every spec the wave added or changed, plus the specs that exercise each route or surface the wave's diff touches. Build the set from the diff (`git diff --name-only <base>...HEAD` mapped to specs), never from memory, and record the spec list with the result in the wave's evidence.
- **The full suite runs once per phase,** on the tree that will land last, before the final wave merges. Run it earlier when a wave touches **shared surfaces**: the app layout, shell or navigation, badges or other aggregates every page renders, auth, the shared fixtures or their reset script, the E2E harness config, or a dependency upgrade. Each project lists its shared paths. When you are unsure whether something is shared, treat it as shared.
- **A phase never closes on targeted runs alone.** A red that the full run finds outside every wave's targeted set is fixed in the phase. That surface then joins the project's shared list, or the spec map that should have caught it.
- **Do not re-run a gate on a tree it already passed on.** If the merge result's tree hash equals the tree the author tested (because the branch was already based on the current main), the author's gate stands. Compare the tree hashes; do not assume they match. Once main has moved, the merge result is a new tree and needs its own gate.
- **Unchanged from before:** the E2E run comes before any human-verify ask, and a green on a moving tree proves nothing (§5, "A Green Test Can Lie").

From the TCC Pulse coordination (owner decision, 2026-10-27): the full run took ~54 min (62 specs, one worker, shared live store), against ~2 min for `make check`, and it ran once per wave.

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

### Sibling Parity Is a Hypothesis, Not Verification

"This call site is missing the write its siblings do" feels like a diagnosis and a fix in one — but if the sibling is itself broken, mirroring it propagates the latent bug to a third location, which is exactly what a post-mortem found. Matching an existing pattern *feels* like correctness and silently substitutes for it. Before copying a reference implementation, verify the reference actually works end-to-end at the deliverable's altitude (§5).

### Stubs and Dead Levers

A stubbed placeholder (`resolveSlot(..., () => null)`) wired into a live path silently disables the whole feature while every layer around it looks implemented; a config lever (env var, secret, flag) that no code reads is a knob someone will one day turn expecting an effect. Both read as "done" in review. Grep for stubbed callbacks and hardcoded nulls on wired paths before calling a feature complete, and delete config levers that connect to nothing (§8 dead code) — or the next operator will chase a dead cadence knob while the real lever sits elsewhere.

---

## 8. Design Principles

### Database Constraints Enforce Business Invariants

If the database can enforce a uniqueness, referential, or consistency rule -- it must. Application-level checks are a convenience; DB constraints are the safety net.

### Enforce Invariants at Every Layer — and Change Every Layer in Lockstep

An invariant that must hold regardless of caller privilege needs enforcement at more than one layer (an app-side validation *and* a DB trigger/constraint), because privileged paths bypass the outer layer. The corollary is the trap: once an invariant lives in two layers, any change to its definition must land in both **in the same unit of work**. A validation rule narrowed in the app schema but not in its DB-trigger twin silently rejected every newly-valid write — invisible until the stage of the tournament that exercised it began. Treat any diff that changes a validation on a DB-backed table as a schema change: it ships with the matching migration, or states explicitly why no DB twin exists.

### One Source of Truth per Displayed Value

When two surfaces show "the same" number computed from different bases, they will diverge — one page summed a trigger-maintained rollup while another recomputed from a filtered subset, and a user saw 271 points on one screen and 277 on the other. Any value displayed in more than one place gets one authoritative source; the other surfaces read it. Recomputing "the same" total through a different filter is a divergence waiting for a screenshot. (This is §5's single-source-of-truth seam rule, applied to production surfaces.)

### Functional Core, Imperative Shell

Keep the irreducible domain calculation (scoring, pricing, settlement) a pure function of its inputs — no wall clock, no randomness, no I/O. Purity is what makes it unit-testable at exact boundaries, importable by a simulator on the identical code path, and byte-mirrorable across runtimes. Clock- and race-dependent decisions ("is this settleable yet", stability windows) belong in the calling orchestrator; display formatters take `now` as an argument.

### Client-Supplied Values Are Hints, Never Authorization

A cookie, search param, or form field naming a resource is a *hint* — re-validate it against access rules on every read so a stale or forged value is inert. Never persist a client-supplied authoritative ID: strip it at the boundary and derive the real value server-side.

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

**Numeric ratchets, not just binary gates.** Many quality signals are scalar, not pass/fail: code-health scores (CodeScene Hotspot, Code Health Average), coverage percentages, bundle size, p95 latency, type-coverage ratio. A binary gate ("score above threshold") tolerates "we got worse but still pass" drift; a **numeric ratchet** stores the current best score and rejects any commit that regresses it. Thresholds only go up. When the remote tree improves the score (e.g., after a refactor), commit the new floor; the new floor becomes the gate.

This is the agent-context analog of code-health enforcement: agents will happily accept "we passed the threshold" as success, then regress the score next commit. The ratchet removes the negotiation. Implement at pre-commit and pre-push for fast feedback; let CI catch regressions that escape local hooks. The concept is portable to any quality tool that emits a scalar.

**Coverage is the wrong thing to ratchet.** The numeric ratchet is right for code-health, bundle size, and p95 latency; it is *wrong* for test count and line/branch coverage. An always-increasing coverage gate is a Goodhart trap: it measures *volume* at the non-bottleneck station (§5 "Price Tests Against the Bottleneck") rather than defects caught, and it structurally forbids consolidating or deleting redundant tests — you can't drop a slow test without failing the ratchet, so bloat locks in. Ratchet *outcome* signals instead: escaped-defect rate, code-health score, or p95 pipeline time as a ceiling that only goes *down*. The general form: **a metric you can name is a frame you can game** (Shipper, "After Automation," 2026-05) — the moment you specify what to optimize, the agent optimizes climb-within-the-frame, not the value the frame was a proxy for. Ratchet outcomes, never proxies.

### Standards Live in Tooling, Not Reviews

Standards become real only when enforced by tooling that **rejects the run** — not by reviewer comments that suggest a change. Linters, formatters, static analysis, schema validators, and the ratchet effect above are tool-enforced rules: the agent cannot ship code that violates them. Reviewer-enforced rules are negotiable by default, especially in agentic flows where the human is downstream of many small commits and lacks the context-bandwidth to enforce uniformly.

The corollary for AI collaboration: every standard you want the agent to follow needs a path to mechanical enforcement. If the only way to know whether the agent followed the rule is to read every diff, the rule is decorative. Worked example: a rule "always use named exports" enforced by ESLint cannot be silently violated; the same rule maintained only in `CLAUDE.md` gets ignored under load. Promote rules from prose into tooling whenever possible; treat the prose-only rule as a temporary state on the way to enforcement.

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

The operational corollary: **treat agents like humans with weird constraints.** Specifically, humans with no persistent memory who are freshly cloned for every task. The way to get high-quality output is to encode the process the same way you would for a new hire -- skills, rules, conventions, and routing tables -- not to invent novel AI-specific scaffolding. If a process document strips down to the same instructions you'd give a competent human engineer, it is on the right track. **Corollary of the corollary: garbage codebase produces garbage agent output.** A messy, undocumented, deeply coupled codebase will compound through the agent rather than be cleaned up by it; AI amplifies the substrate it operates on, in both directions.

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

For systems whose change surface extends beyond your own deploys — vendor platforms, identity providers, agents with delegated authority — delivery metrics alone overstate health. Pair them with the scope-note and legibility discipline in §18 "Measure Outcomes and Comprehension, Not Output Volume": a dashboard that is green but undiagnosable is measuring flow, not understanding.

### Verify at the Effect, Not the Trigger

A scheduler reporting "succeeded", an HTTP 200, or "N rows" proves the *trigger* ran — not that the effect happened. A cron job reported success for weeks while a guard short-circuited and the function it existed to call never fired; a bare `{ok: true, iterations: 0}` masked a dead ingest pipeline. Two rules: (1) jobs report a **work-done count**, and an active window that produces zero work is a flagged anomaly, not a success; (2) "applied/pushed/deployed" is proven by reading back the new state (a row's `updated_at`, a dry-run printing "up to date", a health endpoint's SHA) — never by the command's own exit code.

### Degraded Paths Fail Loud

The dominant reason production bugs lurked for weeks instead of surfacing on first occurrence: silent degradation. A destructured `{ data }` with no error check renders an empty page identical to "no rows"; a swallowed catch logs to a console nobody reads; a permission failure degrades to an all-null fallback. Conventions: every data fetch checks the error before touching the data; handled errors on critical paths still go to telemetry; results are discriminated so the UI renders an *error* state distinct from a legitimately *empty* one (`length === 0` is often a valid success). A privilege check that fails should raise, not filter to zero rows.

### Match the Verification Layer to Where the Bug Class Lives

A post-hoc walk through two weeks of production bugs found a green pre-merge gate would have caught ~2 of 10 — the dominant classes (live-pipeline state and timing, silent fallbacks, cross-layer enforcement drift, wrong-role invocation) live in production state and real-payload behavior, not in unit-testable logic. When that is where your bugs live, the highest-leverage investment is not more unit tests: it is production health alerting, post-deploy smoke checks, and a golden replay harness of captured real payloads. Choose the layer that can actually observe the failure.

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

### Know the Target Before You Run

Three incidents from one project: a script named `db:push:test` pushed migrations to *production* (the ":test" referred to a schema, not an environment); the local `.env` pointed dev and seed scripts at prod; a scaffolding command hard-deleted every planning directory via an unguarded `rmSync`. Before running anything that mutates state, confirm which environment it targets and what its blast radius is — read the script, not its name. Make dangerous targets opt-in: tooling refuses remote/prod targets unless explicitly authorized, and destructive automation gets vetted against its source before its first run, not after.

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

### Column Before Code

Code that reads a new column ships *after* the schema change and backfill have reached production — otherwise it throws (or silently blanks) on every row that predates it. The deploy order is: migration → backfill → verify remotely → code that depends on it. When code must land ahead of its dependency, it degrades gracefully (returns empty with a logged hint, never throws), and no scheduled job or trigger is registered against a not-yet-deployed target — a dead cron errors on every tick from the moment it's wired.

### Corrections Are New Migrations

A data fix ships as a new forward-only migration that is idempotent and self-guarded (a sentinel check makes re-runs no-ops on already-fixed databases) — never as an edit to a base seed or an applied migration, which shared environments will never re-run. When inserting a migration into non-linear history, read it and evaluate the ordering risk before forcing the splice: additive/idempotent DDL is safe; schema-dependent DDL is not.

### In-Place Replace Drops What You Don't Restate

`CREATE OR REPLACE` (and its cousins) silently resets every attribute not restated — privileges, security context, search path, comments. A "replace" that only restates the body strips the GRANT footer, and the function stops working for its callers. Re-state the entire definition including its footer; use `ALTER` for attribute-only changes; reserve drop+create for signature changes. Relatedly: privileged functions run *as someone* — contract-test each wrapper's expected caller role, because an elevated client calling a caller-scoped function fails (or silently returns false) in ways user-session testing never shows.

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

### Workflow Triggers — Avoid the `push` + `pull_request` Double-Fire

A workflow triggered on **both** `push: branches: ['**']` and `pull_request:` runs **twice** for every commit on a branch that has an open PR — once for the push event, once for the pull_request event. This silently doubles CI minutes (and doubles the load on shared runners) for the entire life of every PR. On an expensive job (browser-based E2E, full image builds) it is the single most wasteful default in a CI config.

The naive concurrency guard does **not** fix it:

```yaml
concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

`github.ref` differs between the two events (`refs/heads/<branch>` for push vs `refs/pull/<n>/merge` for pull_request), so the two runs land in different concurrency groups and never cancel each other. `cancel-in-progress` only dedups successive runs of the *same* event type.

**The fix — scope `push` to long-lived branches; let `pull_request` gate everything else:**

```yaml
on:
  push:
    branches: [main]      # post-merge validation on protected branches only
  pull_request:
    branches: [main]      # the gate for every feature branch
```

- A feature-branch push with an open PR now fires **only** the `pull_request` run (one run, not two).
- Pushes to `main` (post-merge) still get a `push` run, keeping the protected branch green.
- The `pull_request` run is also the *more correct* gate: it tests the branch **merged into the base**, catching semantic conflicts a raw branch-tip build misses.
- Trade-off (usually acceptable): a branch with **no PR yet** gets no CI until the PR opens. If pre-PR feedback matters, push to a `draft` PR instead of relying on branch-push CI.

**Audit every workflow, not just the main one.** This footgun tends to be copy-pasted: a repo's guard/lint/security workflow often carries the same `push: ['**']` + `pull_request:` pair (and frequently *without* even a concurrency block, so it also fails to cancel superseded runs). Grep all of `.github/workflows/*.y*ml` for the trigger pair and fix them together; give each workflow the same `concurrency` block with `cancel-in-progress: true` so fast-follow pushes don't queue duplicates.

### A Push Is Not a Deploy: Spend a Metered Deploy Quota on Purpose

Hosts meter deployments, and the meter counts every deployment *created*, not every one that built. Vercel Hobby allows 100 a day per account, and a BLOCKED, errored or cancelled deployment counts the same as a live one. With several agents pushing branches, per-push previews eat the quota, and once it is gone the production deploy after a merge cannot start for up to 24 hours. Mercaditos, 2026-10-29: 100 deployments in a day, 95 of which never built (88 branch previews and 5 production git deploys, all BLOCKED by a GitHub-account mismatch); the only 5 that shipped were started by hand.

- **Turn off deploys triggered by a push, on every branch** (Vercel: `"git": { "deploymentEnabled": false }` in `vercel.json`). Vercel reads the file from the pushed commit, so the rule takes effect on each branch once a commit carrying it reaches that branch: land it on the long-lived branches first.
- **Every deploy is one deliberate call.** Production gets one after each merge, for the merge SHA (CLI, API or MCP "create deployment"). A preview is made only when someone will look at it, and the link is sent to them.
- **Pushes become free.** Agents push whenever it helps (backups, review, handoffs) without spending the quota.
- **The merge is not done until it is deployed.** The manual deploy is the next step of the merge, in the same checklist as the post-deploy check (health endpoint reports the running SHA = the merge SHA; see "Committed Is Not Deployed"). A merge left undeployed is the failure mode this trade buys; the post-deploy check is what catches it.
- **Count before a heavy day.** List deployments since midnight (in the quota's time zone) and keep headroom for production.
- **Prove it** (see "Prove Your Guards Fire"): after the rule lands, push a throwaway branch and confirm no deployment was created.
- The same holds for any metered trigger: CI minutes, build credits, paid API calls fired by a webhook. Make the expensive action explicit rather than a side effect of a push.

### Code CI Runs Only for Changes That Touch Code

A PR that changes only prose (`*.md`, `docs/`, `.planning/`, design assets) cannot break a test, a type or a migration, yet a 40-minute integration/E2E job gates it like any code change. In a multi-session or multi-agent flow this compounds: a dozen small docs and report PRs queued behind the slowest job, each waiting an hour for a check that proves nothing. Gate the expensive jobs on the paths that can change behaviour.

- Put the path filter on the workflow (`paths-ignore: ['**/*.md', 'docs/**', '.planning/**']`) or detect changed paths in a first job and `if:` the expensive jobs on its output. Keep the cheap, always-relevant checks (PR conventions, secret scan, format) unconditional.
- **Required status checks and skipped workflows interact badly.** A workflow skipped by `paths-ignore` never reports its check, so a *required* check stays "Expected" forever and blocks the merge. Either make the job-level `if:` skip (a skipped job counts as passing for branch protection) or add a trivial always-running job with the same name that passes when nothing relevant changed.
- State the merge rule explicitly: "all jobs green" must read "all jobs that ran are green, and a job skipped by the path filter is acceptable". Otherwise agents and humans keep treating `skipped` as not-green and the filter saves nothing.
- Prove the guard fires (see below): one docs-only PR that skips the expensive job, and one code PR that runs it. A filter that also skips code changes is worse than none.
- Docs that are *tested* (a test that scans `docs/ops` for secrets, a doc-sync check, generated API docs) are code for this purpose: keep their paths out of the ignore list or keep that test in the always-run job.

### Committed Is Not Deployed

Anything that deploys on a path outside the app's CI — edge functions, cron definitions, dashboard-configured secrets — can be committed, reviewed, and locally green while the deployed artifact is weeks stale. A settlement function was committed and gated but never deployed (every call 404'd); an engine-version bump left the old deployed function deferring forever. For every out-of-band deploy path: (a) a post-deploy smoke test invokes the *deployed* artifact against a synthetic input and asserts real state changed, and (b) a version-drift healthcheck asserts the deployed version matches the repo — expose a health endpoint reporting the running commit SHA, and read it after every deploy.

### The Build You Tested Is Not the Build That Ships

Local build ≠ cloud build: an upload-filter rule (`.vercelignore`-class) dropped a source directory only in the cloud path, so the same commit built locally and failed deployed. Restored build caches can pair stale assets with fresh output — one served old font-CSS hashes against newly-rendered HTML, breaking every page on an unchanged SHA. When output breaks with no code change, suspect the cache first: force a no-cache rebuild, and clear derived artifacts after changing anything inlined at build time (public env vars). The deployed artifact is verified by observing it, not by the green local run.

### The Documented Override — and When It Becomes an Alarm

When the gate is red at ship time from a failure the change demonstrably didn't cause, blocking isn't automatically right. A healthy override is a recorded decision with four parts: the exact failing job; a **mechanical proof of pre-existence** (a command whose output shows the failing file is outside the change's delta — an assertion is not evidence); a scoped remediation ticket; and a precedent citation. But track the override *rate*: when CI was down for a month and every merge shipped on local verification, the safety valve became the failure mode — an entire test layer silently stopped running, and the next production post-mortem named "restore CI" as the single highest-leverage fix. One override is hygiene; a sustained pattern is a critical-infrastructure alarm.

### Prove Your Guards Fire

Automation that exists is not automation that works. A guard's bypass path read the wrong input source and could never activate; a path-scanning CI check passed vacuously after the files it scanned were moved — silently disarmed. Every guard is proven on both paths (blocks what it should block, passes what it should pass) at introduction and after any refactor of what it watches. Scanning guards assert they matched ≥1 file. Known-findings allowlists are **two-way ratchets**: a finding that disappears must also leave the allowlist, so every green run re-proves each entry is still detected.

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

**"Done" means wired end-to-end and observed.** A requirement marked Complete while its final wiring is "deferred to a later plan" is the most dangerous status in the tracker — the observed case was discovered dead the day after the one event it existed for, because the later plan was never written. A requirement is complete when the end-to-end path has been exercised and observed at the deliverable's altitude; one implemented layer plus a promissory note is *in progress*, whatever the tracker says.

**Verification claims name their evidence.** "Verified" backed only by unit tests and a typecheck on the layer you edited is a false claim — one post-mortem found "verified at altitude" written above an evidence list containing neither a running app nor a real read-back. A verification claim names the observed artifact: the e2e spec that ran, the screenshot, the read-back query, the health-endpoint SHA. No named artifact, no "verified".

### Release-Readiness Completion Comment

When the work is agentic, end every task with a **structured completion comment** that names each gate explicitly. Soft phrasing ("verify tests pass") lets agents skip whichever check is inconvenient; the named-section shape forces a pass-or-explicit-disclaim on each gate ("Telemetry: no event needed because…").

Template (agent fills each section; sections that don't apply get an explicit "n/a — <why>"):

```
## Release-readiness

- What was built: <one-line summary>
- Tests run: <commands + result>
- Coverage: <before / after, or "no coverage delta">
- Code-health: <before / after on the relevant scalar (CodeScene, etc.)>
- Lint / typecheck: <commands + result>
- CI pre-check: <make check or equivalent, result>
- Localization: <strings added / extracted, or n/a>
- Telemetry: <events added, or n/a — why>
- Refactors: <count + brief summary, or none>
- ADRs created: <list, or none>
- Docs updated: <files touched, or n/a>
- Migration safety: <migration added + downgrade path, or n/a>
- Outstanding: <known issues / follow-ups, or none>
```

The comment is the **receipt**, not the work — its purpose is to make every gate's status visible at the boundary of the task. Treat a missing section as a failed gate, not a stylistic omission.

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

Rules files are *one* codification surface, not the only one — a repeatable procedure belongs in a skill, reliable system access in an MCP tool, and a must-always-fire step in a hook. See §3 "Codify (Compound Engineering)" for the routing decision across all four surfaces.

**Skills earn their slot via use.** A skill with no invocation in ~14 days is a candidate for deprecation. Audit cadence: bi-weekly. See §18 "Skill Hygiene."

### AGENTS.md vs CLAUDE.md -- the ecosystem naming question

`CLAUDE.md` is Anthropic-specific; `AGENTS.md` is the tool-agnostic equivalent emerging as a cross-vendor convention (Aider, Open SWE, and several other frameworks already read it). They serve the same role: repo-wide context file the agent injects into its system prompt.

In practice you have three options:

1. **Maintain only `CLAUDE.md`.** Default for Claude-first shops. Forfeits portability to other agents.
2. **Maintain only `AGENTS.md`.** Portable across vendors; loses no functionality for Claude (Claude Code reads `CLAUDE.md` *and* `AGENTS.md` if present).
3. **Symlink one to the other.** `ln -s AGENTS.md CLAUDE.md` (or vice-versa). Lets a single canonical file serve both names. Most defensible default -- adopters across vendors get the same context, no duplication.

Until ecosystem naming settles, the symlink pattern is the cheapest hedge. Revisit when the convention stabilizes.

### Comments and Documentation as Leverage

LLMs give inline comments and documentation **far more weight than human engineers do**. A three-sentence description at the top of a file or schema can fix persistent agent style inconsistencies that code review alone cannot. This flips the traditional cost calculus:

- Write comments and docstrings as if an agent is your primary reader: be **precise and explicit**, not conversational
- Describe *why* a pattern exists, not just what it does -- agents use this to generalize correctly
- Update `CLAUDE.md` and rules files after every non-obvious decision; a stale guide is worse than none

This is especially important for unusual conventions. If your codebase uses a non-standard pattern (a JSON-columns SQL schema, a custom error hierarchy, a specific naming convention), three sentences describing it upfront will save hours of agent confusion.

### Domain Vocabulary as LLM Context

Code serves two purposes simultaneously: instructions to a machine, and a conceptual model of the problem domain. Vocabulary is not just labels -- it carries meaning, constraints, and design consequences. This distinction matters critically for LLM collaboration.

Precise, consistent vocabulary in code and prompts enables reliable LLM mapping of intent to implementation. Vague or inconsistent naming forces the model to guess intended designs -- and it will guess plausibly but wrongly.

**Maintain explicit domain vocabulary:**

- A `glossary.md` rules file listing domain terms with their precise meanings, constraints, and design consequences. Not just "what it is" but "why this boundary exists" and "what it must never mean."
- Consistent naming across code, API schemas, database columns, event names, test fixtures, and prompts. When the same concept has three names in three places, the agent picks one at random.
- Bounded context discipline: vocabulary that's stable in one domain context may be unstable in another. Document where terms apply and where they don't.

**The cognitive debt amplifier:** LLMs can introduce vocabulary faster than developers build understanding of it. Code that uses terms the team doesn't fully grasp is dangerous even if it compiles -- and agents will happily generate more of it. Vocabulary that exceeds team understanding is the subtler form of cognitive debt that fast AI generation amplifies.

### Recommended Rule Categories

| Rule File | Scope |
|-----------|-------|
| `principles.md` | Design principles that apply to all backend code |
| `api.md` | API route patterns, response models, middleware conventions |
| `db.md` | ORM models, migrations, constraint conventions |
| `glossary.md` | Domain vocabulary: precise meanings, constraints, bounded context boundaries |
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

### Configured Integrations at the Agent Boundary

When a managed integration (an MCP server, a platform CLI with stored auth) is already configured, expose it at the agent boundary so routine privileged operations flow through it — read-only operations freely, mutating ones behind an owner gate — instead of hand-rolled, key-bearing shell or REST calls scattered across sessions. This centralizes the audit surface and removes repeated secret-handling paths.

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
- **After context compaction**, re-read the task plan and relevant source files before continuing. This recovery step should be baked into CLAUDE.md itself as an explicit instruction (not just a guideline), so the agent always knows to re-orient before it fills in assumptions. Example: "After any compaction event, read task-plan.md first, then re-read the relevant source files for the current task before continuing."

### Context Architecture

| Layer | File | Loaded | Purpose |
|-------|------|--------|---------|
| Global | `~/.claude/CLAUDE.md` | Always | User preferences, tooling, cross-project conventions |
| Project | `CLAUDE.md` | Always | Project description, setup, commands, key decisions |
| Domain | `.claude/rules/*.md` | By file path | Deep context for specific subsystems |
| Memory | `.claude/memory/` | On recall | Learned preferences, feedback, project state |

### Shared Team Context

When context lives only in a developer's head -- or only in the prompts they type -- AI output quality scales with seniority. Senior developers get better results because they know what to ask for. Junior developers get worse results because they don't know what they don't know.

Shared, version-controlled context files break this dependency:

- **Consistency**: every developer's agent runs against the same conventions
- **Coherence**: outputs align with the codebase regardless of who prompted
- **Prompt independence**: quality doesn't depend on how well the developer phrases the request
- **Seniority independence**: junior developers get the same context layer as seniors

This is why team-level CLAUDE.md and `.claude/rules/` files are not a personal preference but a multiplier. A well-maintained shared context is the difference between AI lifting the whole team and AI amplifying only the people who were already strong.

### One File Per Deliverable

Each context artifact should live in its own file, referenced from a base document rather than inlined:

- `CLAUDE.md` points to domain rules; it doesn't contain them
- Tech specs, test standards, workflow definitions -- each in its own `.mdc` or rules file, loaded by file path when relevant
- One spec file per ticket; one plan file per execution unit

The anti-pattern: a single sprawling `CLAUDE.md` that grows to contain all knowledge. It becomes context pollution and makes it impossible to scope context to the current task. Progressive disclosure (below) is structurally impossible if everything is in one file.

### Progressive Disclosure for Rules Files

File-path scoping controls *which* rules files load. Progressive disclosure controls *how much* of each file loads. The two work together.

Structure rules files in three layers, from cheapest to most expensive:

1. **Compact config (<500 tokens)** — machine-readable frontmatter or a short JSON block covering the most common defaults. Handles 80% of tasks at minimal cost.
2. **Pattern summary (<300 tokens)** — distilled list of key patterns and invariants for this domain. Loaded when Layer 1 is insufficient.
3. **Full documentation (up to 3K tokens)** — complete reference with examples. Only loaded for deep or unfamiliar tasks.

A **content router** selects depth based on task keywords: when the task mentions a concept the domain file covers, escalate to the next layer. Simple tasks get Layer 1; complex or novel tasks reach Layer 3.

In practice: write your rules file so the first section is dense and self-contained (Layer 1), followed by a summary block (Layer 2), with full narrative and examples below (Layer 3). The agent can stop reading at the right depth.

"A rules file is not a manual — it's a routing table for the agent's attention." Loading 3K tokens of rules for a task that needs 200 is context pollution (§8). Progressive disclosure is the structural fix.

**External validation (2026-05-26).** Tharlq's Anthropic-internal skills practice independently arrives at the same structure: top-level skill body stays small (Layer 1 / Layer 2), deeper material lives in sibling files Claude loads only when the task escalates (Layer 3). The pattern is structural, not idiosyncratic -- two independent practitioners converging on the same three-layer shape is a strong signal that "load exactly what the task needs" is the right design constraint for context-aware authoring.

### Designing Skills

A skill is **a folder, not a markdown file.** The markdown body is the trigger; the folder can carry scripts, assets, data, hooks, and configuration. The interesting skills hide most of their machinery behind the body -- the body just orients Claude to what's there.

Five rules that compound:

- **Don't State the Obvious.** A skill's job is to push Claude *out* of its default behavior, not duplicate it. If a paragraph describes something Claude would do anyway, delete it.
- **Carry a Gotchas section.** Real failure points the first invocations expose belong in the skill -- not in the user's memory. Update over time as new gotchas surface. The Gotchas section is what separates a reusable skill from a one-off prompt.
- **Description = router prompt.** The agent only sees skill descriptions at session start to decide which skills to invoke. Phrase the description as a question Claude asks itself about its current task ("Use this when X"), not as a label ("This is the X skill").
- **Avoid railroading.** Skills are reusable across contexts; over-specific step sequences ("first do A, then B, then C") fight that. Describe the outcome and the constraints, let Claude pick the path.
- **Progressive disclosure via the file system.** Top-level body stays small; deeper material (examples, error catalogues, reference data) lives in sibling files the skill points at. Claude pulls them in when the task needs them.

### On-Demand Hooks

Hooks don't have to be global. A hook scoped to a specific skill's session activates only while that skill is loaded -- and then unloads with it. This is the right shape for high-effort safety guards that matter in some contexts but would be noise everywhere else.

Concrete pattern: a `/careful` skill carries a `PreToolUse` hook that blocks `rm -rf`, `DROP TABLE`, `git push --force`, `kubectl delete` for the duration of the skill's session. Outside `/careful`, the same commands run normally -- the user opted into the heavyweight check by invoking the skill.

The general principle: **the cheapest place to enforce a guard is at the same scope as the work the guard protects.** Global PreToolUse hooks fire on every tool call across every session; per-skill hooks only fire when the user has explicitly entered the high-stakes context.

### Stop Hooks as Completion Gates

`PreToolUse` blocks a specific *action* before it happens. A `Stop` hook blocks the *declaration of completion* itself -- it fires when the agent decides it's done, and can force it to keep working. This is the deterministic enforcement mechanism the Definition of Done (§16) needs: the checklist says what "done" means, the Stop hook is what actually stops the agent from self-certifying past it.

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "[ \"$(jq -r '.stop_hook_active')\" = true ] && exit 0; <your-check-command> || { echo '<what failed and why>' >&2; exit 2; }"
      }]
    }]
  }
}
```

**The `stop_hook_active` check is not optional.** When that flag is `true`, a previous Stop hook already forced a continuation this turn -- skip the check and exit 0, or the agent gets trapped in an infinite fix-stop-block cycle. This is the one line every Stop-hook example that gets shared around tends to omit.

The `PreToolUse` pattern above also generalizes past *command-name* blocking (`rm -rf`, `DROP TABLE`): it can inspect the actual *content* of a `Write`/`Edit` call (`.tool_input.content` / `.tool_input.new_string`) and block on a pattern match. That turns a written convention -- "don't use a raw `<input>` tag, use our design-system component" -- into something enforced at the point of writing, not caught at review.

**Exit-code contract**: `exit 2` blocks the action or the Stop, feeding the hook's stderr back to the agent as corrective instruction; `exit 1` only logs a warning and lets it proceed; `exit 0` passes silently. Test every `jq` path against a real hook payload before trusting it -- a wrong path returns `null` silently, so the hook looks wired up while enforcing nothing.

Source: zarar.dev, "Don't rely on instructions, use Agent Hooks to enforce guardrails" (2026-06-20) -- CLAUDE.md/AGENTS.md instructions get ignored by agents "half the time"; hooks are the deterministic alternative. See [[wiki/sources/zarar-dev-agent-hooks-deterministic-guardrails-for-ai-generated-code]].

### Skill Hygiene

The skill registry rots the same way CLAUDE.md does: skills accumulate faster than they get retired. A skill that hasn't been invoked in two weeks is a candidate for one of three outcomes -- kept with documented rationale, deprecated, or merged into a related skill.

Bi-weekly audit pattern: instrument skill invocations via a PreToolUse hook that appends to `.claude/state/skill-usage.jsonl`, then on a cadence list every skill with no recent invocation. The audit isn't auto-deprecation -- it's surfacing what isn't earning its slot so taste decisions can be made deliberately.

This pairs with the "spa day" pattern (below) -- skill hygiene is the "identify what's not being used"; the spa day is the "clean up what's inconsistent." Different signals; complementary cadences.

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

### Time to a Correct Result Is the Metric

**Time matters: do not spend time that can be avoided, and the earlier a correct result is obtained, the better.** Correctness is never traded for speed, but waiting is a real cost, not a neutral default. An agent or a coordinator that leaves work idle "to be safe" has to name what the wait protects.

- **Run heavy jobs in parallel by default.** Builds, test gates, Docker parity batches and offline suites run at the same time when they do not contend. Give each its own volumes, container or compose project name, and its own worktree. A strict one-at-a-time queue is the exception, not the rule.
- **Serialize only for a named contention.** Two runs that hit the same live database at once (statement timeouts), a shared port or container name, or a machine out of memory are reasons to queue. "Something might interfere" is not. Check the machine (load, free memory, `docker stats`) before stacking more, and say which resource the queue protects.
- **Don't wait for the next scheduled run to confirm a change.** If a deploy can be verified now with an on-demand, scoped run (a single source, a single job), do that instead of waiting for tomorrow's nightly. Batch the changes the run should prove, so one run confirms them all.
- **Keep idle sessions assigned.** When a session finishes and its next task is unblocked, dispatch it at once. Stack dependent work on the open branch rather than waiting for a merge, when the merge order is safe.
- **Ask once, then act on standing rules.** Re-asking the owner for something already granted (a merge on green, a push, a pre-approved deploy) spends their time and the session's. Record the standing rule and stop asking.

### Bracket Agents, Don't Watch Them

Run agents on a **maker/manager schedule**: define clear start and end conditions per session, then bracket the work with a scheduled review block (e.g., 4pm daily) rather than monitoring continuously. Continuous watching activates the same variable-reward attention-economy dynamic as doom-scrolling and drains the cognitive reservoir you need for the parts of the work agents *cannot* do — direction-setting, taste, judgment on the next-step decisions that determine whether the work was worth doing.

The pattern in three rules:

1. **Define the start condition explicitly.** The agent gets a brief that names the goal, the constraints, and the verifiable success criteria (per "Spec the Outcome, Not the Process" in §3). Vague briefs invite continuous nudging.
2. **Define the end condition explicitly.** "Stop when all tests pass and the release-readiness checklist is filled in" is a brakeable condition. "Stop when it looks good" is not.
3. **Schedule the review block.** Block 30-60 minutes at a fixed time of day to review every running session's output in one pass. Between review blocks, do not check sessions — if a session is genuinely stuck, the next review will catch it; if not, the review block is when intent gets re-applied.

The discipline pairs naturally with cadence (§2) — agents committing every 20-30 minutes produce a clean reviewable history at the next review block. Without cadence, the review collapses into archaeology over a giant uncommitted diff.

### The 40-20-40 Attention Budget

A coarse target for how human attention splits within an agent-assisted session: **40% context-setting, 20% generation and testing iteration, 40% reviewing and verification.** Most of the work is at the boundaries — preparing the agent and verifying its output — not in the middle where the agent runs.

This is a heuristic from one practitioner, not a controlled measurement. Useful anyway because it forces the same question that "Don't mistake faster coding for faster delivery" (Anti-Patterns, below) raises at the org scale — *where does the wall-clock actually go?* — but at the practitioner-day scale.

Two failure modes the budget surfaces:

- **Skipping the front 40%.** Going straight to generation without context-setting (skills, rules, task brief, neutral prompts) produces work the agent had to guess at. The 19% slower / 45% security-flaw findings cited in §5 (METR/Anthropic, Stanford) are the downstream cost.
- **Skipping the back 40%.** Shipping agent output without review-time is the "delegate the actual work to other people" anti-pattern (below). Generation is the cheap part; verification is the load-bearing part.

Pairs structurally with "Bracket Agents, Don't Watch Them" (above): bracketing tells you *when* attention lands; the 40-20-40 budget tells you *where* it lands within the bracket.

**Self-audit smell:** if your own attention split is closer to 10/60/30, the productivity win is illusory — you're producing more code with less review, not better outcomes. Treat the ratio as a numeric ratchet (§8): track your own split, move it toward 40-20-40 over time, never let it regress.

### Ablate at PR Granularity

Every meaningful change to the agent's *context* — skill edits, rules-file additions, prompt template tweaks, system-prompt updates — ships with a numeric before/after delta on a fixed evaluation set, in the PR description. Without this, "I improved the docs" is unfalsifiable, and the surprisingly common case where a well-intentioned addition makes things worse goes undetected until a downstream regression surfaces it.

The discipline mirrors §8's ratchet effect, but applied to agent-context rather than code-quality:

- **Hold the eval set fixed.** A few dozen offline cases that represent the work the agent actually does. Each case has a verifiable pass/fail (or a graded score). Eval cases earn their slot via use; cases that never fail get pruned.
- **Run before, edit, run after, ship the delta.** The PR description includes the slice-level result. A change that regresses is rejected at review the same way a change that fails CI is rejected.
- **Keep a short list of what didn't work.** Negative results are cheap to record and prevent the next person from re-running the same experiment. Examples worth recording: prompt iterations that hit three consecutive net-negative cycles, swaps to cheaper models that lost accuracy without saving latency, doc additions that increased confusion without improving outcomes.

This is the operational signature of treating agent context as engineering work, not docs work. The eval set is the test suite for the prompt; the ablation is the red/green of context engineering. Pairs with §17 "Rules Files as a Knowledge Hoard" — the hoard earns its slot via measured uplift, not by feeling thorough.

### Subagents for Large Codebases

On large codebases, codebase discovery is expensive in tokens. Use subagents for exploration and token-heavy operations to preserve the root agent's context window.

Claude Code's Explore subagent dispatches a fresh copy with its own context window to map the codebase, returning only the relevant findings. The root agent spends its context on implementation, not discovery.

Parallel subagents can also run independent file edits simultaneously -- potentially using cheaper models (Haiku) for cognitively simple but token-heavy operations like finding and updating all affected templates.

**The main value of subagents is preserving the root context and managing token-heavy operations.** Don't dispatch subagents for tasks that benefit from continuous context.

### Initialize Claude in Subdirectories, Not the Repo Root

In large codebases (monorepos, multi-package repos, layered architectures), start Claude inside the subdirectory you're actually working in — not at the repo root.

Claude Code walks **up** the directory tree from the working directory and loads every `CLAUDE.md` it encounters. Starting in a subdirectory composes the layered context the right way (`subdir/CLAUDE.md` + parent + root) without dragging in irrelevant context from sibling directories you aren't touching.

Practical consequences:
- **Scope test and lint commands per subdirectory.** A repo-root `make test` that runs everything will timeout and waste context on irrelevant output. Each subdirectory's `CLAUDE.md` should declare the test/lint command for its scope.
- **Layered CLAUDE.md files become the norm, not the exception.** Root file holds pointers and critical cross-cutting gotchas only. Subdir files hold local conventions, commands, and patterns.
- **Skills and rules can be path-scoped** to subdirectories so they only activate where relevant — see §17 Rules Files as a Knowledge Hoard.

If you find yourself routinely starting Claude at the repo root and immediately `cd`-ing into a subdirectory, that's a smell: the root CLAUDE.md is probably too heavy, or you're missing a subdir-level CLAUDE.md that should exist.

### Neutral Prompting

AI agents are designed to please. If you say "find me a bug in this module," the agent will find one -- even if it has to invent it. Work with this, not against it:

- **Use neutral prompts for investigation**: "Analyze the logic of this module and report all findings" instead of "Find the bug."
- **Use directed prompts for implementation**: "Implement JWT authentication with bcrypt-12 hashing and 7-day refresh token rotation" is better than "Build an auth system."
- **Never ask leading correctness questions**: "Is this correct?" will almost always get "yes." Instead: "Walk through this implementation step by step, state what each part does, and flag anything inconsistent."

### Constrain the Harness, Don't Trust the Model

The safest agent is the best-constrained *system*, not the most capable model. The CI-Work benchmark (Fu et al., 2026-05) found that more capable models leak *more* contextually-inappropriate data, and — counterintuitively — that steering an agent toward specific sources or telling it to "be thorough" nearly *doubled* the contextual-integrity violation rate while reducing useful output. Two consequences:

- **Beware "check everything / be thorough" in sensitive contexts.** A well-intentioned thoroughness instruction is also an instruction to surface material that shouldn't cross a boundary. Scope the ask to the task; don't reflexively widen it.
- **Filter before the prompt window, not after.** Least-privilege access plus context-aware, role-conditioned filtering applied *before* data reaches the model is the load-bearing control — you cannot prompt your way to safety on an over-provisioned context. This is "Standards Live in Tooling, Not Reviews" (§8) applied to data access: the guarantee lives in the harness, the prompt is best-effort.

### Anti-Patterns

**Don't file PRs with code you haven't reviewed yourself.** If you open a PR with hundreds or thousands of lines an agent produced, and you haven't done the work to verify it's functional, you are delegating the actual work to other people. They could have prompted an agent themselves. What value are you even providing?

A good agentic PR:
- **Works, and you are confident it works** -- you've run it, not just read it
- **Is small enough to review efficiently** -- several small PRs beats one large one; agents make splitting easy
- **Includes context** for the higher-level goal it serves
- **Has a PR description you've read** -- agents write convincing-looking descriptions; review them too

Include evidence you've done the review work: notes on manual testing, comments on implementation choices, or screenshots of the feature working. This signals to reviewers that their time won't be wasted.

**Don't use cheap models for agent work during the adoption phase.** Cheaper models don't just produce worse results -- they teach you the wrong lessons about what agents can and can't do. You'll conclude agents are incapable of things frontier models handle easily. Pay for frontier models until you have a calibrated sense of their actual limits.

**Don't mistake faster coding for faster delivery.** AI reduces time-in-code, not time-in-review. Each approval layer multiplies wall-clock time ~10x regardless of how fast the code was written -- a 30-minute bug fix becomes a 5-hour task with peer review, a week with a design doc, 12 weeks with cross-team sign-off. If AI makes coding 10x faster but review layers stay the same, the result is larger batches of unvetted work arriving at unchanged queues, not faster delivery. Speed the coding; redesign the review structure.

### Measure Outcomes and Comprehension, Not Output Volume

Once generation cost trends toward zero, the artifacts AI inflates — PRs, lines, commits, test count — stop being velocity signals and become exactly the proxies most vulnerable to gaming. What stays scarce is judgment, learning, and system understanding. Instrument those.

- **Learning speed is the bottleneck.** When coding cost drops toward zero, the constraint becomes figuring out what is actually true (Wolff, Anthropic, "Engineering at AI Speed," 2026-05). Measure and shorten *time-to-learn* — feedback-loop latency, p95 CI/review turnaround, cycles-to-correct-requirement — not artifacts produced.
- **Metrics come in opposed pairs.** Never instrument a speed/volume signal without a paired quality/maintainability counter-metric that would move the *opposite* way if quality degraded — so the pair, read together, is gameable only by genuinely improving both (Reock, DX, "Leadership in AI-Assisted Engineering"). A single target gets gamed: mandate "100% AI utilization" and you get README-touch-on-Monday. Read a constellation of metrics in tension (SPACE; DX Core 4: Utilization → Impact → Cost), never a single dimension.
- **The counter-metric for delivery velocity is comprehension.** Delivery metrics (DORA's four) measure work flowing through the pipe, not whether anyone can explain what is in it — and AI widens that "legibility gap" by shipping code nobody fully understands. The numbers stay green while you can roll back but can't diagnose (LaPosta, LeadDev, 2026-05). Two instruments: (a) attach a **scope note** to each critical-system metric review — metric definitions, risk tolerance, dependency chain, out-of-band change surface, and at least one recent incident narrative; (b) run the **legibility test**: "how many people can explain this system end-to-end, in plain language, in under five minutes?" Two or fewer is a succession crisis, not a knowledge-concentration problem. (See §9 Observability.)

This is the org-scale form of "Don't mistake faster coding for faster delivery" (above) and the §8 ratchet carve-out: ratchet outcomes and comprehension, never the volume AI makes cheap.

### Teaching Through Feedback

When Claude does something wrong, correct it explicitly and explain why. When it does something right that wasn't obvious, confirm it. Both corrections and confirmations become memory that shapes future behavior.

Periodically review and consolidate your rules, removing contradictions and pruning stale instructions. If the agent needs to read too many files before starting, it's time for a cleanup.

**Cadence: every 3–6 months.** Instructions tuned for an older model generation can become unnecessary or actively constraining as capabilities improve. Set a calendar reminder. A rule that says "always remind the agent to run tests before claiming done" was load-bearing in 2024 and is noise in 2026 — the current models do it unprompted. A rule that says "avoid this specific deprecated API" stays load-bearing forever. The review separates the two.

**The "spa day" pattern:** don't do this cleanup yourself — delegate it. Tell the agent: "Go through all rules and skills files, identify contradictions, and propose a consolidated version with my updated preferences." The agent is better at spotting its own contradictions than you are at spotting them from the outside. After a spa day, performance returns to baseline and context stays lean. Run this whenever you notice the agent hedging, asking redundant clarifying questions, or producing inconsistent results across similar tasks.

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

### Agent Memory Is Point-in-Time

A note an agent (or you) wrote about project state was true when written and goes stale silently: a task was dispatched to "apply the 159 unapplied proposals" that had in fact been applied two weeks earlier; a decisions log still said a feature was deferred long after it shipped. Any recalled note asserting "X is (not) done" gets re-verified against ground truth — git, the live file, the running system — before it drives work. Notes are leads, not facts.

### Your Tooling Can Lie to You

Wrappers, shims, and output-filtering proxies between the agent and the real tool can fake success: a build shim returned a plausible 194ms "success" without building anything (e2e then ran stale code); an output-optimizing hook reported "No issues found" while dropping the warnings, and truncated the test log that contained the failure. When a result is load-bearing, bypass to the real binary and read machine-readable ground truth (exit codes, the runner's result file) — not the wrapper's prose. Scope convenience wrappers narrowly, and add a tripwire that detects when they eat signal.

### Harden for Headless

Agent and CI contexts have no human at the keyboard: anything that can prompt interactively (credential helpers, first-run wizards, TTY confirmations) hangs forever there — give every automated path a non-interactive override. Background processes spawned by a subagent die when the subagent returns; run long jobs from a context that outlives them. And watch static context weight: a planning file that doubled to 61KB pushed subagent dispatches past their stream timeout — context bloat shows up as infrastructure failure, not just degraded output (see Context Discipline above).

### Deterministic Middleware as Agentic Safety-Net

The agentic loop is creative; the load-bearing steps in a workflow are not. Production internal coding agents (Stripe Devin, Ramp's OpenCode-composed agent, LangChain's Open SWE) converge on the same pattern: **deterministic middleware wraps the loop and guarantees the critical steps fire** even if the loop wanders off.

Concrete examples from Open SWE:

- `check_message_queue_before_model` -- injects pending messages into the agent's input on every iteration; the loop can't lose user input.
- `open_pr_if_needed` -- runs after the loop completes and opens a PR if one is still missing; the loop can't forget the load-bearing final step.
- `ToolErrorMiddleware` -- catches tool errors and either retries or escalates; the loop can't silently swallow a failed write.

The general principle: **agentic for the creative work, deterministic for the load-bearing steps.** Anywhere a step is "must happen, no exceptions" -- open the PR, run the migration check, write the audit log -- that step belongs in a hook or middleware, not in the agent's prompt. The prompt is best-effort; the middleware is guarantee.

This complements the Ratchet Effect (§8) and the Definition of Done (§16): both rely on something deterministic firing at the right moment. Middleware is the implementation; ratchet/DoD are the specifications.

### What to Delegate vs. What to Direct

- **Delegate**: Research, boilerplate, test generation, documentation updates, refactoring within established patterns
- **Direct**: Architecture decisions, new patterns, security-sensitive code, non-obvious business logic
- **Separate research from implementation**: If you don't know the exact approach, run a research task first. Then start a fresh session to implement. Mixing research and implementation pollutes context with discarded alternatives.

---

## 19. Consuming External Data & APIs

§14 covers serving APIs to agents; this section covers the reverse dependency — your system consuming a third-party feed. External data is untrusted input that *drifts*: fields move, values arrive in undocumented shapes, timestamps get revised, entities get renamed.

### Join on the Most Stable Key

Match external entities by their canonical external ID first, with content-based matching (timestamps, name pairs) only as ranked fallbacks. A knockout match froze for seven hours because ingest matched candidates by kickoff timestamp and the provisionally-seeded time had drifted an hour from the provider's real one — the row fell out of the candidate set entirely. Display names are worse: they get renamed both upstream and by your own UX. Never join on them, and never select records by parsing a human label or scanning an ID range.

### Declare the Full Consumed Surface

Schema validators that strip unknown keys (Zod-style) turn upstream contract drift into silent data loss: the live score lived in a field the schema never declared, so validation deleted it and the UI showed "–" for the whole match. Declare every field you consume; validate incoming payloads against known-value sets at ingestion; alert on shape drift before it corrupts state.

### Upstream Semantics Are Assumptions Until Observed

The docs said one thing; the live feed dropped a match from its "live" set the instant it finished, freezing the state machine pre-terminal. Verify semantic assumptions against captured real payloads, not documentation — and **store raw responses** (a rolling window is enough) so diagnosing the next drift is a query, not a guess.

### Syncs Reconcile — They Don't Just Insert

An insert-only upsert accumulated stale rows for every entity the provider re-keyed; the naive fix (update everything) corrupted rows that carried local meaning. A sync must reconcile: update what changed, by stable key, with explicit rules for which fields are provider-owned vs locally-owned. And create-time-only propagation (copy-on-join, broadcast-on-submit) can never populate state that arrives later — pair it with an explicit retroactive backfill path.

---

## 20. Debugging Discipline

### Reason from the Mechanism, Not the Error String

Pattern-matching an error message to a known failure produces confident wrong fixes: a "flaky CDN" install hang was a deterministic version-pair deadlock; a cloud-build failure was misdiagnosed three times before a one-line ignore rule was found. **"Flaky" is a deterministic bug you haven't isolated yet** — until proven otherwise. Reproduce the mechanism before shipping the fix.

### Never Verify Against Your Own Derived Output

Circular verification is the debugging analogue of the tautology test (§5): a bracket was "verified correct" against pairings derived from the same scrambled data it was meant to validate — the check could not fail. Validate derived state against an independent source of truth: the upstream payload, a golden fixture, a hand-computed constant.

### Reproduce on the Untouched Baseline

Before blaming your change for a red, stash and re-run on the baseline. Before blaming the code for broken output on an unchanged SHA, suspect the cache and the toolchain (§15, §18): a forced no-cache rebuild and a real-binary bypass are cheap eliminations. Know which checks are ordering-sensitive (a bundle-scanning guard needs a build first) so you don't chase environment artifacts as regressions.

### A Fix Without a Tripwire Is Half a Fix

When tooling or config was the root cause, restore the broken capability *and* add a tripwire that detects the failure mode's return — don't paper over with a workaround that hides the class (a `page.reload()` in an e2e masks the hydration bug it was added to survive). Durable fix + detection beats fast workaround every time the bug class recurs. And when you fix any bug, grep for its twin before closing (§5).

---

## 21. Decommissioning & Hibernation

A project that stops operating deserves the same engineering as one launching. Ad-hoc teardown leaks money, deletes the wrong things, and turns revival into a re-discovery project.

### Shutdown Is a Runbook, Not a Session

Write the mothball runbook before mutating anything, and make it the single source of operational truth for the dormant period: what stays up, what's disabled, what's deleted, where the backups live, and the revival sequence.

### Inventory the Live System First

Read the *live* infrastructure — actual scheduled jobs, actual billing tier, actual storage — before acting on what the docs say. Teardown is when documented assumptions meet reality: the "free tier" project had been silently on a paid plan for months; job IDs had drifted from what the migrations implied. Never trust the doc's numbers for a destructive operation.

### Disable, Don't Delete — Except Where the Law Says Otherwise

Prefer reversible off-switches (`active = false`) over deletion. But identify the compliance-load-bearing automation first: the data-erasure job that fulfills deletion requests **stays on** while everything else goes dark. Legal obligations don't hibernate.

### Exports, Backups, and the Revival Path

Export what can't be regenerated (auth users, secret/vault inventories, env configs) — encrypted, stored *outside* the repo. Prune before downgrading (a 1.1GB log table shrank to 31MB and made the free tier viable). Then write the revival playbook while the knowledge is fresh: every gotcha paid for in production (deploy order, secret wiring, version pins) is front-loaded there instead of re-purchased at wake-up.

---

## 22. Key Decisions Log

Maintain a "Key Decisions" section in CLAUDE.md that captures important architectural choices and their rationale. This serves as quick context for anyone (human or AI) working on the project.

Format:
```markdown
## Key Decisions

- **Decision name:** Brief description of what was decided and why
- **Another decision:** Context and rationale
```

Update whenever a non-obvious architectural choice is made. The goal is to prevent future contributors from re-debating settled decisions or accidentally violating design constraints.

**Decision records go stale — verify before relying.** A decisions log said OAuth was deferred months after it shipped; a project doc claimed a free tier while billing said otherwise. A decision record captures *why* something was chosen at a point in time, not what is true now — before acting on one, verify current state against ground truth (the code, the console, the live page). Keep settled facts and open hypotheses visibly separate; an unverified hypothesis that reads like a fact will eventually be treated as one.

---

## 23. Project Initialization Checklist

Not every project needs all 23 sections from day one. Start with the essentials; add process as the project grows. The ratchet effect applies here too.

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
- Choosing test cases: test the requirement not the code's assumption; test the seam with a single source of truth; include the default/fallback/degenerate-but-valid case; coverage measures lines not inputs; prefer authoritative validation over shape regexes; grep for the bug's twin before closing
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
- Codify: the explicit final phase (discuss → plan → execute → verify → codify); encode each learning into the right surface -- rules, skills, MCP tools, or hooks -- so a future agent loads it automatically
- Stop hooks are what make Definition of Done load-bearing: a hook that gates the agent's own completion declaration on a real check, not a checklist it can talk itself past -- must check `stop_hook_active` or it infinite-loops
- The code-is-cheap habit recalibration: fire off prompts for micro-decisions that used to cost an hour
- Parallel agent sessions: one engineer can now implement, refactor, test, and document simultaneously
- Building agent capability intuition is a deliberate practice (the AGI-pilled loop) -- not a personality trait
- Start lean, add process as the project grows -- not every project needs everything from day one
- Progressive disclosure for rules files: structure as 3 layers (compact config → pattern summary → full docs); content router selects depth by task keyword; a rules file is a routing table, not a manual
- Faster coding ≠ faster delivery: each review layer multiplies wall-clock time ~10x regardless of coding speed; redesign review structure, not just coding speed
- The 40-20-40 attention budget: 40% context-setting, 20% generation, 40% review — most of the work is at the boundaries, not in the middle where the agent runs; track your own split as a numeric ratchet
- Verify at the effect, not the trigger -- a scheduler's "succeeded" proves the trigger ran; read back the state change, and treat zero-work-in-an-active-window as an anomaly
- A green test can lie -- stale-contract, bug-pinned-as-feature, and tautology tests certify regressions; a test is evidence only if it could have been red
- Committed is not deployed -- out-of-band deploy paths need post-deploy smoke tests and a version-drift healthcheck; the tested build is not always the shipped build
- Degraded paths fail loud -- error states are distinguishable from empty; handled errors still reach telemetry; multi-layer invariants change in lockstep
- External feeds drift -- join on stable keys, declare the full consumed surface, store raw payloads, reconcile instead of insert-only
- "Done" means wired end-to-end and observed -- no promissory notes; verification claims name their evidence artifact
- Shutdown is engineering too -- inventory the live system, disable don't delete, keep compliance jobs on, write the revival playbook

---

## Changelog

### v1.3.3 (2026-10-30) — a push is not a deploy

- §15 gains "A Push Is Not a Deploy: Spend a Metered Deploy Quota on Purpose". Turn off push-triggered deploys on every branch; each deploy (production after a merge, a preview someone will look at) is one deliberate call; a merge is done only when deployed and checked. From Mercaditos hitting Vercel Hobby's 100-a-day cap with 95 deployments that never built (owner decision, 2026-10-30).

### v1.3.2 (2026-10-27) — full E2E once per phase

- §5 gains "Full E2E Suite Once per Phase, Targeted Runs per Wave". Each wave runs the quality gate plus the E2E specs its diff touches. The full suite runs once per phase before the final merge, or earlier when a wave touches shared surfaces. A gate is not re-run on a tree it already passed on. From the TCC Pulse coordination (owner decision, 2026-10-27).

### v1.3.1 (2026-10-18) — time to a correct result

- §18 gains "Time to a Correct Result Is the Metric": heavy runs in parallel by default, serialize only for a named contention (live database, port, memory), confirm a deploy with an on-demand scoped run instead of waiting for the nightly, keep idle sessions assigned, act on standing rules instead of re-asking. From the TCC Phase 46 coordination (owner instruction, 2026-10-18).

### v1.3.0 (2026-07-20) — the Pencadores harvest

Full-lifecycle distillation of a second project (a WC2026 prediction app: init → public launch → live tournament operation → decommissioning). Sources: 159 consolidated teach proposals, two forensics reports (2026-06-16 false-done, 2026-06-29 knockout save-trigger), the champion-settlement post-mortem, the pipeline-resilience proposal set, milestone audits v1.3/v1.4, the mothball runbook, and 52 persistent-memory lessons.

**Three new sections (Operations group):**
- §19 Consuming External Data & APIs — stable-key joins; declare the full consumed surface (strip-mode validators turn drift into silent data loss); upstream semantics verified against captured payloads; raw-payload retention; syncs reconcile, never insert-only; create-time propagation needs a retroactive backfill path
- §20 Debugging Discipline — mechanism over error-string ("flaky" is deterministic until proven otherwise); no circular verification against your own derived output; reproduce on the untouched baseline; suspect caches/shims on unchanged-SHA breakage; a fix without a tripwire is half a fix
- §21 Decommissioning & Hibernation — shutdown as a runbook; inventory the live system before mutating; disable-don't-delete except compliance jobs; encrypted off-repo exports; prune before downgrade; revival playbook
- Key Decisions Log and Project Initialization Checklist renumbered to §22/§23

**Augmentations:**
- §2: squash-merges break three-dot diffs — check the real delta with two-dot form
- §3: confirm the architecture with the owner, not the library's headline pattern; Milestone Exit Audit (3-source cross-reference; prod uptime compensates, never substitutes; reconcile external trackers)
- §5: "A Green Test Can Lie" (stale-contract, bug-pinned-as-feature, tautology); rare/one-shot paths get no incidental coverage — rehearse them deliberately; flakes nobody owns compound forever
- §7: sibling parity is a hypothesis, not verification; stubs and dead levers read as "done" in review
- §8: enforce invariants at every layer and change all layers in lockstep; one source of truth per displayed value; functional core, imperative shell; client-supplied values are hints, never authorization
- §9: verify at the effect, not the trigger; degraded paths fail loud (error ≠ empty, discriminated results, telemetry for handled errors); match the verification layer to where the bug class lives
- §10: know the target before you run — read the script, not its name; dangerous targets are opt-in
- §11: column before code; corrections are new forward-only idempotent migrations; in-place replace drops what you don't restate; contract-test caller roles
- §15: committed is not deployed (post-deploy smoke + version-drift healthcheck); the tested build ≠ the shipped build (upload filters, poisoned caches); the documented override and its alarm threshold; prove your guards fire (vacuous pass, two-way ratchet)
- §16: "done" means wired end-to-end and observed — no promissory notes; verification claims name their evidence
- §17: configured integrations at the agent boundary instead of key-bearing shell calls
- §18: agent memory is point-in-time — re-verify against ground truth; your tooling can lie to you — read machine-readable ground truth; harden for headless (non-interactive overrides, background-process lifetimes, context weight as an infra failure)
- §22 (Decisions Log): decision records go stale — verify before relying; separate settled facts from open hypotheses

> **Merge note (2026-07-20):** v1.3.0 was authored upstream in parallel with v1.2.9–v1.2.13 below, on the same v1.2.8 base — both lines bumped the same version numbers for different content. Renumbered the local line to v1.2.9–v1.2.16 in chronological order so the sequence is unambiguous; no content was dropped.

### v1.2.16 (2026-07-06)

**§18 Collaborating with AI — new subsection under "On-Demand Hooks":**
- Added "Stop Hooks as Completion Gates" -- a `Stop` hook gates the agent's own completion declaration on a real check (test suite, lint, a specific regression test) rather than the agent's self-report, closing the gap "Deterministic Middleware as Agentic Safety-Net" (v1.2.8) left open: middleware guarantees mid-loop steps fire, but nothing previously guaranteed the *final* "I'm done" declaration was checked. Documents the `stop_hook_active` infinite-loop trap (must exit 0 when true, or a forced continuation loops forever), generalizes the existing "On-Demand Hooks" PreToolUse pattern from command-name blocking to tool-input-content blocking (grep `.tool_input.content`/`.new_string` for a banned pattern), and states the exit-code contract (2 = block + feedback, 1 = warn, 0 = pass) explicitly for the first time in this doc.
- Added a Summary bullet cross-referencing Definition of Done (§16): the checklist specifies what "done" means, the Stop hook is what actually enforces it.

Source: zarar.dev, "Don't rely on instructions, use Agent Hooks to enforce guardrails" (2026-06-20) -- CLAUDE.md/AGENTS.md guardrails get ignored by agents "half the time"; the article's two worked examples (PreToolUse content-blocking, Stop-hook test-gating) are both directly actionable patterns this doc didn't have. Ingested 2026-07-06, [[wiki/sources/zarar-dev-agent-hooks-deterministic-guardrails-for-ai-generated-code]].

### v1.2.15 (2026-06-11)

**§3 Planning & Execution — "Compound Engineering" renamed and expanded to "Codify (Compound Engineering)":**
- Names Codify as the explicit final phase of the development loop (discuss → plan → execute → verify → codify) — the step is now visible at the workflow level rather than buried as an afterthought.
- Broadens the codification *surface* beyond rules files to four targets, with a routing rule for matching the artifact to the learning: rules files (conventions/examples), skills (repeatable procedures), MCP tools (reliable system access), hooks (must-always-fire steps). The closing question — "what did I learn, and which surface makes a future agent load it automatically?" — earns the rename with a content delta, not just new vocabulary.
- Added a cross-reference from §17 "Rules Files as a Knowledge Hoard" pointing to the four-surface routing decision.
- TOC and Summary updated to match.

Source: Shah Rahman (Meta), "A Practical Guide to Becoming an AI-Native Engineer" (ByteByteGo, 2026-06-02) — the six-phase ADLC's explicit "Codify" phase and MCP-tools-as-codification framing (queue item 10). GSD-fork implementation of a `codify` phase tracked as a follow-up in FORK.md.

### v1.2.14 (2026-06-11)

**§5 Testing — new subsection:**
- Added "Price Tests Against the Bottleneck" — under agentic development, V&V (review/build/test/deploy) is the constraint, so a test earns its slot only if it buys more verification than it costs. Five rules: no test without a named failure mode; cheapest test that catches the bug; report CI cost and propose deletions, not just additions; never fake green (agents fake it by editing the test); push validation upstream.

**§8 Design Principles — Ratchet Effect extended:**
- Added "Coverage is the wrong thing to ratchet" — the numeric ratchet is right for code-health/bundle-size/latency but a Goodhart trap for coverage % and test count (measures volume at the non-bottleneck station; locks in test bloat). Ratchet outcome signals (escaped-defect rate, p95 pipeline time as a ceiling) instead. "A metric you can name is a frame you can game."

**§18 Collaborating with AI — two new subsections:**
- Added "Constrain the Harness, Don't Trust the Model" — the safest agent is the best-constrained system, not the most capable model. "Be thorough" in sensitive contexts nearly doubles contextual-integrity leakage; filter before the prompt window (least-privilege, role-conditioned), don't prompt your way to safety on an over-provisioned context.
- Added "Measure Outcomes and Comprehension, Not Output Volume" — once generation cost → 0, the artifacts AI inflates (PRs, LOC, test count) become the most gameable proxies. Three rules: learning speed is the bottleneck (instrument time-to-learn); metrics come in opposed pairs (speed signal + quality counter-metric in tension; DX Core 4); the counter-metric for delivery velocity is comprehension (per-critical-system scope note + the <5-min/≥3-people legibility test).

**§9 Observability — one cross-reference:**
- Added a Metrics-and-Alerting pointer to the §18 legibility/scope-note discipline for systems whose change surface extends beyond own deploys (vendor platforms, IdPs, delegated-authority agents).

**Why batch:** Sourced from a 2026-06-11 ingest cluster converging on one structural insight — under agentic development, validation/verification is the bottleneck and the volume metrics AI inflates decouple from system health. Nygard "AI versus Throughput / Microservices" (test-pricing + coverage carve-out), Shipper "After Automation" (metric-saturation), Wolff "Engineering at AI Speed" (learning-speed bottleneck), Reock/DX "Leadership in AI-Assisted Engineering" (oppositional metrics), LaPosta/LeadDev "DORA Metrics Are Lying to You" (legibility counter-metric), and Fu et al. CI-Work (constrain-the-harness). Five independent sources on the same nerve justified one update over per-source patches. Deferred: "Codify as a named sixth phase" (queue item 10) — needs a design decision on vocabulary-vs-content, not a one-line addition.

### v1.2.13 (2026-06-11)

**§18 Collaborating with AI — one new subsection:**
- Added "The 40-20-40 Attention Budget" — coarse target for splitting practitioner attention within an agent-assisted session (40% context-setting / 20% generation+testing / 40% review+verification). Most of the work is at the boundaries, not in the middle where the agent runs. Surfaces two failure modes (skipping front 40% → 19% slower / 45% security-flaw findings; skipping back 40% → "delegate the actual work to other people" anti-pattern). Pairs with "Bracket Agents, Don't Watch Them" — bracketing tells you when attention lands, the budget tells you where within the bracket. Treat as a numeric ratchet (§8) per self-audit.

Source: Shah Rahman (Global Head of Autonomous ML, Meta), "A Practical Guide to Becoming an AI-Native Engineer" (ByteByteGo, 2026-06-02). n=1 practitioner heuristic, not a controlled study — the ratios are coarse, the discipline of tracking them is the point.

### v1.2.12 (2026-06-09) — retroactive entry

- §5: added "Skipped Is Not Passed — Bring Up the Stack Before You Claim Verified" (shipped in commit 33a61a6 without a changelog entry; recorded here for completeness). Motivated by a feature that shipped dead behind a silently-skipped real-DB test.

### v1.2.11 (2026-06-09)

**§2 Git Hygiene — two new subsections:**
- Added "Never `--no-verify`" as a non-negotiable in Pre-Commit Hooks, naming the cross-syntax anti-pattern family (`// eslint-disable`, `# type: ignore`, `as any`, etc.)
- Added "Commit Cadence" — 20-30 minute discipline + "task not done until `git push` succeeds" rule; agentic flows multiply the value because state accumulates faster

**§5 Testing — Red/Green TDD with Agents extended:**
- Added "Red → Green → Refactor → Commit, one cycle per commit" — explicit four-phase cycle with commit step
- Added Kent Beck's Test Desiderata (Isolated · Deterministic · Fast · Behavioral · Structure-insensitive · Specific · Predictive) for evaluating which tests earn their slot
- Tactical guidance: fix flaky tests first, prefer E2E over unit for user flows

**§8 Design Principles — Ratchet Effect extended + new subsection:**
- Added "Numeric ratchets, not just binary gates" — scalar quality signals (code-health scores, coverage %) ratcheted on best-known value; portable to any quality tool emitting a scalar
- Added "Standards Live in Tooling, Not Reviews" — tool-enforced rules reject the run; reviewer-enforced rules are negotiable by default in agentic flows. Promote prose rules into tooling whenever possible

**§16 Definition of Done — Release-Readiness Completion Comment template:**
- Added structured completion-comment shape with named sections (What built, Tests run, Coverage, Code-health, Lint/typecheck, CI pre-check, Localization, Telemetry, Refactors, ADRs, Docs, Migration safety, Outstanding). The named-section shape forces a pass-or-explicit-disclaim per gate rather than soft "verify tests pass" phrasing that lets agents skip whichever check is inconvenient

**§18 Collaborating with AI — two new subsections:**
- Added "Bracket Agents, Don't Watch Them" — maker/manager schedule, define start/end conditions per session, scheduled review block instead of continuous watching; protects the cognitive reservoir agents *cannot* substitute for
- Added "Ablate at PR Granularity" — every agent-context change (skill, rule, prompt template) ships with a before/after eval delta on a fixed slice in the PR description; eval set is the test suite for the prompt; keep a list of what didn't work

**Why batch:** Most additions sourced from a 2026-06-03..06-09 ingest cluster — Tolaria AGENTS.md, Brier "Culture of AI Engineering," Hoang "Escape from Agentic Loop," and Anthropic's self-service analytics case study. Convergence across four independent sources on tooling-not-reviewers + numeric ratchets + ablation discipline justified treating them as one structural update rather than per-source patches.

### v1.2.10 (2026-06-09)

**§5 Testing — new subsection + one augmentation:**
- Added "Choosing Test Cases & Reading Coverage" — test the requirement not the code's assumption (independent oracle); test the seam between modules with a single source of truth iterated across the boundary; always include the default/fallback/degenerate-but-valid value; coverage measures lines executed not inputs covered; prefer authoritative validation (platform API / library / DB constraint) over hand-rolled shape regexes; grep for a bug's twin before closing the fix.
- Augmented "never assume LLM code works until executed" with "verify at the deliverable's altitude" — a fix confirmed one layer below the user is a hypothesis; observe the real artifact as the real user.

Sources: own `/reflect` debrief 2026-06-09 — profile-save `invalid_input` regression (a `Region/City` timezone regex rejected the canonical zone `UTC`, which was the page default, the auto-detect fallback, and an offered datalist option; a passing timezone test had encoded the same wrong shape assumption; the twin bug was live in a second validator).

### v1.2.9 (2026-06-03..06-09)

**§15 Observability & CI — new subsection:**
- Added "Workflow Triggers — Avoid the `push` + `pull_request` Double-Fire" — documents how a workflow on both `push: ['**']` and `pull_request:` runs twice per commit on any branch with an open PR, why the naive `github.ref` concurrency guard can't dedupe them (the two events land in different groups), and the fix (scope `push` to long-lived branches, let `pull_request` gate the rest). Includes the "audit every workflow" note since the trigger pair gets copy-pasted across guard/lint/security workflows.

Sources: own `/reflect` debrief 2026-06-03.

### v1.2.8 (2026-05-28)

**§18 Collaborating with AI — three new subsections, one augmentation:**
- Added "Designing Skills" — skill-as-folder reframe, five rules (Don't State the Obvious, Gotchas section, description-as-router, avoid railroading, progressive disclosure via filesystem)
- Added "On-Demand Hooks" — per-skill PreToolUse hooks scoped to skill activation; safety guards at the same scope as the work
- Added "Skill Hygiene" — bi-weekly audit pattern using PreToolUse invocation logging; pairs with the spa-day cleanup pattern
- Added "Deterministic Middleware as Agentic Safety-Net" — three named middleware patterns (queue-check, open-PR-if-needed, tool-error); agentic for creative work, deterministic for load-bearing steps
- Augmented "Progressive Disclosure for Rules Files" with external validation paragraph — Tharlq's Anthropic-internal skills independently converge on the same three-layer shape

**§17 Claude Code Configuration — new subsection + one-liner:**
- Added "AGENTS.md vs CLAUDE.md" — tool-agnostic naming convention; symlink pattern as the cheapest hedge until ecosystem settles
- Added "skills earn their slot via use" one-liner pointing at §18 Skill Hygiene

**§3 Planning & Execution — new subsection:**
- Added "Dependent-Repo Pre-Flight Check" — `gh search prs` scan of dependent repos for recent merges before any planning phase that depends on a backend wire or external contract; 10-minute step that prevents multi-hour rework when an upstream contract changed silently mid-flight

Sources: Tharlq (Anthropic), "Lessons from Building Claude Code: How We Use Skills" (2026-05-26); Naitik Mehta in reply thread to same; LangChain, "Open SWE: An Open-Source Framework for Internal Coding Agents" (2026-05-26); own `/reflect` debrief 2026-05-27.

### v1.2.7 (2026-05-26)

**§5 Testing — Red/Green TDD with Agents augmented:**
- Added "Interface design is a precondition for TDD, not an output of it" paragraph
- Spell out the coupling between code structure and AI-TDD effectiveness: shallow-module
  codebases give agents no clear test boundary; deep modules with thin interfaces
  (Ousterhout) are what makes TDD with agents actually work
- Reframes the "confirm what interface changes are needed" step as load-bearing, not as
  a refactor afterthought — interface changes are decisions the agent must pause on

**§8 Design Principles — "Best Software for an Agent" extended:**
- Added "treat agents like humans with weird constraints" operational framing —
  process discipline for memoryless, cloned-fresh humans is the design model; AI-specific
  scaffolding is usually a smell when human-process scaffolding would work
- Added "garbage codebase produces garbage agent output" corollary — AI amplifies the
  substrate in both directions; a messy codebase compounds through the agent rather
  than getting cleaned up by it

Source: Matt Pocock, "5 Claude Code skills I use every single day" (YouTube, 2026-03-16);
[[source:youtube-5-claude-code-skills-i-use-every-day]]. Skills as encoded process,
Brooks design tree (`/grill-me`), Ousterhout deep modules, TDD-as-interface-design-first,
treat-agents-like-humans framing.

### v1.2.6 (2026-05-20)

**§18 Collaborating with AI — new subsection "Initialize Claude in Subdirectories, Not the Repo Root":**
- Claude Code walks UP the directory tree from `cwd` and loads every CLAUDE.md it encounters
- Starting in a subdirectory composes the layered context the right way without dragging in irrelevant sibling-directory noise
- Test/lint commands must be scoped per subdirectory or they timeout and waste context
- Routinely cd-ing after starting at root is a smell: root CLAUDE.md is too heavy, or a subdir CLAUDE.md is missing

**§18 Collaborating with AI — Teaching Through Feedback augmented:**
- Added explicit 3–6 month cadence for rules/CLAUDE.md review
- Rules tuned for older model generations become unnecessary or actively constraining as capabilities improve
- Example contrast: "remind agent to run tests" rule was load-bearing in 2024 / noise in 2026; "avoid this deprecated API" stays load-bearing forever

Source: Anthropic Applied AI team, "How Claude Code Works in Large Codebases: Best Practices and Where to Start" (claude.com/blog, 2026-05-14); harness-over-model thesis, enterprise rollout patterns.

### v1.2.5 (2026-05-15)

**§2 Git Hygiene — new subsection "Worktree Isolation":**
- Added one-worktree-per-ticket as the recommended parallel agent workflow pattern;
  git worktrees let multiple agent sessions work on separate branches simultaneously
  without stashing or context-switching costs; GSD `workflow.use_worktrees` toggle noted

**§3 Planning & Execution — new subsection "The Spec as Source of Truth":**
- Extends "Spec the Outcome" to its logical conclusion: spec is the source of truth,
  code/tests/migrations/endpoints are living projections of it; developer designs
  contracts, agents fulfill them; any merge not traceable to a spec requirement is suspect

**§18 Collaborating with AI — two new subsections:**
- Added "Shared Team Context" — explains why version-controlled context files break the
  senior/junior AI output quality gap; four properties: consistency, coherence, prompt
  independence, seniority independence; team CLAUDE.md is a multiplier, not a preference
- Added "One File Per Deliverable" — each context artifact lives in its own file,
  referenced from a base document; anti-pattern is a sprawling CLAUDE.md that prevents
  task-scoped progressive disclosure

Source: Álvaro Moya / LIDR, "Workshop Spec-Driven Development con IA" (2026-03-17);
context engineering three-component recipe and SDD source-of-truth framing.

### v1.2.4 (2026-05-15)

**§18 Collaborating with AI — Anti-Patterns:**
- Added "Don't mistake faster coding for faster delivery" — AI reduces time-in-code,
  not time-in-review; each approval layer multiplies wall-clock time ~10x regardless
  of coding speed; faster code generation without redesigning review structure produces
  larger batches of unvetted work, not faster delivery

Source: Avery Pennarun, "Every layer of review makes you 10x slower" (apenwarr.ca,
Mar 2026); Deming/Toyota manufacturing parallel.

### v1.2.3 (2026-05-15)

**§18 Collaborating with AI:**
- Added "Progressive Disclosure for Rules Files" subsection — 3-layer structure (compact
  config <500 tokens → pattern summary <300 tokens → full docs 3K tokens) with a content
  router that selects depth based on task keywords; file-path scoping controls which files
  load, progressive disclosure controls how much of each file loads; the two work together

Source: @trq212, "Lessons from Building Claude Code: Seeing like an Agent" (X thread,
Feb–Mar 2026); pattern independently derived by multiple practitioners.

### v1.2.2 (2026-05-15)

**§18 Collaborating with AI:**
- Extended compaction handling — bake re-orientation into CLAUDE.md as an explicit
  instruction, not just a guideline; prevents agents from filling in assumptions after
  compaction
- Added "spa day" pattern — delegate periodic rules/skills cleanup to the agent itself;
  it identifies contradictions and proposes consolidations; run when agent starts hedging
  or producing inconsistent results

Source: @xyis, "How To Be A World-Class Agentic Engineer" (X, 3.5M views, Mar 2026)

### v1.2.1 (2026-05-15)

**§17 Claude Code Configuration:**
- Added "Domain Vocabulary as LLM Context" subsection — vocabulary carries constraints
  and design consequences; precise naming enables reliable LLM intent→implementation
  mapping; vague naming forces guessing; cognitive debt amplifier: LLMs generate
  vocabulary faster than teams build understanding of it
- Added `glossary.md` to recommended rule categories with description

Source: Unmesh Joshi, "What Is Code?" (martinfowler.com, 2026-05-12)

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
