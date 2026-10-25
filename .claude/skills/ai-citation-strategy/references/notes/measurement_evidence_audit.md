# Measuring presence in AI answers, and an evidence audit of AI SEO / GEO claims

Researched on 2026-10-22 for two sites:
- **Mercaditos** (mercaditos.app): a Christmas-market finder starting with Berlin, built with Next.js 16 on Vercel and Postgres, pages in EN/DE/ES, analytics with Umami Cloud.
- **The Cultural Club (TCC)**: a Barcelona cultural-events site.

This field changes month to month. Every source carries its date, and "(may be outdated)" marks material from before mid-2026 or anything that changed during the research window. Several of the most important facts below date from June to October 2026.

**Evidence labels**
- **Proven**: the platform's own documentation or source code, or a measured study with a stated method.
- **Reported**: industry data with known limits, such as vendor panels, single sites or secondary coverage.
- **Claimed**: an assertion without data.
- **Speculative**: an inference or forecast, including my own cost arithmetic.

Out of scope, because other researchers cover them: access policy, machine-readable data and agent protocols, citation and authority building, and local and events strategy.

---

## 1. Crawler and fetch activity: identifying AI bots, verifying them, and getting logs on Vercel

### Takeaway
AI crawlers mostly do not run JavaScript, so Umami cannot see them. Measuring crawlers needs server or CDN logs.

Each major operator now documents separate user agents for training, search indexing and fetches a user triggers. OpenAI, Anthropic (since 2026), Perplexity and Google publish IP lists for verification. Cryptographic signatures (Web Bot Auth) are starting to appear.

On Vercel there are three options:
- **Free:** the AI bots ruleset in log mode, plus the Firewall and Observability views. On Hobby these keep only 1 to 24 hours of history.
- **Durable on Hobby:** a few lines in the existing `proxy.ts` that write bot hits to Postgres.
- **Durable on Pro:** a log drain filtered to AI bots. It costs $0.50 per GB, which is cents a month at bot-only volume.

### Cited Findings

#### Who the bots are, by operator and purpose

