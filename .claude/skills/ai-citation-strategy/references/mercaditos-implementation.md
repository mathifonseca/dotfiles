# Mercaditos: the worked case

How Mercaditos (mercaditos.app, a Christmas-market finder starting with Berlin) applied the research
in `report.md`. Every line below was checked against the Mercaditos repo
(`~/code/berlinchristmasmarkets`) on 2026-10-25; planning lives in
`.planning/review-2026-10-20/TRACKER.md` (work items W2, W5, W9, W17; decision D3).

## The stack, so another site can map the differences

- Next.js 16 App Router with `cacheComponents` (Partial Prerendering, `"use cache"`), Turbopack.
- next-intl 4 for languages (en, de, es).
- Postgres on Supabase with Drizzle and PostGIS.
- Vercel Hobby. No Cloudflare in front. robots.txt allows everything except `/api/`.
- Umami Cloud for analytics (client-side, so it never sees crawlers).
- Facts gathered by a review pipeline: two readers per market, a word-for-word quote per value,
  and a human OK per market (the `market-facts` skill in the repo).

**One deploy caveat (2026-10-25):** the work below is merged to `main`, but production deploys were
paused (the GitHub ↔ Vercel link moved accounts), and the database migrations for W2 must reach
production first. So the live site may still show the 22 October behaviour that the report observed.

## What the research found on the live site (22 October 2026)

- Unknown paths returned HTTP 200 with a `noindex` tag (soft 404). Next.js streaming cannot change
  the status after `notFound()` is called mid-stream.
- One URL served English, German or Spanish by the `Accept-Language` header, with no `Vary`, so
  crawlers (no such header, US data centres) almost certainly saw English only.
- No canonical, hreflang or JSON-LD on `/berlin`.
- All 95 sitemap entries carried the time the sitemap was generated as `lastmod`, and listed
  locale-prefixed URLs that 307-redirected.
- Requests with Bingbot's and Applebot's user agents got an uncached render of 6.2–6.5 s. The
  likely cause is that Next.js serves "HTML-limited" bots a blocking, non-streamed render that
  skips the cache. This is an inference, still to be confirmed.
- The `/berlin` page was 650 KB, with its Suspense content arriving in six hidden blocks at the end.

## Built

### One address per language (D3, decided 2026-10-22, built 2026-10-24, commit b50fe7f)

- English is unprefixed (`/berlin`). German is `/de/berlin` and Spanish is `/es/berlin`.
- next-intl `localePrefix: "as-needed"`, and its proxy sends hreflang alternates for each page
  (`src/lib/i18n/routing.ts`).
- **No automatic redirect by browser language** (`localeDetection: false`). A visitor whose browser
  prefers another language sees a small fixed bar at the bottom of the page linking to that
  language's address (`src/components/layout/language-suggestion.tsx`).
- The proxy writes no locale cookie (`localeCookie: false`). Only the language switcher writes
  `NEXT_LOCALE`, and only the suggestion bar reads it.
- Old slug aliases keep their `/de` and `/es` prefix when they 301.
- **Why:** crawlers have no language setting, no cookies and no localStorage. With one URL, only
  English is ever indexed or cited. AI Overviews cite German pages for about 90% of German questions
  and Spanish pages for about 83% of Spanish ones. hreflang makes Google treat the versions as one
  page in three languages, not duplicates. A cookie, not localStorage, because the server must
  render the right language in the first HTML.
- **Gotcha (Next.js 16 `cacheComponents`):** next-intl's server `Link` and `usePathname` read
  request data. Inside `"use cache"` functions, or outside `<Suspense>`, they trigger "uncached
  data outside Suspense". The fix was a small `LocaleLink`, which takes the locale as an argument
  (and in the cache key). The switcher reads `window.location` only on click or after mount.

### An honest status model, where "not announced" is a fact (W2, commit c2c1a8f)

- `markets.season_status` is one of `confirmed`, `expected`, `not_announced` or `cancelled`, and
  NULL means not part of this season (`src/lib/constants/season-status.ts`; the database CHECK is
  built from the same list).
- `entry_type` is nullable, so **an unknown fee is never shown as free**. Data checks reject
  "free" without a quote that covers every visitor.
