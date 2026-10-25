# Machine-readable formats and agent-facing protocols: an evidence-rated inventory (as of 2026-10-22)

Every line carries one of four evidence labels. **Proven** means the platform's own documentation, or a measured study with a stated method. **Reported** means industry data or press with known limits: small samples, vendor authors or secondhand accounts. **Claimed** means an assertion without data. **Speculative** means my own inference or estimate. All sources were searched or fetched on 2026-10-22. The date after each source is that source's own publication or last-updated date. "FLAG" marks items likely to change within months. Build-cost figures are my estimates for a Next.js 16 + Postgres site on Vercel (Mercaditos), and all of them are Speculative.

## 1. schema.org / JSON-LD: which types matter for places and dated events, do AI platforms use it, and what changed at Google in 2025–2026?

### Takeaway
JSON-LD still earns Google rich results: Event, Local business, Organization and Breadcrumb are all still supported as of 2026-10-16. Bing says markup helps its LLMs. But Google states that no special markup is needed for its AI features. In the one controlled test, live AI fetchers ignored facts that existed only in JSON-LD, and the largest study (Ahrefs, May 2026) found that adding JSON-LD did not raise AI citations. Treat JSON-LD as a signal for search indexes that restates facts already visible in the HTML, not as a direct line into AI answers. Google removed FAQ rich results in May–June 2026 and practice-problem results in January 2026. It also limited Dataset markup to Dataset Search. Event was not touched.

### Cited Findings