**OpenAI** documents four agents. **Proven** — [OpenAI, crawler overview](https://developers.openai.com/api/docs/bots) (undated, checked 2026-10-22)

| Agent | Purpose | robots.txt | IP list |
|---|---|---|---|
| OAI-SearchBot | Surfaces sites in ChatGPT search. Blocked sites will not appear in search answers but "can still appear as navigational links". | Applies | openai.com/searchbot.json |
| GPTBot | Training | Applies | gptbot.json |
| ChatGPT-User | Visits pages when a user asks ChatGPT or a Custom GPT. Not used for search eligibility. | "robots.txt rules may not apply" | chatgpt-user.json |
| OAI-AdsBot | Checks ad landing pages. Not used for training. | Not addressed | adsbot.json |

- If a site allows both OAI-SearchBot and GPTBot, one crawl may serve both purposes.
- robots.txt changes take about 24 hours.
- Example strings: `OAI-SearchBot/1.4`, `GPTBot/1.4`, `ChatGPT-User/1.0`, `OAI-AdsBot/1.0`.

**Anthropic.** **Proven** — [Anthropic help article 8896518](https://privacy.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler) (dated 2026-04-07)
- ClaudeBot: training data.
- Claude-User: fetches when a Claude user asks a question.
- Claude-SearchBot: search quality.
- All three honour robots.txt and the non-standard Crawl-delay.
- The IP list is at https://claude.com/crawling/bots.json: "If a crawler has a source IP address on this list, it indicates that the crawler is coming from Anthropic."
- **Conflict / outdated:** older copies of the same article, still served in search snippets, say Anthropic "does not currently publish IP ranges" — [support.anthropic.com copy](https://support.anthropic.com/en/articles/8896518) (undated snippet). Treat the 2026-04-07 version as current.

**Perplexity.** **Proven** — [Perplexity crawlers](https://docs.perplexity.ai/guides/bots) (undated, checked 2026-10-22)
- PerplexityBot: for search results, "not used to crawl content for AI foundation models". IP list: perplexitybot.json.
- Perplexity-User: user-initiated, and "generally ignores robots.txt". IP list: perplexity-user.json.
- Perplexity recommends matching both the user-agent string and the published IP ranges.

**Google: AI Overviews and AI Mode.** **Proven** — [Vercel verified-bots directory quoting Google](https://vercel.com/docs/bot-management) (2026-09-10); [Google common crawlers](https://developers.google.com/search/docs/crawling-indexing/google-common-crawlers) (last updated 2026-10-15)
- Preferences addressed to Googlebot "affect Google Search (including Discover and all Google Search features)". AI Overviews and AI Mode therefore have no separate crawler and cannot be separated in logs.
- Google-Extended is a robots.txt product token, not a crawler. It controls use for Gemini Apps and Vertex AI, including grounding, and "does not impact a site's inclusion or ranking in Google Search".

**Google: user-triggered fetchers.** **Proven** — [Google user-triggered fetchers](https://developers.google.com/search/docs/crawling-indexing/google-user-triggered-fetchers) (last updated 2026-08-19)
- `Google-Agent` is used by "agents on Google infrastructure to navigate the web and take actions on user request". Its IPs are in `user-triggered-agents.json`, and Google is "experimenting" with Web Bot Auth under the identity `https://agent.bot.goog`.
- `Google-GeminiNotebook` replaces the former token `Google-NotebookLM`, which is supported until August 2026.
- All these fetchers "generally ignore robots.txt".
- Verification uses `user-triggered-fetchers.json`, `user-triggered-fetchers-google.json` and `user-triggered-agents.json`, plus reverse DNS to `*.gae.googleusercontent.com` or `google-proxy-*.google.com`.
- Google warns that user agents "can be spoofed".

**Microsoft.** **Proven (may be outdated)** — [Vercel, "The rise of the AI crawler"](https://vercel.com/blog/the-rise-of-the-ai-crawler) (2024-12-17); [Bing AI Performance announcement](https://blogs.bing.com/webmaster/February-2026-284b440771373a5a245425a5d31a8ad6/Introducing-AI-Performance-in-Bing-Webmaster-Tools-Public-Preview) (2026-02-10)
- Copilot has no unique user agent, which is why Vercel's study left it out.
- Logs therefore cannot isolate Copilot. First-party data on Copilot citations comes only from Bing Webmaster Tools (section 3); third-party trackers sample it too (section 4).

**Other operators.** Vercel's maintained verified-bot directory also lists these AI agents. **Proven** — [Vercel Bot Management](https://vercel.com/docs/bot-management) (2026-09-10)
- Applebot: search; "may be used to train".
- Amazonbot and Amzn-SearchBot.
- Meta-ExternalAgent (training and indexing), Meta-ExternalFetcher (user-initiated, "may bypass robots.txt") and Meta-WebIndexer (Meta AI search).
- MistralAI-User and MistralAI-Index.
- DuckAssistBot and CCBot.
- Gemini Deep Research, the ChatGPT operator (agent) and Google-CloudVertexBot.
- ExaSearchBot, ShapBot (Parallel), Kernel and Browserbase.

#### Verifying bots, and how often they are faked
- **Proven.** Vercel verifies a bot's claimed identity three ways:
  - by IP range;
  - by reverse DNS (for example, an IP claiming to be Googlebot must resolve to `*.googlebot.com` or `*.google.com`);
  - by cryptographic Web Bot Auth, which uses HTTP Message Signatures (RFC 9421).
  
  — [Vercel Bot Management](https://vercel.com/docs/bot-management) (2026-09-10)
- **Proven.** Vercel added Web Bot Auth verification on 2025-08-12 and names the ChatGPT agent ("operator") as a bot that signs its requests. — [Vercel changelog](https://vercel.com/changelog/vercels-bot-verification-now-supports-web-bot-auth) (2025-08-12)
- **Reported.** HUMAN Security found that 5.7% of traffic labelled as one of 16 AI crawlers was spoofed, and ChatGPT-User was the most spoofed. — [HUMAN Security](https://humansecurity.com/learn/blog/ai-crawler-spoofing-chatgpt-mistral-perplexity/) (date not confirmed)
- **Reported.** On one small site, only 6 of 33 "AI assistant" visits and 107 of 799 "Googlebot" requests came from verified IPs. — [Search Engine Journal, Duane Forrester](https://searchenginejournal.com/my-ai-assistant-traffic-was-fake-the-googlebot-number-was-worse/580052/) (2026)
- **Reported (contested).** Cloudflare says Perplexity also crawled with an undeclared generic Chrome user agent from IPs outside its published ranges, 3–6M requests a day. Perplexity attributes these requests to BrowserBase (see section 6). — [Cloudflare](https://blog.cloudflare.com/perplexity-is-using-stealth-undeclared-crawlers-to-evade-website-no-crawl-directives/) (2025-08-04)

#### Why client-side analytics such as Umami cannot see them
- **Proven (may be outdated).** Vercel and MERJ monitored nextjs.org and the Vercel network, and validated on two job sites. — [Vercel](https://vercel.com/blog/the-rise-of-the-ai-crawler) (2024-12-17)
  - "None of the major AI crawlers currently render JavaScript". That covers OpenAI's crawlers, ClaudeBot, Meta-ExternalAgent, Bytespider, PerplexityBot and CCBot. AppleBot and Googlebot (which also serves Gemini) do render it.
  - Requests in one month: Googlebot 4.5B, GPTBot 569M, Claude 370M, AppleBot 314M, PerplexityBot 24.4M.
  - Share of fetches returning 404: ChatGPT 34.82%, Claude 34.16%, Googlebot 8.22%.

#### Getting the logs on Vercel, by plan, with cost
- **Proven.** Two managed rulesets are available on **all plans**. — [Vercel Bot Management](https://vercel.com/docs/bot-management) (2026-09-10)
  - The **AI bots** ruleset is off by default (labelled "Allow") and can be set to **log** or **deny**. Vercel maintains the bot list and adds new AI bots automatically.
  - The **Bot Protection** ruleset runs in log or challenge mode and skips verified bots. It "doesn't work when a reverse proxy (e.g. Cloudflare…) is placed in front" of the deployment.
- **Proven.** The Firewall **Traffic** page groups requests by client IP, user agent, request path, ASN, JA4 TLS fingerprint and country, filtered by rule or action. The time ranges are the past hour (default), 24 hours and a live 10-minute window, and no export is described. — [Vercel Firewall Observability](https://vercel.com/docs/vercel-firewall/firewall-observability) (2026-09-10)
- **Proven.** Observability's Edge Requests view shows bot name, bot category and "bot verified" (verified, spoofed or unverifiable). "All users can view bot verification badge while Observability Plus subscribers can query this data at no extra cost." — [Vercel changelog](https://vercel.com/changelog/view-and-query-bot-verification-data-in-vercel-observability) (2025-09-30)
- **Proven.** Retention and Observability Plus. — [Vercel Observability Plus](https://vercel.com/docs/observability/observability-plus) (2026-07-06)
  - Observability data is kept 12 hours on Hobby and 1 day on Pro; runtime logs are kept 1 hour on Hobby and 1 day on Pro.
  - **Observability Plus** is Pro or Enterprise only, and on by default for teams created or upgraded to Pro from 2026-04-03. It costs **$1.20 per 1M events**, keeps 30 days and adds Query.
- **Proven.** **Drains** (logs, traces, Speed Insights, Web Analytics) are **Pro or Enterprise only**, not Hobby or the Pro trial. They cost **$0.50 per GB**, measured as uncompressed JSON. — [Vercel Drains](https://vercel.com/docs/drains) (2026-09-01)
- **Proven.** What a log-drain record contains. — [Vercel Log Drains reference](https://vercel.com/docs/drains/reference/logs) (2026-09-11)
  - Fields include `proxy.userAgent`, `proxy.clientIp`, `proxy.referer`, `proxy.path` (with the query string), `proxy.statusCode`, `proxy.vercelCache` (HIT, MISS, …), `proxy.pathType`, `proxy.wafAction` and `ja4Digest`.
  - Sources include `static` (static assets such as HTML), `lambda`, `edge`, `firewall` (denied requests) and `redirect`.
  - Sampling rules by path prefix, and OData filters such as `contains(log/userAgent, 'Googlebot')`, keep only the rows wanted.
- **Proven.** **Hobby** is free and includes 1M function invocations, 4 active CPU hours and 1M CDN requests a month. It is restricted to "non-commercial, personal use only". Pro costs $20 per developer seat a month. — [Vercel Hobby plan](https://vercel.com/docs/plans/hobby) (2026-09-14)
- **Proven.** In Next.js 16, Middleware is renamed **Proxy** (`proxy.ts`). It defaults to the Node.js runtime and is "invoked for every route" unless a matcher narrows it. It "executes before routes are rendered" and exposes `event.waitUntil()` for background work. — [Next.js proxy docs](https://nextjs.org/docs/app/api-reference/file-conventions/proxy) (v16; local copy checked in Next.js 16.2.10)
- **Proven (project code).** Mercaditos already has `src/proxy.ts` with the matcher `/((?!api|_next|embed|.*\..*).*)`.
  - It runs on every page path.
  - It does not run on `/api`, `/_next`, `/embed` or any path containing a dot, so not on `/robots.txt`, `/sitemap.xml`, `/llms.txt` or images.
  - The project's own notes put it on Vercel Hobby.
  
  — [src/proxy.ts](../../../../src/proxy.ts) (checked 2026-10-22); [.claude/rules/platform.md](../../../../.claude/rules/platform.md)

#### Outside Vercel (relevant to TCC, depending on its hosting)
- **Proven.** Cloudflare AI Crawl Control shows crawler requests by operator and category, and the most popular paths. "Total referrals (paid plans only)" and "Top referrers… available for customers on a paid plan". — [Cloudflare AI Crawl Control docs](https://developers.cloudflare.com/ai-crawl-control/features/analyze-ai-traffic/) (last updated 2026-04-23)
- **Reported.** On the free plan, AI Crawl Control identifies crawlers by user-agent string only, and its Metrics tab covers 24 hours. This is Cloudflare's docs as summarised by search; I did not re-verify it on the page. — [Cloudflare, manage AI crawlers](https://developers.cloudflare.com/ai-audit/features/manage-ai-crawlers) (undated)
- **Reported.** A February 2026 update added path patterns, a "Referrals over time" chart and bytes transferred. — [Cloudflare changelog](https://developers.cloudflare.com/changelog/post/2026-02-09-analytics-enhancements/) (2026-02-09)
- **Reported.** Microsoft Clarity's free **Bot Activity** view launched on 2026-01-21. — [Clarity blog](https://clarity.microsoft.com/blog/ai-bot-activity-in-clarity/) (Jan 2026; the primary returned 403, so this was read via search); [Clarity update](https://clarity.microsoft.com/blog/updates-to-bot-activity-in-clarity/) (2026); [PPC Land](https://ppc.land/microsoft-clarity-exposes-ai-bot-traffic-with-new-visibility-dashboard/) (2026); [SEJ](https://searchenginejournal.com/microsoft-clarity-now-flags-bots-that-ignore-robots-txt/580446/) (2026)
  - It reads server-side CDN logs and groups bots by operator and by purpose (training crawler or assistant fetch).
  - It shows the bots' share of traffic and the share of pages crawled. It does not block anything.
  - A later update flags robots.txt violations.
  - Supported sources: Fastly, Amazon CloudFront, Cloudflare (later including the free, pro and business plans), Akamai, Azure Front Door and the WordPress plugin. **Vercel is not listed.**

### Inferences
- **Classify every logged hit into four classes, because they mean different things** (Speculative synthesis of the docs above):
  - Training: GPTBot, ClaudeBot, Meta-ExternalAgent, CCBot, Bytespider.
  - Search index: OAI-SearchBot, Claude-SearchBot, PerplexityBot, Googlebot, Bingbot, Meta-WebIndexer, MistralAI-Index, Amzn-SearchBot.
  - User-triggered fetch: ChatGPT-User, Claude-User, Perplexity-User, MistralAI-User, Meta-ExternalFetcher, DuckAssistBot, Google's user-triggered fetchers.
  - Agents: the ChatGPT agent, Google-Agent, Browserbase, Kernel.
  
  User-triggered fetches are the nearest server-side sign that a page was just used in an answer. Search-index fetches are a precondition for being cited. Training fetches say nothing about visibility.
- **On Hobby, the cheapest durable log for Mercaditos is the existing `src/proxy.ts`** (Speculative):
  - Match the user agent against a list, and only on a match call `event.waitUntil()` to insert time, bot, class, path, IP and user agent into a small Postgres table.
  - Verify the IPs later in a daily job against the published JSON lists.
  - The extra cost is close to zero, because the proxy already runs on these paths and only bot hits write rows.
  - Limits: the proxy runs before the page renders, so it cannot record status codes or bytes. The current matcher also skips `/robots.txt`, `/sitemap.xml` and `/llms.txt`.
- **A zero-code spot check is the AI bots ruleset in log mode plus the Firewall Traffic view by user agent.** With 1 to 24 hours of history it cannot show trends. (Speculative, from the documented time ranges.)
- **On Pro, a log drain with an OData filter on AI user agents gives the cleanest record**, including status codes, cache state and static requests (Speculative; the record size is my assumption, not documented):
  - At about 1.5 KB per record, 100,000 bot requests a month is about 0.15 GB, roughly $0.08 a month. Draining all traffic, 1M requests, is about 1.5 GB, roughly $0.75.
  - The real cost is the $20-a-seat Pro plan, which Vercel's terms require for commercial use anyway.
- **Do not put Cloudflare in front of Vercel** just to get Cloudflare's or Clarity's free crawler dashboards: Vercel documents that its Bot Protection then stops working. (Speculative.)
- **For TCC,** if it is already served through Cloudflare, Fastly, CloudFront, Akamai or Azure Front Door, AI Crawl Control and Clarity Bot Activity are free crawler dashboards. Clarity's bot view reads CDN logs, but its referral and session features use a client script that sets cookies, a privacy trade-off compared with Umami. (Speculative.)
- **Count only verified hits in KPIs,** and report "unverifiable" separately. A count based on user agents alone can be badly inflated on a small site. (Speculative.)
- **Events-specific KPI** (Speculative): the time from publishing or updating a page (new dates, a new event) to the first verified search-bot fetch.
  - For TCC, whose event pages appear and expire weekly, this is the crawl metric that matters most.
  - Bing recommends IndexNow for change notification (section 3).

### Gaps
- I did not re-check, this session, the verification methods for Bingbot (IP list or reverse DNS), Applebot or Meta's agents.
- Vercel does not document the size of a log-drain record, so the drain cost above rests on an assumed ~1.5 KB.
- The docs do not say whether Hobby projects get the full Firewall Traffic breakdowns, or how many Observability "events" one request generates (needed to price Observability Plus).
- Agents that run a full browser (the ChatGPT agent, Google-Agent, agentic browsers) may execute Umami's script and be counted as visitors. Whether Umami filters them is unverified.
- TCC's hosting and CDN are unknown, so which Cloudflare or Clarity option applies is open.
- The JavaScript-rendering study dates from December 2024, and I found no newer measurement.

---

## 2. Referrals: what each AI platform sends, how much hides in Direct, and what Umami shows

### Takeaway
Only ChatGPT tags its links (`utm_source=chatgpt.com`). Gemini, Perplexity, Claude and Copilot rely on the referrer. Clicks from Google's AI Overviews and AI Mode are indistinguishable from organic Google. Mobile apps and copied links send nothing.

Since ChatGPT's GPT-6 rollout around 2026-10-09:
- most ChatGPT clicks arrive **without a referrer**;
- for several days inline links also lost the UTM tag, until a reported fix on 2026-10-15.

Umami v3.2.0 (June 2026) has a built-in **"llm" channel, but it keys only on the referrer**. A tagged ChatGPT visit without a referrer therefore lands in "direct" in that view, and is visible only in the UTM report.

The share of AI visits hidden in Direct is unknown. The only figure, about 70%, comes from a vendor's model.

### Cited Findings
- **Proven.** OpenAI: "ChatGPT automatically includes the UTM parameter utm_source=chatgpt.com in referral URLs." Appearing in ChatGPT search requires allowing OAI-SearchBot. — [OpenAI Publishers and Developers FAQ](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq) (snapshots carry different "updated" dates; checked via search 2026-10-22)
- **Reported (may be outdated).** Seer Interactive's referrer table, from internal testing at one point in time, with earlier models and no sample sizes — [Seer Interactive](https://www.seerinteractive.com/insights/are-ai-sites-like-chatgpt-sending-your-website-traffic) (published 2024-12-02, updated 2026-06-22). The article's own dates for GA4's AI channel (May 2025 vs May 2026) are inconsistent.

  | Platform | UTM tag | Referrer |
  |---|---|---|
  | ChatGPT citation links | Usually | Yes |
  | ChatGPT search-result links | No | Yes |
  | Gemini | No | gemini.google.com |
  | Perplexity | No | perplexity.ai |
  | Claude | No | claude.ai |
  | Copilot, AI Overviews, AI Mode | Not tested | Not tested |

  Seer also says in-app browsers and copied links land in Direct, and that a native AI channel is "a floor, not a ceiling".
- **Reported (conflict).** Practitioner blogs disagree with Seer on Claude ("rarely" passes a referrer) and on Gemini ("sometimes"). They also say Copilot passes `copilot.microsoft.com`, though Bing-integrated sessions may show as `bing`. — [Terminus](https://www.terminusapp.com/blog/tracking-ai-referral-traffic/) (2026); [DarwinApps](https://www.darwinapps.com/blog/how-to-track-chatgpt-gemini-and-perplexity-referral-traffic-in-ga4-and-crm/) (2026)
- **Reported.** Perplexity passes a referrer in desktop browsers, but visits from its mobile app often arrive without one. — [SEO Handbook citing Seer's tests](https://seohandbook.co.uk/seo-analytics/dark-traffic/) (undated)
- **Reported (may be outdated).** Google AI Mode links once carried `rel="noopener noreferrer"`, so the visits showed as Direct. Google fixed this in late May 2025, and Ahrefs' retest showed google / organic. Since then, clicks from AI Mode and AI Overviews are indistinguishable from other organic Google clicks in analytics. — [SEJ](https://www.searchenginejournal.com/google-fixes-ai-mode-traffic-attribution-bug/547946/) (2025); [Ahrefs](https://ahrefs.com/blog/google-ai-mode-is-here-but-you-cant-track-it-properly) (2025, update of May 31)
- **Reported. October 2026: ChatGPT's tagging and referrers break.** — [SEJ](https://www.searchenginejournal.com/chatgpt-traffic-drop-appears-to-be-a-tracking-problem/593157/) (2026-10-15); [LLM Pulse](https://llmpulse.ai/blog/chatgpt-referral-traffic-fell/) (2026-10-13, last updated 2026-10-21); [Search Engine Land](https://searchengineland.com/chatgpt-appears-to-drop-utm-tracking-making-ai-referral-traffic-harder-to-measure-496552) (Oct 2026; 403 for me, title in results: "ChatGPT drop in UTM tracking was a bug")
  - **When:** starting around 2026-10-09, after the GPT-6 rollout (paid plans 2026-10-07, free plans 2026-10-08, according to LLM Pulse). Inline answer links opened without `utm_source` and without a referrer; links in the sources panel and shopping links kept the tag.
  - **Graphite:** GA4 ChatGPT sessions fell 22–57%.
  - **LLM Pulse:** about −46% on 2026-10-09 to 11, while total traffic was about −2%.
  - **Adobe (Cedric Huesler):** on about 500 pages where ChatGPT drove at least 5% of visits, ChatGPT visits fell by about **31,000 a day while Direct rose by about 26,000 a day**. This is four days of sampled data.
  - **Profound:** answers with at least one tagged source link fell from about 98% (Oct 8) to 66% (Oct 14).
  - **Bug and fix:** Huesler says OpenAI confirmed the bug to him on Oct 14, and that a fix began on Oct 15, with tagged clicks back to 95–100% of the previous week. Glenn Gabe had not seen the fix. OpenAI's release notes do not mention it.
  - **The referrer stays withheld on most ChatGPT clicks, so the UTM tag is now the signal to count.**
  - Caveat: the analysts sell AI-visibility services, and OpenAI has published no statement.
- **Reported.** Across 1M prompts after GPT-6, ChatGPT showed a direct URL in 42% of responses, up from 8–10%, and 54% of those were home pages. These are displayed links, not clicks. — [SEJ, citing Peec AI](https://www.searchenginejournal.com/chatgpt-traffic-drop-appears-to-be-a-tracking-problem/593157/) (2026-10-15)
- **Reported / Claimed. How much AI traffic hides in Direct.** — [Loamly](https://www.loamly.ai/blog/ai-traffic-attribution-crisis) (undated, 2026); [Attrifast](https://attrifast.com/blog/dark-ai-traffic-ga4) (2026)
  - Loamly: 70.6% of "confirmed" AI-driven visits (446,405 visits analysed) arrived without a referrer. "Confirmed" is defined by Loamly's own detection heuristics, and other sites repeat the figure.
  - Attrifast argues the share cannot be measured deterministically once the source signal is gone.
  - I found no independent controlled experiment.
- **Reported. GA4's native "AI Assistant" channel** (since 2026-05-13) sets the medium to `ai-assistant`. Google names ChatGPT, Gemini and Claude as examples but has not published the full referrer list. One source says it is not retroactive, and practitioners say it undercounts. — [SEJ](https://www.searchenginejournal.com/google-analytics-adds-ai-assistant-as-default-channel-group/574974/) (May 2026); [SEJ](https://searchenginejournal.com/ga4s-ai-assistant-channel-undercounts-your-ai-traffic-how-to-build-one-that-doesnt/580133) (2026)
- **Reported.** Microsoft Clarity added AI channel groups for ChatGPT, Claude, Gemini, Copilot and Perplexity on 2025-08-29. — [Clarity coverage via search](https://www.techwyse.com/?p=77889) (2026)
- **Proven (source code). Umami's "llm" channel.** — [getChannelMetrics.ts](https://github.com/umami-software/umami/blob/master/src/queries/sql/getChannelMetrics.ts); [constants.ts](https://github.com/umami-software/umami/blob/master/src/lib/constants.ts); [commit 21b56d2](https://github.com/umami-software/umami/commit/21b56d2) (2026-05-11); [v3.2.0 release notes](https://github.com/umami-software/umami/releases/tag/v3.2.0) (2026-06-24)
  - Umami v3.2.0 (2026-06-24, "LLM channel logic") puts a visit in channel `llm` when its referrer domain matches `LLM_DOMAINS`: chatgpt.com, claude.ai, copilot.microsoft.com, gemini.google.com, meta.ai and perplexity.ai.
  - The rules run in order. A visit is `direct` if it has no referrer and no query string. Otherwise, a visit that matches no rule ends with an empty label, which is then **coalesced to `direct`**.
  - A visit with `utm_source=chatgpt.com` and no referrer matches no rule, because `utm_source` is never consulted for the llm channel. **It is counted as `direct`.**
- **Proven (source code and docs). The Umami tracker** sends `document.referrer`, stripped of the origin for same-origin referrers. It sends the full URL including the query string unless `data-exclude-search="true"` is set. — [Umami tracker source](https://github.com/umami-software/umami/blob/master/src/tracker/index.ts); [Umami tracker configuration](https://docs.umami.is/docs/tracker-configuration) (undated)
- **Proven (docs). Umami reports.** — [Umami UTM](https://docs.umami.is/docs/utm); [Umami Attribution](https://docs.umami.is/docs/attribution); [Umami docs index](https://docs.umami.is/docs) (undated, checked 2026-10-22)
  - The UTM report (since v2.11.0) breaks views down by `utm_source`, medium, campaign, term and content.
  - The Attribution report (since v2.18.0) credits referrers, paid ads and UTM campaigns, first-click or last-click.
  - The dashboard supports Annotations, Segments and filters.
- **Proven (project code).** Mercaditos loads Umami with `data-website-id` and `data-domains="mercaditos.app"` and **does not set `data-exclude-search`**, so UTM tags are recorded. — [analytics-script.tsx](../../../../src/components/layout/analytics-script.tsx); [umami.ts](../../../../src/lib/analytics/umami.ts) (checked 2026-10-22)
- **Reported (conflicting). ChatGPT's share of AI referrals.**
  - 87.4%: Conductor, 13,770 enterprise domains (section 6). — [BusinessWire](https://www.businesswire.com/news/home/20251113364791/en/Conductor-Unveils-2026-AEO-GEO-Benchmarks-Report-How-AI-Shapes-Brand-Visibility-in-a-Zero-Click-World) (2025-11-13)
  - 74.78%: SE Ranking. — [SE Ranking](https://seranking.com/blog/ai-traffic-research-study/) (2026)
  - About 89% in mid-2025 falling to about 63% in spring 2026: Goodie, a vendor. — [Higoodie](https://higoodie.com/blog/ai-search-traffic-report-2026/) (2026)
  - Similarweb reportedly measured a +157.7% week-on-week jump in ChatGPT referrals after a link-display change on 2026-05-07. — [Cognizo citing Similarweb](https://www.cognizo.ai/blog/chatgpt-ai-visibility-statistic) (2026)
  - In short, AI referral volumes swing with product changes nobody outside controls.

### Inferences
- **Count AI referrals in Umami from two parts** (Speculative):
  - Channel **`llm`**.
  - Plus visits in the **UTM report with `utm_source=chatgpt.com` that have no referrer**, for example via a segment or filter. Visits that carry both a referrer and the tag are already counted as `llm`.
  - Add a Umami **annotation for 2026-10-09 to 15** (the ChatGPT tagging bug), so the seasonal comparison is not misread.
- **AI domains outside Umami's list land in `referral`.** These include `chat.openai.com`, the legacy ChatGPT host that GA4 guides still list, and assistants such as Grok, DeepSeek or Mistral, if they send referrers at all. Review the Referrers list monthly. (Speculative.)
- **Keep `data-exclude-search` off.** Turning it on would silently remove the only ChatGPT signal that survives the missing referrer. (Proven mechanism; recommendation Speculative.)
- **Clicks from AI Overviews and AI Mode are inside organic Google search** in Umami and cannot be separated. The only window is Search Console's generative AI report (section 3), which has impressions but no clicks.
- **Estimating dark AI traffic: use Adobe's page-level method.** Watch Direct on the pages that the prompt panel (section 4) shows being cited. A Direct rise there that coincides with citation, but not site-wide, is the best available sign of untagged AI visits. (Speculative.)
- **Places and events.** AI referrals will cluster in the season (Nov–Dec for Mercaditos; around event dates for TCC). A month-over-month comparison will mislead, so compare season to season. Because Mercaditos has no locale in its URLs, any EN/DE/ES split of AI visitors must come from Umami's browser-language data or a custom event property, not from paths. (Speculative; I did not verify Umami's language dimension this session.)

### Gaps
- I found no controlled 2026 test of what referrer or UTM each assistant sends, in particular from the mobile apps of ChatGPT, Gemini, Claude, Copilot and Perplexity, or from agentic browsers.
- OpenAI has not confirmed the October 2026 bug or a fix in its own channels, so the current state of tagging is unknown beyond analysts' reports.
- I did not verify whether **Umami Cloud** already runs v3.2.0 or later with the llm channel. It probably does, but check in the dashboard.
- I found no measured share of "dark" AI traffic beyond Loamly's vendor model.

---

## 3. Platform reports: Google Search Console, Bing Webmaster Tools, OpenAI, Perplexity (state as of October 2026)

### Takeaway
Two free first-party reports now exist, and both are new in 2026:
- **Google Search Console's "Generative AI" performance report** (announced 2026-06-03, worldwide since 2026-08-31) gives **impressions only**, for AI Overviews and AI Mode, by page, country, device and date. It has no clicks and no queries.
- **Bing Webmaster Tools' "AI Performance"** (public preview since 2026-02-10) gives citations, cited pages and sampled "grounding queries" for Copilot and Bing's AI summaries. Since 2026-06-16 it adds Citation Share, Intents, Topics and Compare. It has no clicks.

Neither OpenAI nor Perplexity offers a public publisher dashboard. OpenAI's only publisher-facing instrument is the UTM tag. Perplexity pays participating publishers through Comet Plus.

### Cited Findings
- **Proven. Google's announcement.** — [Google blog](https://blog.google/products-and-platforms/products/search/new-controls-website-owners/) (2026-06-03, updated 2026-08-31)
  - On 2026-06-03 Google (Mrinalini Loew, GM, Search Ecosystem) announced Search Console insights that "include impressions metrics and information about which pages appear in AI responses and in what countries". Google says it will "introduce additional metrics over time".
  - A footnote reads: "As of August 31, 2026, we've rolled out these features to all websites worldwide." The body still describes a UK-first test, so the page is internally inconsistent.
- **Proven. What the Search report contains.** — [Search Console Help: Generative AI performance report (Search)](https://support.google.com/webmasters/answer/16984139) (undated, checked 2026-10-22)
  - **Surfaces:** AI Overviews and AI Mode. Search Labs is excluded.
  - **Metric:** impressions, defined as "how many times links to your site were shown to a user in a generative AI feature on Google Search". The chart aggregates by property, so two results from the same site in one feature count as one impression.
  - **Dimensions:** pages (grouped to canonical), countries, dates in Pacific Time, and devices.
  - **Search type:** Web text or Web multimodal (Lens, Circle to Search).
  - **Limits:** the usual 1,000-row cap, preliminary recent data, and an unspecified minimum before the report appears.
  - **Not mentioned:** clicks.
- **Proven.** A separate report covers Discover's AI features. — [Discover report help](https://support.google.com/webmasters/answer/16983858)
- **Reported (secondary coverage of Google and CMA material).** The rollout timeline and what the CMA expects next. — [SEJ](https://www.searchenginejournal.com/google-search-console-ai-reports-rolled-out-worldwide/587836/) (2026-08-31)
  - The rollout went: UK test on June 3, the control appearing outside the UK in July, and all sites on August 31. Help pages still said "in progress".
  - **Clicks are not included.**
  - On June 3 the UK CMA imposed a conduct requirement that Google let sites opt out of AI features without penalty in standard results. It gave Google until **March 2027** for page-level controls, and "expects click-through data".
- **Proven. The opt-out control launched with the reports.**
  - A property-level Search Console setting removes a site from AI Overviews, AI Mode and AI features in Discover, after which it receives "no traffic or impressions" from them.
  - Google: "This control will not be used as a ranking signal for search results outside of these generative AI Search features."
  - AI training is governed separately, by Google-Extended.
  
  — [Google blog](https://blog.google/products-and-platforms/products/search/new-controls-website-owners/) (2026-06-03); [control help page](https://support.google.com/webmasters/answer/16908024); [SEJ](https://www.searchenginejournal.com/google-search-console-ai-reports-rolled-out-worldwide/587836/) (2026-08-31)
- **Proven.** Google's earlier page said traffic from AI features was counted in the overall "Web" totals. Its May 2026 guide, last updated 2026-07-10, points to the new Generative AI performance report. — [Google, AI features and your website](https://developers.google.com/search/docs/appearance/ai-features) (2025-12-10); [Google, AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10)
- **Proven. Bing's AI Performance report.** — [Bing Webmaster blog](https://blogs.bing.com/webmaster/February-2026-284b440771373a5a245425a5d31a8ad6/Introducing-AI-Performance-in-Bing-Webmaster-Tools-Public-Preview) (2026-02-10); [SEJ](https://www.searchenginejournal.com/bing-webmaster-tools-adds-ai-citation-performance-data/566874/) (2026-02-09)
  - **Coverage:** citations across "Microsoft Copilot, AI-generated summaries in Bing, and select partner integrations". The partners are not named.
  - **Metrics:**
    - Total Citations: how often content is shown as a source; not its placement in the answer.
    - Average Cited Pages: the daily average of unique cited URLs.
    - Page-level citation activity.
    - Trends over time.
    - **Grounding queries:** the key phrases the AI used when retrieving content. "The data shown represents a sample of overall citation activity."
  - **Not included:** clicks. The report is a public preview.
  - **Microsoft's guidance:** depth in topics already cited; clear headings, tables and FAQ sections; examples, data and cited sources; regular updates with **IndexNow**; consistency across formats; and, for local businesses, **Bing Places for Business** to keep address, hours and contact details current. It does not mention structured data.
- **Proven / Reported. Bing's June 2026 additions.** — [Bing blog](https://blogs.bing.com/search/June-2026/New-AI-Visibility-Insights-in-Bing-Webmaster-Tools-Intents-Topics-Citation-Share-Compare) (June 2026, read via search excerpt); [SEJ](https://searchenginejournal.com/bing-rolls-out-ai-citation-share-in-webmaster-tools/579547) (June 2026); [PinMeTo](https://www.pinmeto.com/news/bing-ai-performance-backfill-citation-share-2026/) (2026)
  - On 2026-06-16 Bing added four preview views: **Intents, Topics, Citation Share and Compare**.
  - Citation Share is the share of AI citations a site captures for a grounding query.
  - Microsoft said the jumps in the data from June 1 were a backfill, not a change in citation frequency.
- **Reported (one site).** One site reported about 48,000 citations across 34 pages in about three months, but only 14 Copilot clicks (about 0.03%). — [Whole Whale](https://wholewhale.com/resources/bing-webmaster-analytics-for-ai-search-is-sobering/) (2026; date not verified)
- **Proven / gap. OpenAI.**
  - The only publisher-facing measurement is the `utm_source=chatgpt.com` tag, plus the advice to allow OAI-SearchBot. — [OpenAI FAQ](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq)
  - I found no OpenAI publisher dashboard.
- **Reported / Claimed. Perplexity.**
  - Perplexity launched **Comet Plus** in August 2025: $5 a month, with 80% of revenue going to participating publishers (a reported $42.5M pool), paid on human visits, search citations and agent actions. — [Press Gazette](https://pressgazette.co.uk/news/perplexity-launches-ai-subscription-revenue-share-scheme-for-publishers/) (Aug 2025)
  - The 2024 Publishers' Program reportedly gave partners analytics through ScalePost. — [LLM Pulse](https://llmpulse.ai/blog/perplexity-publishers-program/) (2026)
  - Only one commercial blog claims "detailed analytics dashboards" in 2026. — [Digital Strategy Force](https://digitalstrategyforce.com/journal/perplexitys-2026-publisher-program-what-it-means-for-content-creators/) (2026, Claimed)
  - I found no public, self-serve Perplexity dashboard.

### Inferences
- **Set up both first-party reports now. They are free and are the only ground truth for Google's and Microsoft's AI surfaces** (Speculative):
  - Verify Mercaditos in Bing Webmaster Tools (it can import from Search Console).
  - Export both reports weekly in season and keep the exports, because retention and API access for the new reports are undocumented.
- **Use Search Console's country dimension as a rough proxy for language audience** (DE vs ES vs other). AI impressions per page, divided by Web impressions for the same page, give an "AI exposure" ratio per page. With no AI clicks, AI click-through cannot be computed. (Speculative.)
- **Bing's grounding queries show how Copilot phrases retrieval for the site.** Together with Search Console's queries, they are the best free source of real wording for the prompt panel (section 4). (Speculative.)
- **The Google opt-out control is measurable, but costly.** It removes impressions and traffic from AI features. For a small site whose aim is to be the cited source, it is not a sensible experiment. (Speculative.)
- **Places and events: Bing's guidance (Bing Places) and Google's (Business Profile; section 5) point to venue listings as an input to local AI answers.** For Christmas markets, those listings belong to the organisers. The site can measure, but not directly control, whether AI answers about a market draw on its pages or on venue listings. (Speculative.)

### Gaps
- I found no Search Console API support for the new report, its data retention, and whether queries or clicks will be added beyond the CMA's expectation.
- Bing's partner integrations are not named, and I found no API for AI Performance.
- I found no confirmation of any OpenAI or Perplexity publisher dashboard as of October 2026.

---

## 4. Visibility tracking: commercial tools, a do-it-yourself panel, and API vs consumer apps

### Takeaway
Commercial trackers sample prompts. Most query the consumer interfaces daily, logged out, from a chosen country. Entry prices run from about $29 to $250 a month, and plans for brands at the top end have moved to quoted contracts.

Two measured studies show that AI answers vary from run to run. Both conclude that only "mentioned or cited in X% of N runs", at site rather than page level, holds steady. API answers recover only about a quarter of the pages the ChatGPT app cites.

A do-it-yourself panel on the model APIs costs about $50 a month for 50 questions × 3 languages × 4 engines run weekly, or about $150 with 3 repeats per run. It measures the API, not what people see in the apps, and none of these APIs reproduces Google's AI Overviews or AI Mode.

### Cited Findings

#### Commercial trackers (prices checked 2026-10-22; they change often)
- **Proven (vendor pricing page). Otterly.AI.** — [Otterly pricing](https://otterly.ai/pricing) (undated, © 2026, checked 2026-10-22)
  - Lite: **$29 a month** (or $25 billed annually) for 15 prompts.
  - Standard: $189 for 100 prompts. Premium: $489 for 400. Enterprise starts at 1,000 prompts.
  - Every plan covers ChatGPT, Google AI Overviews, Perplexity and Copilot, runs **daily**, and allows "unlimited countries and languages".
  - On Lite, AI Mode and Gemini cost $9 a month each, and Claude $29.
  - The collection method is not described.
- **Reported. Peec AI (Berlin) pricing; the sources conflict.** — [Capterra](https://capterra.com/p/10030058/Peec-AI/pricing); [Rework](https://resources.rework.com/tools/aeo-ai-visibility/best-peec-ai-alternatives); [eClincher](https://www.eclincher.com/articles/profound-alternatives-8-ai-visibility-tools-after-profounds-pricing-change) (2026-10-08)
  - Starter about $95 a month for 50 prompts on 3 engines, daily. Pro $245 for 150 prompts. Advanced $495 for 350.
  - Peec's own pricing update of 2026-03-03 gives no figures — [Peec blog](https://peec.ai/blog/pricing-update).
- **Claimed (vendor's own description). Peec's method.** — [Peec help](https://help.peec.ai/en/articles/13726915-what-s-the-difference-between-chatgpt-and-chatgpt-5-search); [Peec docs](https://docs.peec.ai/) (undated)
  - It scrapes the interface, interacting "exactly as real users do". By default its ChatGPT data is what **logged-out** users see.
  - An API-based "ChatGPT 5 Search" option exists, and Peec itself says it differs from what users see.
- **Proven / Reported. Profound.**
  - The pricing page lists a free 7-day trial (50 prompts; ChatGPT, Gemini and AI Overviews; 1 region, 1 language) and quote-based Enterprise covering up to 9 engines. — [Profound pricing](https://www.tryprofound.com/pricing) (checked 2026-10-22; Proven)
  - It reportedly dropped its $99 and $399 brand plans in mid-September 2026. — [eClincher](https://www.eclincher.com/articles/profound-alternatives-8-ai-visibility-tools-after-profounds-pricing-change) (2026-10-08; Reported, by a competitor)
  - **Outdated warning:** older reviews still quote the $99 plan.
  - Its "Prompt Volumes" come from an opaque consumer panel whose stated size varies ("1.5+ billion" vs "hundreds of millions" of prompts). — [Profound changelog](https://product.tryprofound.com/en/changelog/new-prompt-volumes-features-available-now) (2025-09-18; Claimed)
- **Proven (vendor page). Ahrefs Brand Radar.** — [Ahrefs Brand Radar](https://ahrefs.com/brand-radar) (checked 2026-10-22)
  - Its prompts come from Ahrefs' keyword database, expanded with "People also ask" and fan-out. The index holds 495M+ prompts.
  - It covers AI Overviews, AI Mode, Gemini, Copilot, Perplexity and ChatGPT, but not Claude.
  - The index is re-tested **monthly on a 90-day window**. Custom prompts can run daily, weekly or monthly.
  - Prices as displayed: custom prompts from €47 a month, the index from €179, all models €654. Reported dollar prices conflict.
- **Reported. Semrush AI Visibility Toolkit.** $99 a month (possibly the annual rate) for 1 domain and 25 prompts; 50 more prompts cost $60 a month. — [Semrush KB](https://www.semrush.com/kb/1493-ai-visibility-toolkit) (undated, read via search)
- **Reported (sources conflict).** Scrunch Starter: $250 a month billed annually, for 350 custom prompts. — [Scrunch pricing](https://www.scrunch.com/pricing) (undated)
- **Reported (published by a competitor).** AthenaHQ has a free tier and a $295 Starter; Promptwatch costs $95 a month. — [eClincher](https://www.eclincher.com/articles/profound-alternatives-8-ai-visibility-tools-after-profounds-pricing-change) (2026-10-08)

#### How variable answers are, and API vs app
- **Proven (measured, not peer-reviewed; Gumshoe sells a tracker). SparkToro and Gumshoe.** — [SEJ](https://www.searchenginejournal.com/ai-recommendations-change-with-nearly-every-query-sparktoro/566242/) (2026-01-30); [SparkToro](https://sparktoro.com/blog/new-research-ais-are-highly-inconsistent-when-recommending-brands-or-products-marketers-should-take-care-when-tracking-ai-visibility/) (Jan 2026)
  - **Method:** 2,961 runs through ChatGPT, Claude and Google AI Overviews or AI Mode, with 12 prompts run 60–100 times per platform by volunteers (Nov–Dec 2025).
  - The chance of getting the same brand list twice was **under 1 in 100**. The same list in the same order came up in under 0.1% of runs.
  - When 142 people wrote their own prompts for the same need, the prompts' semantic similarity was 0.081.
  - **"Visibility %" across runs was steadier than rank.**
- **Proven (preprint with a stated method; ChatGPT only). ChatGPT app vs API.** — [arXiv 2610.15382](https://arxiv.org/abs/2610.15382) (2026-10-11); [SEJ](https://searchenginejournal.com/openais-api-only-partly-matched-chatgpts-citations-paper-finds/593304/) (2026-10-18)
  - **Method:** 80 questions (40 English, 40 Chinese) run 20 times each in signed-in ChatGPT on GPT-5.3 and GPT-5.5 Instant (Mar–Jul 2026), compared with Google results and with the Responses API using web search.
  - Google results plus the API recovered only **26–28% of the pages** ChatGPT cited and **49–50% of the sites**.
  - **40.8–44.5%** of the distinct pages cited for a question appeared in only one run.
  - For Chinese questions, 67–70% of runs that searched visibly used only English queries.
  - The authors recommend tracking at both page and site level, repeating runs, logging the model, and checking whether a tool reads the API or the app.
- **Reported / Claimed (methods not checked).** Other reports that API and app citations diverge:
  - the API cites niche domains, the web app mainstream outlets — [The Decoder](https://the-decoder.com/chatgpts-news-picks-swing-wildly-depending-on-whether-you-use-the-web-interface-or-the-api/);
  - "zero query overlaps" between API and app — [Genezio](https://genezio.com/research/zero-query-overlaps/);
  - 24% brand overlap — [The Stacc](https://thestacc.com/blog/llm-scraped-vs-api-results/).

#### Do-it-yourself panel: API prices (checked 2026-10-22)
- **Proven. OpenAI's web search tool.** — [OpenAI pricing](https://developers.openai.com/api/docs/pricing)
  - $10 per 1,000 calls plus search-content tokens, on reasoning models and the non-preview tool. The preview tool on non-reasoning models costs $25 per 1,000, with content tokens free.
  - gpt-5-mini costs $0.25/$2.00 per million tokens; gpt-5-nano $0.05/$0.40.
- **Proven. Anthropic's web search tool.** — [Anthropic web search tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool); [Anthropic pricing](https://platform.claude.com/docs/en/about-claude/pricing)
  - **$10 per 1,000 searches** plus tokens.
  - Citations are always on (`url`, `title`, `cited_text`), and each result carries a `page_age`.
  - It accepts a city-level `user_location`, allowed and blocked domains, and `max_uses`, and works in the Batches API.
  - The web fetch tool costs nothing beyond tokens.
  - Haiku 4.5 costs $1/$5 per million tokens ($0.50/$2.50 in batch).
- **Proven / Reported. Perplexity.**
  - The official pricing page now lists the **Agent API**: `web_search` at $2.50 per 1,000 calls, `fetch_url` at $0.0005, plus tokens. The **Search API**, which returns raw results only, costs $5 per 1,000 ($1 per 1,000 for "fast"). — [Perplexity pricing](https://docs.perplexity.ai/guides/pricing.md) (Proven)
  - Sonar Chat Completions support reportedly ended on 2026-09-27. — [eCorpIT](https://ecorpit.com/perplexity-sonar-retirement-september-27-agent-api-migration-2026/) (Reported)
  - **Outdated:** the old Sonar request fees of $5–14 per 1,000.
- **Proven. Gemini grounding with Google Search.** — [Gemini API pricing](https://ai.google.dev/gemini-api/docs/pricing)
  - Gemini 3 and newer models share **5,000 free search requests a month**, then cost **$14 per 1,000 search queries**. One prompt can trigger several queries.
  - Gemini 2.5 Flash gets 1,500 free a day on the paid tier, then $35 per 1,000 grounded prompts.
  - 3.1 Flash-Lite costs $0.25/$1.50 per million tokens.
- **Proven / Reported. Microsoft.**
  - The Bing Search APIs were retired on 2025-08-11. — [Microsoft](https://learn.microsoft.com/en-us/lifecycle/announcements/bing-search-api-retirement) (Proven)
  - "Grounding with Bing Search" costs about $35 per 1,000 transactions, works only inside Azure AI Foundry Agent Service, and gives no raw results. — [PPC Land](https://ppc.land/microsoft-ends-bing-search-apis-on-august-11-alternative-costs-40-483-more/) (2025-06-09; Reported; 2026 rate not confirmed)

### Inferences

**Cost of a do-it-yourself panel** (Speculative). Assumptions: about 2 searches, about 10k input tokens of search content, and 1–2k output tokens per run. Per-run costs:
- OpenAI gpt-5-mini: about $0.027.
- Anthropic Haiku 4.5: about $0.035 (about $0.028 in batch).
- Perplexity Agent API: about $0.016.
- Gemini 3.x Flash-Lite: about $0.002, with searches inside the free 5,000 a month.

The averages are about $0.02 per run across 4 engines, or $0.021 across OpenAI, Anthropic and Gemini.

| Scenario | Runs | Cost |
|---|---|---|
| 50 questions × 3 languages × 4 engines, weekly, 1 repeat | about 2,600 a month | **about $50 a month** |
| Same, with 3 repeats | about 7,800 a month | **about $150 a month** |
| One full sweep (150 prompts × 4 engines × 3 repeats) | 1,800 | about $36 |

**Commercial alternatives for about 150 prompts** (Speculative arithmetic on the prices above):
- Peec Pro: about $245 a month.
- Otterly: Standard plus extra prompts about $288, or Premium $489.
- Semrush: about $279 for 175 prompts.
- Scrunch: $250 billed annually.

The trackers run daily and cover the consumer apps, AI Overviews and AI Mode, which the APIs cannot reproduce. A grounded Gemini API answer is not an AI Overview, and Copilot has no affordable API stand-in.

**What to record** (Speculative):
- Report a **mention rate and a citation rate per engine and language over N runs**, at site or domain level. Do not report rank or exact URLs.
- Store the model version, date, location setting, raw answer and raw citations with every run.
- The arXiv recommendations (repeat runs, log the model, track page and site) apply directly.

**Where the prompts come from** (Speculative):
- Real wording from Search Console queries, Bing's grounding queries and Umami landing pages.
- Several phrasings per need, because people word the same need very differently (a similarity of 0.081 across 142 writers).

**Places and dated events** (Speculative):
- **Location:** set a city-level location per prompt, for example Anthropic's `user_location` set to Berlin or Barcelona. Profound's trial is limited to 1 region; Otterly allows unlimited countries.
- **Season:** run the panel in season. Take a baseline in October, then run weekly or twice a week from mid-November through December. For TCC, run weekly all year, since events expire. A monthly index on a 90-day window, like Ahrefs', is too slow for a five-week season.
- **Accuracy:** no vendor page sells a check of whether the answers give the right dates and hours. A do-it-yourself panel can extract the dates and hours from each answer and compare them with the site's own database, using `cited_text` and `page_age` to catch last year's pages being cited.
- **Language:** ChatGPT searched in English for most Chinese questions in the arXiv study. German and Spanish prompts may surface English sources the same way, so track each language separately.

### Gaps
- Profound's capture method (app or API), Peec's official current prices, Semrush's billing basis, which Scrunch structure is current, and whether trackers count each prompt × country × language combination as a separate prompt.
- Not researched: HubSpot AI Search Grader, LLMrefs, Rankscale, Am I On AI. Also the cost of SERP APIs that capture AI Overviews and AI Mode (SerpApi, DataForSEO), the only cheap way to sample Google's AI surfaces directly.
- I found no independent check of any tracker against real user prompts, and no variability study specific to local or event queries.

---

## 5. Evidence audit: popular AI SEO / GEO claims

### Takeaway
Google's pages, updated through July 2026, say that no special files, markup, chunking or AI-specific rewriting is needed, and that Google Search ignores llms.txt. Bing's 2026 guidance adds structure, FAQ sections, freshness and IndexNow, but gives no data.

The best controlled evidence finds no lift from the most popular tactics:
- **Schema:** Ahrefs' difference-in-differences test on 1,885 pages (May 2026) found no citation gain from adding JSON-LD.
- **"GEO" tactics:** C-SEO Bench (NeurIPS 2025) found most of them "largely ineffective".
- **The "+40%" figure:** it comes from a simulated 2023 engine and measures share of the answer for pages that were already retrieved.

For sites about places and dated events, the levers with evidence behind them are accurate, current facts and normal SEO. Venue listings (Google Business Profile, Bing Places) also feed local AI answers.

### Cited Findings

#### Claim 1: "llms.txt helps"
- **Proven (fact).** Jeremy Howard proposed it on 2024-09-03. — [Answer.AI](https://www.answer.ai/posts/2024-09-03-llmstxt.html)
- **Proven.** Google: "You don't need to create new machine readable files, AI text files, markup, or Markdown to appear in Google Search… Google Search itself doesn't use them… Doing so will neither harm nor help your site's visibility or rankings in Google Search, as Google Search ignores them." — [Google AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (published May 2026, updated 2026-07-10); [announcement](https://developers.google.com/search/blog/2026/05/a-new-resource-for-optimizing) (May 2026)
- **Proven.** Google's older page: "You don't need to create new machine readable files, AI text files, or markup to appear in these features." — [Google, AI features and your website](https://developers.google.com/search/docs/appearance/ai-features) (2025-12-10)
- **Reported.** John Mueller has said none of the AI services have said they use llms.txt, and compared it to the keywords meta tag. In June 2026 he called it "purely speculative for now (the file has existed for years, yet none of the AI systems use it…)". — [TechWyse](https://www.techwyse.com/news/ai-search/google-john-mueller-llms-txt-speculative-webmcp-ai-agents) (2026-06-04)
- **Reported.** Gary Illyes reportedly said Google does not support llms.txt and has no plans to. — [Search Engine Land](https://searchengineland.com/google-says-normal-seo-works-for-ranking-in-ai-overviews-and-llms-txt-wont-be-used-459422) (2025, about July)
- **Reported (conflicting signal).** Lighthouse 13.3 (May 2026) added an llms.txt check to an experimental "Agentic Browsing" audit, a use case separate from Search. — [TechWyse](https://www.techwyse.com/news/ai-search/google-ai-search-optimization-guide-llms-txt-lighthouse-audit) (May–June 2026)
- **Reported (correlational vendor study).** SE Ranking, about 300k domains: 10.13% had llms.txt, there was no correlation with AI citation frequency, and dropping the variable made their model more accurate. — [SEJ](https://www.searchenginejournal.com/llms-txt-shows-no-clear-effect-on-ai-citations-based-on-300k-domains/561542/); [SE Ranking](https://seranking.com/blog/llms-txt/) (late 2025)
- **Reported (single-site vendor test).** Over 90 days, 84 of 62,100+ AI-bot visits requested `/llms.txt`, about 0.1%. — [OtterlyAI](https://otterly.ai/blog/the-llms-txt-experiment/) (2025)
- **Reported.** BuiltWith counted 844,473 sites with llms.txt on 2025-10-25. — [blckalpaca](https://blckalpaca.at/en/knowledge-base/seo-geo/geo-generative-engine-optimization/llmstxt-844000-implementations-zero-confirmed-ai-usage)
- **Places and events:** no difference. Fresh dates belong in the pages, structured data and feeds, not in a static file.
- **Verdict:** no evidence it helps, and Google documents that Search ignores it. It is harmless and cheap if wanted for other agents. The section 1 logs can check whether any bot ever fetches it, provided the proxy matcher is widened or the file is served by a route handler.

#### Claim 2: "Schema markup increases AI citations"
- **Proven.** Google: "Structured data isn't required for generative AI search, and there's no special schema.org markup you need to add". It is still "a good idea to continue using it as part of your overall SEO strategy", and it should match the visible text. — [Google AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10); [Google AI features](https://developers.google.com/search/docs/appearance/ai-features) (2025-12-10)
- **Reported (platform remark, no data).** Bing's Fabrice Canel said schema helps Microsoft's LLMs understand content. — [Search Engine Land](https://searchengineland.com/microsoft-bing-copilot-use-schema-for-its-llms-453455) (March 2025)
- **Proven.** Bing's own February 2026 guidance for AI visibility does not mention structured data. — [Bing blog](https://blogs.bing.com/webmaster/February-2026-284b440771373a5a245425a5d31a8ad6/Introducing-AI-Performance-in-Bing-Webmaster-Tools-Public-Preview) (2026-02-10)
- **Proven (measured, vendor study with limits). Ahrefs' controlled test.** — [Ahrefs](https://ahrefs.com/blog/schema-ai-citations/) (2026-05-12, original not fetched); [TechWyse summary](https://www.techwyse.com/news/ai-search/schema-markup-ai-citations-ahrefs-study) (2026-05-13)
  - **Design:** 1,885 pages that added JSON-LD (Aug 2025 to Mar 2026), against matched controls, 30 days before and after (difference-in-differences).
  - **Results:** AI Overviews **−4.6%**; AI Mode **+2.4%** and ChatGPT **+2.2%**, both indistinguishable from noise.
  - **Limits:** only pages already heavily cited, concurrent page changes, all schema types pooled. The summary also reports control counts inconsistently.
- **Reported (confounded by site quality).** Correlational counter-data: 38.5% vs 32.0% ChatGPT citation rates for pages with and without JSON-LD, and cited pages "3x more likely" to carry it. — [Analyzify](https://analyzify.com/hub/schema-markup-ai-citations-research) (2026)
- **Reported.** AI crawlers that do not run JavaScript cannot see JSON-LD injected client-side, for example through Google Tag Manager. — [Trusted Shops](https://ai-trust-audit.trustedshops.com/en/blog/what-ai-crawlers-see-and-what-they-don-t) (date not verified); consistent with [Vercel](https://vercel.com/blog/the-rise-of-the-ai-crawler) (2024-12-17)
- **Proven. Places and events.** Google says its AI responses "can include… information about local businesses", and that Business Profiles help them "be visible in both AI responses and other Google Search results". — [Google AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10)
  - Bing says the same about Bing Places. — [Bing blog](https://blogs.bing.com/webmaster/February-2026-284b440771373a5a245425a5d31a8ad6/Introducing-AI-Performance-in-Bing-Webmaster-Tools-Public-Preview) (2026-02-10)
  - For a market, the organiser's listing may be what the AI shows. Event and Place schema still serve normal Search features.
- **Verdict:** useful for Search and for making entities clear, but adding it gave no measurable lift in AI citations. Render it on the server, and keep it matching the visible page.

#### Claim 3: FAQ sections and FAQ schema
- **Proven (still in force).** Since 2023-08-08, FAQ rich results show only for "well-known, authoritative government and health websites". — [Google Search Central blog](https://developers.google.com/search/blog/2023/08/howto-faq-changes) (2023-08-08)
- **Proven.** Google's 2026 guide never mentions FAQs: "You don't need to write in a specific way just for generative AI search." — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10)
- **Proven (platform statement, no data). Conflict with Google's stance.** Bing says clear headings, tables and FAQ sections help AI systems reference content accurately (paraphrased). — [Bing blog](https://blogs.bing.com/webmaster/February-2026-284b440771373a5a245425a5d31a8ad6/Introducing-AI-Performance-in-Bing-Webmaster-Tools-Public-Preview) (2026-02-10)
- I found no controlled study that isolates FAQ blocks.
- **Places and events:** real questions ("Open on 24–26 December?", "Entry fee?", "Card payment?") are facts AI answers often get wrong. Answering them is useful content, not a citation trick.
- **Verdict:** FAQ schema has given most sites no rich result since 2023, and there is no evidence that FAQ blocks raise AI citations. Write them only where people actually ask.

#### Claim 4: "AI-friendly" rewriting and chunking
- **Reported (platform statement relayed by the press).** Danny Sullivan and John Mueller, on *Search Off the Record*, said not to break content into "bite-sized" chunks for LLMs. Google does not use such signals, and they warned against making one version for LLMs and another for the web. — [Ars Technica via Harvard tagteam mirror](https://tagteam.harvard.edu/hub_feeds/3382/feed_items/17175713/content) (2026-01-10)
- **Proven.** Google: "There's no requirement to break your content into tiny pieces for AI to better understand it… There's no ideal page length." — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10)
- **Proven (benchmark, not live engines). C-SEO Bench.** — [C-SEO Bench, arXiv 2506.11097](https://arxiv.org/abs/2506.11097) (NeurIPS 2025 Datasets & Benchmarks; v3 2025-10-20)
  - Most conversational-SEO methods are "largely ineffective" and often hurt.
  - Traditional SEO, which raises a source's rank in the model's context, is "significantly more effective".
  - Gains shrink as more actors adopt the methods.
- **Claimed.** Practitioners argue that chunking and writing for users are compatible, and that retrieval systems split pages at headings anyway. — [iPullRank](https://ipullrank.com/misinformation-about-chunking) (2026)
- **Places and events:** one market per page, with dates, hours and address near the top, is already naturally chunked. The real risk is inconsistent facts across the EN, DE and ES versions.
- **Verdict:** do not rewrite for AI. Clear headings and an answer near the top are simply good writing.

#### Claim 5: Adding statistics, quotes and citations (the GEO paper)
- **Proven within its own setup.** Aggarwal et al., KDD 2024: "boost visibility by up to 40%". — [arXiv 2311.09735](https://arxiv.org/abs/2311.09735) (v3 2024-06-28; the detailed method is in the [HTML version](https://arxiv.org/html/2311.09735v3))
  - **The engine:** the top 5 Google results fed to gpt-3.5-turbo.
  - **The metrics:** Position-Adjusted Word Count and a GPT-judged impression score.
  - **The winners:** quotations, statistics and citing sources, with gains of 30–40% on word count. On Perplexity (200 samples): quotations +22%, statistics up to +37%; keyword stuffing −10%.
  - **The authors' own limits:** two engines, queries drifting over time, and no effect on rankings evaluated.
- **Proven. Conflict.** C-SEO Bench finds most such methods ineffective, "contrary to reported results in the literature". — [arXiv 2506.11097](https://arxiv.org/abs/2506.11097) (2025-10-20)
- **Places and events:** here the "statistics" are dates, hours, prices and stall counts. Sourced facts help accuracy; a stale number is a liability.
- **Verdict:** real, sourced numbers and quotes are good content. The 40% is a 2023 lab result for pages already retrieved and is not replicated, so treat it as hygiene, not a lever.

#### Claim 6: Freshness tweaks
- **Reported (correlational, dates from page metadata). Ahrefs freshness study.** — [Ahrefs](https://ahrefs.com/blog/do-ai-assistants-prefer-to-cite-fresh-content/) (2025-07-28)
  - About 17M citations across 7 platforms.
  - Pages cited by AI averaged 1,064 days since publication, against 1,432 for organic results ("25.7% fresher").
  - By last update the gap is only 13.1%.
  - ChatGPT favours the newest pages.
- **Proven (lab, not production engines). Recency bias in LLM rerankers.** — [Fang et al., arXiv 2509.11353](https://arxiv.org/abs/2509.11353v1) (2025-09-14)
  - Artificial dates were injected into TREC passages for seven LLM rerankers.
  - "Fresh" passages were promoted: the top-10 mean year shifted up to 4.78 years, and pairwise preferences flipped up to 25%.
  - Larger models reduced the effect but did not remove it.
- **Proven (platform statement). Bing:** regular updates help AI systems cite the current version, and it recommends IndexNow. — [Bing blog](https://blogs.bing.com/webmaster/February-2026-284b440771373a5a245425a5d31a8ad6/Introducing-AI-Performance-in-Bing-Webmaster-Tools-Public-Preview) (2026-02-10)
- **Proven (old, but still the live guidance). Google:** "don't artificially freshen a story without adding significant information". — [Google Search Central blog](https://developers.google.com/search/blog/2019/03/help-google-search-know-best-date-for) (2019-03)
- **Reported.** Mueller: changing dates won't improve rankings. — [SEJ](https://www.searchenginejournal.com/googles-john-mueller-changing-dates-on-pages-wont-improve-rankings/401734/) (date not verified)
- **Places and events: this is the biggest difference from generic sites. Freshness is the content.** The risk is AI answers quoting last season's dates.
  - Name the season and year explicitly.
  - Update when organisers publish.
  - Keep `dateModified` honest.
  - Ping IndexNow.
- **Verdict:** recency bias is real in the lab and visible in the data, but faking dates goes against Google's guidance. Make real updates, and measure date accuracy in AI answers (section 4).

#### Claim 7: Author bios and E-E-A-T
- **Proven.** Google's AI guide never mentions bylines. It stresses "non-commodity" content with "unique expert or experienced takes". — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10)
- **Proven (as reader guidance).** Google advises accurate authorship "where readers might expect it". — [Google helpful content](https://developers.google.com/search/docs/fundamentals/creating-helpful-content)
- **Claimed (no public method).** Vendor claims of +50–70% or 58% vs 19% citations. — [Presenc AI](https://presenc.ai/research/does-author-eeat-signals-improve-ai-visibility-2026) (2026); [Texta](https://www.texta.ai/blog/authority-signals-for-ai) (2026-03-17)
- **Places and events:** the expertise that matters is first-hand verification (checked with the organiser, sources linked), not a bio box.
- **Verdict:** no controlled evidence. Bylines are a reader-trust practice.

#### Claim 8: Seeding Reddit
- **Reported (prompt set not public). Semrush citation study.** — [Semrush](https://www.semrush.com/blog/most-cited-domains-ai/) (2025-11-10)
  - 230k+ prompts and 100M+ citations, July–October 2025.
  - Reddit appeared in about 60% of ChatGPT responses in early August, and about 10% by mid-September.
  - Wikipedia fell from about 55% to under 20%.
- **Reported (magnitude conflicts).** About 8% falling to under 2%. — [NP Digital](https://neilpatel.com/marketing-stats/chatgpt-citation-analysis-reddit/) (late 2025)
- **Reported.** Reddit sued Perplexity, SerpApi, Oxylabs and AWMProxy on 2025-10-22, and Anthropic in June 2025. — [PYMNTS](https://www.pymnts.com/cpi-posts/reddit-sues-perplexity-ai-and-data-firms-over-alleged-unauthorized-scraping/) (Oct 2025)
- **Proven.** Google: "seeking inauthentic 'mentions' across the web isn't as helpful as it might seem… other systems block spam". — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10)
- **Verdict:** Reddit's share of citations swings with platform changes nobody controls, and Google discounts inauthentic mentions. Seeding is a reputational risk with unproven payoff. Genuine, disclosed answers in r/berlin or r/Barcelona are community work, not a measurable lever.

#### Claim 9: Paid placements
- **Proven (fetch returned 403; details from the search snippet). ChatGPT ads.** — [OpenAI](https://openai.com/index/testing-ads-in-chatgpt) (Feb–Aug 2026)
  - The test began on 2026-02-09 in the US, for Free and Go users.
  - OpenAI says ads do not influence answers; they are labelled "sponsored".
  - An update of 2026-08-11 lists the UK, Mexico, Brazil, Japan and South Korea, but not Germany or Spain.
- **Reported (timing conflicts).** Perplexity's 2024 sponsored follow-up questions were phased out from about October 2025. — [Search Engine Land](https://searchengineland.com/perplexity-stops-testing-advertising-469452); [Gigazine](https://gigazine.net/gsc_news/en/20260219-perplexity-drops-ads-hurt-trust-ai) (2025 to 2026-02-19)
- **Reported.** Google ads appear in AI Overviews and AI Mode, and Copilot ads run through Microsoft Advertising. — [eMarketer](https://www.emarketer.com/content/google-adds-ads-ai-mode--reshaping-search) (2025); [Search Engine Land](https://searchengineland.com/microsoft-copilot-ads-change-appearance-trigger-447186)
- **Proven.** Google: "No third-party tool has access to our internal ranking or AI systems." — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10)
- **Claimed.** "Guaranteed citation" offers are flagged as a red flag, because answers are probabilistic. — [SEO.com](https://www.seo.com/blog/ai-seo-agency-red-flags/)
- **Verdict:** the only paid route is a labelled ad unit. No platform sells organic citations.

#### Claim 10: Other myths
- **Proven.** "Blocking Google-Extended removes you from AI Overviews" is a **myth**. Google-Extended "does not impact a site's inclusion in Google Search". What Search shows, including AI features, is controlled by nosnippet, data-nosnippet, max-snippet and noindex, and since 2026 by the Search Console AI control (section 3). — [Google crawlers doc](https://developers.google.com/search/docs/crawling-indexing/google-common-crawlers) (2026-10-15); [Google AI features](https://developers.google.com/search/docs/appearance/ai-features) (2025-12-10)
- **Proven.** "SEO is dead" is a **myth**. Google's AI features are "rooted in our core Search ranking and quality systems", and C-SEO Bench finds traditional SEO more effective. — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10); [arXiv 2506.11097](https://arxiv.org/abs/2506.11097)
- **Proven.** "You need an AI sitemap or special files" is a **myth** for Google Search (see claim 1).

### Inferences
Verdict table (Speculative synthesis of the findings above):

| Claim | Strongest evidence | Verdict |
|---|---|---|
| llms.txt helps | Google: Search ignores it (Proven). No correlation across ~300k domains; ~0.1% of AI-bot hits fetch it (Reported) | No evidence; harmless |
| Schema raises AI citations | Ahrefs difference-in-differences test on 1,885 pages: no lift (Proven, vendor) | Keep for Search, server-rendered; not an AI lever |
| FAQ sections | No controlled study. Google: no special writing; Bing: FAQs help (statements) | Only where real questions exist |
| AI-friendly rewriting and chunking | Google: don't (Proven). C-SEO Bench: largely ineffective (Proven, benchmark) | Don't |
| Statistics and quotes | GEO paper +40% in a simulation; C-SEO Bench contradicts it | Good hygiene; not a lever |
| Freshness tweaks | Recency bias in the lab (Proven); correlational data (Reported); Google: no fake dates | Real updates only; vital for dated events |
| Author bios | No controlled evidence (Claimed) | Reader trust only |
| Seeding Reddit | Volatile citation shares (Reported); Google discounts inauthentic mentions | Spam risk |
| Paid placements | Labelled ads exist (Proven); no paid citations | Ads are not citations |
| Google-Extended removes you from AI Overviews | Google docs (Proven) | Myth |

- The platform documents and the two strongest studies agree: tactics labelled "GEO" show no reliable lift, while normal SEO plus original, accurate content is what platforms say they reward.
- The GEO paper never tested getting retrieved, which is the main problem for a small site, because its sources were already in the top 5. Its 40% does not carry over to "get cited".
- To test any tactic on these sites, copy Ahrefs' design: matched page groups, a before-and-after window, and outcomes from section 4 (the panel) and section 3 (Search Console and Bing). Do not judge from correlations or single prompts.
- For places and events, the measurable risk and opportunity is **factual accuracy and currency in AI answers**: dates, hours, entry fees, and last season's data.

### Gaps
- Not verified: Illyes's exact date and venue, the date of Mueller's first Reddit comment, and a reported llms.txt briefly published on Google's developer docs in December 2025.
- I found no public statement from OpenAI, Anthropic or Perplexity on whether their engines use llms.txt.
- I did not fetch the originals of the Ahrefs schema study or the SE Ranking study.
- I found no controlled study isolating FAQ blocks, author bios, or the effect of Event or Place schema on AI citations.
- Google's help pages on ads in AI features, and the scale of Copilot ads, were not checked against primary sources. The OpenAI ads page returned 403.

---

## 6. Risks: fewer clicks, scraping without attribution, and the crawl trade-off

### Takeaway
The evidence that AI answers reduce clicks per search is strong and growing. A representative panel, a randomized field experiment and several large vendor datasets point the same way: roughly 35–60% fewer organic clicks when an AI Overview appears. Google's denial rests on a different measure (total clicks across more searches) and comes without data.

AI assistants send little traffic: about 0.3–1% of site visits in 2025–26, mostly from ChatGPT. They crawl far more than they refer.

The operators' own documents show that blocking **search** crawlers costs visibility in their answers, while blocking **training** crawlers does not.

For places and dated events, the main questions ("when", "where", "is it open") are the ones most likely to end without a click, and the most exposed to stale or wrong answers.

### Cited Findings

#### AI answers and click-through
- **Proven (US, Google only; may be outdated, since only 18% of searches had a summary then). Pew Research.** — [Pew Research](https://www.pewresearch.org/short-reads/2025/07/22/google-users-are-less-likely-to-click-on-links-when-an-ai-summary-appears-in-the-results/) (2025-07-22)
  - **Method:** 900 US adults with a browsing tracker, 68,879 searches in March 2025.
  - Users clicked a traditional result in **8%** of visits with an AI summary, against **15%** without one.
  - They clicked a link inside the summary in **1%** of visits.
  - **26%** of visits with a summary ended the session, against 16%.
- **Proven.** Pew also measured which queries trigger summaries: 60% of queries with a question word, 53% of queries of 10 or more words, and 8% of one- or two-word queries. — [Pew](https://www.pewresearch.org/short-reads/2025/07/22/google-users-are-less-likely-to-click-on-links-when-an-ai-summary-appears-in-the-results/) (2025-07-22)
- **Reported (vendor, correlational, desktop only; supersedes Ahrefs' April 2025 figure of 34.5%). Ahrefs.** — [Ahrefs](https://ahrefs.com/blog/ai-overviews-reduce-clicks-update/) (2026-02-04)
  - An AI Overview "now correlates with a **58% lower** average clickthrough rate for the top-ranking page".
  - **Method:** 300,000 keywords, December 2023 against December 2025.
  - Position-1 click-through rate fell from 0.073 to 0.016.
- **Reported (correlational; "We cannot claim causation"; the article's own tables have inconsistencies). Seer Interactive, 2026 update.** — [Seer Interactive](https://www.seerinteractive.com/insights/aio-impact-on-google-ctr-2026-update) (2026-04-24)
  - **Data:** 53 brands, 5.47M queries, 2.43B impressions, January 2025 to February 2026.
  - Organic click-through rate with an AI Overview: 3.19% → 1.31% → 2.36%.
  - Informational queries: cited 2.07%, not cited 0.94%, no AI Overview 3.35%.
  - Being cited gives about +120% over not being cited, but is still −38% against no AI Overview.
- **Reported (figures via secondary summaries; may be outdated). Seer, September 2025.** Organic −61% (1.76% to 0.61%) and paid −68%. — [Seer](https://www.seerinteractive.com/insights/aio-impact-on-google-ctr-september-2025-update) (Sept 2025)
- **Reported (randomized field experiment; working paper read only through secondary coverage). Agarwal and Sen.** — [SEJ](https://www.searchenginejournal.com/ai-overviews-cut-organic-clicks-38-field-study-finds/) (Apr 2026)
  - 1,065 US Chrome desktop users were randomized, with AI Overviews hidden for some.
  - Hiding them raised organic clicks per search from 0.37 to 0.62, and cut zero-click searches from 0.73 to 0.54.
  - Headline: **−38% to −39.8%** organic clicks, with no difference in user satisfaction.
- **Reported (clickstream panels).**
  - Similarweb: zero-click news searches rose from 56% to about 69% (May 2024 to May 2025). ChatGPT referrals to news grew from under 1M to 25M, without offsetting the loss. — [TechCrunch](https://techcrunch.com/2025/07/02/chatgpt-referrals-to-news-sites-are-growing-but-not-enough-to-offset-search-declines) (2025-07-02)
  - SparkToro and Similarweb: **68.01%** of US Google searches were zero-click in January–April 2026, against 60.45% in 2024. Only 0.34% of searches moved into AI Mode. — [Search Engine Land](https://searchengineland.com/google-zero-click-searches-2026-study-479717) (2026; read via [TechWyse](https://www.techwyse.com/news/reports-data/google-zero-click-searches-68-percent-2026))
- **Claimed (no figures or method). Google's position.** Liz Reid says total organic click volume is "relatively stable year-over-year", with "slightly more quality clicks", and that third-party studies use "flawed methodologies". — [Google blog](https://blog.google/products/search/ai-search-driving-more-queries-higher-quality-clicks/) (2025-08-06)
  - **Conflict:** the independent studies measure clicks per query; Google speaks of total and "quality" clicks.

#### How much traffic AI sends, and its quality
- **Reported.** Conductor: AI referrals are **1.08%** of site traffic, and ChatGPT is 87.4% of them (13,770 enterprise domains). — [BusinessWire](https://www.businesswire.com/news/home/20251113364791/en/Conductor-Unveils-2026-AEO-GEO-Benchmarks-Report-How-AI-Shapes-Brand-Visibility-in-a-Zero-Click-World) (2025-11-13)
- **Reported (conflicts with Conductor because the samples differ).** SE Ranking: **0.32%** in 2026, with AI visitors spending 68% more time on site. — [SE Ranking](https://seranking.com/blog/ai-traffic-research-study/) (2026)
- **Reported (one site).** On ahrefs.com, AI search was 0.5% of visits but 12.1% of signups, about 23× organic conversion. — [Ahrefs](https://ahrefs.com/blog/ai-search-traffic-conversions-ahrefs/) (2025-06-16)
- **Reported (growth from a small base).** Adobe, US holiday season 2025: AI traffic to retail sites +693% and to travel sites +539%, converting 31% better. — [Adobe](https://business.adobe.com/blog/ai-driven-traffic-surges-across-industries) (2025–26)
- **Reported (TollBit customers, via secondary coverage).**
  - Q4 2024: click-through rate 0.74% from AI search engines and 0.33% from chatbots, against 8.63% from Google. — [Search Engine Land](https://searchengineland.com/ai-scraping-ai-search-traffic-report-453160) (2025)
  - Q2 2025: about 135 scrapes per human referral. — [Search Engine Land](https://searchengineland.com/google-more-visitors-ai-systems-report-462905) (2025)
  - Q4 2025: about 1 AI-bot visit per 31 human visits. — [TechRadar](https://www.techradar.com/pro/ai-bot-web-traffic-is-closing-in-on-human-usage-experts-warn)

#### Scraping without attribution
- **Reported (Cloudflare's network only; Cloudflare also sells remedies). Crawl-to-refer ratios**, measured as HTML crawler requests per referred visit. — [Cloudflare](https://blog.cloudflare.com/ai-search-crawl-refer-ratio-on-radar) (2025-07-01); [Cloudflare](https://blog.cloudflare.com/crawlers-click-ai-bots-training/) (2025-08-29, modified 2026-07-15)

  | Operator | Jan 2025 | Jul 2025 |
  |---|---|---|
  | Anthropic | 286,930 | 38,065 |
  | OpenAI | 1,217 | 1,091 |
  | Perplexity | 54.6 | 194.8 |
  | Microsoft | 38.5 | 40.7 |
  | Google | 3.8 | 5.4 |

  Crawling purpose over 12 months: about **80% training, 18% search, 2% user actions**.
- **Reported (primary returned 403).** Cloudflare's 2025 Year in Review: AI crawlers made 4.2% of HTML requests, against 4.5% for Googlebot. Anthropic's ratio was about 25,000–100,000:1 in the second half of 2025. "User action" crawling grew more than 15×. — [InfoQ](https://infoq.com/news/2025/12/cloudflare-2025-ai-bots/) (Dec 2025)
- **Reported (2026 figures that don't fully reconcile).** For July 2026: Anthropic about 1,917:1, OpenAI 251:1, Google 4.7:1. Anthropic disputes the method. — [ecorpit](https://ecorpit.com/ai-crawler-crawl-to-referral-ratio-2026-geo-decision/) (Jul 2026); [WebProNews](https://www.webpronews.com/anthropics-crawling-spree-exposes-cracks-in-the-webs-uneasy-ai-truce/) (2026)
- **Reported, contested by Perplexity. Perplexity's undeclared crawler.** — [Cloudflare](https://blog.cloudflare.com/perplexity-is-using-stealth-undeclared-crawlers-to-evade-website-no-crawl-directives/) (2025-08-04)
  - Cloudflare tested on new, unindexed domains with robots.txt disallowing all crawlers.
  - Besides the declared Perplexity-User (20–25M requests a day), it found an undeclared generic Chrome user agent making 3–6M requests a day from outside Perplexity's published IPs.
  - In the same test, ChatGPT-User fetched robots.txt and stopped.
- **Claimed (no data).** Perplexity's reply: the requests were BrowserBase's, and user-driven agents are not crawlers. — [Perplexity](https://www.perplexity.ai/hub/blog/agents-or-bots-making-sense-of-ai-on-the-open-web) (Aug 2025)
- **Reported.** Spoofing: 5.7% of traffic network-wide, and 82% of "AI assistant" visits fake on one small site (details in section 1). — [HUMAN Security](https://humansecurity.com/learn/blog/ai-crawler-spoofing-chatgpt-mistral-perplexity/) (date not confirmed); [SEJ, Duane Forrester](https://searchenginejournal.com/my-ai-assistant-traffic-was-fake-the-googlebot-number-was-worse/580052/) (2026)

#### The crawl trade-off, as the platforms document it
- **Proven.** OpenAI: blocking OAI-SearchBot keeps a site out of ChatGPT search answers, but it can still appear as navigational links. GPTBot is for training only. ChatGPT-User is user-initiated and "robots.txt rules may not apply". "Each setting is independent." — [OpenAI](https://developers.openai.com/api/docs/bots) (checked 2026-10-22)
  - **Conflict:** Cloudflare saw ChatGPT-User obey robots.txt (above).
- **Proven.** Anthropic: blocking Claude-SearchBot "may reduce your site's visibility and accuracy in user search results", and blocking Claude-User may reduce visibility for searches users direct. ClaudeBot is training only. — [Anthropic](https://support.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler) (2026-04-07)
- **Proven.** Perplexity: PerplexityBot is not used for training, and Perplexity-User "generally ignores robots.txt". — [Perplexity](https://docs.perplexity.ai/guides/bots)
- **Proven.** Google: Google-Extended does not affect inclusion in Search. The 2026 Search Console control removes a site from AI Overviews, AI Mode and Discover's AI features, along with their impressions and traffic. — [Google crawlers](https://developers.google.com/search/docs/crawling-indexing/google-common-crawlers) (2026-10-15); [Google blog](https://blog.google/products-and-platforms/products/search/new-controls-website-owners/) (2026-06-03)
- **Reported (secondary, unverified in the primary).** Cloudflare says more than 50% of AI-crawler traffic re-fetches unchanged pages. Its pay-per-crawl programme is turning into "pay per use". It was reported to start blocking mixed-use AI crawlers by default on ad-supported sites from 2026-09-15. — [PPC Land](https://ppc.land/cloudflare-stops-charging-ai-per-crawl-and-starts-paying-per-answer/) (2026); [Let's Data Science](https://letsdatascience.com/news/cloudflare-blocks-mixed-use-crawlers-on-monetized-pages-5a9acadb) (2026)

#### What differs for places and dated events
- **Proven.** Queries with a question word ("when", "where") trigger AI summaries 60% of the time, against 8% for one- or two-word queries. — [Pew](https://www.pewresearch.org/short-reads/2025/07/22/google-users-are-less-likely-to-click-on-links-when-an-ai-summary-appears-in-the-results/) (2025-07-22)
- **Reported.** In Seer's data, informational "near me" queries showed AI Overviews 76.9% of the time. Transactional queries (including Local, Events and Map results) showed them about 5% of the time, and transactional "near me" queries 1.5%. — [Seer](https://www.seerinteractive.com/insights/aio-impact-on-google-ctr-2026-update) (2026-04-24)
- **Proven (measured for news).** The EBU and BBC reviewed 3,000+ answers from ChatGPT, Copilot, Gemini and Perplexity: **45%** had at least one significant issue, and **20%** had major accuracy problems, including **out-of-date information**. — [EBU](https://www.ebu.ch/news/2025/10/ai-s-systemic-distortion-of-news-is-consistent-across-languages-and-territories-international-study-by-public-service-broadcaste) (Oct 2025)
- **Reported (survey).** Phocuswright: 56% of travellers used AI for at least one trip, but only 8% said AI answers alone were enough, and 51% usually click through to sources. — [Phocuswright](https://www.phocuswright.com/Travel-Research/Consumer-Trends/The-AI-Surge-Travels-Fastest-Behavioral-Shift-in-a-Decade) (Mar 2026)

### Inferences
- **Expect fewer clicks per impression even as visibility rises.** Both sites' core questions are question-word factual queries. The plan must count citations and mentions, and check the accuracy of dates and places, not only referral clicks.
- **The only relevant click-loss test for a small seasonal site is its own data.** Compare Search Console click-through rate on the site's own queries, year on year in the same season.
- **AI referral volumes are too small to judge a season on**, at about 0.3–1% of visits. The conversion uplifts (Ahrefs 23×, Adobe +31%) come from one site and from retail, so treat them as hypotheses.
- **What matters is each site's own crawl-to-refer ratio:** verified bot hits per operator divided by referrals per operator. Cloudflare's network ratios swing from month to month.
- **Blocking training crawlers has no documented visibility cost. Blocking search crawlers removes a site from that assistant's answers. User-triggered fetchers cannot be relied on to obey robots.txt.** Split the logs into these classes (section 1).
- **For dated events, the specific risk is a stale answer:** last year's dates, or a market that has ended shown as open. Measure it directly in the panel.

### Gaps
- I found no measured zero-click rate for **AI Mode**. The widely repeated "about 93%" could not be verified.
- The primaries for Cloudflare's 2025 Year in Review, SparkToro's 2026 zero-click study and the Agarwal and Sen paper were read only through secondary coverage.
- I found no measured data on how often AI answers give **wrong event dates**, apart from news (EBU).
- I found no German or Spanish click studies; almost all are from the US.
- I found no reliable per-site figures on the bandwidth or hosting cost of AI crawling, and no public adoption data for Cloudflare's pay-per-crawl or content-signals programmes.

---

## 7. Synthesis: what to log and track, with which tools, at what cost

### Takeaway
Track five layers, cheapest first:
1. Verified AI-bot fetches from your own logs.
2. AI referrals in Umami: the `llm` channel plus ChatGPT's UTM tag.
3. The two free first-party reports: Search Console's AI impressions, and Bing's citations and Citation Share.
4. A small, repeated prompt panel through the model APIs, scored for **mention rate** and for **factual accuracy against your own database**.
5. Optionally, a cheap commercial tracker for the consumer apps and Google's AI Overviews.

Cost: about $0–$25 a month off-season and roughly $150–$300 for a Christmas season, mostly API calls. Mercaditos needs no Vercel upgrade. Judge progress season over season with matched page groups, not single prompts.

### Cited Findings
These are the facts the plan rests on, with sources.
- **Proven.** Umami's `llm` channel keys on referrer domains only; ChatGPT's `utm_source` appears only in the UTM report. — [Umami source](https://github.com/umami-software/umami/blob/master/src/queries/sql/getChannelMetrics.ts) (v3.2.0, 2026-06-24)
- **Reported.** Most ChatGPT clicks have arrived without a referrer since about 2026-10-09. — [SEJ](https://www.searchenginejournal.com/chatgpt-traffic-drop-appears-to-be-a-tracking-problem/593157/) (2026-10-15)
- **Proven.** Search Console's generative AI report gives impressions only. — [Google Help](https://support.google.com/webmasters/answer/16984139)
- **Proven.** Bing AI Performance gives citations and grounding queries, and Citation Share since 2026-06-16. — [Bing blog](https://blogs.bing.com/webmaster/February-2026-284b440771373a5a245425a5d31a8ad6/Introducing-AI-Performance-in-Bing-Webmaster-Tools-Public-Preview) (2026-02-10); [Bing blog](https://blogs.bing.com/search/June-2026/New-AI-Visibility-Insights-in-Bing-Webmaster-Tools-Intents-Topics-Citation-Share-Compare) (June 2026)
- **Proven.** On Vercel: Hobby keeps 1–12 hours of logs and has no drains. Drains are Pro-only at $0.50/GB. The AI bots ruleset in log mode is on all plans. — [Vercel Hobby](https://vercel.com/docs/plans/hobby) (2026-09-14); [Vercel Drains](https://vercel.com/docs/drains) (2026-09-01); [Vercel Bot Management](https://vercel.com/docs/bot-management) (2026-09-10)
- **Proven.** Next.js 16 `proxy.ts` runs on every matched page request and supports `event.waitUntil()`. — [Next.js docs](https://nextjs.org/docs/app/api-reference/file-conventions/proxy)
- **Proven.** Answer variability is high; rates over many runs are stable. API answers recover only about 26–28% of the pages the app cites. — [SparkToro via SEJ](https://www.searchenginejournal.com/ai-recommendations-change-with-nearly-every-query-sparktoro/566242/) (2026-01-30); [arXiv 2610.15382](https://arxiv.org/abs/2610.15382) (2026-10-11)
- **Proven.** API prices: OpenAI and Anthropic web search $10/1k; Gemini 3 grounding 5,000 free a month then $14/1k; Perplexity Agent API search $2.50/1k. — [OpenAI](https://developers.openai.com/api/docs/pricing); [Anthropic](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool); [Gemini](https://ai.google.dev/gemini-api/docs/pricing); [Perplexity](https://docs.perplexity.ai/guides/pricing.md) (all checked 2026-10-22)
- **Proven.** Otterly Lite costs $29 a month for 15 prompts, daily, covering ChatGPT, AI Overviews, Perplexity and Copilot, with unlimited countries and languages. — [Otterly pricing](https://otterly.ai/pricing) (checked 2026-10-22)
- **Proven** (a platform statement, a vendor difference-in-differences study and a peer-reviewed benchmark). Google's guidance and controlled tests find no lift from llms.txt, schema or rewriting. — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (2026-07-10); [Ahrefs](https://ahrefs.com/blog/schema-ai-citations/) (2026-05-12); [C-SEO Bench](https://arxiv.org/abs/2506.11097) (2025-10-20)

### Inferences
Everything in this section is **Speculative**: a plan built on the findings above.

#### What to log and track

| Layer | KPI | Tool | Cadence | Cost |
|---|---|---|---|---|
| 1. Crawl and fetch | Verified hits per operator × class (training / search / user fetch / agent); distinct URLs fetched; share of hits on current-season pages; time from publishing to first search-bot fetch; robots.txt and llms.txt fetches if logged; own crawl-to-refer ratio per operator | Mercaditos: `proxy.ts` → Postgres table, plus a daily IP-verification job against the OpenAI, Anthropic, Perplexity and Google JSON lists; ruleset in log mode for spot checks. On Pro: a filtered log drain. TCC: its own server or CDN logs, or Cloudflare AI Crawl Control / Clarity Bot Activity if behind a supported CDN | Continuous; weekly summary | about $0 on Hobby; cents a month on Pro plus the plan |
| 2. Referrals | AI visits = Umami `llm` channel + `utm_source=chatgpt.com` visits with no referrer; landing pages; browser language; key events per AI visit compared with other channels | Umami Cloud (already paid); annotations for platform incidents | Weekly in season, monthly otherwise | $0 extra |
| 3. First-party reports | Search Console: AI impressions by page, country and device, and the AI/Web impression ratio per page. Bing: citations, cited pages, grounding queries, Citation Share | Search Console, Bing Webmaster Tools (export weekly) | Weekly in season | $0 |
| 4. Prompt panel | Mention rate and citation rate per engine × language over N runs (site level); **date and hours accuracy rate** against the database; **stale-season citation rate** (answers citing last year's dates or pages) | Do-it-yourself script on the OpenAI, Anthropic, Gemini (and optionally Perplexity) APIs with city-level location, storing raw answers, citations and model versions | Baseline in October; weekly mid-Nov to Dec (Mercaditos); weekly all year (TCC) | ≈$22 per sweep (30 questions × 3 languages × 4 engines × 3 repeats); ≈$200 a season |
| 5. Consumer-app sample (optional) | The same mention and citation rates on the real ChatGPT, AI Overviews, Perplexity and Copilot interfaces, for a few core prompts | Otterly Lite ($29 a month, 15 prompts) for the season only, or Standard ($189 a month, 100 prompts) if the budget allows | Daily, in season | ≈$60 a season (Lite) |
| Click-loss guard | Search Console click-through rate on core queries, season on season | Search Console | Season end | $0 |

#### Site-specific notes
- **Mercaditos.**
  - Stay on Hobby for measurement. Add the bot logger to the existing `src/proxy.ts`, keeping writes non-blocking with `event.waitUntil()`.
  - Decide whether to widen the matcher, or log in route handlers, to capture robots.txt, sitemap.xml and llms.txt fetches.
  - Keep `data-exclude-search` off in Umami.
  - Verify the site in Bing Webmaster Tools and wire IndexNow for date updates.
  - Seed the panel's prompts from Search Console queries and Bing's grounding queries in EN, DE and ES, with Berlin as the location.
  - Keep in mind that Vercel's Hobby terms are non-commercial. If the site monetises, Pro ($20 a seat) also unlocks drains and Observability Plus.
- **TCC.**
  - Events expire weekly, so the crawl-recency KPI (publishing to first search-bot fetch) and a weekly year-round panel matter more than a seasonal one.
  - Panel languages are probably ES, CA and EN. Catalan is an assumption to confirm.
  - If it is served through Cloudflare, AI Crawl Control (free crawler view; referrals need a paid plan) and Clarity Bot Activity are the cheapest crawler dashboards.

#### Season calendar (Mercaditos)
- **October:** baseline sweep, and set up the reports.
- **From the second half of November** (markets open): weekly sweeps and weekly exports.
- **January:** post-mortem sweep and the season-on-season comparison, against the October baseline and, from 2027, against the 2026 season.

#### How to check progress honestly
- **Pre-register** the prompts, engines, repeat count and KPIs before the season, and do not change them mid-season.
- With 90 prompts × 3 repeats = 270 observations per engine per sweep, a 50% mention rate has a 95% margin of at least ±6 percentage points: sqrt(0.25/270) ≈ 0.030 × 1.96. The true margin is wider, because repeats of the same prompt are correlated. Only changes clearly bigger than that are signal, so pool several sweeps before calling a trend.
- **To test any tactic,** change half of a set of comparable pages (for example, half the market pages), keep the other half as controls, and compare panel citations, Bing citations and Search Console AI impressions over 30 days. This is the matched difference-in-differences design Ahrefs used.
- Small sites have little statistical power, so prefer changes that are worth doing anyway, such as correcting dates, naming the season and year, and fixing 404s that bots hit.
- **Log every known platform change** as an annotation:
  - the ChatGPT tagging bug, 2026-10-09 to 15;
  - the Search Console report rollout, June to August 2026;
  - Bing's June 2026 backfill;
  - model changes recorded in the panel.

#### What not to spend on
- Tools or agencies that "guarantee" citations, or that sell llms.txt or schema as an AI-ranking lever.
- Opaque "prompt volume" estimates as a planning basis.
- Prompt-level rank tracking. Ranks are not stable; rates over many runs are.

### Gaps
- There is no cheap, verified way to sample Google AI Overviews and AI Mode programmatically, beyond paid trackers or SERP APIs whose prices were not checked.
- I found no published benchmark for how often AI answers get event dates wrong, so the first season's accuracy rate becomes the baseline.
- Several unknowns affect the plan:
  - TCC's hosting and CDN.
  - Whether Umami Cloud runs v3.2.0 or later.
  - The Search Console report's retention and API.
  - The exact size of a Vercel drain record.
  - Whether Umami counts agentic browsers as visitors.
- The panel's per-run costs rest on assumed token counts and searches per run. Measure the first sweep's real spend before committing to the full season.
