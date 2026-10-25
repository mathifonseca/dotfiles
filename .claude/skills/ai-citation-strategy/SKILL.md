---
name: ai-citation-strategy
description: How a site becomes the source that AI assistants and agents (ChatGPT, Claude, Perplexity, Gemini, Google AI Overviews and AI Mode, Copilot, Siri) find, read and cite, with the evidence behind each step and the worked case of Mercaditos. Use when asked about AI search visibility, being cited by AI, GEO or AEO, agent readiness or agentready.org, llms.txt, AI crawlers or bots in robots.txt or a CDN, structured data or JSON-LD for AI, an MCP server for a content or events site, measuring AI mentions, citations or referrals, or "what did Mercaditos learn about AI citations". Written for places and dated events (Mercaditos, The Cultural Club) but the rules are generic.
---

# Become the source AI assistants cite

**Status.** The research was done on 2026-10-22 for Mercaditos (W17) and kept generic so The Cultural
Club (TCC) can use it too. The field churns monthly: vendor terms, bot names, ChatGPT's referrer
behaviour and protocol drafts all changed during the research. **Re-verify any number or bot name
before you rely on it**, and cite the source, not this file. Every figure below links to its source
in `references/report.md`.

## The thesis

1. Assistants don't crawl the web afresh per question. They pull candidates from a few search
   indexes (Google, Bing, Brave, their own) and sometimes fetch a page live.
2. Most AI fetchers don't run JavaScript. Only facts that are visible text in the first HTML
   response count.
3. The new layer of "agent" files (llms.txt, Markdown mirrors, GEO rewriting) has little or no
   measured effect. Plain indexing, readable HTML, and complete, current facts do.
4. For places and dated events, assistants fail by **leaving facts out and repeating last year's
   dates**. The site that is right on a given date, in the visitor's language, wins.
5. Measure the mention rate and the accuracy of the dates assistants repeat, not rankings or clicks.

## The seven steps, in order (each is wasted if an earlier one fails)

1. **Reachable.**
   - Admit every operator's search crawler and live fetcher. Set your training policy separately.
   - Keep CDN and firewall rules from challenging verified bots.
   - Get indexed in Google, Bing and Brave.
   - *Evidence:* Ora's controlled test served one site in 19 configurations, 190 probes. Only two
     changes stopped agents from getting the answer: hiding it behind JavaScript, and answering
     agent user agents with a 403.
2. **Readable.**
   - Every fact as visible text in the first HTML, early on the page and outside late-streamed
     blocks.
   - Real 404, 410 and 301 status codes, decided before streaming starts.
   - `rel=canonical`, one crawlable URL per language with hreflang, semantic and labelled controls,
     and filters as shareable GET URLs.
   - *Evidence:* the crawlers of OpenAI, Anthropic, Meta, ByteDance and Perplexity download scripts
     but never run them. In the 2024 log study, AI crawlers hit missing pages on about a third of
     their fetches. Lighthouse says "agents rely on the accessibility tree as their primary data
     model".
3. **The record.**
   - One durable URL per entity, updated each edition, with past editions archived.
   - Each fact carries its year, a "verified on" date, a named source, and a status: announced, not
     announced, cancelled, postponed or ended.
   - Hours for each day, with the exceptions. Comparison pages for questions that span many places.
   - Every language generated from one database.
   - *Evidence:* in 252,000 controlled trials, "explicit price information and a recent timestamp"
     helped consistently, and formatting-only edits had little effect. 44.2% of ChatGPT's citations
     came from the first 30% of a page's text.
4. **Fresh.**
   - `lastmod` set to the real time the content changed.
   - IndexNow on create, update, cancel and remove (it reaches Bing, Yandex, Seznam, Naver, Yep,
     the Internet Archive and Amazon, **not Google**).
   - Request indexing in Search Console.
   - Season pages live weeks ahead, with honest `dateModified` and `eventStatus`.
   - *Evidence:* 75% of cited pages had been updated within a year, but only 42% had been published
     within one. A page on a brand-new domain was still absent from ChatGPT search after 3 days.
5. **Mentioned elsewhere.**
   - Earn mentions where assistants already look: city and tourism listings, local press, YouTube,
     genuine community answers. Give them unique, quotable data.
   - Keep third-party records (Google profiles, OpenStreetMap, Wikidata) correct.
   - Never manufacture mentions.
   - *Evidence:* across about 75,000 brands, YouTube mentions correlated about 0.74 with AI
     visibility and branded web mentions 0.66–0.71, against 0.19–0.24 for backlinks.
