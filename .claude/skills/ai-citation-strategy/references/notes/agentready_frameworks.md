# Agent-readiness frameworks: agentready.org compared with the other 2025–2026 checklists, specs and graders

Research date: 2026-10-22. All sources were fetched or searched on that date. This field changes month to month. Anything about WebMCP, ChatGPT Atlas, scanner check lists, or agentready.org's version number may be out of date by November 2026.

Evidence labels used throughout:
- **Proven**: the platform's own documentation, or a measured study with a stated method.
- **Proven (harness)**: measured with a stated method, but only on Ora's agent test harnesses (Claude or GPT models inside agent SDKs and coding agents). It does not cover consumer products such as ChatGPT search, Gemini, Perplexity or Copilot. Ora's studies are vendor-run and not peer-reviewed.
- **Reported**: industry data with known limits, such as vendor scans, log studies of a vendor's own customers, single small experiments, or secondary press.
- **Claimed**: an assertion without data.
- **Speculative**: a forecast, or an inference not backed by data.

---

## 1. What exactly does agentready.org say, who is behind it, and is it a standard, a proposal or a product?

### Takeaway
agentready.org ("AgentReady") is a vendor-led, MIT-licensed **proposal**. No standards body publishes it.
- **Authors and status:** its own GitHub repo calls it the "AgentReady proposed standard for agent readiness" and says it is "Written by: ora.ai and Vercel".
- **Evidence:** it comes almost entirely from Ora's own studies of Claude- and GPT-based agent harnesses, mostly on software and SaaS sites.
- **Contents of v2.0 (October 2026):** 24 active requirements in three groups: Find (4), Read (10) and Act (10). There are four MUSTs:
  - do not block agents;
  - put the answer in the initial HTML;
  - return real HTTP status codes;
  - only for products agents should act on, ship an MCP server or a CLI.
- **Scoring:** the spec has no score, grade or badge. Scores come from Ora's scanner and from partner "rankers" such as Vercel's is-agentic.com and Mintlify's Agent Score.
- **Places and events:** it says nothing about places, events, opening hours or dated content.

### Cited Findings