- Provenance on every market: `verified_at`, `source_url`, and `quotes` (one entry per sourced
  fact). A recheck of every source page runs before any production load.
- **Why:** assistants fail mostly by omission and stale dates. A page that says "2026" before the
  organiser confirms will be believed, so "not announced yet" has to be stated, not guessed.

### Hours for each day, with holiday exceptions and unknown days (W5, the "when" engine)

- `src/lib/when/`: each market's hours are worked out per day in Berlin time.
- On the season's holidays (Totensonntag, 24, 25, 26 and 31 December, 1 January) the usual hours
  don't count. Unless a source states that day, its hours are **unknown**, not assumed
  (`src/lib/when/holidays.ts`).
- The city page answers the comparison questions no organiser page answers: open now, today,
  tonight (after 19:00), this weekend, a chosen date, free entry. Filters are GET URLs
  (`?when=`, `?date=`, `?free=1`), so they can be shared and crawled.
- Missing facts are shown as missing ("hours not announced yet"), never filled in.

## Decided, not built yet (W9, decided 2026-10-24)

1. Filter URLs (`?when=`, `?date=`, `?free=`) carry a canonical link to their base page
   (`/berlin`, `/de/berlin`). Only base pages go in the sitemap.
2. The sitemap lists only this season's markets, in all three languages with hreflang. Each
   entry's `lastmod` is the market's "checked on" date, not the time the file was generated.
3. Real 404s for unknown addresses, decided before streaming starts. Markets outside this season
   answer 404 until January.
4. Structured data from facts only: `Event` on each market page with its dates, known hours, place,
   "free" only when confirmed, and its status. `/berlin` lists its markets. Nothing for unknown
   facts.
5. German and Spanish pages keep the same slugs and get titles in their own language
   ("Weihnachtsmärkte in Berlin 2026"), using the stored description translations.
6. `llms.txt` is generated live from the same data (cheap; the evidence says almost nobody reads it).
7. Confirm, then fix, the ~6 s render for HTML-only crawlers (Bingbot, Applebot).

Later: verified bot-hit logging in `proxy.ts`, Bing Webmaster Tools, IndexNow, a prompt panel
measuring mention rate and date accuracy (October baseline, weekly from mid-November), and perhaps
a read-only MCP server.

## W9 build (2026-10-25, branch `feat/w9-seo`, commit 3600fb4; not deployed yet)

Measured first, on a local production build (`next build` + `next start`) with each crawler's user
agent, then on the live site where it could be (production still ran the pre-W5 code).

**What was actually wrong (the findings another Next.js site should check first):**

- **The city page was empty for script-less fetchers.** `/berlin` gave OAI-SearchBot, Claude-User
  and PerplexityBot 269 characters of visible text. Every market name was in the HTML file, but
  only inside the React Server Components payload (`self.__next_f.push(...)` scripts), which a
  fetcher that doesn't run JavaScript never shows. Cause: a client component called
  `useSearchParams()` during the static pre-render (PPR / `cacheComponents`), which makes Next.js
  give up server rendering up to the nearest `<Suspense>`, here the whole page. Bingbot didn't see
  the problem because it gets a different render (next point). Fix: read the query inside its own
  small `<Suspense>` whose fallback is the full page rendered without a query; the visible text
  went from 269 to ~12,500 characters. **Audit lesson: `grep KEY page.html` gave a false PASS,
  because the key was in the script payload; strip `<script>` bodies (and `<div hidden id="S:…">`
  streamed blocks) before searching.**
- **The 6-second crawler path is Next.js, not a slow page.** On production, Bingbot waited 6.3 s
  for the first byte (`x-vercel-cache: BYPASS`), a browser and OAI-SearchBot 0.2–0.3 s (cache
  HIT). Next.js 16 gives every request whose user agent matches its built-in bot list (Googlebot,
  Bingbot, Applebot, Twitterbot, Slackbot, …) a full live render on any pre-rendered (PPR) page,
  and Vercel skips its cache for them. `htmlLimitedBots` in `next.config` does **not** change this:
  `getBotType()` reads the built-in list (it only changes streamed vs blocking metadata). The lever
  is making that live render cheap: cached data ("use cache"), a lighter page, the function in the
  database's region. Locally the new page's bot render takes 0.04–0.19 s; production must be
  re-measured after deploy.