6. **Agent options.**
   - JSON-LD generated from the same row as the visible text.
   - Later, a read-only MCP server with no sign-in, returning canonical URLs.
   - llms.txt only if it is generated live.
   - Skip NLWeb, A2A and Markdown mirrors. Watch WebMCP.
   - *Evidence:* Ahrefs compared 1,885 pages that added JSON-LD with about 4,000 controls and found
     no lift in AI citations. 97% of llms.txt files got zero requests in a month.
7. **Measured.**
   - Verified bot logs, AI referrals, Search Console and Bing reports, and a repeated prompt panel
     scored for mentions and date accuracy (see below).

## Which bots to let in

| Assistant | Index behind its answers | Bots to admit for answers | Training-only control |
|---|---|---|---|
| Google AI Overviews, AI Mode | Google Search | Googlebot | None needed; Google-Extended doesn't affect Search |
| Gemini app | Google Search (grounding) | Googlebot, Google's user-triggered fetchers | Google-Extended, **which also ends Gemini-app grounding** |
| ChatGPT | OpenAI's own index plus third parties | OAI-SearchBot, ChatGPT-User | GPTBot |
| Claude | Brave (reported) plus Anthropic's crawler | Claude-SearchBot, Claude-User | ClaudeBot |
| Perplexity | Its own index | PerplexityBot, Perplexity-User | None (says it doesn't train) |
| Copilot | Bing | Bingbot | No token; NOARCHIVE also removes Copilot use |
| Siri, Spotlight | Applebot; new Siri reportedly on Gemini | Applebot | Applebot-Extended |
| Meta AI | Its own index plus Bing and Google (reported) | Meta-WebIndexer, Meta-ExternalFetcher | Meta-ExternalAgent (which also indexes) |

Traps:
- **Cloudflare (from 15 September 2026)** blocks Training and Agent bots by default on ad-showing
  pages of new domains. It treats multi-purpose crawlers (Googlebot, Bingbot, Applebot) under the
  strictest matching rule, so **blocking "Training" can remove the site from Google, Bing and
  Apple**. Check AI Crawl Control first.
- **Vercel** blocks nothing by default, and verified bots skip its Bot Protection. But setting the
  AI Bots ruleset to "Deny" blocks the search crawlers and live fetchers too.
- **Next.js (App Router):** AI crawlers are not on Next's "HTML-limited" bot list, so they get the
  streamed page. Suspense content arrives in hidden blocks at the end, and metadata can land in
  `<body>`. `notFound()` after streaming has started gives a 200 plus noindex, not a 404. Bots that
  *are* on the list (Bingbot, Applebot) get a blocking render, which took 6.2–6.5 s uncached on
  Mercaditos.
- Live fetchers (ChatGPT-User, Perplexity-User) don't reliably obey robots.txt. For a site that
  wants to be cited, that doesn't matter.

## What's worth doing (October 2026)

| Item | Verdict |
|---|---|
| Facts as visible text in server-rendered HTML | Foundation |
| Admitting search crawlers and live fetchers | Foundation |
| Real status codes, canonical URLs, one URL per language | Foundation |
| Accessible, semantic controls (browser agents read the accessibility tree) | Do |
| Honest `lastmod`, IndexNow pings | Do |
| JSON-LD that repeats visible facts | Do, for Search rich results (no AI-citation lift) |
| Read-only remote MCP server | A small bet once the basics hold (Claude lets any plan add one by URL) |
| llms.txt | Optional, and only if generated live |
| Markdown mirrors | Skip unless free (1 Markdown fetch per 13,000 HTML fetches) |
| iCalendar and RSS | For people and partners, not agents |
| WebMCP | Watch (Chrome origin trial) |
| NLWeb, A2A, AI Catalog, agent skills, Content Signals, FAQ markup | Skip |
| ACP, UCP, x402 | Only if selling tickets directly |

GEO rewriting: the famous "up to 40%" is "rejected as a general claim". C-SEO Bench found only 3 of
54 combinations significantly positive. Google says not to chunk pages or write specially for AI.

## Places and dated events

- Google Maps refuses "temporary, one-time events". A free seasonal event sells no tickets and
  rarely has a claimed profile, so assistants fall back on web pages. That's the opening.
- **An aggregator wins on what official pages lack:**
  - completeness across a whole city;
  - comparisons across places ("open on 26 December", "free entry", "open late");
  - hours for each day, with the holiday exceptions;
  - versions in the languages visitors ask in.

  It doesn't win by restating the organiser's page: first-party pages took nearly 60% of citations
  for unbranded factual questions.
- **State negative facts:** "closed on 25 December", "dates not announced yet", "cancelled". A page
  that says "2026" before the organiser confirms will be believed (giving passages newer dates
  moved rerankers by up to 4.78 years), so never guess a date.
- **One durable URL per entity, updated each edition.** Never a new URL each year. Never bump dates
  without real edits.
- Where you disagree with the organiser, say why and link the organiser. Give each fact a source
  and a "verified on" date.
- Documented failures to beat:
  - ChatGPT recommended a Liverpool market for Christmas Eve when it ran one weekend in early
    December.
  - AI repeated a false claim that Germany had cancelled its Christmas markets.
  - AI-made posts sent tourists to a Buckingham Palace market that never existed.
- Tend records you don't own, cheaply: suggest edits on Google profiles (never claim profiles you
  don't run), OpenStreetMap's `xmas:*` tags, Wikidata items for notable entities.

## Language

- The question's language predicts the cited page's language. AI Overviews cited same-language pages
  for 85% of non-English prompts, and ChatGPT for 70%. For German questions it was about 90%
  German pages, and for Spanish about 83% Spanish.
- Googlebot sends no `Accept-Language` header and crawls from the US, and so did every AI crawler
  measured. **One URL that switches language by request header gets indexed in one language
  only.** The fix is one crawlable URL per language, with hreflang.
- An accurate English version of local-language facts fills a gap, because English questions are
  answered from English pages. A local-language version competes head-on with the official
  sources.

## Measuring

| Layer | Question | Tool | Rough cost |
|---|---|---|---|
| 1. Verified bot fetches | Do crawlers and fetchers reach the current pages? | A few lines in the edge proxy writing bot hits to Postgres (`waitUntil`), checked daily against published IP lists. Spoofing is common: 5.7% of claimed AI-crawler traffic was fake | ~$0 |
| 2. AI referrals | Who clicks through, and to which pages? | Umami's "llm" channel, plus `utm_source=chatgpt.com` visits with no referrer. Most ChatGPT clicks have arrived without a referrer since about 9 October 2026 | $0 |
| 3. First-party reports | How often are we shown or cited? | Search Console's Generative AI report (impressions only); Bing Webmaster AI Performance (citations, grounding queries, Citation Share) | $0 |
| 4. Prompt panel | Mention rate, and **date accuracy**, per engine and language | A script on the OpenAI, Anthropic, Gemini and Perplexity APIs, storing raw answers and model versions | ~$50–150 a month in season |
| 5. Consumer-app sample | Do the real apps cite us? | Otterly Lite, in season only | $29 a month |

Panel rules:
- Answers barely repeat: the same brand list came back in under 1 run in 100. Report "mentioned or
  cited in X% of N runs" per engine and language, at site level.
- **Date accuracy is the measure nobody sells.** Extract the dates and hours from each answer and
  compare them with your database.
- Fix the prompts, engines and repeat count before the season, and leave them alone.
- At 270 observations per engine per sweep, a 50% rate has a margin of at least ±6 points.
- Test a tactic on half of a group of comparable pages, with the other half as controls, over 30
  days.
- Compare season with season. Note platform incidents.
- Assistants send only about 0.3–1% of visits. Being cited is the goal, not the clicks.

## Applying this to a new site: the audit

Run these against production. `$S` is the site, and `$KEY` is a fact you know is on the page.

```bash
for ua in "Googlebot/2.1" "bingbot/2.0" "OAI-SearchBot/1.0" "ClaudeBot/1.0" "PerplexityBot/1.0" "Applebot/0.1"; do
  curl -s -o /tmp/p.html -w "$ua %{http_code} %{time_total}s %{size_download}B\n" -A "Mozilla/5.0 (compatible; $ua)" "$S/some-page"
  # Is the fact VISIBLE in the first HTML? Strip scripts and streamed hidden blocks first:
  # a plain grep finds it inside a framework's script payload (Next.js RSC) and passes falsely.
  python3 -c 'import re,sys;s=open("/tmp/p.html").read();s=re.sub(r"<script\b.*?</script>","",s,flags=re.S);s=re.sub(r"<div hidden id=\"S:\d+\">.*?</div>","",s,flags=re.S);print(sys.argv[1] in re.sub(r"<[^>]+>"," ",s))' "$KEY"
done
curl -s -o /dev/null -w "%{http_code}\n" "$S/this-page-does-not-exist"   # must be 404, not 200
curl -s "$S/some-page" | grep -Eo '<link[^>]+(canonical|alternate)[^>]*>'  # canonical + hreflang
curl -s "$S/sitemap.xml" | grep -o '<lastmod>[^<]*' | sort | uniq -c | head  # all the same time = dishonest
curl -s "$S/robots.txt"
curl -s "$S/some-page" | grep -o '<script type="application/ld+json">.*</script>' # facts match the visible text?
curl -sI -H "Accept-Language: de" "$S/" | grep -i -E 'vary|content-language|location'
```

Then check by hand:
- the CDN or firewall bot settings (Cloudflare AI Crawl Control, Vercel AI Bots ruleset);
- the site is verified in Google Search Console and Bing Webmaster Tools;
- the site's pages appear in Brave Search;
- where the key facts sit: in the first 30% of the text, or inside late-streamed blocks?

User-agent tests prove only how the server answers that string, not what the real bot does (real
bots come from published IP ranges).

**Next.js (App Router, PPR / `cacheComponents`) traps, all found on Mercaditos in October 2026**
(details in `references/mercaditos-implementation.md`, "W9 build"):
- `useSearchParams()` in a pre-rendered client component empties the server HTML up to the nearest
  `<Suspense>`: script-less fetchers get a blank page while browsers look fine.
- `generateMetadata` that reads the clock, the query or params that weren't pre-rendered streams
  the `<title>` and canonical into `<body>`.
- `notFound()` after streaming starts is a soft 404 (200 + noindex); use `global-not-found` and
  decide unknown addresses in the proxy.
- Googlebot, Bingbot and Applebot always get a live, uncached render of pre-rendered pages (a
  built-in list `htmlLimitedBots` doesn't change); make that render cheap.
- Test on a production build: the dev server renders everything live and hides the first trap.

**Order to fix in:** blockers and status codes → facts in the first HTML → language URLs and
canonicals → honest `lastmod` and IndexNow → the record's completeness and honesty → JSON-LD →
measurement baseline → mentions → MCP.

## The Cultural Club (Barcelona cultural events)

The same steps apply, on a faster clock:
- **Events expire within days.** Lasting citations go to evergreen hubs ("this weekend in
  Barcelona"), not single events. The crawl metric that matters most is the time from publishing an
  event to its first verified search-bot fetch.
- **Choose a policy for ended events:** keep the page marked "ended", return 410, or redirect. No
  framework or study says what assistants prefer.
- **Ticketed events already reach assistants** through ticketing partners (Ticketmaster and
  SeatGeek apps in ChatGPT). Link the partner's event page, and make sure dates and prices agree.
- **Catalan is not in Google's Event results** (Spain is listed with Spanish only), and no study
  covers Catalan retrieval. Publish Spanish and English versions of each event for search and
  visitors, with Catalan for locals. Each needs its own URL with hreflang.
- **JSON-LD:** `eventStatus` (Cancelled, Postponed, or Rescheduled with `previousStartDate`),
  `offers.availability` (SoldOut), `performer` and `organizer` matter more than for markets.
- **If served through Cloudflare,** check AI Crawl Control first (see the trap above). TCC's
  hosting and CDN were not examined.
- llms.txt goes stale fast for expiring events. A live feed, API or MCP endpoint ages better. An
  MCP server can report cancellations and sold-out events live.
- Measure with a weekly panel all year, in Spanish, English and (to confirm) Catalan.
- Mentions: Barcelona city-council listings and the arts press.
- **Project rule:** Mercaditos and TCC share doctrine and copy-adapted docs, **never runtime code**
  (Python service vs TypeScript/Next.js; expiring events vs durable venues; two owners). Use this
  skill and the Mercaditos case as a pattern, and implement in TCC's own stack.

## Where to look

- `references/report.md`: the full argued report with every source linked. Read it before quoting
  a number.
- `references/notes/`: one research angle per file, with an evidence label on each claim (Proven,
  Reported, Claimed, Speculative):
  - `agentready_frameworks.md`: agentready.org v2.0 compared with Cloudflare's isitagentready,
    is-agentic, Mintlify and Lighthouse Agentic Browsing; what each check is worth.
  - `discovery_crawling_access.md`: indexes behind each assistant, the bot list, robots.txt,
    CDN defaults, JavaScript rendering, Next.js streaming, sitemaps, IndexNow, language crawling;
    the live tests on mercaditos.app.
  - `machine_readable_protocols.md`: schema.org and Event markup, llms.txt, Markdown, MCP, NLWeb,
    WebMCP, A2A, commerce protocols, feeds.
  - `citation_content_authority.md`: what makes a page get cited (relevance, position, freshness,
    mentions vs links); the GEO evidence audit.
  - `local_events_queries.md`: where place and event facts come from (Maps, Yelp, ticketing, web),
    the documented failures, aggregators vs official pages, languages.
  - `measurement_evidence_audit.md`: measurement layers, bot verification, referrer behaviour,
    Search Console and Bing reports, panel design and costs, and the claims audit.
- `references/mercaditos-implementation.md`: the worked case. What Mercaditos found on its own site,
  what it built (language URLs, the "not announced" status, hours for each day), what is decided
  (W9), and the gotchas.