**Identity, authors, partners, status**
- **Self-description:** "the open standard for agent readiness". Quotes: "AgentReady is an open specification of what a product should implement to be usable by AI agents"; "It does not promote a protocol or a vendor"; "The practices below are based on measured agent behavior, and are revised as that behavior changes." Source: [agentready.org](https://www.agentready.org/) (fetched 2026-10-22; v2.0, October 2026). Claimed (self-description).
- **GitHub repo:** the repo description reads "AgentReady proposed standard for agent readiness". Source: [GitHub agentready-org/standard](https://github.com/agentready-org/standard) (fetched 2026-10-22). Proven (primary).
  - The README says "Written by:" ora.ai and Vercel, and that the research was done by the ora.ai research lab.
  - The licence names "era labs (ora.ai)" as copyright holder.
  - Where the repo and the site diverge, "the site wins until reconciliation lands here".
  - Versioning follows semver. Changes come through issues and pull requests against `spec/spec.md`.
- **Repo traction on 2026-10-22:** 38 stars, 7 forks, 2 watchers, 2 open issues, 1 open PR and 25 commits on main. No individual maintainers are named. Source: [GitHub](https://github.com/agentready-org/standard). Reported (one snapshot).
- **Collaborators on the homepage:** the page lists "in collaboration with" Ora, Vercel, Stripe, Auth0, Mintlify, Tavily by Nebius, Google and Elementor. No individual people are named. Source: [agentready.org](https://www.agentready.org/). Proven for what the page says; the partnerships are not confirmed from the partners' side. Roles shown on the page:

  | Partner | Role shown on the page |
  |---|---|
  | Ora | "Together with the ora.ai research lab we learned from more than 250,000 real agent runs" |
  | Vercel | "Vercel × Ora, for sites whose job is content" (that is, is-agentic.com) |
  | Mintlify | Agent Score for documentation sites |
  | Tavily | a report on "who agents find when they search your market" |
  | Stripe | the payments study: "Stripe test mode, fictional stores, no real money" |
  | Elementor | cited as WordPress example work |
  | Google, Auth0 | listed, with no role |

- **Ora's committee roles:** Ora's post gives these roles. Source: [Ora blog, "agentready open standard"](https://ora.ai/blog/agentready-open-standard) (current version dated 2026-10-19; no named author; footer credits "era labs").
  - Ora: research.
  - Vercel: "infrastructure and web essentials".
  - Mintlify: docs.
  - Auth0: auth.
  - Stripe: payments.
  - Tavily: search.
  - Google and Elementor: partners "who build and study the surfaces agents touch", with no role.
  - Self-description: "vendor neutral, MIT licensed, and developed in the open", and "There are no weights, thresholds, or badges in the spec."
- **Conflicting dates:** the changelog dates v1.0.0 to "announced March 20, 2026" and published 2026-04-24 ([CHANGELOG](https://github.com/agentready-org/standard/blob/main/CHANGELOG.md)).
  - A search snippet of the same Ora URL calls it "Ora's March 2026 announcement". That snippet describes the older five-area structure: Identity & Access (OAuth 2.0, PKCE S256, Web Bot Auth) and Commerce (x402, ACP, UCP, MPP). It also says AgentReady "is not a scoring framework, a benchmark, or a badge" ([Ora blog](https://ora.ai/blog/agentready-open-standard)).
  - So the post seems to have been rewritten for v2.0. When the partners joined is not stated.
- **Version history** ([CHANGELOG](https://github.com/agentready-org/standard/blob/main/CHANGELOG.md), Proven):
  - **v1.0.0** (announced 2026-03-20, published 2026-04-24):
    - five topic sections: Discoverability, Content for agents, Capabilities, Identity & Access, Commerce;
    - a "baseline/conditional" applicability model, plus `/spec.json` and `/llms.txt`;
    - requirements included AR-DISC-03 llms.txt (SHOULD), AR-CONT-02 Markdown content negotiation (MAY) and AR-CONT-03 `/index.md` fallback (MAY);
    - all v1.0.0 identifiers were later retired.
  - **v1.0** (August 2026):
    - restructured into Find, Read and Act;
    - "Strengths (MUST / SHOULD / MAY) are now assigned from measurement";
    - removed `/spec.json` and the baseline/conditional model;
    - removed AR-READ-10 (AGENTS.md / SKILLS.md, MAY).
  - **v2.0** (October 2026):
    - added AR-ACT-10, an MCP server or a CLI (MUST), described as "the only new MUST, so v1.0 conformance may not carry over";
    - added AR-FIND-04 AI Catalog (MAY), AR-READ-11 pricing (SHOULD), AR-ACT-08 payments (MAY) and AR-ACT-09 NLWeb (MAY);
    - WebMCP (AR-ACT-07) "raised from MAY to SHOULD";
    - AR-FIND-01 widened to cover bot protection;
    - the Act group now applies only to "products agents are expected to act on".

**Conformance and scoring**
- **Conformance rules:** "A site conforms when it meets every MUST requirement that applies, including MUST NOT prohibitions." Act requirements apply only to products agents are expected to act on. "Scoring, grades, and the leaderboard are out of scope and belong to the ora scanner." No certification is described. Source: [spec.md v2.0](https://github.com/agentready-org/standard/blob/main/spec/spec.md). Proven.
- **Strength tags:** MUST means "failure breaks agents"; SHOULD means it "measurably shapes behavior or makes action reliable"; MAY means "emerging". New conventions enter as MAY and move up or down as evidence changes. Sources: [agentready.org](https://www.agentready.org/); [Ora blog](https://ora.ai/blog/agentready-open-standard).
- **"Essentials" list on the homepage.** It opens with "Two changes broke an agent: hiding the answer behind JavaScript, and blocking access." Source: [agentready.org](https://www.agentready.org/).
  - Find: "Publish first-party docs", "Allow agents in robots.txt and bot protection", "List pages in a sitemap.xml".
  - Read: "Put the answer in the initial HTML", "Return real HTTP status codes", "Link llms.txt, JSON-LD, and OpenAPI", "Fence and language-tag code".
  - Act, only if agents should complete a task: "Auth an agent can finish", "A public API with OpenAPI", "An MCP server or a CLI", "WebMCP on pages agents should act through".
- **"Check your site" section:** "Three public rankers score the site itself, each on a different surface… None of them is the spec." It also says scanner checks and weights "may change independently of this spec." Source: [agentready.org](https://www.agentready.org/). The rankers:
  - ora.ai (100+ checks);
  - is-agentic.com (Vercel × Ora, for content sites; essentials plus a "recommended tier");
  - Mintlify Agent Score (29 checks, for docs);
  - Tavily's avr.tavily.com, a visibility report rather than a ranker.
- **Score distribution on the homepage:** Ora scanner data "read from ora.ai in October 2026": D or F 59%, C 35%, B or above 6%, average 42. Each square is about 1% of roughly 125,000 sites. Source: [agentready.org](https://www.agentready.org/). Reported (vendor scan; sample not defined).

**Every v2.0 requirement** (sources: [spec.md](https://github.com/agentready-org/standard/blob/main/spec/spec.md) and [agentready.org](https://www.agentready.org/)). "[STUDIES]" figures are Ora's own measurements, so they are Proven (harness) at best.

| ID | Strength | Requirement | Rationale or evidence given by the spec |
|---|---|---|---|
| AR-FIND-01 | MUST | "The site MUST NOT block agent and crawler access to public content", whether through robots.txt or at the network layer (bot protection). The homepage advises allowing agents with one wildcard rule rather than a list of named crawlers, letting verified agents through, and throttling with 429 + Retry-After rather than challenges. | Blocking broke agents. Not-ready sites blocked agents 2.1× as often. In Ora's scanner, established agents reached 81–90% of sites. |
| AR-FIND-02 | SHOULD | Publish citable answers on one canonical, current, first-party docs page. | 82% of answers traced to a fetched page; docs pages were the most common type (47%). |
| AR-FIND-03 | SHOULD | `sitemap.xml`, referenced from robots.txt. | "Standard for crawlers", but fetched directly in only 4% of runs. |
| AR-FIND-04 | MAY (new in 2.0) | AI Catalog at `/.well-known/ai-catalog.json`, linked from the homepage with `<link rel="ai-catalog">` and an HTTP `Link` header. | "Not measured." |
| AR-READ-01 | MUST | "The answer MUST be present in the initial HTML", not injected by a single-page app after load. | Hiding the answer behind JavaScript was one of the two changes that broke agents in the controlled experiment. |
| AR-READ-02 | MUST | Real status codes: 404 or a valid redirect for missing paths; 429 + Retry-After when throttling; never 200 for missing pages; never a challenge page in place of 429. | One single-page app returned 200 for every path. Agents treat 429 as a signal to back off. |
| AR-READ-03 | SHOULD | Homepage as raw HTML with real links to docs, product and pricing. | Homepage reached in 69% of runs and was the first step in 92%; the next hop was docs in 59%. |
| AR-READ-04 | SHOULD | Docs pages answer the tasks users bring to agents; setup and quickstart linked from the homepage. | Docs reached in 83% of runs, about 3.4 docs pages per run. |
| AR-READ-05 | SHOULD | Fenced, language-tagged code. | 61% of code-containing answers included lines verbatim from a fetched page. |
| AR-READ-06 | SHOULD | Link discovery files (`.well-known`, etc.) from pages agents already visit. | 86–100% of visits to these files came through links, not guessed paths. |
| AR-READ-07 | SHOULD | `llms.txt` as a lean, described index of key pages. | 86% of llms.txt fetches came from a page linking to it. One in three agents that read it then fetched a listed page; 36% drew their final answer from its content. |
| AR-READ-08 | SHOULD | JSON-LD on key pages, especially the homepage, with critical facts repeated in visible text. | "Most agents read a page's text, not its <script> elements", so facts that exist only in JSON-LD, a JSON config or a hydration payload go unseen. Markdown converters may drop script blocks. The Elementor/WordPress work is cited as an example. |
| AR-READ-09 | MAY | A markdown mirror, advertised with `rel="alternate" type="text/markdown"` or an HTTP `Link` header. | Agents requested markdown in about 65% of fetches, and chose it 96% of the time when they named a format. But "Format did not determine task success in the studies, so ensure the HTML works before adding a .md mirror." |
| AR-READ-10 | retired (August 2026) | AGENTS.md / SKILLS.md (was MAY). | — |
| AR-READ-11 | SHOULD (new in 2.0) | Pricing as text on a first-party page, not an image, a calculator or a sales form. | Answers were 60% accurate from first-party pages vs 37% elsewhere. |
| AR-ACT-01 | SHOULD | Auth an agent can finish: self-serve keys with documented scopes; OAuth 2.0 metadata under `/.well-known` (RFC 8414, RFC 9728). | OAuth + PKCE passes on about 1% of sites. |
| AR-ACT-02 | SHOULD | A public API described in OpenAPI, with operation IDs, typed errors, `/v1/` versioning and documented rate limits. | — |
| AR-ACT-03 | SHOULD | An MCP server over Streamable HTTP at `/mcp`. Public docs MCP, plus an OAuth+PKCE-gated product MCP. Protected-resource metadata at `/.well-known/oauth-protected-resource`. Listed in the MCP Registry via `server.json`. | 3% of sites ship a spec-grade MCP server. |
| AR-ACT-04 | MAY | MCP server card for discovery before connecting (SEP-2127, "a draft whose path may change"). | Listed as an open question in the spec. |
| AR-ACT-05 | MAY | MCP Apps view (a `ui://` resource). | No evidence given. |
| AR-ACT-06 | SHOULD | SDKs on npm and PyPI, plus a CLI. | No evidence given. |
| AR-ACT-07 | SHOULD (raised from MAY in 2.0) | WebMCP tools registered on `document.modelContext`, feature-detected, and only for actions the product really offers. A W3C Community Group draft. | No measured evidence in the spec. |
| AR-ACT-08 | MAY | Agent payments: x402 or MPP for per-call pricing; UCP or ACP for checkout; Stripe Link with Shared Payment Tokens. No CAPTCHAs for verified agents. | Paying through Link, agents got 92.3% of test checkouts right, and 18 of 26 agents scored at least 90% (Stripe test mode, fictional stores). |
| AR-ACT-09 | MAY | An NLWeb `/ask` endpoint with schema.org-shaped results, with the same `ask` tool exposed over MCP. Said to "suit content-heavy sites". | No evidence given. |
| AR-ACT-10 | MUST (new in 2.0, applies only where agents act) | At least one agent-operable interface, an MCP server or a CLI. "Do not ship an empty surface." | — |

- **Agents named in the spec** ([spec.md](https://github.com/agentready-org/standard/blob/main/spec/spec.md)):
  - training crawlers: GPTBot, ClaudeBot;
  - search-index crawlers: OAI-SearchBot, Claude-SearchBot;
  - user-initiated fetchers: ChatGPT-User, Claude-User, which "may not consult robots.txt";
  - agent search APIs, treated as a kind of crawler: Brave Search API, Exa, Parallel, Tavily;
  - payment: Link Agent Wallet.
  - Open questions in the spec: the path for the MCP server card, and whether user-initiated fetchers that ignore robots.txt need separate guidance.
- **Not on agentready.org:** local businesses, places, events, restaurants, travel, opening hours or dated content. Nor are Perplexity, Gemini, Copilot, Apple, ChatGPT Atlas, Comet or Claude in Chrome mentioned. The only test platforms it names are "Four agent stacks on Claude and GPT models". Source: [agentready.org](https://www.agentready.org/) (fetched 2026-10-22).

**Evidence base behind the strength tags**
- **Controlled experiment:** one docs site was served in 19 configurations and probed on 5 topics by two clients (a plain fetch client "like most agent tools" and a client that runs JavaScript), 190 probes in all. Only hiding the answer behind JavaScript, or blocking agent user agents with 403s, stopped retrieval. Source: [Ora blog](https://ora.ai/blog/agentready-open-standard). Proven (harness), for those two clients.
- **What agents reached:**
  - Pages reached across Ora's traced runs: docs 83%, homepage 69%, `.well-known/*` 23%, `openapi.json` 21% (on sites that ship one), `sitemap.xml` 4%.
  - Share of fetches that arrived through a link rather than a guessed path: `openapi.json` 97%, `.well-known/*` 93%, `llms.txt` 86%.
  - Source: [Ora blog](https://ora.ai/blog/agentready-open-standard). Reported (vendor traces; the agent behind each figure is not named).
- **Public data in the repo:** `data/traces.csv` (1,033 agent runs across 25 product sites) and `data/fetchability.csv` (190 probes). Source: [GitHub](https://github.com/agentready-org/standard). Reported. This is a small fraction of the "250,000+ runs" Ora cites.
- **The business study:** "AX is the New AEO", arXiv:2609.34951, by Ido Finder, Assaf Elovic, Gad Shalev and Liad Yosef. Submitted 2026-09-28, revised to v3 on 2026-10-06 (cs.AI, cs.IR). Source: [arXiv](https://arxiv.org/abs/2609.34951). Proven (harness). Abstract findings:
  - 37,927 agent journeys, each a buyer question about one of 1,056 real businesses, run on four harnesses;
  - training knowledge supplied about 7–10% of answers;
  - answers about agent-ready businesses were built from the business's own pages 78% of the time, vs 56% for others;
  - agent-ready businesses were clearly recommended about 1.9× as often;
  - answers built from the wider web were 3.7× more likely to contain none of the requested facts; "the main problem is omission rather than fabrication";
  - answers built from the site were about 41% more accurate;
  - a grounded answer about a not-ready business cost the agent about 64% more.
- **Method details** (source: [Ora blog, "AX is the new AEO"](https://ora.ai/blog/ax-is-the-new-aeo), 2026-10-08):
  - Harnesses: claude-agent-sdk with claude-sonnet-4-6; claude-code with claude-haiku-4-5; openclaw with gpt-5.4-mini; eve with gpt-5.4. The GPT stacks searched through Tavily; the Claude stacks used built-in search.
  - "Agent-ready" means Ora's own score (100+ checks), taken on 2026-08-24. The middle band (0.50–0.65) was "excluded by design".
  - Sites were paired within an industry and matched on brand fame, the model's prior knowledge of the brand, and third-party citation frequency.
  - Two blind LLM judges (Claude and GPT) graded recommendations. Accuracy was graded on 31,127 facts across 2,499 answers from 131 businesses.
  - Clear endorsements: 20% vs 11% overall, and 14% vs 5% (2.6×) on claude-agent-sdk.
  - Accuracy rose from 41% to 56% as more of the evidence came from the business's own site.
  - Not-ready sites took 23% more turns.
  - Business categories named include Consumer, IT Infrastructure, Development, Artificial Intelligence, and Sales & Marketing.
  - On connectors and registries: "We haven't measured this, so we're not claiming it."
  - The page names Ora's own ranker as the source of the readiness score, a conflict of interest.

**Ora's scanner, the scorer behind agentready.org** (source: [Ora, "State of agent readiness 2026"](https://ora.ai/blog/state-of-agent-readiness-2026), 2026-04-22). Reported (vendor scan; how sites were selected is not explained).
- **Sample:** n = 114,273 "products", in an April 2026 snapshot.
- **Method:** 110 checks across five weighted layers (Discovery, Identity, Auth & Access, Agent Integration, User Experience). An LLM marks checks that do not apply. Scans "ran real agents (ChatGPT-User, ClaudeBot, Google-Extended, DeepSeek, ora-agent, and OpenClaw)".
- **Scores:** median 42; 73% graded D or F.
- **Adoption:** llms.txt 48%; robots.txt AI policy 50%; sitemap 69%; MCP endpoint 34% (spec-grade 3%); OAuth metadata + PKCE S256 about 1%; WebMCP 1%.
- **"AI crawler reach":** ChatGPT-User 81%, ClaudeBot 82%, Google-Extended 87%, DeepSeek about 90%, OpenClaw 59%.
- **Who was scanned:** the dataset is framed around software products. Consumer and Healthcare sit at the floor, which the authors attribute to B2B buyers dispatching agents while consumers still shop through browsers.
- **Disclosure:** Ora "grades at the top of its own framework" and leaves itself off the leaderboard.

### Inferences
- **"Standard" overstates it.** No standards body is involved, the repo calls itself "proposed", governance is two companies' repository, and community uptake is modest (38 stars). Treat it as a well-documented vendor proposal. (Inference)
- **It is written for software products.** Its nouns are docs, homepage, pricing, API, code fences, SDK and MCP. For a content site, only these items carry over:
  - FIND-01 (access) and FIND-03 (sitemap);
  - READ-01 (initial HTML), READ-02 (status codes), READ-08 (JSON-LD plus visible text) and READ-11 (prices as text);
  - possibly READ-07 (llms.txt) and READ-09 (markdown);
  - FIND-02, if "first-party docs" is read as one canonical first-party page per entity.
- **"Does not promote a vendor" needs context.** Partner products map onto requirement areas almost one for one:
  - Stripe and payments (AR-ACT-08, supported by a Stripe Link study);
  - Auth0 and auth (AR-ACT-01);
  - Mintlify and docs;
  - Tavily and search (Tavily also ran search inside two of the four test harnesses);
  - Vercel and hosting plus is-agentic;
  - Ora and the scanner.
- **The "Google" listing is unexplained and partly contradicted by Google.** No role is given and no Google statement was found. Google Search's own guide (Question 2) says llms.txt and Markdown are unnecessary, which contradicts agentready's llms.txt SHOULD. The Chrome and Lighthouse side partly agrees with agentready, since Lighthouse checks llms.txt and WebMCP. Any Google involvement is more plausibly Chrome or WebMCP than Search. (Speculative)
- **The MUSTs are well supported; the SHOULDs less so.**
  - The MUSTs (do not block, initial HTML, real status codes) rest on a two-client controlled experiment and on harness studies. They agree with platform documentation (Question 4), so they are the strongest part of the spec.
  - The llms.txt SHOULD rests on harness data where one of the four harnesses is Claude Code. Ahrefs (Question 4) found coding agents such as Claude Code among the few real readers of llms.txt. So the SHOULD may reflect coding-agent behaviour, not consumer assistants.
- **Ora's "real agents" are probably user-agent strings.** The scanner lists "Google-Extended" as an agent it ran. Google's crawler documentation describes Google-Extended as a robots.txt control token with no separate fetching user agent; that was not re-fetched in this session. This suggests Ora sends those user-agent strings rather than running Google's agent. Read "AI crawler reach" as "share of sites that do not block that user-agent string".
- **Versions churn fast.** There were three versions in six months, identifiers were retired twice and strengths were reassigned. Any "AgentReady-conformant" claim needs a version number.

### Gaps
- No statement from Google, Stripe, Auth0 or Elementor confirming they take part was found. Vercel's role is confirmed only by the README, by is-agentic, and by third-party coverage; no vercel.com announcement about agentready.org was found.
- The full arXiv paper was not read, only the abstract and Ora's summary. No independent replication, peer review or academic critique was found.
- No Hacker News thread about agentready.org was found (Algolia search, Question 2), and no independent critique of it.
- When the partners joined, and whether any governance body exists beyond the two named authors, is not stated anywhere I found.

---

## 2. Which other agent-readiness frameworks, specs, checklists and graders exist, and what does each recommend?

### Takeaway
Since early 2026 the field has split three ways.
- **Scanners that score adoption of files and protocols:**
  - Cloudflare's isitagentready.com (April 2026);
  - Ora's own scanner, and Vercel × Ora's is-agentic.com (August 2026);
  - documentation graders: Mintlify Agent Score and the Agent-Friendly / Web Documentation Delivery Spec;
  - many SEO-vendor clones.
- **Guidance from platforms that run assistants:**
  - Google Search says no AI-specific files or schema are needed.
  - Google Chrome (the web.dev article and the experimental Lighthouse "Agentic Browsing" category) and OpenAI's Atlas stress accessibility, semantic HTML and WebMCP.
  - Microsoft Bing stresses clear structure, schema, and not hiding content.
- **Independent catalogues and checklists:** specification.website and Lorikeet's 12-point list.

No IETF, W3C or schema.org "agent-ready" standard exists. Those bodies own only single pieces:
- robots.txt (RFC 9309), Link headers (RFC 8288), api-catalog (RFC 9727) and OAuth metadata (RFC 8414 and 9728);
- the Web Bot Auth draft;
- the WebMCP W3C Community Group draft.

### Cited Findings

**Cloudflare: Agent Readiness score / isitagentready.com** (scanner)
- **Launch:** 2026-04-17, during Cloudflare's Agents Week. The page was last modified 2026-07-15 and names no author. Source: [Cloudflare blog](https://blog.cloudflare.com/agent-readiness/). Proven for what the tool checks.
- **Checks by dimension** (same source):

  | Dimension | Checks |
  |---|---|
  | Discoverability | robots.txt (RFC 9309); sitemap.xml; Link headers (RFC 8288) |
  | Content | "Markdown for Agents" via `Accept: text/markdown`. llms.txt is "not checked by default" and can be added as an option. |
  | Bot Access Control | Content Signals in robots.txt (`ai-train`, `ai-input`, `search`); AI bot rules in robots.txt; Web Bot Auth (IETF draft-meunier-web-bot-auth-architecture, `/.well-known/http-message-signatures-directory`; not all sites need it) |
  | Capabilities | Agent Skills (a Cloudflare-proposed RFC, `.well-known/agent-skills/index.json`); API Catalog (RFC 9727); OAuth server discovery (RFC 8414, RFC 9728); MCP Server Card (a draft from the MCP project); WebMCP |
  | Commerce | x402, UCP and ACP, which "do not currently count towards the score" |

- **How it scores, per Search Engine Journal** (Slobodan Manic, 2026-05-24). Source: [SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/). Reported.
  - 16 checks in 5 categories.
  - Site-type presets: All Checks, Content Site and API/Application.
  - The Content Site preset drops the API/Auth/MCP/Skill checks, Commerce and Web Bot Auth, leaving six scored checks.
  - Composite levels exist (for example "Level 2 'Bot-Aware'") but are not documented.
  - The scanner is also available through Cloudflare Radar, the URL Scanner API and an MCP endpoint.
  - SEJ cites the MCP Server Card as SEP-1649.
- **Cloudflare Radar scan** of the 200,000 most-visited domains, filtered to categories such as businesses, publishers and platforms. Source: [Cloudflare blog](https://blog.cloudflare.com/agent-readiness/). Reported.
  - 78% have a robots.txt, mostly written for search crawlers.
  - 4% declare Content Signals.
  - 3.9% pass the Markdown negotiation check.
  - MCP Server Cards and API Catalogs together appear on fewer than 15 sites.

**Vercel × Ora: is-agentic.com** (scanner)
- **Release:** 2026-08-23. It audits public sites using Ora's 100+ checks. Source: [MarkTechPost](https://www.marktechpost.com/2026/08/23/vercel-introduces-is-agentic-a-free-agent-readiness-scoring-tool-that-audits-public-websites-using-oras-100-checks/) (seen as a search result, not read in full). Reported.
- **Access** (source: [is-agentic docs](https://is-agentic.com/docs)). Proven.
  - Free ("Is Agentic is currently free to use").
  - CLI `npx is-agentic <domain>`, with `--json`; a read-only report API; an MCP server at `https://is-agentic.com/mcp`; an agent skill at `vercel-labs/is-agentic`.
  - A site-type tag, `<meta name="is-agentic-site-type">`, takes content, business, app or store. It "does not add points or change the score; it selects which check lens readers see first."
- **Scoring, per a third-party outlet whose byline is a "synthetic analyst" (an AI writer).** Source: [Artiverse](https://www.artiverse.ca/vercels-agent-readiness-audit-puts-websites-through-118-checks/) (2026-08-23). Reported; low reliability.
  - 118 checks in four layers: Discovery (20 points, 15 checks), Access (30, 41), Usability (40, 56), Payments (10, 6).
  - Essential checks share 80 points and recommended checks 20. Emerging signals add a bonus of up to 5 and never lower a score.
  - Recommended checks switch on only when the scan finds an API, an OAuth flow, GraphQL, an MCP server, a developer portal or a commerce surface. A marketing site is not penalised for lacking an interface it never offered.
  - Named check IDs: `content-no-js`, `agent-friendly-404` (requires a real 404, not a 200 app shell), `markdown-negotiation-vary`, `json-ld`, `sitemap`, `trust-anchors`, `metadata-completeness`.
  - Letter scale: A+ 95–100, A 86–94, B 70–85, C 48–69, D 28–47, F 0–27.
- **User report:** one site owner says is-agentic scored their marketing site 58/100, and fixes raised it to 88. Source: [Apogee Watcher](https://apogeewatcher.com/blog/we-scored-58-on-agent-readiness-how-we-got-to-88) (search snippet). Reported.

**Documentation graders**
- **Mintlify Agent Score** (2026-04-27, Ethan Palm). Source: [Mintlify](https://www.mintlify.com/blog/agent-score).
  - 29 checks for docs sites, built on the open Agent-Friendly Documentation Spec (agentdocsspec.com).
  - Seven categories: Content Discoverability, Markdown Availability, Page Size, Content Structure, URL Stability, Observability, Authentication.
  - Three checks of Mintlify's own: full-content discoverability, agent skill discoverability, MCP server discoverability.
  - Rationale: "To be agent-ready, your documentation must be structured so agents can find it, understand it, and use it."
  - No usage numbers are published.
- **agentdocsspec.com**, whose page calls it the "Web Documentation Delivery Spec". Source: [agentdocsspec.com](https://agentdocsspec.com/). Claimed (rationale given without data).
  - Publisher unnamed. Source code is in the GitHub organisation `agent-ecosystem`, with a CLI at afdocs.dev and background articles dated 2026-02-18 and 2026-02-19 on dacharycarey.com. "The specs are open for community review."
  - 28 checks:

    | Category | Checks |
    |---|---|
    | Content Discoverability (7) | llms.txt existence, validity, size and link resolution; llms.txt directives in HTML and markdown |
    | Markdown Availability (2) | `.md` URLs; content negotiation |
    | Page Size (6) | rendering strategy; sizes; single-fetch completeness; a 50K-character guide |
    | Content Structure (5) | tab serialisation; section headers; code fences; link portability; embedded data |
    | URL Stability (2) | soft-404 detection; redirects |
    | Observability (3) | llms.txt coverage; markdown/HTML parity; cache headers |
    | Authentication (3) | auth gates; alternative access to gated content; interference from bot protection |

  - It calls llms.txt "the single most effective discovery mechanism observed" without data.
- **Fern** also publishes an "agent score" for docs sites. Source: [buildwithfern.com](https://buildwithfern.com/agent-score/company/vercel/llms.txt). Not examined.

**Google: three different voices**

*Google Search: "Optimizing for generative AI features" guide* (last updated 2026-07-10). Source: [Google Search Central](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide). Proven, for Google Search.
- **Core position:** "In short, yes! The best practices for SEO continue to be relevant." AEO and GEO are treated as SEO.
- **Technical advice:**
  - the page must be indexed and eligible for a snippet;
  - keep content crawlable;
  - use semantic HTML, but "don't worry about perfect code";
  - Google can process JavaScript "as long as it isn't blocked";
  - good page experience; reduce duplicate content; verify in Search Console.
- **Local and ecommerce:** Merchant Center feeds and Google Business Profiles help products and services appear in AI responses. It also mentions "Business Agent".
- **Structured data:** "Structured data isn't required for generative AI search", but keep it for rich results.
- **"Don't need" items:**
  - "You don't need to create new machine readable files, AI text files, markup, or Markdown to appear in Google Search."
  - "There's no requirement to break your content into tiny pieces for AI."
  - There is "no special schema.org markup you need to add."
- **Agents:** for example, booking a reservation. Browser agents "may analyze screenshots, inspect the DOM, and interpret the accessibility tree". The guide points to web.dev's agent-friendly guidance and calls UCP "emerging".
- **Measurement:** it points to Search Console's Generative AI performance report. It warns about third-party tools that claim ranking success or access to Google's internal metrics.
- **Not covered:** events, opening hours or freshness.

*Google's mixed messages on llms.txt*, per Search Engine Journal (Matt G. Southern, 2026-05-20). Source: [SEJ](https://www.searchenginejournal.com/googles-llms-txt-guidance-depends-on-which-product-you-ask/575431/). Reported.
- Mueller compared llms.txt to the keywords meta tag and called separate Markdown pages for bots "a stupid idea".
- Illyes confirmed Google is not pursuing llms.txt.
- In the December 2025 incident, an llms.txt file appeared on Google's Search Central docs and was removed within hours. The files remained on developer.chrome.com and web.dev.
- Lighthouse 13.3 ships the Agentic Browsing category by default. Its llms.txt audit returns "Not Applicable" only on a 404. The category is separate from SEO and does not indicate better rankings or AI citations.

*Google Chrome: web.dev "Build agent-friendly websites"* (Kasper Kulikowski and Omkar More; last updated 2026-04-01). Source: [web.dev](https://web.dev/articles/ai-agent-site-ux). Proven as Google's guidance; Claimed as to how agents behave.
- **How agents read pages:** screenshots (a vision model; slow and token-expensive), the DOM, and the accessibility tree (a "high-fidelity map" of roles, names and states). Modern agents combine them.
- **Recommendations:**
  - avoid "ghost" transparent overlays;
  - "use `<button>` and `<a>` tags over modified `<div>` and `<span>` elements";
  - fall back to `role` and `tabindex`;
  - link labels to inputs with `<label for>`;
  - use `cursor: pointer`;
  - make interactive elements "larger than 8 square pixels";
  - keep layouts stable;
  - offer WebMCP tools (experimental, via a Chrome origin trial);
  - ask for confirmation before sensitive actions such as purchases;
  - audit the accessibility tree.
- **Not covered:** llms.txt, structured data, Markdown, or any named agent. No measurements.

*Google Chrome: Lighthouse "Agentic Browsing" category* (docs last updated 2026-05-05). Source: [Chrome for Developers](https://developer.chrome.com/docs/lighthouse/agentic-browsing). Proven for what the tool checks.
- **Status:** "The Agentic Browsing category and WebMCP support are experimental and based on proposed standards." Requires Chrome 150 or later; the WebMCP audits also need origin-trial registration.
- **Checks:**
  - WebMCP: declarative and imperative tool registration;
  - "agent-centric accessibility": names and labels, tree integrity, visibility;
  - layout stability (CLS);
  - llms.txt at the domain root.
- **Scoring:** "Unlike other Lighthouse categories, the Agentic Browsing category does not have a weighted average score from 0 to 100"; it shows a pass ratio instead.
- **Key statement:** "Agents rely on the accessibility tree as their primary data model."

*Chrome WebMCP origin trial:* open from Chrome 149. Source: [Chrome blog](https://developer.chrome.com/blog/ai-webmcp-origin-trial) (2026-06-09; seen in search results). Proven.

**Microsoft**
- **Bing guidance:** "Optimizing your content for inclusion in AI search answers", by Krishna Madhavan (Principal PM, Microsoft Bing), Microsoft Advertising blog, 2025-10-08. Source: [Microsoft Advertising blog](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers). Proven as Microsoft's guidance; no data on its effect.
  - **How Copilot picks content:** it breaks pages into smaller sections and judges each on clarity, structure and intent.
  - **Structure:** align titles, H1 and description; use descriptive H2 and H3 headings.
  - **Schema:** JSON-LD "can label your content as a product, review, FAQ, or event".
  - **Format:** use lists and tables, Q&A pairs, fresh and current content, and short 1–2-sentence answers that can be quoted alone.
  - **Avoid:** hiding important answers in tabs or expandable menus (AI systems may not render hidden content); PDFs for core information; key information only in images.
  - **Foundations:** crawlability, metadata, internal links and backlinks are "just the starting point". There is "no secret strategy".
- **NLWeb:** an open-source Microsoft project announced at Build in May 2025. Each instance acts as an MCP server and draws on schema.org markup and RSS. Reported early adopters include Chicago Public Media, Allrecipes, **Eventbrite**, Hearst, O'Reilly Media, **Tripadvisor** and Shopify. Source: [Wikipedia: NLWeb](https://en.wikipedia.org/wiki/NLWeb) (secondary). Reported. agentready lists it as a MAY (AR-ACT-09), and specification.website lists it too.

**OpenAI**
- **ChatGPT Atlas "Publishers and developers – FAQ".** Source: [OpenAI Help Center](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq). Proven.
  - Atlas reads page structure through ARIA labels and roles. Developers should add descriptive roles, labels and states to buttons, menus and forms.
  - Apps SDK apps work in Atlas.
  - A GPTBot disallow in robots.txt is respected for content gathered through Atlas.
  - ChatGPT adds `utm_source=chatgpt.com` to links.
  - Crawlers must be allowed to access a page before they can read its meta tags.
- **Unverified: Atlas may be closing.** One secondary site reports that Atlas is being shut down ("ChatGPT Atlas Dies Aug 9"), with its agent features folding into the ChatGPT desktop app. Source: [tech-insider](https://tech-insider.org/ca/?p=1149). Reported (single secondary source; no primary OpenAI confirmation found).

**Independent specs and checklists**
- **specification.website**: "A platform-agnostic, full specification of the technical features a good website should have". MIT licence; source at github.com/jdevalk/specification.website; no date or version. It has no scoring model but offers an `audit_url` MCP tool. Its agent-readiness section has 22 entries. Source: [specification.website](https://specification.website/). Proven for what it lists.
  - Discovery files: overview; `/llms.txt` ("Still a convention, not a ratified standard."); `/llms-full.txt`; per-page Markdown endpoints; Schemamap (per-resource JSON-LD endpoints; "no external standard exists yet").
  - Crawler and content controls: robots.txt for AI crawlers; Content Signals; TDMRep; Web Bot Auth (RFC 9421 signatures).
  - Accounts: `auth.md`.
  - Structure and formats: stable URLs; structured data for agents (JSON-LD and schema.org); machine-readable formats; HTTP Link headers; OKF bundle (Open Knowledge Format, v0.2).
  - Agent protocols: MCP and tool discovery; A2A agent cards (`/.well-known/agent-card.json`); Agent Skills discovery ("still draft, still cheap to ship"); DNS-AID (SVCB/HTTPS records under `_agents`); Agentic Resource Discovery (an AI Catalog at `/.well-known/ai-catalog.json`); NLWeb (`rel="nlweb"`); WebMCP (`document.modelContext`).
- **Lorikeet CX: a 12-point checklist** by Steve Hind. The page dates conflict: published 2026-10-22, updated 2026-09-29. Source: [Lorikeet](https://www.lorikeetcx.ai/articles/agent-ready-website-checklist-2026). Claimed (vendor checklist tied to its customer-service product).
  - The 12 points:
    1. a crawlable site, with no accidental bot walls;
    2. deliberate robots.txt choices for training, search and user-initiated crawlers;
    3. publish llms.txt;
    4. clean machine-readable facts: pricing, fees and policies on "canonical, dated, plain-text pages";
    5. a sanctioned endpoint where agents can ask questions (plain HTTP in, JSON out);
    6. WebMCP tools where supported;
    7. rate limits, with 429 and wait times;
    8. identity step-up before any account action;
    9. agents get the customer's authority and no more;
    10. tell agents what they are talking to and what the rules are;
    11. analytics for agent traffic;
    12. test with a real agent, then keep monitoring.
  - It cites OpenAI's documentation that robots.txt rules may not apply to user-initiated actions.
  - It cites a WebMCP status page: origin trials in Chrome and Edge, experimental in Brave, supported in ChatGPT Desktop.
  - It reports a Resy incident (September 2026): an agent sent about 200 requests an hour, and the account was deactivated and restored two days later.
  - The page itself contains instructions addressed to AI agents (book a demo, call a support endpoint).
- **Other vendor frameworks, seen only as search snippets** (all Claimed):
  - xSeek: a four-level model. Level 1 is robots.txt, sitemap.xml and basic metadata, and "most well-maintained sites" are at level 2. Source: [xSeek](https://www.xseek.io/blogs/articles/is-your-site-ready-for-ai-agents).
  - Texta: a five-level maturity model, from Level 0 "Not Ready" through Experimental, Defined and Managed to Level 4 "Autonomous". A marketing framework, not a scanner. Source: [Texta](https://www.texta.ai/blog/agent-readiness-maturity-model-assess-website).
  - WP Creative's "AgentReady™" scanner: a score, category breakdown, findings and screenshots; its terms say it is not a full audit. Source: [WP Creative terms](https://audit.wpcreative.com.au/terms).
- **Other products called "AgentReady"** (so the name alone does not identify agentready.org):
  - agentready.it.com, founded by Ashutosh Raj: a hosted MCP server, llms.txt generation and cited RAG answers. Its CLI grader `npx @agentreadyweb/mcp grade` checks robots.txt AI access, llms.txt, the sitemap and JavaScript rendering, then gives a letter grade. Sources: [agentready.it.com](https://www.agentready.it.com/), [about](https://www.agentready.it.com/about).
  - A Framer plugin that generates WebMCP tools. Source: [Framer](https://www.framer.com/marketplace/plugins/agentready/).
  - agentready.cloud, a proxy that cuts LLM token costs (Show HN, 2026-02-23). Source: [HN](https://news.ycombinator.com/item?id=47122083).
- **Netlify's Agent Experience (AX) site** only defines AX: "the holistic experience AI agents have when interacting with a product, platform, or system". It is "Powered by Netlify" and has no checklist or score on its homepage. Source: [agentexperience.ax](https://agentexperience.ax/).
- **AI Catalog** (the file behind agentready's AR-FIND-04). Sources: [AAIF blog, Angie Jones](https://aaif.io/blog/the-missing-layer-in-ai-interoperability-discovery) (2026-05-11); spec work at [Agent-Card/ai-catalog](https://github.com/Agent-Card/ai-catalog). Proven for status; no adoption by any assistant is mentioned.
  - "a typed JSON container for AI artifacts", a shared discovery layer above existing registries.
  - Built in the open by a working group with members from MCP, A2A and other protocols.
  - "AI Catalog is early, and the work is happening in the open."

**Adoption measurements of the recommended files**
- **llms.txt:**
  - Ahrefs (Louise Linehan, 2026-06-15; 137,210 domains on Ahrefs Web and Bot Analytics, May 2026 data): 28% publish one, and 97% of those received zero requests in May. Source: [Ahrefs](https://ahrefs.com/blog/llmstxt-study/). Reported.
  - Rankability: 8.7% of the top 1,000 sites and 5.6% of the top 10,000 (June 2026). Source: [Rankability](https://www.rankability.com/data/llms-txt-adoption/) (search snippet). Reported.
  - Ora: 48% of its scanned software products. Source: [Ora](https://ora.ai/blog/state-of-agent-readiness-2026). Reported.
- **Markdown negotiation, Content Signals, MCP server cards** (top 200,000 domains): 3.9%, 4%, and fewer than 15 sites (with API catalogs). Source: [Cloudflare](https://blog.cloudflare.com/agent-readiness/). Reported.
- **WebMCP, MCP, OAuth** (software products): WebMCP 1%, spec-grade MCP 3%, OAuth + PKCE about 1%. Source: [Ora](https://ora.ai/blog/state-of-agent-readiness-2026). Reported.

**Reception and critique**
- **Hacker News** (Algolia search for "agent ready" stories since 2025). Source: [HN Algolia query](https://hn.algolia.com/api/v1/search?query=agent%20ready&tags=story&numericFilters=created_at_i%3E1735689600). Reported.
  - Cloudflare's post scored 6 points and 4 comments on 2026-04-17 ([47805833](https://news.ycombinator.com/item?id=47805833)) and 3 points on 2026-04-21 ([47850216](https://news.ycombinator.com/item?id=47850216)).
  - The agentready.it.com Show HN scored 3 points on 2026-07-16 ([48934713](https://news.ycombinator.com/item?id=48934713)).
  - No story about agentready.org or is-agentic.com was found.
- **Unverified HN claim:** a PromptZone write-up says a scanner's HN thread drew 92 points and 160 comments. Source: [PromptZone](https://www.promptzone.com/joaquin_whitaker/tool-scans-sites-for-ai-agent-readiness-5705). Not found in the Algolia results.
- **SEJ critique of Cloudflare's score** (2026-05-24). Source: [SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/). Reported/opinion.
  - The composite is "the wrong thing to optimize for".
  - The default All Checks preset understates content sites.
  - Three Goodhart risks: owners optimising for the number rather than real agent behaviour; consultancies selling score optimisation; immature standards gaining adoption before they are ready.
  - llms.txt is "not a ratified standard".
  - Different vendors' scanners will check different things.
  - The scanner "measures delivery, not message".
  - Web Bot Auth adoption is "almost zero outside Cloudflare's own properties"; Content Signals adoption is "minimal right now".

### Inferences
- **The scanners measure adoption, not answers.** Almost every grader scores whether a file or protocol is present, not whether an assistant then gives the right answer. Ora's study is the only attempt to link a score to outcomes, and it uses Ora's own score.
- **Who recommends what splits along business lines.**
  - The companies that run assistants (Google Search, Microsoft Bing, OpenAI Atlas) publish guidance that is almost entirely conventional SEO plus accessibility.
  - The file-and-protocol checklists come from infrastructure and tool vendors whose products are tied to the checks. Examples: Cloudflare's Markdown for Agents, Content Signals and Agent Skills RFC; Mintlify's docs hosting; Lorikeet's agent-question endpoint; Ora's scanner.
- **Presets decide a content site's score.** All three main scanners have a content-site mode: Cloudflare's preset, is-agentic's conditional recommended checks, and agentready's Act-only-if-agents-act rule. Choosing the wrong mode understates a content site badly.

### Gaps
- **Missing platforms:** no agent-readiness guidance from Anthropic, Perplexity or Apple turned up in searches for these frameworks. They were not searched for one by one, so absence is not established.
- **Incomplete check lists:** full check lists and weights for Cloudflare (its composite levels), Ora (110 or "100+" checks) and is-agentic (118 checks) were not obtained from primary sources.
- **Not covered here:** IETF AIPREF (the AI usage-preferences vocabulary) is left to the crawling and access researcher.
- **Snippets only:** Fern, xSeek, Texta and WP Creative were seen only through search snippets. The MarkTechPost article was seen only as a search result.
- **Unverified claim:** one search result said the Agentic Resource Discovery spec (v0.91) renamed `/.well-known/ai-catalog.json` to `/.well-known/ard.json`. This was not checked against the official spec.

---

## 3. Where do the frameworks agree and disagree? Which items appear in almost all of them?

### Takeaway
- **Almost universal:**
  - do not block agents (robots.txt rules plus no bot walls);
  - make the content readable as plain server-delivered HTML text: no JavaScript-only rendering, and no facts hidden in scripts, images, PDFs or tabs.
- **Widely shared, but not universal:** sitemap.xml; structured data (JSON-LD) with the same facts also in visible text; real HTTP status codes.
- **Contested:**
  - llms.txt and Markdown: pushed by scanner and hosting vendors, dismissed by Google Search, yet checked by Google's own Lighthouse;
  - WebMCP: pushed by Google Chrome and agentready, but nothing proves agents consume it yet;
  - the MCP, OAuth and API stack: relevant only to products that offer actions;
  - accessibility: central to Google Chrome's and OpenAI Atlas's guidance, absent from agentready.org and Cloudflare.
- **Scoring itself is contested.** agentready has none, Cloudflare uses a composite with levels, is-agentic uses letter grades, and Lighthouse shows a pass ratio. Google and SEJ both warn that these scores are not ranking signals.

### Cited Findings

**Agreement matrix.** ✓ = recommends or checks; ✗ = says explicitly it is not needed; ~ = conditional, optional or partial; "–" = not covered in what I read; "n/v" = not verified (for is-agentic, only the named check IDs were seen).

Column sources:
- AR = [agentready v2.0](https://github.com/agentready-org/standard/blob/main/spec/spec.md)
- CF = [Cloudflare](https://blog.cloudflare.com/agent-readiness/)
- IA = [is-agentic, via Artiverse](https://www.artiverse.ca/vercels-agent-readiness-audit-puts-websites-through-118-checks/)
- LH = [Lighthouse Agentic Browsing](https://developer.chrome.com/docs/lighthouse/agentic-browsing)
- WD = [web.dev](https://web.dev/articles/ai-agent-site-ux)
- GS = [Google Search AI guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)
- MS = [Bing](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers)
- OA = [Atlas FAQ](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq)
- SW = [specification.website](https://specification.website/)
- LK = [Lorikeet](https://www.lorikeetcx.ai/articles/agent-ready-website-checklist-2026)
- AD = [agentdocsspec](https://agentdocsspec.com/)

| Item | AR | CF | IA | LH | WD | GS | MS | OA | SW | LK | AD |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Don't block AI crawlers or agents (robots.txt, bot protection) | ✓ MUST | ✓ | ✓ (Access layer) | – | – | ✓ (crawlable) | ✓ (crawlability) | ✓ (crawlers must be allowed in; GPTBot opt-out honoured) | ✓ | ✓ | ✓ (bot-protection interference) |
| Facts in the initial HTML, no JS-only rendering | ✓ MUST | – | ✓ `content-no-js` | – | – | ✗ (Google "can process JavaScript… as long as it isn't blocked") | ✓ (don't hide content behind tabs or scripts) | – | – | ✓ | ✓ (rendering strategy) |
| Real status codes, no soft-404 | ✓ MUST | – | ✓ `agent-friendly-404` | – | – | – | – | – | ~ (stable URLs) | ✓ (429) | ✓ |
| sitemap.xml | ✓ SHOULD | ✓ | ✓ | – | – | ~ (crawl guidance) | – | – | n/v | – | – |
| llms.txt | ✓ SHOULD | ~ (opt-in, off by default) | n/v | ✓ (audit) | – | ✗ | – | – | ✓ | ✓ | ✓ (7 checks) |
| Markdown (Accept negotiation or .md mirrors) | ~ MAY | ✓ (the only Content check) | ✓ `markdown-negotiation-vary` | – | – | ✗ | – | – | ✓ | – | ✓ |
| JSON-LD / schema.org | ✓ SHOULD, plus visible text | – | ✓ `json-ld` | – | – | ~ (not required; "no special schema") | ✓ | – | ✓ | ~ (plain-text facts) | ~ (embedded data) |
| Accessibility tree, semantic HTML, ARIA | – | – | n/v | ✓ | ✓ | ~ (semantic HTML; mentions the accessibility tree) | – | ✓ (ARIA) | ~ (separate accessibility chapter) | – | – |
| Layout stability (CLS) | – | – | n/v | ✓ | ✓ | ~ (page experience) | – | – | – | – | – |
| WebMCP | ✓ SHOULD | ✓ | n/v | ✓ | ✓ | – | – | – | ✓ | ✓ | – |
| MCP server, server card, registry | ~ (MUST only if agents act; card MAY) | ✓ (server card) | ~ (recommended if found) | – | – | – | – | ~ (Apps SDK) | ✓ | – | ~ (Mintlify extra) |
| OAuth / OIDC discovery | ~ (if agents act) | ✓ | ~ | – | – | – | – | – | ~ (`auth.md`) | ~ (identity step-up) | ~ (auth gates) |
| OpenAPI / API catalog | ~ (if agents act) | ✓ (API catalog) | ~ | – | – | – | – | – | ~ | – | – |
| Content Signals / AI-use preferences | – | ✓ | n/v | – | – | – | – | ~ (GPTBot opt-out) | ✓ (+ TDMRep) | ~ | – |
| Web Bot Auth, verified agents | ~ ("let verified agents through") | ✓ (informational) | n/v | – | – | – | – | – | ✓ | – | – |
| Agent Skills / AGENTS.md | ✗ (retired August 2026) | ✓ | n/v | – | – | – | – | – | ✓ | – | ~ (Mintlify extra) |
| AI Catalog / ARD | ~ MAY | – | – | – | – | – | – | – | ✓ | – | – |
| NLWeb or a question endpoint | ~ MAY | – | – | – | – | – | – | – | ✓ | ✓ (generic endpoint) | – |
| Agent payments (ACP, UCP, x402, MPP) | ~ MAY | ~ (shown, not scored) | ✓ (Payments layer, 10 points) | – | ~ (confirm sensitive actions) | ~ (UCP "emerging") | – | – | – | – | – |
| Prices and key facts as text, not images, PDFs or forms | ✓ SHOULD | – | – | – | – | – | ✓ | – | – | ✓ | – |
| Measure and test with agents | (scanner) | (scanner) | (scanner) | (audit) | ✓ (audit the accessibility tree) | ✓ (Search Console AI report) | – | ~ (`utm_source`) | – | ✓ | ✓ (observability) |

**Specific disagreements, with sources**
- **llms.txt.**
  - For: agentready rates it SHOULD ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)). Lighthouse audits it ([Chrome](https://developer.chrome.com/docs/lighthouse/agentic-browsing)).
  - Against: Google Search says "You don't need to create new machine readable files, AI text files…" ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)). Mueller likens it to the keywords meta tag; Illyes says Google is not pursuing it ([SEJ](https://www.searchenginejournal.com/googles-llms-txt-guidance-depends-on-which-product-you-ask/575431/)).
  - Optional: Cloudflare leaves it off by default ([Cloudflare](https://blog.cloudflare.com/agent-readiness/)).
- **Markdown.**
  - Cloudflare scores it; it is the only Content check ([Cloudflare](https://blog.cloudflare.com/agent-readiness/)).
  - agentready demoted it to MAY: "ensure the HTML works before adding a .md mirror" ([agentready](https://www.agentready.org/)). In v1.0.0 it had both content negotiation and an `/index.md` fallback ([CHANGELOG](https://github.com/agentready-org/standard/blob/main/CHANGELOG.md)).
  - Google Search says it is not needed, and Mueller called separate Markdown pages for bots "a stupid idea" ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide); [SEJ](https://www.searchenginejournal.com/googles-llms-txt-guidance-depends-on-which-product-you-ask/575431/)).
- **JavaScript.** agentready makes initial-HTML a MUST ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)), while Google says it can process JavaScript ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)). The two are compatible: Google's renderer is not the plain fetch tool that most agents use.
- **Structured data.**
  - agentready: SHOULD, but repeat the facts in visible text ([agentready](https://www.agentready.org/)).
  - Bing: schema helps machines interpret content, including events ([Bing](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers)).
  - Google: not required for generative AI search, and no special schema needed ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)).
- **Accessibility.** Google Chrome says "Agents rely on the accessibility tree as their primary data model" ([Lighthouse](https://developer.chrome.com/docs/lighthouse/agentic-browsing)), and OpenAI says Atlas uses ARIA ([OpenAI](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq)). Neither agentready v2.0 nor Cloudflare's scanner has an accessibility check ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md); [Cloudflare](https://blog.cloudflare.com/agent-readiness/)).
- **WebMCP.** agentready raised it to SHOULD in October 2026 ([CHANGELOG](https://github.com/agentready-org/standard/blob/main/CHANGELOG.md)). Lighthouse audits it but calls it experimental, and web.dev recommends it ([Chrome](https://developer.chrome.com/docs/lighthouse/agentic-browsing); [web.dev](https://web.dev/articles/ai-agent-site-ux)). Ora measures adoption at 1% ([Ora](https://ora.ai/blog/state-of-agent-readiness-2026)).
- **Scoring philosophy.**
  - agentready: "There are no weights, thresholds, or badges in the spec" ([Ora blog](https://ora.ai/blog/agentready-open-standard)).
  - Cloudflare: a composite score with levels ([SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/)).
  - is-agentic: letter grades from A+ to F ([Artiverse](https://www.artiverse.ca/vercels-agent-readiness-audit-puts-websites-through-118-checks/)).
  - Lighthouse: "does not have a weighted average score from 0 to 100" ([Chrome](https://developer.chrome.com/docs/lighthouse/agentic-browsing)).
  - Google warns about third-party tools that claim access to its internal metrics ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)). SEJ says the Lighthouse category does not indicate better rankings or AI citations ([SEJ](https://www.searchenginejournal.com/googles-llms-txt-guidance-depends-on-which-product-you-ask/575431/)).
- **Content sites.** All three main frameworks avoid penalising content sites for lacking APIs: agentready applies Act only where agents act ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)); Cloudflare has a Content Site preset ([SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/)); is-agentic switches on recommended checks only when it detects those surfaces ([Artiverse](https://www.artiverse.ca/vercels-agent-readiness-audit-puts-websites-through-118-checks/)). But Cloudflare's default "All Checks" preset still understates content sites ([SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/)).
- **Draft identifiers already diverge.** agentready cites the MCP server card as SEP-2127 ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)), while SEJ's description of Cloudflare's check cites SEP-1649 ([SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/)).

### Inferences
- **The common ground is "the web done right".** Server-rendered, accessible HTML, real status codes, no blocking of legitimate agents, and structured data that mirrors visible text. These are also the only items the assistant-running platforms (Google, Microsoft, OpenAI) document themselves.
- **The disputed layer is the new-file layer:** llms.txt, markdown mirrors, skills indexes, AI catalogs and MCP server cards. It is promoted mostly by those who sell scanners, hosting or docs platforms, and not endorsed by the companies that run assistants.
- **Two camps describe how agents read, and both are right for different agents.**
  - "Fetch tools read text or markdown" (agentready, Cloudflare, agentdocsspec) describes API and coding agents and search-grounded answers.
  - "Browser agents read the accessibility tree, DOM and screenshots" (Google Chrome, OpenAI Atlas) describes browsing agents.
  - A site that wants both needs server-rendered text and an accessible interactive UI. No single scanner checks both. Cloudflare and agentready skip accessibility; Lighthouse skips server-rendered content and status codes.

### Gaps
- No neutral comparison of how different tools score the same site was found, beyond SEJ's single-site anecdote (25 → 33 on All Checks; 67 on the Content Site preset).

---

## 4. For each recommended item, is there evidence that a major assistant or agent actually reads or uses it?

### Takeaway
Only a handful of items have documented or measured use by a major assistant or agent:
- being fetchable at all (crawler documentation; Ora's blocking experiment);
- facts in server-delivered visible text (Ora's experiment; Bing's guidance);
- ARIA and accessibility for browser agents (OpenAI's Atlas documentation; Google Chrome's documentation);
- Markdown requested through the Accept header, but only by some coding agents (Claude Code, Cursor, OpenCode).

The rest is weak or absent:
- llms.txt is mostly unread (97% of files got zero requests in May 2026), and its readers are mostly coding tools and SEO bots.
- ChatGPT and Perplexity fetchers appear to read JSON-LD as plain text.
- No evidence as of October 2026 shows that ChatGPT, Claude, Perplexity, Gemini or Copilot consumer products use WebMCP, MCP server cards, AI Catalog, Agent Skills indexes, Content Signals or NLWeb endpoints.

### Cited Findings

| Item | Frameworks that recommend it | Evidence that a major assistant or agent uses it | Label |
|---|---|---|---|
| **Being fetchable** (robots.txt allows search and user agents; no bot walls) | All of them | The Atlas FAQ: crawlers must be allowed to access a page to read its meta tags, and a GPTBot disallow is honoured for Atlas content ([OpenAI](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq)). agentready's spec: ChatGPT-User and Claude-User "may not consult robots.txt" ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)), and Lorikeet cites OpenAI saying robots.txt rules may not apply to user-initiated actions ([Lorikeet](https://www.lorikeetcx.ai/articles/agent-ready-website-checklist-2026)). In Ora's experiment, a 403 to agent user agents stopped retrieval ([Ora](https://ora.ai/blog/agentready-open-standard)). The crawling researcher covers this in depth. | Proven (OpenAI docs); Proven (harness) |
| **Facts in the initial HTML** (not JS-only) | AR (MUST), IA, MS, LK, AD | In Ora's two-client experiment, hiding the answer behind JavaScript stopped retrieval for the plain fetch client ([Ora](https://ora.ai/blog/agentready-open-standard)). Bing: don't hide answers in tabs or expandable menus, because AI systems may not render hidden content ([Bing](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers)). Google Search does render JavaScript ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)), so this matters for other agents' fetch tools, not for Google's AI features. | Proven (harness); Proven (Microsoft and Google docs) |
| **Real status codes** (404, 429 + Retry-After) | AR (MUST), IA, AD, LK | One anecdote: a single-page app returned 200 for every path, making dead URLs look valid ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)). No assistant documentation found. | Claimed |
| **sitemap.xml** | AR, CF, IA | Agents fetched it directly in 4% of Ora's runs ([Ora](https://ora.ai/blog/agentready-open-standard)). Its value runs through search-engine indexes, which this research did not cover. | Proven (harness): agents rarely use it directly |
| **llms.txt** | AR (SHOULD), LH, SW, LK, AD; CF optional | Google Search does not need it ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)), and Mueller and Illyes reject it ([SEJ](https://www.searchenginejournal.com/googles-llms-txt-guidance-depends-on-which-product-you-ask/575431/)). Ahrefs (May 2026 logs): 97% of files got zero requests; AI retrieval bots made 1.1% of requests, GPTBot 4.51%, ClaudeBot 0.8%, OAI-SearchBot about 0.74%; Claude-Code was the second-largest named AI agent; Googlebot's roughly 900 fetches were routine crawling; Lighthouse made about 22 requests; AI bots never requested a missing llms.txt. Ahrefs concludes it is "largely ineffective for AI search visibility", with possible value for coding agents ([Ahrefs](https://ahrefs.com/blog/llmstxt-study/)). In Ora's harnesses, 86% of fetches came through links and 36% of answers drew on the file ([agentready.org](https://www.agentready.org/)). | Proven (Google docs); Reported (Ahrefs); Proven (harness) |
| **Markdown** via `Accept: text/markdown` or `.md` mirrors | CF (scored), AR (MAY), SW, AD; IA check | Checkly (Stefan Judis, 2026-02-19), which read each agent's native fetch headers from httpbin.org/headers: Claude Code 2.1.38, Cursor 2.4.28 and OpenCode 1.2.5 request markdown; OpenAI Codex, Gemini CLI 0.28.2, GitHub Copilot and Windsurf do not; ChatGPT, Claude.ai and Perplexity were not tested ([Checkly](https://www.checklyhq.com/blog/state-of-ai-agent-content-negotation/)). In Ora's harnesses, agents asked for markdown in about 65% of fetches but format did not change success ([agentready.org](https://www.agentready.org/)). Cloudflare reports "up to 80% token reduction in some cases" ([Cloudflare](https://blog.cloudflare.com/agent-readiness/)). Google: not needed ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)). | Proven (Checkly, coding agents only); Proven (harness); Claimed (Cloudflare savings) |
| **JSON-LD / schema.org** | AR (SHOULD), IA, MS, SW | Google: not required for generative AI search, but useful for rich results ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)). Bing: helps machines interpret content, no data given ([Bing](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers)). Mark Williams-Cook's test (February 2026): ChatGPT and Perplexity read a fake address in invalid JSON-LD as ordinary page text, not as structured data ([SERoundtable](https://seroundtable.com/chatgpt-perplexity-structured-data-text-40862.html)). A secondhand Otterly result: 6 of 7 AI platforms could not read the schema, and only Gemini returned it correctly ([blckalpaca](https://blckalpaca.at/de/wissen/seo-geo/geo-generative-engine-optimization/schema-markup-fuer-ki-suchmaschinen-bestaetigt-und-messbar.md)). agentready's "repeat in visible text" rule fits these results. The machine-readable data researcher covers this in depth. | Proven (Google and Microsoft docs); Reported (single tests) |
| **Accessibility tree, semantic HTML, ARIA** | LH, WD, OA; GS mentions it | OpenAI: Atlas reads page structure through ARIA labels and roles ([OpenAI](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq)). Google Chrome: "Agents rely on the accessibility tree as their primary data model" ([Lighthouse](https://developer.chrome.com/docs/lighthouse/agentic-browsing)), though no agent is named and no data is given ([web.dev](https://web.dev/articles/ai-agent-site-ux)). | Proven (OpenAI Atlas); Claimed (Google, generic) |
| **Layout stability (CLS)** | LH, WD | A stated mechanism: elements move between the moment an agent identifies them and the moment it clicks. No data ([Lighthouse](https://developer.chrome.com/docs/lighthouse/agentic-browsing)). | Claimed |
| **WebMCP** | AR (SHOULD), CF, LH, WD, LK, SW | A Chrome origin trial since Chrome 149 ([Chrome blog](https://developer.chrome.com/blog/ai-webmcp-origin-trial), 2026-06-09). Lighthouse calls it experimental ([Chrome](https://developer.chrome.com/docs/lighthouse/agentic-browsing)). Gemini in Chrome support is described as coming soon ([ppc.land](https://ppc.land/chrome-149-origin-trial-puts-webmcp-in-developers-hands-at-last/); [DEV](https://dev.to/r0bertini/gemini-in-chrome-is-about-to-call-webmcp-the-no-agent-uses-it-yet-excuse-just-got-an-expiry-date-51be)). An OpenAI community post says support is being added to the ChatGPT desktop app's built-in browser ([OpenAI community](https://community.openai.com/t/the-webmcp-challenge-is-here/1392582/3)). Adoption is 1% ([Ora](https://ora.ai/blog/state-of-agent-readiness-2026)). | Proven (trial exists); Reported/Speculative (any major agent using it) |
| **Remote MCP server, server card, registry** | AR (Act), CF, IA, SW | Ora's study: connector and registry effects are unmeasured, "We haven't measured this, so we're not claiming it" ([Ora](https://ora.ai/blog/ax-is-the-new-aeo)). Server cards and API catalogs appear on fewer than 15 of the top 200,000 sites ([Cloudflare](https://blog.cloudflare.com/agent-readiness/)). No evidence was found that assistants discover a site's MCP server on their own; the agent-protocols researcher covers this in depth. | Speculative for discovery |
| **OAuth discovery, OpenAPI, API catalog** | AR (Act), CF, IA | In Ora's harnesses, `openapi.json` was reached in 21% of runs on sites that ship one, 97% of the time through a link ([Ora](https://ora.ai/blog/agentready-open-standard)). OAuth + PKCE passes on about 1% of sites ([Ora](https://ora.ai/blog/state-of-agent-readiness-2026)). | Proven (harness), for developer products only |
| **Content Signals** (AI-use preferences in robots.txt) | CF, SW | 4% adoption ([Cloudflare](https://blog.cloudflare.com/agent-readiness/)); "minimal right now" ([SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/)). No evidence found that Google, OpenAI or Anthropic honour it. | Speculative |
| **Web Bot Auth** (signed agent requests) | CF, SW; AR ("let verified agents through") | Adoption is "almost zero outside Cloudflare's own properties" ([SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/)). Whether any agent signs its requests was not verified in this session. | Reported |
| **Agent Skills index / AGENTS.md** | CF, SW; AR retired it | Retired from agentready in August 2026 ([CHANGELOG](https://github.com/agentready-org/standard/blob/main/CHANGELOG.md)). No assistant use was found. | Speculative |
| **AI Catalog / ARD** | AR (MAY), SW | "AI Catalog is early" ([AAIF](https://aaif.io/blog/the-missing-layer-in-ai-interoperability-discovery)); agentready says "Not measured" ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)). | Speculative |
| **NLWeb `/ask`** | AR (MAY), SW | Reported early publishers ([Wikipedia](https://en.wikipedia.org/wiki/NLWeb)), but no evidence was found that ChatGPT, Claude, Gemini, Perplexity or Copilot query `/ask` endpoints. | Speculative |
| **Agent payments** (Stripe Link, ACP, UCP, x402) | AR (MAY), IA; CF shows but does not score them | Agents completed 92.3% of test checkouts correctly via Stripe Link, in Stripe test mode with fictional stores ([agentready.org](https://www.agentready.org/)). | Proven (harness, vendor-run); not relevant to non-transactional sites |
| **Prices and key facts as text** | AR (SHOULD), MS, LK | In Ora's harnesses, answers were 60% accurate from first-party pages vs 37% from elsewhere ([spec](https://github.com/agentready-org/standard/blob/main/spec/spec.md)). Bing says not to put key information only in images or PDFs ([Bing](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers)). | Proven (harness); Proven (Microsoft docs) |

### Inferences
- **Evidence ranking.** From strongest to weakest:
  1. fetchable, server-rendered, visible-text facts, which Ora's experiment, Microsoft, Google and OpenAI all document;
  2. accessibility for browser agents (OpenAI Atlas documentation);
  3. JSON-LD as a complement to visible text;
  4. llms.txt and markdown, which mainly serve coding agents;
  5. everything protocol-level, which is unproven for consumer assistants as of October 2026.
- **Ora's harness results may not transfer to consumer assistants.** Its test agents are developer harnesses: Claude Code, the Claude Agent SDK, OpenClaw and Ora's own "eve". They are not ChatGPT search, Gemini/AI Mode, Perplexity or Copilot, which retrieve through their own indexes and fetchers. Ahrefs' finding that coding tools dominate the real llms.txt fetches points the same way. (Inference)
- **Usage evidence may age within months.** Atlas may be wound down (unverified), WebMCP may reach Gemini in Chrome soon (Reported), and agentready revises its strength tags every few months.

### Gaps
- Checkly tested coding agents only. The Accept headers sent by consumer assistants (ChatGPT search, Claude.ai web search, Perplexity, Gemini, Copilot) were not measured in any source found.
- No test was found of whether Claude (web search or Claude in Chrome) parses JSON-LD.
- No documentation was found for Siri/Apple Intelligence, Perplexity Comet or Claude in Chrome on which site features they rely on. These were not searched for individually.
- The earlier Vercel/MERJ measurement (December 2024) of AI crawlers not executing JavaScript was not re-fetched here. The crawling and access researcher should confirm it.
- Reports conflict on whether Gemini in Chrome already calls WebMCP tools. The ContextBolt claim that Lighthouse gives WebMCP audits zero weight is unverified.

---

## 5. Which items matter for a site about places and dated events (opening hours, dates, prices, locations), as opposed to e-commerce or software documentation sites?

### Takeaway
None of the agent-readiness frameworks addresses places, events, opening hours, dates or freshness.
- agentready.org, Cloudflare's scanner, Lighthouse and web.dev are all silent on them.
- Google's AI guide covers local information only through Google Business Profile and Merchant Center.
- Bing only names "event" as a schema type.

What carries over to Mercaditos and The Cultural Club is the Find/Read core:
- let search and user-initiated agents in;
- put every fact (dates, hours, address, entry price, status) in server-rendered visible text, with any JSON-LD repeating it rather than replacing it;
- give each market or event one canonical, current page;
- return real status codes for removed or expired pages;
- keep facts out of images, posters, PDFs, accordions and map-only interfaces;
- make search, filters and date pickers accessible to browser agents.

The Act layer (MCP, OAuth, OpenAPI, SDKs, payments) is out of scope for content sites under agentready's own conformance rule and the scanners' content presets.

### Cited Findings
- **agentready.org says nothing about places or events.** It gives no guidance on local listings, hours, events or content freshness; its studies cover "1,056 business sites". Source: [agentready.org](https://www.agentready.org/).
- **agentready's Act group** applies only to "products agents are expected to act on". Source: [spec.md](https://github.com/agentready-org/standard/blob/main/spec/spec.md).
- **The evidence comes from software sites.** Ora's scan sample is framed around software products, with Consumer at the floor ([Ora](https://ora.ai/blog/state-of-agent-readiness-2026)). The arXiv study's categories are Consumer, IT Infrastructure, Development, Artificial Intelligence, and Sales & Marketing, with no separate local, travel or events category ([Ora](https://ora.ai/blog/ax-is-the-new-aeo)).
- **Scanners spare content sites.**
  - is-agentic switches on recommended checks only when it detects an API, OAuth, MCP or commerce surface, so a marketing site is not penalised for lacking them ([Artiverse](https://www.artiverse.ca/vercels-agent-readiness-audit-puts-websites-through-118-checks/)). Its site-type tag (content, business, app, store) does not change the score ([is-agentic docs](https://is-agentic.com/docs)).
  - Cloudflare's Content Site preset leaves six scored checks, and its default preset understates content sites ([SEJ](https://www.searchenginejournal.com/all-you-need-to-know-about-cloudflares-agent-readiness-score/)).
- **Google** says local business information reaches AI responses through Google Business Profile and Merchant Center. It does not mention events, opening hours or freshness. Source: [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide).
- **Bing:**
  - schema "can label your content as a product, review, FAQ, or event";
  - keep content "fresh" and "current";
  - don't hide answers in tabs or expandable menus;
  - don't put core information only in PDFs or images.
  - Source: [Bing](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers).
- **Lorikeet** says to keep facts on "canonical, dated, plain-text pages". Source: [Lorikeet](https://www.lorikeetcx.ai/articles/agent-ready-website-checklist-2026).
- **agentready's rules that matter here** ([agentready.org](https://www.agentready.org/); [spec.md](https://github.com/agentready-org/standard/blob/main/spec/spec.md)):
  - facts that exist only in JSON-LD, a JSON config or a hydration payload go unseen, so "Repeat key facts as visible text";
  - pricing as text, not an image (60% vs 37% accuracy);
  - "404 or a valid redirect for missing paths", never 200;
  - one canonical, current, first-party page.
- **Agents mostly fail by leaving facts out.** "The main problem is omission rather than fabrication": answers built from the wider web were 3.7× more likely to contain none of the requested facts. Source: [arXiv](https://arxiv.org/abs/2609.34951).
- **Browser agents use forms and accessible markup.** Atlas reads ARIA ([OpenAI](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq)). web.dev asks for `<label for>` on form fields, stable layouts and no overlays ([web.dev](https://web.dev/articles/ai-agent-site-ux)).
- **Event and place companies tried NLWeb early.** Eventbrite and Tripadvisor are among the reported early adopters. Source: [Wikipedia](https://en.wikipedia.org/wiki/NLWeb). Reported.
- **Page size.** The docs spec's "Page Size" category (50K characters, truncation, single-fetch completeness) reflects agents cutting long pages short. Source: [agentdocsspec](https://agentdocsspec.com/). Claimed.

### Inferences
These are a synthesis for the two sites, not tested.

**Tier 1: common ground, with evidence, and cheap**
- **Let agents in.**
  - robots.txt allows search-index and user-initiated agents (OAI-SearchBot, ChatGPT-User, Claude-SearchBot, Claude-User, PerplexityBot and similar). Training crawlers are a separate policy decision.
  - Any CDN or firewall bot protection (for example Vercel's, if enabled) must not challenge them (AR-FIND-01). The crawling and access researcher owns the details.
- **Put every fact in the server-delivered HTML as visible text** (AR-READ-01 and READ-08): dates, opening hours, address and district, entry type and fee, the official source link, and status ("not announced yet", "cancelled", "ended").
  - Check with a plain non-JavaScript fetch of every page type, in each language.
  - For a Next.js site, the risk lies in facts rendered only client-side: map popups, client-fetched lists, and data inside hydration payloads.
- **Don't hide facts.** Keep them out of map canvases and popups, posters or images, PDFs, and collapsed accordions or tabs (Bing; AR-READ-08). Hours tables and fee notes are often placed exactly there on event sites.
- **One canonical, stable URL per market or event,** with the current season's dates on it (AR-FIND-02 adapted; Lorikeet's "canonical, dated" pages; specification.website's stable URLs).
- **Real status codes** (AR-READ-02):
  - a removed market or event should return 404 or 410, or redirect to its replacement, never a soft-200 app shell (is-agentic's `agent-friendly-404`);
  - a past event that keeps its page should say "ended" or show the next date in visible text.
- **Accessible interactive UI** for browser agents (Atlas, Gemini in Chrome): real `<button>` and `<a>` elements, labelled date and district filters, no overlays over controls, and no layout shift around the map (web.dev; Lighthouse).
- **Say "unknown" out loud.** An explicit "dates not yet announced" fits the omission finding: agents fail mainly by leaving facts out, so stating the gap is better than leaving it blank. (Speculative)

**Tier 2: low or contested evidence, cheap to add**
- **JSON-LD** (Event, Place / LocalBusiness), always mirroring the visible text. The local/events and machine-readable data researchers own which types to use.
- **sitemap.xml** with accurate `lastmod`, referenced from robots.txt.
- **llms.txt** linked from the pages. It is useful to coding agents and tools, irrelevant for Google Search, and checked by Lighthouse.
- **Markdown through `Accept: text/markdown`.** Only some coding agents ask for it, and format did not change success in Ora's tests.
- Add Tier 2 only after Tier 1 passes.

**Tier 3: skip for now, revisit later**
- **Skip:** MCP server or CLI (AR-ACT-10 does not apply to a content site), OAuth discovery, OpenAPI and API catalog, SDKs, MCP Apps, agent payments, AI Catalog, the Agent Skills index, Content Signals and Web Bot Auth. None has evidence of use by consumer assistants for content sites.
- **Watch: WebMCP declarative forms** for a "find markets open on <date> near <place>" search. This becomes relevant only once a major agent (most likely Gemini in Chrome) consumes WebMCP outside the origin trial. Speculative as of October 2026.
- **Watch: NLWeb `/ask`.** Possibly relevant to event and place catalogues (Eventbrite and Tripadvisor tried it), but no assistant is shown to query it. Speculative.

**Things the frameworks leave out that these two sites need**
- **Expiry and freshness of dated content.** No framework covers it. An expiring-events site (The Cultural Club) and a seasonal site (Mercaditos) must choose their own policy for past events: keep the page with an "ended" status, return 410, or redirect.
- **Language versions.** No framework covers multilingual sites. Each language version (EN, DE, ES) should carry the full facts in its own HTML, and none should be the only place a fact appears. (Inference)
- **Scores.** If running Cloudflare's or Ora's scanners, use the content-site presets and read the results as a delivery checklist, not a target. The composite scores are not ranking or citation signals (SEJ; Google; Lighthouse docs).
- **Vendor nudges.** Vercel co-wrote agentready and runs is-agentic, so Vercel-hosted sites may see vendor prompts towards agentready's checklist. Only its Find/Read core is supported by assistant-side evidence. (Inference)

### Gaps
- No framework or study measured agent answers for place or event questions (opening hours, dates, entry fees, locations). Ora's business set does not separate local or event businesses. Agent accuracy for this site type is therefore unmeasured.
- Nothing was found on how agents treat expired event pages (404 vs 410 vs a kept "ended" page), or seasonal pages whose dates are not yet announced.
- Nothing was found on multilingual sites in any agent-readiness framework.
- Whether Google AI Mode and Gemini answer market or event questions from on-site Event/Place JSON-LD, or from Business Profile and Maps data, is left to the local and events researcher.
- Out of scope here: Apple Maps and Siri data sources, and Perplexity's or ChatGPT's local and event data partners.