#### What Google supports now
- **Proven.** Google's structured-data gallery lists 25 features, including Event, Local business, Organization, Breadcrumb, Dataset, Q&A, Discussion forum, Vacation rental and Speakable. FAQ is no longer listed. — [Google Search Central: structured data search gallery, last updated 2026-10-16](https://developers.google.com/search/docs/appearance/structured-data/search-gallery)
- **Proven.** Event results are current but are limited to these region and language pairs: Australia (English), Brazil (Portuguese), Canada (English), **Germany (German)**, India (English), Latin America (Spanish), **Spain (Spanish)**, the United Kingdom (English) and the United States (English). Catalan is not listed. — [Google: Event structured data, last updated 2026-09-08](https://developers.google.com/search/docs/appearance/structured-data/event)
- **Proven.** Required Event properties are `name`, `startDate` and `location` (a `Place` with a `PostalAddress`). Recommended properties are `description`, `endDate`, `eventStatus`, `image`, `location.name`, `offers` (`price`, `priceCurrency`, `availability` = InStock/SoldOut/PreOrder, `validFrom` = when tickets go on sale, and `url`), `organizer` (`name`, `url`), `performer` and `previousStartDate`. Google says to use `price` = `0` for free events. The `eventStatus` values are `EventScheduled` (the default), `EventRescheduled`, `EventPostponed` and `EventCancelled`. When the status changes, keep the original `startDate`. Use `previousStartDate` only with `EventRescheduled`. — [same page](https://developers.google.com/search/docs/appearance/structured-data/event)
- **Proven.** Google's Event policies:
  - Each event needs its own URL, and the page should focus on a single event, not a listing.
  - Don't mark non-events (business hours, coupons, trip packages) as events.
  - Events must be open to the general public; members-only and invitation-only events are not eligible.
  - Virtual-only events are not supported; a physical location is required.
  - Multi-day events give both a start date and an end date.
  - Performances ticketed separately get separate Events.

  The page does not mention `eventAttendanceMode`, `isAccessibleForFree` or `eventSchedule`. — [same page](https://developers.google.com/search/docs/appearance/structured-data/event)
- **Proven.** Local business requires `name` and `address`. Recommended properties include `geo` (at least 5 decimal places), `openingHoursSpecification`, `priceRange`, `telephone` and `url`. On seasonal hours, the page says: "Use both the `validFrom` and `validThrough` properties to define seasonal hours". A closed day sets opens and closes both to 00:00, and hours past midnight use a single entry. Google documents no separate holiday-hours property and says to use the most specific `LocalBusiness` subtype. — [Google: Local business structured data, last updated 2026-09-08](https://developers.google.com/search/docs/appearance/structured-data/local-business)
- **Proven.** schema.org's `specialOpeningHoursSpecification` (on `Place`) holds "The special opening hours of a certain place" and is used to override general hours. This is how the vocabulary expresses special hours for dates like 24 or 31 December. The current release is V30.1 (2026-09-16). — [schema.org/specialOpeningHoursSpecification](https://schema.org/specialOpeningHoursSpecification)
- **Proven.** schema.org's `eventSchedule` "Associates an Event with a Schedule". A `Schedule` carries `repeatFrequency` (an ISO 8601 duration), `byDay`, `byMonthDay`, `startDate`/`endDate`, `startTime`/`endTime`, `scheduleTimezone` and `repeatCount`. Google's Event documentation does not use it. — [schema.org/eventSchedule, V30.1](https://schema.org/eventSchedule)
- **Proven (vocabulary; these pages were not re-fetched in this session).** schema.org defines `Festival` as a subtype of `Event`, `TouristAttraction` as a subtype of `Place`, and `isAccessibleForFree` on `Event`, `Place` and `CreativeWork`. — [schema.org/Festival](https://schema.org/Festival); [schema.org/TouristAttraction](https://schema.org/TouristAttraction); [schema.org/isAccessibleForFree](https://schema.org/isAccessibleForFree)

#### What changed at Google, 2025–2026
- **Reported.** In June 2025, Google phased out seven structured-data features: Book Actions (later partly kept), Course Info, Claim Review, Estimated Salary, Learning Video, Special Announcement and Vehicle Listing. — [EngageCoders summary (date not verified; the primary source is Google's June 2025 post)](https://www.engagecoders.com/google-retires-7-structured-data-features-to-streamline-search-results/)
- **Proven.** On 2025-11-05, Google deprecated practice-problem markup and stated that "Dataset structured data is only used by Dataset Search". On 2026-01-06 it removed the practice-problem documentation. — [Google Search Central: latest documentation updates](https://developers.google.com/search/updates)
- **Proven.** On 2026-05-08, Google posted "Deprecating the FAQ rich result feature". On 2026-06-15 it removed the FAQ documentation because the feature no longer appears in Search. — [same changelog](https://developers.google.com/search/updates)
- **Reported.** FAQ rich results stopped showing on 2026-05-07, including for the government and health sites that had kept them since August 2023. The FAQ report, the search-appearance filter and Rich Results Test support were removed in June 2026, and Search Console API support was due to end in August 2026. Google reportedly said FAQ markup need not be removed. — [Bluehost, 2026](https://www.bluehost.com/blog/google-ends-faq-rich-results/); [SEO Kreativ, 2026](https://www.seo-kreativ.de/en/blog/faq-rich-results-discontinued/)
- **Proven.** Two other relevant 2026 changes:
  - On 2026-03-02, Google said it uses both schema.org markup and `og:image` to choose thumbnails.
  - On 2026-09-18, local-business queries were added to its aggregator and supplier units (region-specific).

  The Event and Speakable documentation did not change between November 2025 and October 2026. — [Google changelog](https://developers.google.com/search/updates)
- **Reported.** John Mueller said "Google is not killing schema" and called the removals routine retirement of little-used features. — [Search Engine Journal (late 2025; exact date not verified)](https://www.searchenginejournal.com/google-is-not-diminishing-the-use-of-structured-data-in-2026/560516/)

#### What AI platforms say about structured data
- **Proven.** Google's AI features page says: "You don't need to create new machine readable files, AI text files, or markup to appear in these features." It adds: "There's also no special schema.org structured data that you need to add." It also asks that structured data match the visible text. — [Google: AI features and your website, last updated 2025-12-10](https://developers.google.com/search/docs/appearance/ai-features)
- **Proven.** Google's guide to generative AI features, published 2026-05-15, says: "Structured data isn't required for generative AI search, and there's no special schema.org markup you need to add". It still recommends markup for rich results. It also says Merchant Center feeds and Google Business Profiles "can help your products and services to be visible in both AI responses and other Google Search results." — [Google: Optimizing your website for generative AI features, last updated 2026-07-10](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)
- **Reported.** Bing's Fabrice Canel said at SMX Munich (March 2025) that schema markup helps Microsoft's LLMs, the ones behind Copilot, understand content. He repeated this on LinkedIn and also recommended IndexNow for freshness. I found no Microsoft write-up of the statement. — [Search Engine Land, March 2025](https://searchengineland.com/microsoft-bing-copilot-use-schema-for-its-llms-453455)

#### Measured evidence on whether AI systems use JSON-LD
- **Proven (measured, with stated limits).** Ahrefs tracked 1,885 pages that added JSON-LD between August 2025 and March 2026, against about 4,000 matched control pages, over 30 days before and after (difference-in-differences). Results:
  - Google AI Overviews citations fell 4.6%. The change was statistically significant but small.
  - AI Mode (+2.4%) and ChatGPT (+2.2%) moved by amounts indistinguishable from zero.

  Limits: every treated page was already heavily cited, schema types were pooled (so there is no Event or LocalBusiness breakdown), the window was 30 days, and only JSON-LD embedded in the HTML was tested. A separate screen of 6 million URLs found that AI-cited pages were about 3 times more likely to have JSON-LD, but the experiment did not show that the markup caused this. — [Ahrefs, 2026-05-11](https://ahrefs.com/blog/schema-ai-citations/)
- **Reported (one test page).** In tests run in October 2025, searchVIU placed 8 prices on one fictional product page, each in a different markup form. No system (ChatGPT, Claude, Gemini, Perplexity or Google AI Mode) extracted the price that existed only in JSON-LD, the price in JavaScript-injected JSON-LD, or the prices in hidden Microdata or RDFa. Prices found out of 8:
  - Gemini: 4
  - ChatGPT: 3
  - Claude: 0
  - AI Mode: 2, only after the page was indexed
  - Perplexity: 1, only after the page was indexed

  Gemini was the only live fetcher that rendered JavaScript. The authors' caveats: one page, small counts, an inconsistently described protocol, and no test of whether markup is used at indexing time. — [searchVIU, October 2025](https://www.searchviu.com/en/schema-markup-and-ai-in-2025-what-chatgpt-claude-perplexity-gemini-really-see/)
- **Reported.** A Mark Williams-Cook test found that ChatGPT and Perplexity read the text inside schema blocks as ordinary page text (they picked up a made-up address placed in schema). This partly conflicts with searchVIU's finding that JSON-LD was ignored. — [Search Engine Roundtable (date not verified)](https://www.seroundtable.com/chatgpt-perplexity-structured-data-text-40862.html)
- **Proven.** Cloudflare's Markdown for Agents conversion keeps a page's JSON-LD and appends it as a fenced `json` block, so agents that fetch the Markdown version through Cloudflare do receive it. — [Cloudflare docs, last updated 2026-10-09](https://developers.cloudflare.com/fundamentals/reference/markdown-for-agents)

### Inferences
- **Speculative.** JSON-LD reaches AI answers mainly through search indexes: Google, whose AI features draw on its index, and Bing/Copilot, which says so. It does not reach them through live fetchers. So every fact in JSON-LD must also appear as visible, server-rendered text, which matches Google's "match visible content" rule.
- **Speculative. Suggested markup for Mercaditos:**
  - **Market page with this season's dates:**
    - Use `Event` (Google documents only `Event`; adding `Festival` is optional). Include `name`, season `startDate`/`endDate`, `location` = `Place` with `name`, `PostalAddress` and `geo` (at least 5 decimals), `eventStatus`, `image`, `description` and `organizer` when known.
    - Add `offers` with `price` 0 and `priceCurrency` EUR, and `isAccessibleForFree`, **only when free entry is evidenced**. This matches the project's "Unknown ≠ free" rule.
  - **Daily hours:** put them in visible text, and optionally in `eventSchedule` (`byDay`, `startTime`/`endTime`, `scheduleTimezone` Europe/Berlin), or as `openingHoursSpecification` with `validFrom`/`validThrough` on the location `Place`, plus `specialOpeningHoursSpecification` for 24, 25 and 31 December. Google uses none of these for Event results, so the visible hours table carries the facts.
  - **Markets whose dates are "not announced"** (the W2 model): emit **no** `Event`, because `startDate` is required and emitting last year's dates would be fabrication. Use `Place`/`TouristAttraction` for the venue instead.
  - **City list pages:** use `BreadcrumbList` only, plus links to the market pages. Google wants Event markup on single-event pages.
  - **Site-wide:** `Organization` and `WebSite`.
  - **Skip:** `FAQPage`, which no longer produces rich results, and `Dataset` unless a downloadable dataset is actually published (see question 4).
- **Speculative. For The Cultural Club:** cultural events change more often than Christmas markets, so `eventStatus` (Cancelled, Postponed, Rescheduled with `previousStartDate`), `offers.availability` (SoldOut) and `offers.validFrom`, `performer` and `organizer` matter more. Catalan-language pages are probably not eligible for Event results, because Google's list has Spanish for Spain but not Catalan. This needs checking.
- **Speculative. Possible language gap for Mercaditos:** the site serves English, German and Spanish with no locale in the URL. Google's Event results are tied to language and region (German for Germany, Spanish for Spain and Latin America). If crawlers only ever see one language at a given URL, the other languages' markup cannot be indexed separately. How next-intl picks the locale for bots needs checking; this overlaps with the crawling and access research.
- **Speculative. Cost:** 0.5–1.5 developer-days to emit JSON-LD from server components using the same database row as the visible HTML. The ongoing cost is keeping the markup in sync with status changes, so generate it and never hand-maintain it.

### Gaps
- I found no primary statement from OpenAI, Perplexity or Anthropic on whether structured data is used for AI answers. Secondary blogs say OpenAI documents structured data only for shopping, but I could not trace that to an OpenAI page; OpenAI's Publishers FAQ returned HTTP 403.
- No study isolates the effect of Event or LocalBusiness markup on AI answers; Ahrefs pooled all types.
- Google does not document whether AI Mode or AI Overviews use Event markup for "what's on this weekend" style answers. This belongs to the local and events research.
- The June 2025 list of retired features and the August 2026 end of FAQ support in the Search Console API come only from secondary sources.

## 2. llms.txt and llms-full.txt: the proposal, who supports it, and measured evidence of use

### Takeaway
llms.txt is a September 2024 proposal for a Markdown index of a site, updated to v2 in August 2026. AI labs and documentation platforms publish it, and Anthropic's docs tell agents to read it. But Google explicitly ignores it for Search. The largest log study (Ahrefs, 137,210 domains, May 2026) found that 97% of published llms.txt files received **zero** requests, and single-site logs mostly show AI crawlers never fetch it. What use exists comes from coding agents (Claude Code) and occasional GPTBot fetches. llms-full.txt is a community convention with no measured consumption.

### Cited Findings
- **Proven.** Jeremy Howard proposed llms.txt, published on 2024-09-03 and now at v2 (modified 2026-08-10). The format:
  - a required H1 naming the site
  - a blockquote summary
  - optional detail text
  - H2 "file lists" of `[name](url): notes` links
  - an "Optional" H2 section of secondary links that agents can skip

  The file can sit at the site root or under any subpath. — [llmstxt.org, modified 2026-08-10](https://llmstxt.org/)
- **Proven.** v2 also defines Markdown companion pages: `page.html.md` or `page.md`, with `index.html.md` or `index.md` for URLs that have no filename. Clients discover them through `rel="alternate" type="text/markdown"` and `rel="describedby"` links, in the HTML or in an HTTP `Link:` header. The page does **not** mention llms-full.txt. — [llmstxt.org](https://llmstxt.org/)
- **Claimed.** llmstxt.org lists adopters: OpenAI, Anthropic and Google Gemini developer docs; Mintlify, GitBook, Yoast SEO, AIOSEO, Wix and Drupal; and VitePress and Docusaurus plugins. It also says Chrome's Lighthouse audits sites for llms.txt as part of agentic-browsing checks. I did not verify the Lighthouse claim. The site names no AI system that reads the file. — [llmstxt.org](https://llmstxt.org/)
- **Proven.** Anthropic's own documentation pages begin with a note to agents: "Fetch the complete documentation index at: https://claude.com/docs/llms.txt. Use this file to discover all available pages before exploring further." This shows Anthropic publishing the file for its docs. It is not a statement that Anthropic's crawlers read other sites' files. — [Claude docs page as fetched 2026-10-22 (page undated)](https://claude.com/docs/connectors/custom/remote-mcp)
- **Proven.** Google's guide says: "You don't need to create new machine readable files, AI text files, markup, or Markdown to appear in Google Search". Such files are fine for other services, but "Google Search ignores them." The 2026-06-15 changelog entry "Clarifying guidance on llms.txt files" says these files "aren't needed for Google Search". — [Google AI optimization guide, last updated 2026-07-10](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide); [Google changelog](https://developers.google.com/search/updates)
- **Proven (measured, with stated limits).** Ahrefs looked at 137,210 domains with Ahrefs Web Analytics traffic in May 2026:
  - 28% published an llms.txt. Ahrefs calls this an upper bound because its customers skew technical.
  - **97% of those files received no requests that month.**
  - Requests to the remaining files were mostly from bots. Ahrefs says 19.5% came from named AI tools, led by GPTBot and Claude-Code.

  The study counted requests, not whether bots used what they fetched. — [Ahrefs, 2026-06-15](https://ahrefs.com/blog/llmstxt-study/)
- **Reported.** Secondary coverage breaks down the Ahrefs requests differently: Search Engine Journal puts AI retrieval bots at about 1.1% of llms.txt requests, which conflicts with Ahrefs' 19.5% for named AI tools. Check the original before quoting a share. — [Search Engine Journal, 2026](https://www.searchenginejournal.com/97-of-llms-txt-files-got-no-requests-ahrefs-data-shows/579478/)
- **Reported (single-site logs; dates not verified).** Three sites logged zero llms.txt fetches by AI crawlers:
  - Prosopo, over 4 days of logs checked against published crawler IP ranges: robots.txt 120 times, sitemap 43 times, llms.txt 0. — [Prosopo](https://prosopo.io/blog/llms-txt/)
  - SaaSLinks, over 14 days across 18 crawler families: robots.txt 723 times, llms.txt 0. — [SaaSLinks](https://saaslinks.net/blog/llms-txt-server-log-study)
  - AWRSHIFT, over 12 days with about 1,000 AI-crawler requests: llms.txt 0. — [AWRSHIFT](https://wp.awrshift.com/llms-txt-in-practice/)
- **Reported (outlier; vendor research).** Across 83 sites over 12 weeks, OpenAI read llms.txt 7 times, Anthropic 9 times and Perplexity 0, while robots.txt was fetched thousands of times. — [EZY.ai (date not verified)](https://www.ezy.ai/research/do-ai-bots-read-llms-txt)
- **Reported.** At GoodBarber, no AI assistant fetched llms.txt on its own over four months. OpenAI's crawlers now reach it through links on GoodBarber's own pages, where they previously found it through third-party directories. — [GoodBarber, 2026-09-22](https://www.goodbarber.com/blog/do-ai-agents-read-markdown-what-two-weeks-of-our-own-server-logs-say-a1622/)

### Inferences
- **Speculative.** Value is low, and so is the cost. A llms.txt generated from the database would have an H1, a one-paragraph summary, one H2 per city linking to market pages (or their `.md` versions), an "as of" date and the season's status. It would take about 2–4 hours. Expected readers are coding agents, developers and occasional OpenAI crawler fetches, not the consumer assistants that answer travellers.
- **Speculative.** Sites about dated events carry an extra risk: a stale llms.txt that still lists last season's dates is worse than none. If built, generate it on each request or with ISR from the live database, never as a committed static file.
- **Speculative.** For a market finder, llms-full.txt is in effect a full data dump (every market with dates, hours, addresses and status). It overlaps with the open-dataset option in question 4. Before publishing a bulk dump, check the licensing of the scraped source data (for example berlin.de).
- **Speculative.** For The Cultural Club, whose events expire, an llms.txt has a short shelf life unless it is regenerated daily. A link to a live feed, API or MCP endpoint ages better than a list of events.

### Gaps
- No OpenAI, Anthropic or Perplexity statement says their production assistants or crawlers read site llms.txt files.
- Nothing measures llms-full.txt consumption, and its origin (thought to be documentation platforms in late 2024) was not verified.
- The claim that Lighthouse audits llms.txt is unverified.
- No llms.txt log study looks at sites about places or events.

## 3. Markdown and plain-text versions of pages, and content negotiation (`Accept: text/markdown`)

### Takeaway
Markdown versions are read by coding agents and by some crawlers. Claude Code, Cursor and OpenCode send `Accept: text/markdown`, and Codex, Gemini CLI, Copilot and Windsurf do not. Crawlers from OpenAI, Amazon and Meta, plus ClaudeBot and Bingbot, follow linked `.md` URLs. But in the one log study from late 2026, the consumer assistants that answer people (ChatGPT, Claude and Perplexity fetching for a user) took HTML more than 13,000 times and Markdown once. Cloudflare converts pages at its edge on paid plans, Vercel documents a do-it-yourself Next.js pattern, and Google says Markdown is unnecessary for Search.

### Cited Findings
- **Proven.** How Cloudflare's Markdown for Agents works:
  - **Request:** a client sends `Accept: text/markdown`, and Cloudflare fetches the origin's HTML and converts it to Markdown at the edge.
  - **Availability:** Pro, Business and Enterprise plans plus SSL for SaaS, at no extra cost. The dashboard instructions mention only Pro or Business.
  - **Output:** YAML frontmatter (title, description and image from meta tags), then the body with navigation, header and footer stripped, then any JSON-LD as a fenced block.
  - **Headers:** `Vary: Accept`. If the origin sets no `Content-Signal`, Cloudflare defaults it to `ai-train=yes, search=yes, ai-input=yes`.
  - **Limits:** HTML only, up to 6 MiB.

  The feature launched around February 2026; the doc's sample response is dated 2026-02-11. — [Cloudflare docs, last updated 2026-10-09](https://developers.cloudflare.com/fundamentals/reference/markdown-for-agents)
- **Proven (documented pattern, not a platform feature).** Vercel's knowledge base recommends content negotiation on the same URL. A `next.config` rewrite sends requests with `Accept: text/markdown` to a Route Handler that returns `text/markdown`, and `curl -H "Accept: text/markdown" https://vercel.com/docs` returns Markdown. It also recommends a `sitemap.md`. It makes no claims about which agents ask for Markdown. — [Vercel KB, "How to serve documentation for agents", published 2026-01-14, updated 2026-01-17](https://vercel.com/kb/guide/how-to-serve-documentation-for-agents)
- **Reported.** A Next.js community discussion asks for built-in, Accept-based Markdown for App Router pages and shares a middleware workaround. Next.js has no native feature for this. — [vercel/next.js Discussion #90579 (date not verified)](https://github.com/vercel/next.js/discussions/90579)
- **Proven (measured snapshot, 2026-02-19).** Checkly had seven coding agents fetch an endpoint that echoes back request headers. Three asked for Markdown:
  - Claude Code v2.1.38: `Accept: text/markdown, text/html, */*`
  - Cursor 2.4.28: `text/markdown,text/html;q=0.9,...`
  - OpenCode 1.2.5: `text/markdown;q=1.0, text/x-markdown;q=0.9, text/plain;q=0.8, text/html;q=0.7, */*;q=0.1`

  Four did not:
  - OpenAI Codex (User-Agent containing `ChatGPT-User/1.0`): HTML Accept header
  - Gemini CLI (User-Agent `GoogleAgent-URLContext`): `*/*`
  - GitHub Copilot: HTML Accept header
  - Windsurf: `*/*`

  Consumer ChatGPT, Claude.ai and Perplexity were not tested. Checkly sells monitoring and measured its own docs. — [Checkly, 2026-02-19](https://www.checklyhq.com/blog/state-of-ai-agent-content-negotation/)
- **Reported (single commercial site, vendor author).** GoodBarber logged requests from 2026-09-04 to 2026-09-18:
  - **Linked `.md` URLs:** about 80,000 requests. Roughly half came from crawlers run by Amazon, Meta and OpenAI, with OpenAI's crawlers finding the `.md` pages through links on the HTML pages. ClaudeBot fetched about 4 `.md` pages per 10 HTML pages. Bingbot requested some. Googlebot requested none.
  - **`Accept` header:** about 22,000 requests, almost all from ShapBot, ExaSearchBot and Claude Code. Claude Code sent the header on almost all of its roughly 1,400 requests and received Markdown 98% of the time.
  - **Assistants answering people:** ChatGPT, Claude on the web and Perplexity fetched HTML more than 13,000 times and Markdown once. ChatGPT-User, Claude-User, Perplexity-User and PerplexityBot never asked for Markdown.
  - Markdown was about 80% smaller than the source HTML.
  - About 900 requests probed for nonexistent `.md` files.

  — [GoodBarber, 2026-09-22](https://www.goodbarber.com/blog/do-ai-agents-read-markdown-what-two-weeks-of-our-own-server-logs-say-a1622/)
- **Proven.** Google says Markdown versions are not needed to appear in Google Search. — [Google AI optimization guide, last updated 2026-07-10](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)

### Inferences
- **Speculative.** As of October 2026, Markdown versions reach developers, coding agents and some AI crawlers, not the people asking ChatGPT, Claude or Perplexity where to go tonight. They are worth building when they come almost free with an API or MCP serializer, not as a reach play in their own right.
- **Speculative. Cost for Mercaditos:** a Route Handler that renders Markdown directly from the database (more reliable than converting HTML), Vercel's rewrite on the `Accept` header, a `.md` URL for each market or city page, and `<link rel="alternate" type="text/markdown">` in the HTML so link-following crawlers find it. About 1–2 developer-days for three locales. Rewriting to a separate path avoids CDN cache mix-ups between HTML and Markdown on the same URL.
- **Speculative. Cloudflare option:** it does not apply directly, because Mercaditos is served by Vercel. It would need Cloudflare proxying on a paid plan. Its default `Content-Signal: ai-train=yes` would also need an explicit decision, which belongs to the crawling and access research.
- **Speculative. Dated events:** the Markdown must carry the same dates, hours and status as the HTML, plus an "as of" timestamp. A version that drifts from the HTML misleads agents and risks looking like cloaking.

### Gaps
- Nothing shows that Markdown versions increase citations or answer accuracy in consumer assistants.
- A Cloudflare Radar figure circulating in secondary coverage (under 0.1% of AI-bot responses served as Markdown in one week of February 2026) could not be traced to a primary source.
- I found no Vercel-native Markdown feature, only the documented pattern.
- Consumer-assistant behaviour may have changed since September 2026.

## 4. Open data feeds and APIs (JSON APIs with OpenAPI descriptions, iCalendar, RSS/Atom, published datasets): do agents use them?

### Takeaway
I found no platform documentation and no measurement showing that consumer AI assistants, on their own, subscribe to a site's iCalendar or RSS feed or call its OpenAPI-described API, as of late 2026. The feed channels into AI answers that platforms do document are their own: Google Merchant Center and Business Profile, and Bing's IndexNow push for freshness. The working route for an API to reach assistants is wrapping it as an MCP server (question 5). The old OpenAPI-manifest route (ChatGPT plugins) closed in 2024. Feeds remain cheap and useful for people and partners.

### Cited Findings
- **Proven.** Google says Merchant Center feeds and Google Business Profiles "can help your products and services to be visible in both AI responses and other Google Search results". It also mentions Business Agent, a conversational brand experience in Search. — [Google AI optimization guide, last updated 2026-07-10](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)
- **Proven.** "Dataset structured data is only used by Dataset Search" (2025-11-05), meaning dataset markup feeds Google Dataset Search, not general results or AI features. — [Google changelog](https://developers.google.com/search/updates)
- **Reported.** Bing's Fabrice Canel recommended IndexNow to push new or updated URLs, because generative AI systems value fresh content. — [Search Engine Land, March 2025](https://searchengineland.com/microsoft-bing-copilot-use-schema-for-its-llms-453455)
- **Reported.** OpenAI stopped new ChatGPT plugin conversations on 2024-03-19 and ended plugins on 2024-04-09. Plugins were defined by `/.well-known/ai-plugin.json` plus an OpenAPI spec. Developers were moved to GPT Actions, which use the same OpenAPI format. — [AIWiki: ChatGPT plugins (date not verified)](https://www.aiwiki.ai/wiki/chatgpt_plugins/raw)
- **Reported (FLAG).** OpenAI reportedly plans to retire custom GPTs and move their workflows into "plugins", announced around September 2026. If so, GPT Actions (OpenAPI) is also on the way out. — [Taskade, 2026](https://www.taskade.com/blog/chatgpt-plugins)
- **Reported (evidence of absence).** Searching turned up third-party wrappers aimed at agents, such as Apify actors with OpenAPI definitions that extract events from public ICS feeds and convert RSS to JSON. Nothing showed ChatGPT or Claude natively subscribing to ICS or RSS. — [Apify ICS extractor OpenAPI](https://apify.com/s3nafps/public-ics-event-calendar-extractor/api/openapi); [Apify RSS feed-to-digest for AI agents](https://apify.com/inn_corp/feed-digest/api/openapi)
- **Reported.** Ticketing data reaches assistants through community MCP servers built on public APIs, such as a Ticketmaster MCP server on Apify. As of July 2026 there was reportedly no official Eventbrite app in ChatGPT and no Eventbrite-run MCP server. — [Apify Ticketmaster MCP](https://apify.com/axlymxp/ticketmaster-mcp-server); [UseCarly, July 2026](https://www.usecarly.com/blog/chatgpt-eventbrite-integration/)
- **Proven.** Claude can attach any public remote MCP server, including one that needs no sign-in or authenticates with a fixed API-key header (the header option is in beta). This is the route by which an existing API reaches Claude users. — [Claude docs: add a connector that isn't in the directory (undated, fetched 2026-10-22)](https://claude.com/docs/connectors/custom/remote-mcp)

### Inferences
- **Speculative. iCalendar (.ics), one feed per market and one per city:** the strongest value for people with dated events (subscribe, or add to calendar). Agents that already have calendar connectors could add events from it, but I found no evidence that any agent ingests site ICS feeds. Cost: 0.5–1 developer-day. Encode `TZID` Europe/Berlin (or Madrid), `STATUS:CANCELLED`, and daily hours as `RRULE` with `EXDATE` exceptions, or as one VEVENT per day.
- **Speculative. RSS/Atom:** about 0.5 day. Useful for "dates announced", "new market added" and "cancelled" updates, which suits November announcement waves. Readers are aggregators and newsletters, not proven AI readers.
- **Speculative. Public JSON API + OpenAPI:** 1–3 days with rate limiting and caching. It is mostly a step toward an MCP server, which can share the same query layer, and partners can use it directly. On its own it reaches no consumer assistant.
- **Speculative. Published dataset (CSV/JSON + `Dataset` markup):** about 0.5 day plus a licensing decision. It reaches Google Dataset Search and possibly open-data catalogues and training corpora. Only worth it if Mercaditos wants to be cited as the reference dataset. Check redistribution rights for scraped official sources first.
- **Speculative. IndexNow:** cheap (hours), and suited to sites whose facts change daily in season. Reaches Bing and Copilot plus other IndexNow engines. Overlaps with the crawling research.

### Gaps
- No measured study of agent consumption of ICS, RSS or OpenAPI on public sites.
- No platform documentation (OpenAI, Anthropic, Google, Perplexity) says assistants ingest arbitrary site feeds.
- The status of GPT Actions after the reported retirement of GPTs is unverified.

## 5. Model Context Protocol (MCP): remote servers for public data, discovery, how assistants let users add them, examples and usage

### Takeaway
MCP is the one agent protocol with broad support in mainstream assistants:
- Claude on every plan (Free allows one custom connector)
- ChatGPT through a reviewed directory, its "apps" renamed "plugins" in July 2026, and through developer mode
- Gemini partly (Enterprise; limited consumer access)
- most developer tools

Ecosystem figures are large: 97 million monthly SDK downloads and 10,000 active servers at December 2025, and about 43,000 registry entries by October 2026. But a small site's server is found manually or through a directory with review and regional limits, `.well-known` discovery is still a draft that keeps moving, and no usage numbers exist for content or events servers. Travel majors (Booking.com, Expedia, Tripadvisor) ship ChatGPT apps. Eventbrite had no official one as of July 2026, and I found only community servers for Ticketmaster.

### Cited Findings

#### The protocol and its scale
- **Reported (the project's own figures; method not stated).** On 2025-12-09, Anthropic announced it was donating MCP to the Agentic AI Foundation, a directed fund under the Linux Foundation. The announcement cited more than 97 million monthly SDK downloads and 10,000 active servers. — [MCP blog, AAIF announcement, 2025-12-09](https://blog.modelcontextprotocol.io/tags/aaif/)
- **Reported (third-party counts; methods differ).** The official MCP Registry (registry.modelcontextprotocol.io) held about 43,298 servers on 2026-10-14, up 36% in 30 days. LocalCan counts 43,012 active servers and says 78% of servers first published in October come with a remote URL. Earlier counts were 30,375 unique servers on 2026-09-10 and about 3,012 in March 2026. Some counts are unique servers, some are server-version records. I found no announcement that the registry is generally available. — [gravity.fast, October 2026](https://gravity.fast/data/mcp-adoption-statistics/); [LocalCan, October 2026](https://www.localcan.com/blog/state-of-mcp-server-development); [DevToolHub, September 2026](https://devtoolhub.com/mcp-registry-by-the-numbers/)

#### Discovery: the registry and .well-known (FLAG: changing)
- **Reported.** SEP-1649 proposed a "Server Card" at a `.well-known` path (first `/.well-known/mcp.json`) so clients can learn a server's capabilities and auth before connecting. SEP-2127, an open pull request, replaced it. It ties into an "AI Card" effort using `/.well-known/ai-catalog.json` for listing a domain's services. — [SEP-1649 issue](https://github.com/modelcontextprotocol/modelcontextprotocol/issues/1649); [SEP-2127 PR](https://github.com/modelcontextprotocol/modelcontextprotocol/pull/2127)
- **Reported.** A tracking issue dated around 2026-09-24 reports that the `.well-known/` prefix was dropped for server cards, which would be served under the server's Streamable HTTP URL, while domain-level discovery moved to the AI Catalog. Blog posts still cite older paths (`/.well-known/mcp/server-card.json`, `/.well-known/mcp.json`). — [panyam/mcpkit issue #531](https://github.com/panyam/mcpkit/issues/531); [bex.co, 2026-07-08](https://bex.co/blog/2026/07/08/mcp-server-cards-well-known-discovery)

#### How assistants let users and developers add servers
- **Proven.** In Claude, a remote MCP server can be added by URL as a custom connector on the Free, Pro, Max, Team and Enterprise plans; **Free allows one**. On Team and Enterprise, an Owner adds it for the organization. Sign-in options are OAuth (Claude's published client identity, automatic registration, or your own client), sign-in when needed, or **no sign-in**. Fixed request-header credentials are in beta. Claude connects from Anthropic's cloud, so the server must be reachable on the public internet over HTTPS (private networks need MCP tunnels). The Connectors Directory lists connectors that are verified by Anthropic or community-built, while custom connectors are unverified. — [Claude docs (undated, fetched 2026-10-22)](https://claude.com/docs/connectors/custom/remote-mcp)
- **Reported.** MCP Apps, the first official MCP extension, was announced 2026-01-26 and built jointly by Anthropic and OpenAI. Tools declare `ui://` resources that the assistant renders in sandboxed iframes, falling back to text where UI isn't supported. Supporting clients include Claude (web and desktop), ChatGPT, VS Code, Goose, Postman and MCPJam. — [The Decoder, January 2026](https://the-decoder.com/mcp-apps-the-model-context-protocols-first-official-extension-turns-ai-responses-into-interactive-interfaces/); [WorkOS, 2026-01-27](https://workos.com/blog/2026-01-27-mcp-apps)
- **Reported.** ChatGPT's Apps SDK, built on MCP, launched at DevDay on 2025-10-06. Its first partners included Booking.com, Expedia, Spotify, Canva, Figma, Zillow and Coursera. Developer submissions opened on 2025-12-17 through the OpenAI Developer Platform, with review, directory metadata and country settings. — [OpenAI: Introducing apps in ChatGPT, 2025-10-06](https://openai.com/index/introducing-apps-in-chatgpt/); [OpenAI: Developers can now submit apps to ChatGPT, 2025-12-17](https://openai.com/index/developers-can-now-submit-apps-to-chatgpt/)
- **Reported (FLAG).** On 2026-07-09, ChatGPT "apps" were renamed "plugins", and the App Directory became a Plugin Directory at chatgpt.com/plugins. Existing app connections reportedly continued to work. OpenAI's help centre refers to a "Plugins Directory", but I did not see OpenAI's release note directly. — [GitHub issue citing OpenAI release notes](https://github.com/dnobj/mail-letter-irl/issues/476); [Wikipedia: ChatGPT](https://en.wikipedia.org/wiki/ChatGPT); [OpenAI Help: Apps in ChatGPT](https://help.openai.com/en/articles/11487775-apps-in-chatgpt)
- **Reported (conflicting; FLAG).** Which ChatGPT plans can add arbitrary MCP servers ("developer mode") differs by source: some say Business and Enterprise/Edu get full MCP support while Pro gets read and fetch only, others say Plus and above. At launch (October 2025), the app directory was **not available in the EEA, Switzerland or the UK**. That matters for Berlin and Barcelona audiences; check current availability. — [UseCarly, 2026](https://www.usecarly.com/blog/chatgpt-mcp/); [Top-MCPs guide, 2026](https://top-mcps.com/guides/how-to-add-mcp-to-chatgpt); [OpenAI, 2025-10-06](https://openai.com/index/introducing-apps-in-chatgpt/)
- **Reported (conflicting; FLAG).** Gemini support varies by product:
  - **Gemini Enterprise and Business:** custom MCP connections over Streamable HTTP on a public HTTPS endpoint, with an admin route Google labels pre-GA.
  - **Consumer Gemini app:** custom "Connected Apps" reportedly limited (tied to "Gemini Spark" tasks; US, 18+, English).
  - **Desktop app:** custom MCP was reportedly in testing on 2026-10-13.
  - **Gemini API:** supports remote MCP.

  — [Progressive Robot, 2026-10-13](https://www.progressiverobot.com/2026/10/13/gemini-desktop-app-mcp-support/); [Progressive Robot, 2026-09-06](https://www.progressiverobot.com/2026/09/06/gemini-business-custom-mcp-server-connections/); [UseCarly: Gemini MCP, 2026](https://www.usecarly.com/blog/gemini-mcp/)

#### Examples in travel, events and content
- **Reported.** In ChatGPT, Booking.com and Expedia launched as apps in October 2025, with bookings completed on the partner's own site. Tripadvisor followed with an app showing reviews, ratings and images. Later lists add Skyscanner and Accor. — [ShortTermRentalz, October 2025](https://shorttermrentalz.com/news/chatgpt-launches-travel-apps-with-expedia-and-booking-com/); [Travel Weekly (2025)](https://www.travelweekly.com/Travel-News/Travel-Technology/Tripadvisor-says-ChatGPT-app-revolutionize-travel-planning)
- **Reported (single sources).** OpenAI reportedly pulled back from handling travel bookings inside ChatGPT in March 2026. Its Instant Checkout feature reportedly shut down in March 2026, while the underlying protocol continues. — [Tourism Tribe, 2026](https://www.tourismtribe.com/chatgpt-instant-checkout-travel-operators/); [ShopAppy, 2026](https://shopappy.com/platforms/headless-commerce/agentic-commerce-protocol-handoff-2027)
- **Reported.** One directory review says no ticketing platform (Ticketmaster, Eventbrite and so on) runs an official MCP server, and only community-built ones exist (review date unclear). Swoogo is reported as the first event-management platform with a native MCP server. — [ChatForest (date not verified)](https://chatforest.com/reviews/event-management-ticketing-mcp-servers/)
- **Reported.** Cloudflare AI Search (formerly AutoRAG) can expose a built-in MCP endpoint with a search tool over a domain onboarded to Cloudflare. Cloudflare's September 2025 "AI Index" announcement promised an automatic AI search index for each domain, with an MCP server, llms.txt and a search API. — [Cloudflare docs: AI Search MCP](https://developers.cloudflare.com/ai-search/how-to/connect-mcp-client/)

### Inferences
- **Speculative. Why MCP matters more for dated events than for evergreen content:** an MCP server answers from the live database ("which markets are open on 24 December after 18:00 near Alexanderplatz?"). Answers built from a search index can be days stale, and in-season facts change daily. For The Cultural Club the same holds, plus sold-out and cancelled states.
- **Speculative. Suggested design:**
  - A read-only, sign-in-free, Streamable HTTP server.
  - Tools: `find_markets(city, date, time?, near?, open_now?, lang)`, `get_market(slug, lang)`, `list_cities()`.
  - Every result returns its canonical URL, so the assistant can cite and link it.
  - Leave out any contact details that the site hides behind login (the existing login gate for contact PII).
  - An MCP Apps map widget is optional.
- **Speculative. Cost:** 2–5 developer-days on Vercel functions, reusing the existing database queries, plus rate limiting and tests. Listing in the official registry takes about an hour. Directory submissions (Claude, ChatGPT) add review time and regional limits. Running costs are function calls and protection against abuse.
- **Speculative. Reach:** realistic users are power users who add a custom connector, developers, and agent builders who aggregate city data. Mass consumers don't add niche connectors unless a directory surfaces them. Treat MCP as "be ready and listed", ranked below getting the facts into server-rendered HTML.
- **Speculative.** Don't hard-code a `.well-known` path for server cards yet; watch SEP-2127 and the AI Catalog.

### Gaps
- I did not research Microsoft Copilot (consumer and Copilot Studio), Perplexity or Mistral Le Chat support for MCP.
- I found no usage numbers for any content, events or tourism MCP server, and no evidence that any city tourism board ships one.
- Current ChatGPT plan and region availability for plugins and developer mode conflicts across sources, and OpenAI's help pages returned HTTP 403.
- It is unclear whether the Claude and ChatGPT directories accept small content publishers, and on what criteria.
- I found no general-availability date for the MCP Registry.

## 6. NLWeb, Agent2Agent (A2A), WebMCP and other browser-side proposals, agents.json, ai-plugin.json, and commerce protocols (ACP, AP2, UCP)

### Takeaway
None of these is a priority for an information site in late 2026.
- **NLWeb** has no public deployment count and no evidence that major assistants query it.
- **A2A** is for enterprise agent-to-agent traffic.
- **WebMCP** is a Chrome origin trial (Chrome 149 to about 156). Consumer agents had not yet adopted it as of May 2026, and Google's own guidance calls it "in active development".
- **ai-plugin.json** died with ChatGPT plugins in April 2024.
- **agents.json** shows no 2026 activity.
- **Commerce protocols** (ACP, AP2, UCP) matter only for a site that sells tickets or bookings. Google does name UCP as the way "Search agents" will do more.

### Cited Findings
- **Reported.** NLWeb was announced at Microsoft Build 2025 and designed by R.V. Guha. Its `/ask` method returns schema.org-typed JSON, and every instance is also an MCP server (`/mcp`). It is MIT-licensed, with about 6.3K GitHub stars and 700 forks as of September 2026. Microsoft named launch partners including **Eventbrite** and **Tripadvisor** (also Chicago Public Media, Allrecipes, Hearst/Delish, O'Reilly, Shopify, Snowflake and Inception Labs); the source does not confirm they run live endpoints. "No public count of NLWeb deployments exists", and there is no evidence that ChatGPT, Claude, Copilot or Gemini query NLWeb endpoints. Cloudflare AI Search offers an "NLWeb Website" quick deploy. — [Presenc AI, updated September 2026](https://presenc.ai/research/nlweb-adoption-2026); [GitHub: nlweb-ai/NLWeb](https://github.com/nlweb-ai/NLWeb)
- **Reported.** A2A, from Google, has been under the Linux Foundation since June 2025. Agents publish an "Agent Card" JSON at `/.well-known/agent-card.json` (some sources say `/.well-known/agent.json`). It reached v1.0 in early 2026 (dates conflict). By April 2026 the Linux Foundation reported 150+ supporting organisations, about 22,000 GitHub stars and 5 official SDKs; the named production users are enterprise vendors (AWS, Microsoft, Salesforce, SAP, ServiceNow). One critical review notes the "150+" includes mere logo placements. — [Stellagent, 2026](https://stellagent.ai/insights/a2a-protocol-google-agent-to-agent); [Tyk, 2026](https://tyk.io/learning-center/a2a-protocol-architecture-and-technical-specification/); [Glukhov, 2026](https://www.glukhov.org/ai-systems/comparisons/a2a-protocol-2026-adoption/)
- **Proven.** Google's web.dev guide recommends "Create WebMCP tools" so agents can call explicit site actions, whether defined in JavaScript or as HTML annotations. It says WebMCP is "in active development and may change" and is available in Chrome through an origin trial. — [web.dev: Build agent-friendly websites, last updated 2026-04-01](https://web.dev/articles/ai-agent-site-ux)
- **Reported (FLAG).** WebMCP timeline:
  - **2026-02-10:** Chrome opened an Early Preview Program with declarative APIs (annotations on HTML forms) and imperative APIs (JavaScript).
  - **2026-05-18:** Chrome for Developers published its documentation.
  - **2026-05-19:** at I/O, Google announced an origin trial starting in Chrome 149, gated by a `tools` Permissions Policy.
  - **Consumers:** Gemini in Chrome support was "coming soon", and Claude for Chrome and Cowork used no website-side tool declarations.

  — [PPC Land, 2026-05-20](https://ppc.land/chrome-149-origin-trial-puts-webmcp-in-developers-hands-at-last/)
- **Reported (FLAG; unverified against Google).** The trial reportedly runs through Chrome 156 and is not on stable. The API moved from `navigator.modelContext` to `document.modelContext` (the old name is deprecated in Chromium 150). Earlier claims that WebMCP "shipped in Chrome 146" are wrong. — [GitHub r0bertini/latch PR #4](https://github.com/r0bertini/latch/pull/4)
- **Reported.** ai-plugin.json was the manifest for ChatGPT plugins, which ended on 2024-04-09. — [AIWiki](https://www.aiwiki.ai/wiki/chatgpt_plugins/raw)
- **Proven.** Google's guide says: "Protocols like Universal Commerce Protocol (UCP) are emerging that will allow Search agents to do more." — [Google AI optimization guide, last updated 2026-07-10](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)
- **Reported (conflicting; FLAG).** UCP is reported live in Google AI Mode and Gemini, with payment-term features added in August 2026. Another source says neither UCP nor ACP has had a release since April 2026 (UCP v2026-04-08, ACP 2026-04-17). — [Scandiweb, 2026](https://scandiweb.com/blog/universal-commerce-protocol/); [ShopAppy, 2026](https://shopappy.com/platforms/headless-commerce/agentic-commerce-protocol-handoff-2027)
- **Reported.** ACP (OpenAI and Stripe) continues, but its main surface, ChatGPT Instant Checkout, reportedly shut down in March 2026. Google donated AP2 (Agent Payments Protocol) to the FIDO Alliance on 2026-04-28, alongside the v0.2 release; AP2 is the payment layer inside UCP. — [ShopAppy, 2026](https://shopappy.com/platforms/headless-commerce/agentic-commerce-protocol-handoff-2027); [Eco, 2026](https://eco.com/support/en/articles/15192002-ap2-protocol-explained-google-s-agentic-commerce-standard-2026)

### Inferences
- **Speculative. WebMCP:** the cheapest experiment is annotating the site's search or filter form ("find markets by city, date, open now") as a declarative tool. That takes hours, plus an origin-trial token. Expected reach in October 2026 is near zero until Gemini in Chrome or another consumer agent calls site tools. Revisit when one ships it.
- **Speculative. NLWeb:** needs a vector index and an LLM call per query, so the running cost is real, and there is no evidence anyone queries it. The quick deploy only works for sites behind Cloudflare. Skip it. A plain MCP server reaches more of the same consumers.
- **Speculative. A2A:** skip. It connects enterprise agents to each other, not information sites to assistants.
- **Speculative. Commerce protocols:** skip for Mercaditos, which sells nothing and whose markets are mostly free. The Cultural Club should watch UCP only if it ever sells tickets directly, and should otherwise link out to sellers.

### Gaps
- I found no 2026 status for agents.json (Wildcard's OpenAPI-based spec).
- I found no WebMCP adoption numbers. Whether Gemini in Chrome calls WebMCP tools as of October 2026 is unconfirmed.
- NLWeb repository activity in 2026 was not checked commit by commit.
- UCP and ACP release status conflicts across sources; ucp.dev and agenticcommerce.dev were not fetched.

## 7. What agentic browsers need from a page (ChatGPT's agent after Atlas, Perplexity Comet, Claude in Chrome, Gemini in Chrome)

### Takeaway
Browser agents read a page through screenshots, the DOM and the accessibility tree. Google's guidance is ordinary accessibility practice:
- semantic `<button>` and `<a>` elements
- labelled inputs
- no transparent overlays
- stable layouts
- WebMCP tools as an option

OpenAI's guidance at Atlas's launch was to use ARIA. The landscape keeps shifting: OpenAI shut down Atlas on 2026-08-09 and moved its agent into the ChatGPT desktop app and a Chrome extension. Claude in Chrome became generally available on paid plans on 2026-08-26, and Gemini in Chrome's "auto browse" reached US paid subscribers on desktop (January 2026) and Android (August 2026). Because several fetchers do not run JavaScript, the facts must be in server-rendered visible text.

### Cited Findings
- **Proven.** Google's web.dev guide describes three ways agents perceive pages: screenshots (slower and more expensive, so a backup), HTML and the DOM, and the accessibility tree ("a high-fidelity map"). Modern agents combine them. Its recommendations:
  - avoid transparent overlays ("ghost elements")
  - prefer `<button>` and `<a>` over styled `<div>` and `<span>`, or give non-semantic elements a role and tabindex
  - link `<label for>` to inputs
  - use `cursor: pointer`
  - make interactive elements visible and larger than 8 square pixels
  - keep layouts consistent across pages
  - create WebMCP tools
  - audit the accessibility tree

  It does not mention structured data, stable URLs or interstitials. — [web.dev, last updated 2026-04-01](https://web.dev/articles/ai-agent-site-ux)
- **Proven.** Google's Search guidance says browser agents "may access your website" and work from screenshots, the DOM and "interpreting the accessibility tree", and that "it's generally a good idea to try to use semantic HTML when possible". — [Google AI optimization guide, last updated 2026-07-10](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)
- **Reported.** At Atlas's launch, OpenAI told site owners that Atlas uses ARIA roles and labels to read page structure and asked for WAI-ARIA best practices. Accessibility consultant Adrian Roselli objected that native semantic HTML should come first and ARIA only as a fallback (an expert opinion). — [Adrian Roselli, October 2025](http://adrianroselli.com/2025/10/openai-aria-and-seo-making-the-web-worse.html)
- **Proven.** OpenAI's help centre says Atlas would stop working on 2026-08-09, with its agentic features moving into ChatGPT (the desktop app and a Chrome extension) and Codex. — [OpenAI Help: Evolving Atlas into ChatGPT for browser-based agentic work (2026)](https://help.openai.com/en/articles/20001371); [9to5Mac, 2026-07-09](https://9to5mac.com/2026/07/09/openai-is-discontinuing-chatgpt-atlas-its-standalone-desktop-browser/)
- **Reported.** Gemini in Chrome "auto browse" launched for US paid subscribers (AI Pro and Ultra) on desktop in late January 2026, with daily limits; it can scroll, click and fill in forms. It reached Android for AI Pro and Ultra users on 2026-08-18. — [9to5Google, 2026-01-28](https://9to5google.com/2026/01/28/chrome-gemini-auto-browse/); [Unite.AI, August 2026](https://www.unite.ai/?p=453888)
- **Reported.** Claude in Chrome became generally available on 2026-08-26 for paid Claude plans (Pro, Max, Team, Enterprise), after a pilot that began in August 2025. — [GIGAZINE, 2026-08-27](https://gigazine.net/gsc_news/en/20260827-claude-chrome-available/)
- **Reported.** In GoodBarber's September 2026 logs, the user-triggered fetchers of ChatGPT, Claude and Perplexity read the HTML a person sees, not Markdown. Keeping that HTML current matters most. — [GoodBarber, 2026-09-22](https://www.goodbarber.com/blog/do-ai-agents-read-markdown-what-two-weeks-of-our-own-server-logs-say-a1622/)
- **Reported.** Of the live fetchers in searchVIU's October 2025 test, only Gemini rendered JavaScript. A price inserted by JavaScript was invisible to ChatGPT and Claude when they fetched the page live. — [searchVIU, October 2025](https://www.searchviu.com/en/schema-markup-and-ai-in-2025-what-chatgpt-claude-perplexity-gemini-really-see/)

### Inferences
- **Speculative. Mercaditos city page:** it is map-first, and a Mapbox canvas is opaque to the accessibility tree and to text extraction. The market list beside it should be server-rendered semantic HTML with:
  - a heading per market
  - the address as text
  - dates and hours in `<time datetime>`
  - a visible status line ("dates not announced", "open today 11:00–21:00", "closed 24 Dec")
  - a plain `<a>` link to a stable URL for each market

  Filters (date, open now, neighbourhood) should be GET URLs (for example `?date=2026-12-24`), so agents and people can share and revisit them.
- **Speculative. Avoid:**
  - consent banners or overlays that cover content before interaction (web.dev's "ghost elements")
  - interstitials and login walls in front of public facts (the login gate for contact details is fine)
  - infinite scroll without URLs
  - controls made of non-semantic elements
- **Speculative. The Cultural Club:** the same rules apply to event lists and calendars, especially date pickers and "load more" controls, which agents struggle with when they are not native elements.

#### Roll-up across all seven questions (my synthesis; costs are Speculative)

| Channel | Who actually consumes it (late 2026) | Evidence | Rough build cost (Next.js + Postgres) | Places and dated events note |
|---|---|---|---|---|
| Server-rendered semantic HTML | Every assistant's fetcher, every crawler, every browser agent | Proven (Google docs) / Reported (logs) | Already exists; audit 1–2 days | Dates, hours and status as visible text in `<time>`; list beside the map |
| JSON-LD (Event, Place, Organization, BreadcrumbList) | Google rich results (Event in 9 region-language pairs, incl. de-DE and es-ES); Bing (says its LLMs use it); live AI fetchers mostly ignore it | Proven / Reported | 0.5–1.5 days | Event only when dates are announced; `eventStatus`; hours via `eventSchedule` or Place hours |
| llms.txt | Coding agents, occasional GPTBot fetches; Google ignores it; 97% of files never requested | Proven (Ahrefs) / Reported | 2–4 hours | Generate from the live database; a stale file is harmful |
| llms-full.txt / bulk dump | Unmeasured | Gap | About 0.5 day + licensing | Overlaps with an open dataset |
| Markdown (.md and `Accept`) | Claude Code, Cursor, OpenCode; crawlers following `.md` links (OpenAI, Amazon, Meta, ClaudeBot, Bingbot); **not** consumer assistants | Proven (Checkly) / Reported (GoodBarber) | 1–2 days | Same facts plus an "as of" stamp |
| iCalendar feeds | People's calendars; no evidence of agents | Gap | 0.5–1 day | `TZID`, `STATUS:CANCELLED`, `EXDATE` |
| RSS/Atom | Aggregators; no evidence of agents | Gap | About 0.5 day | "Dates announced" and "cancelled" items |
| JSON API + OpenAPI | Developers; the base for MCP | Reported | 1–3 days | Date, time and location filters |
| Open dataset + `Dataset` markup | Google Dataset Search only | Proven | About 0.5 day + licensing | Scraped-source rights |
| IndexNow push | Bing/Copilot and other IndexNow engines | Reported | Hours | Daily in-season changes |
| Remote MCP server (+ registry) | Claude on all plans (Free: one), ChatGPT (directory or developer mode, with plan and region limits), Gemini partly, developer tools; no usage data for content servers | Proven (host docs) / Reported | 2–5 days + directory review | Live, date-aware answers; strongest unique value for events |
| MCP Apps UI | Claude, ChatGPT, VS Code and others | Reported | +2–4 days | Map widget in chat (optional) |
| WebMCP | Chrome origin trial only; consumer agents not yet (May 2026) | Proven (web.dev) / Reported | Hours (declarative form) | Search form as a tool; revisit later |
| NLWeb | No evidence of consumers | Reported | High (index + LLM per query) | Skip |
| A2A | Enterprise agents | Reported | n/a | Skip |
| ai-plugin.json / agents.json | Retired (2024) / dormant | Reported / Gap | n/a | Skip |
| ACP, AP2, UCP | Commerce agents (UCP named by Google for Search agents) | Proven (mention) / Reported | High | Only if selling tickets |

### Gaps
- I found no 2026 status or page-perception details for Perplexity Comet.
- How Claude in Chrome perceives pages (accessibility tree vs screenshots) is not confirmed from Anthropic documentation in this research; the sources only say it reads and acts on pages.
- OpenAI's guidance for site owners after Atlas (for the ChatGPT desktop and Chrome-extension agent) was not retrieved; the help centre returned HTTP 403 for the publishers FAQ.
- No measured study links page structure to agents' task success on real sites.
- Publishing facts into third-party knowledge bases (Wikidata, OpenStreetMap, Google Business Profile) was not researched here; it belongs to the citation and authority and the local and events research.