- **Metadata was streamed into `<body>`.** `generateMetadata` that waits on request data
  (`connection()` for an "Open now" label, `await searchParams` for a seller mode) streams the
  `<title>` and canonical link into the body instead of `<head>`, for every visitor except
  Next.js's bot list. Same when a dynamic page's params aren't in `generateStaticParams`: the
  generic shell can't hold param-specific metadata. Fix: metadata reads neither the clock nor the
  query, and every season market is pre-rendered (`generateStaticParams` lists them, 3 languages).
- **Soft 404s.** A page that calls `notFound()` after streaming starts answers 200 + noindex (the
  root layout wrapped every page in `<Suspense>`). A proxy rewrite can't set a status (Next.js 16
  ignores the rewrite's `status`), `dynamicParams` is unavailable with `cacheComponents`, and a page
  that always calls `notFound()` is still pre-rendered as streaming (200). What works:
  `experimental.globalNotFound` + `app/global-not-found.tsx` (a full HTML document; Next.js
  returns it with a real 404 for unmatched routes), and the proxy rewrites unknown addresses to a
  path no route matches (not `/_not-found`: the production server answers that with a 404, but the
  dev server reads it as a `[locale]` value and renders the home page with a 200). The proxy's list of known routes is kept equal to the app's folders by a test.
- **An honesty bug the audit surfaced:** 31 unreviewed markets showed "Free entry" and old scraped
  descriptions ("Open every , offering fresh local produce…") on the season page. Unreviewed rows
  now carry no fee, description or activities; the same rule feeds llms.txt and the JSON-LD.

**Built:**

1. Canonical + hreflang (`en`, `de`, `es`, `x-default`) in `<head>` on the home, city and market
   pages; `?when=`, `?date=`, `?free=` addresses point at the base page.
2. Sitemap: home, live season cities, reviewed markets only; each page in all three languages with
   `xhtml:link` alternates; `lastmod` = the market's checked-on date (city and home: their newest
   market). Nothing out of season gets a date until the data has real ones.
3. Real 404s: unknown cities and markets, a live city's non-season markets (until January), event
   pages while events are off, addresses deeper than any page. Market slugs and old-slug redirects
   come from a per-city index read every minute (it replaced two DB queries on every market
   view); a slug the index doesn't know makes it read the city again (at most every 5 s), so a
   new or renamed market has its page at once; if the index can't be read, the page decides
   (fail open, logged).
4. JSON-LD from facts only: `Event` once dates are confirmed (first and last real day, place,
   organiser, `isAccessibleForFree`/offers only when the fee is known), `EventCancelled` for
   cancelled ones, a bare `Place` while dates are expected or not announced (a "2026" in markup
   before the organiser says it gets believed). `ItemList` on the city page. No LocalBusiness,
   reviews or FAQ on season markets.
5. Titles in each language: "Weihnachtsmärkte in Berlin 2026"; market pages "{name} 2026:
   Termine, Öffnungszeiten, Eintritt" / "fechas, horarios y entrada" / "dates, hours and entry".
6. llms.txt generated live: each market with its page, confirmed dates (or "dates expected, not
   confirmed" / "not announced yet"), fee (never "free" when unknown) and checked-on date.

**How it is guarded:** unit tests for every rule (each proven by planting its defect: an
"expected" market emitted as an Event, an unknown fee as free, the query read without its own
Suspense, a clock read in `generateMetadata`, a new page folder missing from the proxy's list, …),
an integration test of the season query against Postgres, and `tests/crawler-view.spec.ts`, which
fetches pages with an AI fetcher's user agent and asserts on the visible text, `<head>`, status
codes, sitemap and llms.txt. The suite's server is the dev server, which renders everything live
and therefore cannot reproduce the pre-render bail-out, so that one is covered by a unit test
that renders the page to a string while the query read suspends.

**Not done yet:** IndexNow pings, verified bot-hit logging in the proxy, Bing Webmaster Tools, the
prompt panel, the MCP server; the market page itself still shows old data for unreviewed markets
(W6 rebuilds it).
