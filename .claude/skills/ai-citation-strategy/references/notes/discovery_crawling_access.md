# Discovery, crawling and access: how AI assistants find and fetch pages

Research date: 2026-10-22. Every claim carries an evidence label:
**Proven** (the platform's own documentation, its source code, or a measured study or test with a stated method),
**Reported** (industry data or press with known limits), **Claimed** (an assertion without data) or **Speculative**.
"Observed" means my own test against the live mercaditos.app on 2026-10-22, run with `curl` from a developer machine
(Vercel edge `fra1`). Each request carried a bot's published user-agent string but did **not** come from that bot's IP
range. Next.js chooses its rendering path from the user-agent string, so the HTML shown is representative. Firewall
verification may treat the real bots differently. The session's web-search budget ran out near the end of this work,
so a few items below are marked "not re-read" or moved to Gaps.

## 1. Which crawlers, user agents and search indexes feed each assistant? Do they publish IP ranges or verification methods?

### Takeaway
Every major vendor now splits its bots by purpose: a training crawler, a search-index crawler, a fetcher that a user's
question triggers, and, increasingly, a browsing agent. The indexes behind the answers differ. Google's AI Overviews,
AI Mode and the Gemini app use the Google Search index. Copilot uses Bing. ChatGPT uses OpenAI's own index plus
third-party providers. Claude reportedly uses Brave plus its own index. Perplexity, Meta and Apple run their own
crawlers. Everyone except Meta publishes IP lists. OpenAI's agent signs its requests cryptographically, and Google is
testing the same.

### Cited Findings

**Summary map** (sources for each cell are in the bullets that follow)

| Assistant | Training token | Search/index crawler | Live user fetch | Agent / browser | Index behind answers | IP list / verification |
|---|---|---|---|---|---|---|
| ChatGPT | GPTBot | OAI-SearchBot | ChatGPT-User | ChatGPT agent (signed); Atlas browser (Chrome-like UA) | OpenAI's index plus third-party providers; Google results via SerpApi reported in 2025 | 4 JSON lists; Web Bot Auth for the agent |
| Claude | ClaudeBot | Claude-SearchBot | Claude-User | not documented | Brave Search (reported) plus Claude-SearchBot | claude.com/crawling/bots.json |
| Perplexity | none (says no training) | PerplexityBot | Perplexity-User | Comet browser | own index (SerpApi use reported) | 2 JSON lists |
| Gemini app | Google-Extended (token, no UA) | Googlebot | Google-Agent, Gemini Notebook, Gemini Deep Research | Google-Agent (Web Bot Auth trial) | Google Search index for grounding | JSON lists plus reverse DNS |
| AI Overviews / AI Mode | n/a | Googlebot | n/a | n/a | Google Search index (pages that can show a snippet) | Googlebot lists |
| Microsoft Copilot | no separate token (NOARCHIVE meta) | Bingbot | no unique UA (2024 study) | n/a | Bing index; Bing grounding API feeds partners | not re-verified this session |
| Siri / Apple Intelligence | Applebot-Extended (token, no crawling) | Applebot | n/a | n/a | Applebot data for Siri, Spotlight and Safari; next-generation Siri reportedly uses Gemini | applebot.json plus reverse DNS |
| Meta AI | Meta-ExternalAgent | Meta-WebIndexer | Meta-ExternalFetcher | Meta-ExternalFetcher (agentic tasks) | own index; Bing and Google partnerships (reported) | none published on the crawler page |

**OpenAI (ChatGPT search and agent)**
- [Proven] OpenAI lists four agents. **GPTBot** crawls content that "may be used to train" its foundation models. **OAI-SearchBot** surfaces sites in ChatGPT's search features. **ChatGPT-User** visits pages when a user asks ChatGPT or a Custom GPT a question, can be involved in GPT Actions and is "not used for automatic crawling". **OAI-AdsBot** checks ad landing pages and is not used for training. Current tokens: `GPTBot/1.4`, `OAI-SearchBot/1.4`, `ChatGPT-User/1.0`, `OAI-AdsBot/1.0`. The page is undated (fetched 2026-10-22). — [OpenAI bots docs](https://developers.openai.com/api/docs/bots)
- [Proven] The IP lists are published at `openai.com/searchbot.json`, `/gptbot.json`, `/chatgpt-user.json` and `/adsbot.json`. When OpenAI fetches robots.txt it may add a "robots.txt" marker to the user-agent string. Sites that opt out of OAI-SearchBot "can still show up as navigational links". — [OpenAI bots docs](https://developers.openai.com/api/docs/bots)
- [Proven, read through machine-translated copies of the English article] ChatGPT agent signs every outbound request with RFC 9421 HTTP Message Signatures, sending `Signature`, `Signature-Input` and `Signature-Agent: "https://chatgpt.com"`. The public key sits at a well-known endpoint. Sites are told to make sure proxies do not strip those headers. The article date is unknown. — [OpenAI Help 11845367, "ChatGPT agent allowlisting" (translated copy)](https://help.openai.com/bg-bg/articles/11845367-chatgpt-agent-allowlisting)
- [Proven, Vercel's own changelog, 2025-08-12] Vercel verifies the Web Bot Auth signatures of ChatGPT's "operator" feature and lets those requests through Bot Protection. — [Vercel changelog](https://vercel.com/changelog/vercels-bot-verification-now-supports-web-bot-auth)
- [Reported] The Information reported that ChatGPT partly used Google results scraped by SerpApi for current-events queries such as news and sports. SerpApi later removed OpenAI from its customer list, and OpenAI made no statement (2025-08-25). The same article cites an Ahrefs study: 83.39% of the results ChatGPT chose did not appear in Google's results for the same fan-out queries. — [Search Engine Roundtable](https://www.seroundtable.com/chatgpt-serpapi-scrape-google-39989.html)
- [Reported] The ChatGPT Atlas browser presents as ordinary Chrome, with a real Chrome user-agent and TLS fingerprint, so detection based on browser identity misses it (vendor analysis, undated). — [HUMAN Security, Atlas profile](https://www.humansecurity.com/ai-agent/chatgpt-atlas/); [MIT AI Agent Index, 2025](https://aiagentindex.mit.edu/2025/chatgpt-atlas)
- [Reported, single unverified source] Atlas was shut down on 2026-08-09 and its browsing folded into the ChatGPT app. Treat this as unconfirmed. — [Decodo blog](https://decodo.com/blog/chatgpt-atlas-ai-browsers-bypass-detection)

**Anthropic (Claude)**
- [Proven] Anthropic runs three bots. **ClaudeBot** collects content that "could potentially contribute to" training. **Claude-User** fetches pages when a user's question needs them; blocking it "may reduce visibility in user-directed web search". **Claude-SearchBot** crawls "to improve the quality and accuracy of search responses". The article is dated 2026-04-07. — [Claude Help Center](https://support.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler)
- [Proven] The IP ranges are published at `claude.com/crawling/bots.json`. Anthropic warns that blocking IPs "may not reliably opt you out" because it stops the bots from reading robots.txt. — [Claude Help Center, 2026-04-07](https://support.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler)
- [Reported] Claude's web search appears to run on Brave Search. The evidence: Brave was added to Anthropic's subprocessor list, the tool has a `BraveSearchParams` parameter, and at least one search returned identical citations in Claude and Brave. Anthropic has not formally confirmed it in the sources I found (2025-03-21, now 19 months old; flag as possibly outdated). — [TechCrunch](https://techcrunch.com/2025/03/21/anthropic-appears-to-be-using-brave-to-power-web-searches-for-its-claude-chatbot/)

**Perplexity**
- [Proven/Claimed] **PerplexityBot** "is designed to surface and link websites in search results" and is not used to train foundation models. **Perplexity-User** handles user actions, "generally ignores robots.txt rules" and is not used for training. The UA strings are `PerplexityBot/1.0` and `Perplexity-User/1.0`, and the IP lists are `perplexity.com/perplexitybot.json` and `/perplexity-user.json`. The page is undated (fetched 2026-10-22). The training statements are Perplexity's own claims. — [Perplexity docs](https://docs.perplexity.ai/guides/bots)
- [Reported] Perplexity is also reportedly a SerpApi customer, per Glenn Gabe (2025-08-25). — [Search Engine Roundtable](https://www.seroundtable.com/chatgpt-serpapi-scrape-google-39989.html)

**Google (Gemini app, AI Overviews, AI Mode)**
- [Proven] To be a supporting link in AI Overviews or AI Mode, a page must be "indexed and eligible to be shown in Google Search with a snippet". Google states: "There are no additional requirements to appear in AI Overviews or AI Mode, nor other special optimizations necessary", and "You don't need to create new machine readable files, AI text files, or markup". Both features may use "query fan-out" (updated 2025-12-10). — [Google Search Central, AI features](https://developers.google.com/search/docs/appearance/ai-features)
- [Proven, verbatim] Google-Extended is "a standalone product token that web publishers can use to manage whether content Google crawls from their sites may be used for training future generations of Gemini models that power Gemini Apps and Vertex AI API for Gemini and for grounding (providing content from the Google Search index to the model at prompt time to improve factuality and relevancy) in Gemini Apps and Grounding with Google Search on Vertex AI." It "does not impact a site's inclusion in Google Search nor is it used as a ranking signal" and "doesn't have a separate HTTP request user agent string" (updated 2026-10-15). — [Google common crawlers](https://developers.google.com/search/docs/crawling-indexing/google-common-crawlers)
- [Proven] Googlebot's token affects "Google Search (including Discover and all Google Search features)". Google-CloudVertexBot affects only crawls that site owners request for Vertex AI Agents. GoogleOther does not affect any specific product. The IP list is `common-crawlers.json` (updated 2026-10-15). — [Google common crawlers](https://developers.google.com/search/docs/crawling-indexing/google-common-crawlers)
- [Proven] Fetchers that users trigger include **Google-Agent** ("used by agents on Google infrastructure to browse the web and act on user request") and **Google-GeminiNotebook** (formerly `Google-NotebookLM`, supported until August 2026). These "generally ignore robots.txt rules". The IP lists are `user-triggered-fetchers.json`, `user-triggered-fetchers-google.json` and `user-triggered-agents.json` (Google-Agent), with reverse-DNS patterns. Google is "experimenting with the Web Bot Auth protocol" under the identity `https://agent.bot.goog` (updated 2026-08-19). — [Google user-triggered fetchers](https://developers.google.com/search/docs/crawling-indexing/google-user-triggered-fetchers)
- [Proven, Vercel's own directory] Vercel's verified-bot directory lists `gemini-deep-research` (category ai_assistant) and `google-agent` ("used by agents hosted on Google infrastructure such as Project Mariner") (updated 2026-09-10). — [Vercel Bot Management docs](https://vercel.com/docs/bot-management)
- [Proven; from a 2024 study, so possibly outdated] "Gemini uses Googlebot's infrastructure" (2024-12-17). — [Vercel/MERJ, "The rise of the AI crawler"](https://vercel.com/blog/the-rise-of-the-ai-crawler)

**Microsoft Copilot**
- [Reported: SEJ's summary of Bing's official guidelines, which I did not read directly] Bing's rewritten Webmaster Guidelines now cover "Copilot and grounding API results" and treat "grounding results and citations" as outcomes a site can be eligible for. They name "Generative Engine Optimization" as eligibility for grounding and citation in AI answers (2026-02-27). — [Search Engine Journal](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/)
- [Proven; 2024 study] The Vercel/MERJ study left Copilot out because it "lacks a unique user agent", so no separate Copilot crawler could be seen (2024-12-17). Together with Bing's guidelines covering Copilot grounding, this points to Bingbot and the Bing index as Copilot's crawl path (Inference). — [Vercel/MERJ](https://vercel.com/blog/the-rise-of-the-ai-crawler)
- [Reported, from search-result summaries, not re-read] Bing Webmaster Tools' **AI Performance** report (public preview, February 2026) counts citations in Copilot, in Bing's AI summaries and in "select AI partner integrations". The partners are not named. Reports disagree on whether clicks are shown, and one source puts the lag at 48–72 hours. — [Search Influence](https://www.searchinfluence.com/blog/bing-ai-performance-report-copilot-citations/); [Search Engine Land](https://searchengineland.com/bing-webmaster-tools-testing-new-ai-performance-report-468039)

**Apple (Siri, Spotlight, Apple Intelligence)**
- [Proven] Applebot data "helps power search features" in Spotlight, Siri and Safari, and "may" train the foundation models behind Apple Intelligence. **Applebot-Extended** does not crawl; disallowing it opts content out of training, and those pages "can still appear in search results". Verification uses reverse DNS in `*.applebot.apple.com` or the list at `search.developer.apple.com/applebot.json` (published 2026-09-04). — [Apple Support 119829](https://support.apple.com/en-us/119829)
- [Reported, pre-launch reporting from January–February 2026] The next-generation Siri in iOS 26.4 reportedly runs a custom Gemini model on Apple's Private Cloud Compute. The planned "World Knowledge Answers" web search was reportedly scaled back, with Gemini handling web and knowledge queries. My sources did not confirm the shipped behaviour. — [Tom's Guide](https://www.tomsguide.com/ai/apple-intelligence/siri-2-0-could-finally-reach-your-iphone-next-month-with-the-gemini-powered-assistant-due-to-gain-even-more-abilities-at-wwdc-this-summer); [YourStory](https://yourstory.com/ai-story/apple-siri-ai-search-google-gemini-2026); [GoogleWatchBlog, Feb 2026](https://www.googlewatchblog.de/2026/02/apple-stellt-im-februar-eine-neue-siri-version-mit-googles-gemini-vor/)

**Meta AI**
- [Proven] Meta lists five crawlers. **Meta-WebIndexer** improves Meta AI search, and allowing it "helps Meta cite and link to your content". **Meta-ExternalAgent** crawls "to train foundation AI models or to improve products by indexing content directly". **Meta-ExternalFetcher** makes user-requested fetches, including agentic tasks, and "may bypass robots.txt". **Meta-ExternalAds** serves advertising. **facebookexternalhit** builds link previews and may bypass robots.txt for integrity checks. The page publishes no IP ranges and is undated (fetched 2026-10-22). — [Meta for Developers, web crawlers](https://developers.facebook.com/docs/sharing/webmasters/web-crawlers)
- [Reported, from search-result summaries, not re-read] Meta AI got real-time information through a Bing partnership, later joined by Google. In October 2024 The Information reported that Meta was building its own AI search engine "to cut Google, Bing reliance". I found no source saying either partnership has ended. — [Yahoo Finance / The Information](https://finance.yahoo.com/news/meta-develops-own-ai-search-151240545.html?.tsrc=rss); [PinMeTo, 2026](https://www.pinmeto.com/news/meta-webindexer-crawler-meta-ai-search-2026/)

**Other assistants (from Vercel's directory)**
- [Proven, Vercel's verified-bot directory, updated 2026-09-10] **DuckAssistBot** crawls in real time for DuckDuckGo's AI answers and is not used for training. **MistralAI-Index** and **MistralAI-User** build Mistral's search index and fetch pages for answers, also not for training. **Amzn-SearchBot** serves Alexa and Amazon search without collecting training data. **CCBot** (Common Crawl) crawls for AI training and research. — [Vercel Bot Management docs](https://vercel.com/docs/bot-management)

**Volumes and trends**
- [Reported: Cloudflare's measurement over January 1 – December 2, 2025] AI bots made up 4.2% of HTML requests; Googlebot alone made up 4.5%. Of Verified Bot traffic, Googlebot was more than 28%, GPTBot about 7.5% and Bingbot 6%. User-triggered crawling grew more than 15x (key findings) or 21x (body text) over the year; the page does not reconcile the two. ChatGPT-User peaked at up to 16x its January level, OAI-SearchBot at about 5x and PerplexityBot about 3.5x, while ClaudeBot ended about 10% above January. Training remained most AI crawling. — [Cloudflare Radar 2025 Year in Review](https://blog.cloudflare.com/radar-2025-year-in-review/)
- [Proven; 2024 study] Requests over one month on Vercel's network: Googlebot 4.5 billion, GPTBot 569 million, Claude 370 million, AppleBot 314 million, PerplexityBot 24.4 million. All the AI crawlers measured ran from US data centres (2024-12-17). — [Vercel/MERJ](https://vercel.com/blog/the-rise-of-the-ai-crawler)

### Inferences
- To be reachable by all the assistants, a site has to admit at least: Googlebot (AI Overviews, AI Mode, Gemini grounding); Bingbot (Copilot and Bing's grounding partners); OAI-SearchBot and ChatGPT-User; Claude-SearchBot and Claude-User; PerplexityBot and Perplexity-User; Applebot; Meta-WebIndexer and Meta-ExternalFetcher. It also has to be **indexed** in Google and Bing, and, for Claude, reportedly in Brave.
- Several answer engines reportedly fall back on third-party indexes (Bing, Brave, Google via SerpApi). Classic indexing in Google and Bing is therefore still the base layer for every assistant. This is an inference from Reported evidence.
- Agentic browsers such as Atlas and Comet cannot be told apart from humans by user-agent. Any rule that challenges "non-browser-like" traffic, or blocks by IP reputation, can break agents without anyone noticing (Speculative about how big the effect is).

### Gaps
- OpenAI's current official statement on which third-party providers (for example Bing) ChatGPT search uses could not be verified: openai.com and help.openai.com returned HTTP 403 to my fetches.
- I did not research how Brave builds its index or which user-agent it crawls with. Brave matters for Claude if the 2025 report still holds.
- I found no documentation that Claude's browsing agents (such as Claude in Chrome) sign their requests.
- Bing's IP list and verification method were not re-verified this session.
- xAI/Grok, DeepSeek and Mistral Le Chat were not researched beyond the Vercel directory entries.
- I found no source confirming what shipped in iOS 26.4 Siri, or whether Siri's web answers now draw on Google's index.

## 2. How do robots.txt rules map to each use? Can a site allow search and answers while opting out of training? What do the companies say about respecting robots.txt, and where is non-compliance documented?

### Takeaway
A site can opt out of training while staying in answers for OpenAI, Anthropic, Apple and (with care) Meta. For
Google, robots.txt cannot separate AI Overviews and AI Mode from Search. Blocking Google-Extended also removes the
site from **Gemini-app grounding**. Microsoft offers meta tags (NOARCHIVE/NOCACHE) rather than a user-agent token.
OpenAI, Perplexity, Google and Meta say their user-triggered fetchers may ignore robots.txt; Anthropic says all three
of its bots honour it. Documented cases of ignored robots.txt: Perplexity (Cloudflare, 2025, disputed), ChatGPT-User
(TollBit, 2026), and agentic browsers.

### Cited Findings

**Mapping of robots.txt tokens to uses**

| Vendor | Disallow to stop training | Keep allowed for search index | Keep allowed for live answers | Effect of the training opt-out on answers |
|---|---|---|---|---|
| OpenAI | GPTBot | OAI-SearchBot | ChatGPT-User (robots "may not apply") | none documented |
| Anthropic | ClaudeBot | Claude-SearchBot | Claude-User | none documented |
| Perplexity | n/a (says no training) | PerplexityBot | Perplexity-User (generally ignores robots) | n/a |
| Google | Google-Extended | Googlebot | user-triggered fetchers ignore robots | **Removes the site from grounding in Gemini Apps and Vertex AI**; AI Overviews and AI Mode unaffected |
| Apple | Applebot-Extended | Applebot | n/a | none: "can still appear in search results" |
| Meta | Meta-ExternalAgent | Meta-WebIndexer | Meta-ExternalFetcher (may bypass) | unclear, because ExternalAgent also "index[es] content directly" |
| Microsoft | no token; NOARCHIVE meta | Bingbot | n/a | NOARCHIVE also removes the page from Copilot |

- [Proven] OpenAI: disallowing GPTBot signals that content should not be used for training. Opting out of OAI-SearchBot removes a site from ChatGPT search answers. For ChatGPT-User, "robots.txt rules may not apply" because a user started the action. Search systems can take "~24 hours from a site's robots.txt update" to adjust. — [OpenAI bots docs](https://developers.openai.com/api/docs/bots)
- [Proven, as policy] Anthropic's bots "honor 'do not crawl' signals through standard robots.txt directives", support the non-standard Crawl-delay, and "respect anti-circumvention technologies", with no attempt to bypass CAPTCHAs (2026-04-07). Unlike the other vendors, this covers Claude-User. — [Claude Help Center](https://support.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler)
- [Proven] Perplexity recommends allowing PerplexityBot to appear in its results; Perplexity-User "generally ignores robots.txt rules". — [Perplexity docs](https://docs.perplexity.ai/guides/bots)
- [Proven] Google: "robots.txt directives for Googlebot is the control" for AI features in Search. To limit what appears, use `nosnippet`, `data-nosnippet`, `max-snippet` or `noindex`. Google-Extended is pointed to only for "other systems" (2025-12-10). — [Google AI features](https://developers.google.com/search/docs/appearance/ai-features)
- [Reported: secondary coverage of Google's announcement and of a UK regulator order] On 2026-06-03 the UK CMA imposed a conduct requirement. Google responded with a **Search Console toggle** that removes a site from AI Overviews, AI Mode and AI Overviews in Discover. It works per domain for now, starts with a subset of UK sites and is to roll out globally. Opted-out sites get no traffic or impressions from those features, and classic rankings are unaffected. The main obligations take effect on 2026-12-03 and page-level grounding controls by 2027-03-03. — [PPC Land, 2026-06-03](https://ppc.land/google-reacts-to-uk-order-with-a-search-console-ai-opt-out-toggle/); [MediaPost, 2026-06-05](https://www.mediapost.com/publications/article/415549/google-gives-uk-publishers-a-way-to-opt-out-of-a.html)
- [Proven] Apple: Applebot follows rules addressed to it. "If a file doesn't mention Applebot but does mention Googlebot", Applebot follows the Googlebot rules. Applebot does not follow crawl-delay (2026-09-04). — [Apple Support 119829](https://support.apple.com/en-us/119829)
- [Proven] Meta's crawlers can be blocked with Disallow, except that Meta-ExternalFetcher "may bypass robots.txt". Changes can take up to 24 hours because Meta caches robots.txt. — [Meta crawler docs](https://developers.facebook.com/docs/sharing/webmasters/web-crawlers)
- [Reported: SEJ's summary of Bing's guidelines, 2026-02-27] NOARCHIVE "keeps content out of Copilot responses and grounding results". NOCACHE limits Copilot to URL, title and snippet, and Bing advises against it if a site wants richer citations. `data-nosnippet` and NOSNIPPET "may reduce citation quality". A `data-snippet` attribute specifies text that Bing may display or cite. — [Search Engine Journal](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/)
- [Reported: search-result summary of 2023 coverage, not re-read; possibly outdated] Under Bing's 2023 terms, NOARCHIVE content is not used to train Microsoft's generative foundation models. — [Search Engine Roundtable (2023)](https://seroundtable.com/block-bing-chat-ai-36072.html); [Search Engine Journal (2023)](https://www.searchenginejournal.com/microsoft-gives-websites-more-control-over-content-in-bing-chat/496890/)
- [Proven] Google "generally caches the contents of robots.txt file for up to 24 hours". If robots.txt returns 5xx, Google stops crawling the site for the first 12 hours, then uses the last good copy for up to 30 days. Files are limited to 500 KiB (updated 2026-08-31). — [Google robots.txt spec](https://developers.google.com/search/docs/crawling-indexing/robots/robots_txt)

**Documented non-compliance and disputes**
- [Reported: Cloudflare's measurement, disputed] Cloudflare set up new, undiscoverable domains that disallowed all bots in robots.txt and blocked PerplexityBot and Perplexity-User in the firewall. Perplexity still answered questions about the content. The undeclared crawler impersonated Chrome on macOS, used IPs outside Perplexity's published ranges, rotated ASNs, and ignored or skipped robots.txt, at 3–6 million requests a day (the declared crawlers made 20–25 million). Cloudflare removed Perplexity from its verified bots. In the same test, ChatGPT-User fetched robots.txt and stopped when disallowed (2025-08-04). — [Cloudflare blog](https://blog.cloudflare.com/perplexity-is-using-stealth-undeclared-crawlers-to-evade-website-no-crawl-directives/)
- [Claimed] Perplexity replied that Cloudflare had misattributed traffic from BrowserBase, a third-party browser service it says it uses for fewer than 45,000 requests a day, and called the post a "publicity stunt" (August 2025). — [TechRadar](https://www.techradar.com/pro/perplexity-hits-back-after-cloudflare-slams-its-online-scraping-tools)
- [Reported: TollBit's publisher-network data, H1 2026, as summarised by SEJ on 2026-08-14] About 15% of identified AI page fetchers on European sites reached URLs disallowed in robots.txt. ChatGPT-User, Bytespider and Youbot each reached disallowed pages on nearly half of the European sites that named them. Only 9% of European sites disallow Claude-User (26% in North America), and 13% disallow Perplexity-User (26% in North America). TollBit counts any request to a disallowed URL as a bypass. — [Search Engine Journal](https://www.searchenginejournal.com/openai-says-robots-txt-may-not-apply-to-chatgpts-fetch-bot/)
- [Reported: single secondary source, not re-read] OpenAI removed the robots.txt compliance wording for ChatGPT-User from its docs on 2025-12-09. — [Let's Data Science](https://letsdatascience.com/news/openai-says-robotstxt-may-not-apply-to-chatgpts-fetch-bot-4a79669b)
- [Reported: from search-result summaries of TollBit's quarterly reports, not re-read] The share of AI bot scrapes ignoring robots.txt rose from 3.3% to 12.9% in Q1 2025 and was 13.3% in Q2 2025. — [TollBit Q1 2025](https://tollbit.com/bots/25q1); [TollBit Q2 2025](https://tollbit.com/bots/25q2)
- [Reported] Columbia Journalism Review's tests, as relayed by Decodo, found that the Atlas and Comet agentic browsers could retrieve paywalled and crawler-blocked articles. — [Decodo blog](https://decodo.com/blog/chatgpt-atlas-ai-browsers-bypass-detection)
- [Reported: Cloudflare, 2025] AI crawlers (GPTBot, ClaudeBot, CCBot) received the most full-site disallows. Rules for Googlebot and Bingbot were mostly partial. Google-Extended **allow** directives tripled during 2025. — [Cloudflare Radar 2025 Year in Review](https://blog.cloudflare.com/radar-2025-year-in-review/)

### Inferences
- Below is a robots.txt that keeps maximum answer reach while opting out of training (Inference built from the
  vendor docs above). RFC 9309 allows several `User-agent` lines per group. A crawler follows only its most specific
  group, so shared rules such as `Disallow: /api/` must be repeated in each named group.
  ```
  User-agent: *
  Allow: /
  Disallow: /api/

  # Training-only tokens. Disallowing them has no documented effect on search or answers.
  User-agent: GPTBot
  User-agent: ClaudeBot
  User-agent: Applebot-Extended
  User-agent: CCBot
  Disallow: /

  # Do NOT disallow Google-Extended if Gemini-app grounding matters.
  # Meta-ExternalAgent is ambiguous (training "or" indexing); leave it allowed for maximum reach.
  Sitemap: https://example.com/sitemap.xml
  ```
  Mercaditos currently serves `User-Agent: * / Allow: / / Disallow: /api/` plus a Sitemap line (observed 2026-10-22).
  That already gives maximum reach, training included. Adding training opt-outs is a policy choice, not a
  reach issue.
- Opting out of Google-Extended has a hidden cost for a place or event guide. Gemini-app answers that are grounded in
  Google Search would stop using the site, even though AI Overviews and AI Mode would still use it.
- robots.txt is not a dependable gate against live fetchers. They are the bots that create citations, so a site that
  wants to be the source should welcome them, not try to block them.
- At the CDN layer, blocking the "Training" category can remove a site from Google, Bing and Apple entirely. See
  question 5 for Cloudflare's multi-purpose crawler rule.

### Gaps
- OpenAI's current docs do not say whether one crawl is shared between OAI-SearchBot and GPTBot when both are allowed.
- I found no current Microsoft statement on how to opt out of training while staying in Copilot. The NOARCHIVE wording dates from 2023.
- Older documented incidents (for example ClaudeBot's heavy crawling of iFixit in 2024) could not be re-verified after the search budget ran out.
- Whether Brave's crawler honours robots.txt rules aimed at specific AI tokens is unknown.

## 3. Do AI crawlers execute JavaScript? What does that mean for client-rendered content, and what do they see on a server-rendered Next.js site?

### Takeaway
Only Googlebot (so Gemini, AI Overviews and AI Mode) and Applebot are documented to render JavaScript. The last
published log study (Vercel/MERJ, December 2024) found that the crawlers of OpenAI, Anthropic, Meta, ByteDance and
Perplexity download JavaScript files but never execute them. Anything that exists only after client-side rendering,
such as map pins or lists fetched in the browser, is invisible to them. On a Next.js site, server rendering is
necessary but not sufficient. Next.js 16 sends AI crawlers the streaming variant of the page: Suspense content arrives
in hidden blocks at the end of the document, metadata may be streamed into `<body>`, and a not-found page that fires
mid-stream returns HTTP 200 with a noindex tag. My tests on mercaditos.app confirm all three patterns.

### Cited Findings
- [Proven, measured on nextjs.org and the Vercel network, validated on two job-board sites; 2024-12-17, possibly outdated] The study found that "none of the major AI crawlers currently render JavaScript" (OpenAI, Anthropic, Meta, ByteDance, Perplexity). ChatGPT spent 11.50% and Claude 23.84% of their requests on JavaScript files but executed none of them. Gemini, through Googlebot, and AppleBot render JavaScript; CCBot does not. ChatGPT hit 404s on 34.82% of fetches and followed redirects on 14.36%; Claude hit 404s on 34.16%; Googlebot on 8.22%. The recommendation is to server-render main content, metadata and navigation, keep sitemaps current and keep redirects working. — [Vercel/MERJ](https://vercel.com/blog/the-rise-of-the-ai-crawler)
- [Proven] "Applebot may render the content of your website within a browser". If JavaScript, CSS or other resources are blocked by robots.txt, rendering may fail (2026-09-04). — [Apple Support 119829](https://support.apple.com/en-us/119829)
- [Reported] Bing's 2026 guideline rewrite **removed** its JavaScript-rendering guidance (2026-02-27). — [Search Engine Journal](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/)
- [Reported] The Atlas agentic browser is Chromium, so it executes JavaScript like a user's browser. — [HUMAN Security](https://www.humansecurity.com/ai-agent/chatgpt-atlas/)
- [Proven: Next.js source and docs, installed version 16.2.10] Next.js serves blocking, non-streamed metadata in `<head>` only to user agents matching `HTML_LIMITED_BOT_UA_RE`. In 16.2.10 that list includes Google's `*-Google`/`Google-*` crawlers, Bingbot, BingPreview, applebot, DuckDuckBot, facebookexternalhit, Twitterbot, LinkedInBot, Slackbot, Discordbot, WhatsApp, Yeti and a few others. It includes **no AI crawler** (no GPTBot, OAI-SearchBot, ChatGPT-User, ClaudeBot, Claude-*, PerplexityBot, Perplexity-User, meta-externalagent, meta-webindexer, MistralAI or DuckAssistBot). Googlebot alone is classed as a "DOM bot" that executes JavaScript. — [Next.js `html-bots.ts`](https://github.com/vercel/next.js/blob/canary/packages/next/src/shared/lib/router/utils/html-bots.ts) (checked in this repo at `node_modules/next/dist/shared/lib/router/utils/html-bots.js` and `is-bot.js`)
- [Proven: Next.js docs] With streaming metadata, "the resulting metadata tags are appended to the `<body>` tag", which has been "verified … by bots that execute JavaScript … (e.g. Googlebot)". For HTML-limited bots, metadata blocks and lands in `<head>`. `htmlLimitedBots` overrides the list, and `/.*/` disables streaming metadata altogether (added in 15.2.0). — [Next.js generateMetadata, streaming metadata](https://nextjs.org/docs/app/api-reference/functions/generate-metadata#streaming-metadata); [Next.js htmlLimitedBots](https://nextjs.org/docs/app/api-reference/config/next-config-js/htmlLimitedBots)
- [Proven: Next.js docs] When `notFound()` fires mid-stream, "Next.js cannot go back and change the status to 404. Instead, it injects `<meta name="robots" content="noindex">`". A `redirect()` mid-stream "becomes a client-side redirect rather than an HTTP redirect header". — [Next.js streaming guide](https://nextjs.org/docs/app/guides/streaming)
- [Proven, observed 2026-10-22, `https://mercaditos.app/berlin`] The GPTBot, OAI-SearchBot, ClaudeBot, PerplexityBot, Googlebot and Chrome user agents all received the cached prerender (`x-vercel-cache: HIT`, time to first byte 0.18–0.38 s). Each got about 650 KB of HTML with `<title>` inside `<head>`. Six Suspense blocks arrived as `<div hidden id="S:…">` with four `<template id="B:…">` placeholders. The page had no `rel="canonical"`, no `hreflang` and no JSON-LD. — [mercaditos.app/berlin](https://mercaditos.app/berlin)
- [Proven, observed 2026-10-22] The **Bingbot** and **Applebot** user agents, which are on Next's HTML-limited list, received `x-vercel-cache: BYPASS` with a time to first byte of **6.2–6.5 s**. That held on all three Bingbot runs and the one Applebot run. Those responses were about 516 KB with a single hidden Suspense block, consistent with a blocking dynamic render on every request. — [mercaditos.app/berlin](https://mercaditos.app/berlin)
- [Proven, observed 2026-10-22] Unknown URLs return **HTTP 200** with `<meta name="robots" content="noindex">`, under every user agent tested including GPTBot and Bingbot. `/this-city-does-not-exist` is titled "This-city-does-not-exist Markets - Mercaditos". `/berlin/this-market-does-not-exist` is titled "Market Not Found - Mercaditos". `/.well-known/tdmrep.json` returns a 200 HTML page with `<html lang=".well-known">`. — [mercaditos.app](https://mercaditos.app/this-city-does-not-exist)

### Inferences
- What people use visually on place and event pages (maps, filters, calendars) is the least visible part to non-JS AI
  crawlers. Names, addresses, opening dates, hours and status have to be **server-rendered text** in the initial HTML,
  not just map pins or lists fetched in the browser. Ideally they sit early in document order rather than in streamed
  hidden blocks. This follows from the Vercel study, the Next.js docs and the observations.
- It is unknown (**Speculative**) whether AI fetchers keep `hidden` Suspense blocks when they turn HTML into text, or
  read a `<title>` or canonical placed in `<body>`. The safe pattern is to keep primary content and metadata out of
  late-streamed boundaries: static or cached `generateMetadata`, and primary content rendered without Suspense.
- Adding AI user agents to `htmlLimitedBots` would give them in-order HTML. On Mercaditos, though, the HTML-limited
  path is the one that bypasses the cache and takes about 6 s, as observed for Bingbot and Applebot. The better fix is
  to make the HTML-limited path cacheable or fast, then decide. Bingbot (Copilot, plus Bing's grounding partners)
  and Applebot (Siri, Spotlight) already get the slow path today (Inference; cause not confirmed).
- A 200 response with noindex works for Google, which honours noindex. AI fetchers request many URLs that do not exist
  (34% 404s in the 2024 study) and assistants often guess URLs. A 200 page titled "X Markets – Mercaditos" for a
  non-existent city could be taken as real (**Speculative**). Real 404 or 410 codes, and real 301s, need to be decided
  before streaming starts, in `proxy` or middleware or before any Suspense boundary.
- `Disallow: /api/` stops Googlebot and Applebot from loading API calls while they render. Any visible content that
  depends on `/api/` will be missing from their rendered view (Inference from Apple's statement). Non-JS crawlers
  never see it anyway.

### Gaps
- I found no independent 2025–2026 log study that re-tests whether GPTBot, ClaudeBot, PerplexityBot or Meta's crawlers execute JavaScript. The December 2024 Vercel/MERJ study is still the main measured source; later blog posts mostly repeat it.
- No vendor documents page-size or timeout limits for its fetchers. That matters for 650 KB pages.
- No vendor documents whether its AI fetchers honour `<meta name="robots" content="noindex">`.
- I did not confirm the cause of the BYPASS/6 s path for HTML-limited bots in Next 16 with this app's configuration; it is an inference from Next's bot handling.

## 4. How do sitemaps, lastmod, IndexNow and submission through Bing Webmaster Tools or Google Search Console affect freshness? How fast do changes reach each assistant?

### Takeaway
Only Google and Bing document how they use sitemaps. Only the IndexNow group accepts push notifications: Bing,
Yandex, Seznam, Naver, Yep, the Internet Archive and Amazonbot. Google is not in it. No AI company publishes how often
its own index is refreshed. Pages fetched live because of a user's question (ChatGPT-User, Claude-User,
Perplexity-User) are only as current as the page itself. Whether the page is a candidate at all depends on index
freshness, which is measured only in small vendor studies: crawler visits within hours on an established domain, but
days for a brand-new domain to show up in ChatGPT search. robots.txt changes take up to about 24 hours at OpenAI,
Google and Meta.

### Cited Findings
- [Proven] Bing: use ISO 8601 `lastmod` with a time component, reflecting "the true last modification time of the page content", never the sitemap's generation time. `changefreq` and `priority` "are ignored by Bing". Bing fetches a sitemap immediately once it is referenced in robots.txt or submitted in Webmaster Tools, then rechecks "typically at least once per day". IndexNow notifies Bing "instantly" when URLs are added, updated or removed. "No tool can guarantee when or how your content will appear in AI-generated results." AI search engines "adjust ranking and surfacing in near real time based on content changes" (a claim without data) (2025-07-31). — [Bing Webmaster Blog](https://blogs.bing.com/webmaster/July-2025/Keeping-Content-Discoverable-with-Sitemaps-in-AI-Powered-Search)
- [Proven] The official IndexNow participant file lists bing, yandex, seznam, naver, yep, internetarchive and amazonbot. Google is not listed (fetched 2026-10-22). — [indexnow.org searchengines.json](https://www.indexnow.org/searchengines.json)
- [Proven] Google: AI Overviews and AI Mode traffic appears in Search Console's Performance report under the "Web" search type. When a change does not show up, confirm with URL Inspection, then "allow time for recrawling or request it" (2025-12-10). — [Google AI features](https://developers.google.com/search/docs/appearance/ai-features)
- [Proven] robots.txt caching: OpenAI "~24 hours" ([OpenAI bots docs](https://developers.openai.com/api/docs/bots)); Google "up to 24 hours" ([Google robots.txt spec, 2026-08-31](https://developers.google.com/search/docs/crawling-indexing/robots/robots_txt)); Meta "up to 24 hours" ([Meta crawler docs](https://developers.facebook.com/docs/sharing/webmasters/web-crawlers)).
- [Reported: vendor study, one domain, user agents identified by string only, March 2026] Presenc published 300 new pages on its established domain, announced only through a sitemap, and logged crawler visits. First visits: GPTBot after 14 minutes, OAI-SearchBot after 2 h 18 min (13.7% of pages within 24 h), ClaudeBot after 4 h 42 min (2.3%), PerplexityBot after 6 h 11 min (1.7%). All bots together reached 43% of pages within 24 h and 64.7% within 72 h. The study did **not** measure appearance in answers. — [Presenc AI](https://presenc.ai/research/how-fast-ai-crawlers-index-new-pages)
- [Reported: single-site experiments, n=1] A page on a brand-new domain was still not indexed in SearchGPT or Bing after three days. A page on an already-indexed domain was indexed after 48 hours (2024, updated 2025-11). A brand-new domain had zero pages indexed after three days of IndexNow alone (2025-07). — [Metehan Yesilyurt, SearchGPT test](https://metehan.ai/blog/how-to-submit-index-your-page-on-searchgpt-an-experiement-results); [Metehan Yesilyurt, July 2025](https://metehan.ai/blog/what-happens-when-you-launch-a-website-without-google-or-bing-ai-citation-test/)
- [Proven; 2024 study] AI crawlers spent about 34% of fetches on 404s, many of them old `/static/` assets. ChatGPT followed redirects on 14.36% of fetches. Recommendations: "keep sitemaps current" and maintain redirects (2024-12-17). — [Vercel/MERJ](https://vercel.com/blog/the-rise-of-the-ai-crawler)
- [Reported] Bing's AI Performance report shows "grounding queries" and citations, reportedly with a 48–72 h lag (February 2026; not re-read). — [Search Influence](https://www.searchinfluence.com/blog/bing-ai-performance-report-copilot-citations/)
- [Proven, observed 2026-10-22] The Mercaditos sitemap has 95 `<url>` entries. Every `<lastmod>` equals the generation timestamp (`2026-10-22T15:05:14.405Z`), and `changefreq` and `priority` are set. The URLs are locale-prefixed (`/en/berlin`, `/de`) and **307-redirect** to unprefixed paths (`/berlin`, `/`). The sitemap has no hreflang entries. — [mercaditos.app/sitemap.xml](https://mercaditos.app/sitemap.xml)
- [Proven, observed 2026-10-22] The same URL `/berlin` serves English, German or Spanish depending on `Accept-Language` (`x-matched-path` `/en/berlin`, `/de/berlin` or `/es/berlin`, with `<html lang>` en, de or es). `Vary` does not include `Accept-Language`. — [mercaditos.app/berlin](https://mercaditos.app/berlin)
- [Proven] Google: if a site returns different content by location or language on the same URL, "Google might not crawl, index, or rank all your content for different locales". Googlebot sends no `Accept-Language` header and crawls mainly from US IP addresses. Google recommends "separate locale URL configurations and annotating them with rel="alternate" hreflang annotations" (2025-12-10). — [Google locale-adaptive pages](https://developers.google.com/search/docs/specialty/international/locale-adaptive-pages)
- [Proven; 2024 study] All measured AI crawlers ran from US data centres. — [Vercel/MERJ](https://vercel.com/blog/the-rise-of-the-ai-crawler)

### Inferences
- **Dated events and seasonal places need accurate per-URL `lastmod`.** That means the time the event's dates, hours
  or status actually changed, plus an IndexNow ping on create, update, cancel and remove. IndexNow reaches Bing
  (Copilot and Bing's grounding partners) plus Yandex, Seznam, Naver, Yep, Amazon and the Internet Archive. For Google,
  the levers are the sitemap and Search Console's request-indexing. A `lastmod` stamped "now" on every URL, as
  Mercaditos does, goes against Bing's guidance and wastes the signal.
- Sitemaps should list final, canonical 200 URLs. Mercaditos lists URLs that 307-redirect, and in its setup the German
  and Spanish versions have no URL of their own. AI crawlers, like Googlebot, send no `Accept-Language` and crawl
  from US data centres, so they almost certainly only ever see the English version. For a three-language
  Christmas-market guide, separate locale URLs with `hreflang` are the documented fix. This conflicts with the
  project's "no locale in the URL" decision and needs an explicit decision.
- On the evidence available (crawls within hours on an established domain; days for new domains or pages to reach
  ChatGPT search), **season pages should be live, linked and in the sitemap weeks before markets open**. This applies to
  Christmas markets (late November) and to Barcelona events announced weeks ahead (Inference from Reported data).
- Live fetchers read the current page. When an event is cancelled or rescheduled, the page itself must say so in
  server-rendered text, because that is what ChatGPT-User, Claude-User and Perplexity-User will read.

### Gaps
- No AI vendor (OpenAI, Anthropic, Perplexity, Meta, Apple) documents how often its index is refreshed, or whether it reads sitemaps or `lastmod`.
- I found no controlled, multi-site study of time from publishing to first citation in each assistant.
- Whether ChatGPT benefits from IndexNow (for example indirectly through Bing) is undocumented and Speculative.
- Google's generative-AI reporting in Search Console (2026) belongs to the measurement researcher and was not examined here.

## 5. Infrastructure: Cloudflare's AI-bot defaults, pay-per-crawl, Web Bot Auth and signed agents, Vercel bot protection and firewall defaults, rate limiting. What should a small Vercel site check?

### Takeaway
Cloudflare is where a site most easily blocks AI without noticing. From 2025-07-01, new domains were asked about or
defaulted to blocking AI crawlers. From **2026-09-15**, new domains block **Training and Agent** bots by default on
pages that show ads, while Search stays allowed. Multi-purpose crawlers (Googlebot, Bingbot, Applebot) are blocked
wherever Training is blocked. Vercel blocks nothing by default: its Bot Protection and AI Bots rulesets are both off,
and verified bots, which include most AI search crawlers and live fetchers, skip Bot Protection and Attack Mode. But
setting the AI Bots ruleset to "Deny" blocks search crawlers and live fetchers too. Web Bot Auth (RFC 9421 signatures)
is how agents are starting to prove identity: OpenAI uses it, Google is testing it, and Vercel and Cloudflare verify
it. Mercaditos runs on Vercel DNS with no Cloudflare in front.

### Cited Findings
**Cloudflare**
- [Proven, Cloudflare] On 2025-07-01 Cloudflare announced it was "changing the default to block AI crawlers unless they pay creators for their content". It claimed that getting traffic is now about 750 times harder with OpenAI and about 30,000 times harder with Anthropic than with the Google of a decade ago (Claimed figures). — [Cloudflare blog, 2025-07-01](https://blog.cloudflare.com/content-independence-day-no-ai-crawl-without-compensation/)
- [Reported] Every new domain signing up to Cloudflare was asked whether to allow AI crawlers. — [CNBC via NBC](https://www.nbcnewyork.com/news/business/money-report/web-giant-cloudflare-to-block-ai-bots-from-scraping-content-by-default/6321598/)
- [Proven, Cloudflare, 2026-07-01, modified 2026-07-15] Bots are now classified by purpose: **Search** (indexes so it can answer later), **Agent** (acts for a person in real time, "e.g. ChatGPT-User and browser-use agents") and **Training**. From 2026-09-15, **new domains** have Training and Agent "blocked by default on pages that display ads", with Search allowed. Multi-purpose crawlers are handled under the most restrictive matching rule: "multi-purpose crawlers such as Googlebot, Applebot, and BingBot" are blocked for customers who block Training. "Verified" no longer means allowed by default. Content-use levels are `immediate`, `reference` (default) and `full`. A `Forwarded` header "transitive trust" scheme is experimental. Customers could opt out before 2026-09-15. — [Cloudflare blog, "Content Independence Day: AI options"](https://blog.cloudflare.com/content-independence-day-ai-options/)
- [Reported, conflicting on scope] Help Net Security says the controls are open to all customers including Free and that customers would be notified first. Other coverage says the defaults also reach existing Free zones and new sites on existing accounts. — [Help Net Security, 2026-07-02](https://www.helpnetsecurity.com/2026/07/02/cloudflare-ai-crawler-controls/); [Let's Data Science](https://letsdatascience.com/news/cloudflare-blocks-mixed-use-crawlers-on-monetized-pages-5a9acadb)
- [Proven] Cloudflare's docs list three AI behaviours that all customers can manage (Search, Agent, Training), and a bot can have more than one (updated 2026-07-01). — [Cloudflare docs, bot concepts](https://developers.cloudflare.com/bots/concepts/bot/#ai-bots)
- [Proven] Pay per crawl is still in **closed beta**. A crawler either presents payment intent and gets HTTP 200, or gets **HTTP 402 Payment Required** with the price. Cloudflare is the merchant of record, and WAF or Bot Management blocks override it (updated 2026-07-28). — [Cloudflare docs, pay per crawl](https://developers.cloudflare.com/ai-crawl-control/features/pay-per-crawl/what-is-pay-per-crawl/)
- [Proven] After the Perplexity case, Cloudflare added the stealth-crawler signatures to its managed AI-crawling block rule, "available to all customers, including free ones" (2025-08-04). — [Cloudflare blog](https://blog.cloudflare.com/perplexity-is-using-stealth-undeclared-crawlers-to-evade-website-no-crawl-directives/)
- [Proven] Cloudflare's managed robots.txt is enabled on more than 3.8 million domains and adds `Content-Signal: search=yes, ai-train=no` by default (2025-09-24). — [Cloudflare blog, Content Signals](https://blog.cloudflare.com/content-signals-policy/)

**Vercel**
- [Proven] The **Bot Protection** managed ruleset is "inactive by default", labelled Off. When enabled it challenges non-browser traffic with a JavaScript challenge and "automatically excludes verified bots". It does not work when a reverse proxy such as Cloudflare sits in front of Vercel. The **AI Bots** managed ruleset is also "inactive by default", labelled Allow, and can log or deny. It covers "AI bots that crawl your site for training data, search purposes, or user-generated fetches", and Vercel adds new bots to it automatically (updated 2026-09-10). — [Vercel Bot Management docs](https://vercel.com/docs/bot-management)
- [Proven] Vercel keeps a verified-bot directory. "Attack Mode and bot protection automatically recognize and allow these bots". Bots are verified by IP, reverse DNS and Web Bot Auth. WAF custom rules can block by User-Agent or by `Signature-Agent` header. Rate limiting is configured through WAF custom rules. The directory includes chatgpt-user, chatgpt-operator, gpt-actions, oai-searchbot, gptbot, claude-user, claude-searchbot, claudebot, perplexity-user, perplexitybot, meta-webindexer, meta-externalagent, meta-externalfetcher, google-agent, gemini-deep-research, mistralai-user, mistralai-index, duckassistbot, amzn-searchbot, bingbot, googlebot and applebot (updated 2026-09-10). — [Vercel Bot Management docs](https://vercel.com/docs/bot-management)
- [Proven] Signed verified bots pass Bot Protection and Challenge Mode, and spoofed ones are blocked (2025-08-12). — [Vercel changelog](https://vercel.com/changelog/vercels-bot-verification-now-supports-web-bot-auth)

**Web Bot Auth status**
- [Proven] The IETF webbotauth working group has one adopted document, `draft-ietf-webbotauth-httpsig-protocol-00` (2026-09-01). Related individual drafts include a key registry, hosted directories, anonymous Web Bot Auth, and two new Illyes drafts dated 2026-10-22. It is not an RFC (fetched 2026-10-22). — [IETF Datatracker, webbotauth](https://datatracker.ietf.org/wg/webbotauth/documents/)
- [Proven] OpenAI's ChatGPT agent signs its requests ([OpenAI Help, translated copy](https://help.openai.com/bg-bg/articles/11845367-chatgpt-agent-allowlisting)). Google is testing Web Bot Auth for Google-Agent ([Google user-triggered fetchers, 2026-08-19](https://developers.google.com/search/docs/crawling-indexing/google-user-triggered-fetchers)). Perplexity's bot page mentions no signatures and relies on UA plus IP ([Perplexity docs](https://docs.perplexity.ai/guides/bots)).

**Observed setup (Mercaditos, 2026-10-22)**
- [Proven, observed] Nameservers are `ns1/ns2.vercel-dns.com` and the response header is `server: Vercel`, so there is no Cloudflare proxy and Cloudflare's defaults do not apply. robots.txt allows everything except `/api/`. Every tested bot user agent got HTTP 200 for `/berlin`. These requests came from a non-bot IP, so they do not exercise Vercel's verified-bot logic. — [mercaditos.app/robots.txt](https://mercaditos.app/robots.txt)

### Inferences
**Checklist so a small Vercel site does not silently block AI fetchers** (Inference, assembled from the sources above):
1. **Vercel Firewall → managed rulesets.** Leave AI Bots on Allow or Log, never **Deny**: Deny also blocks OAI-SearchBot, Claude-SearchBot, PerplexityBot and the live fetchers. If Bot Protection is on, keep the default verified-bot exclusion. Remember that its JavaScript challenge cannot be passed by crawlers that do not run JavaScript.
2. **Custom WAF rules and rate limits.** Exclude verified bots, or at least the AI search and live-fetch user agents, from challenge, deny and rate-limit rules. A rate limit tuned for humans can throttle a crawler fetching many pages, such as all the markets of one city.
3. **Attack Mode** lets verified bots through but challenges unidentified agents such as Atlas or Comet-style browsers. Treat it as an emergency switch to turn back off.
4. **If a CDN or proxy sits in front** (relevant to The Cultural Club if it uses Cloudflare): check AI Crawl Control's Search, Agent and Training settings. Make sure Training is not blocked unless you accept losing Googlebot, Bingbot and Applebot. Make sure Agent is allowed on pages that show ads. Check what managed robots.txt serves, and remember Vercel's Bot Protection degrades behind a proxy.
5. **Check the robots.txt actually served** (`curl https://site/robots.txt`), not the one in the repo, because CDN-managed robots.txt can rewrite it.
6. **Verify with logs**: match hits against the published IP lists (OpenAI, Anthropic, Perplexity, Google, Apple) and look for 403, 429 or challenge responses to AI user agents in Vercel's firewall and observability views.
7. **Status codes and speed** (from question 3): real 404 and 301 codes before streaming starts, and no 6 s cache-bypass path for HTML-limited bots.
8. **Do not strip `Signature`, `Signature-Input` or `Signature-Agent` headers** in middleware or proxies, so signed agents can still be verified.

For events sites, Cloudflare's new "Agent blocked on ad pages" default specifically removes the live-fetch path
(ChatGPT-User and similar) that answers questions like "what's on in Barcelona tonight". A site that shows ads and
joined Cloudflare after 2026-09-15 should check this first.

### Gaps
- I found no documentation of how Vercel's automatic DDoS mitigation treats bursts from crawlers.
- It is not documented whether Vercel's AI Bots ruleset includes Applebot, which Vercel's directory classes as ai_crawler. Blocking it would also remove the site from Siri and Spotlight search.
- The exact Disallow lines that Cloudflare's managed robots.txt adds for AI training bots, and how Bot Fight Mode interacts with AI crawlers, were not researched.
- Whether Cloudflare's 2026-09-15 defaults reach existing Free zones is reported inconsistently.
- Whether Anthropic, Perplexity or Meta plan to adopt Web Bot Auth is undocumented.

## 6. Content-use signals: Cloudflare Content Signals, IETF AI Preferences (aipref), TDMRep, licensing headers. What is their status, and does any assistant honour them?

### Takeaway
None of the new content-use signals is a finished standard with a public commitment from any assistant. Cloudflare's
Content Signals reach millions of domains through managed robots.txt, but Cloudflare itself says they are preferences
AI companies may ignore. The IETF aipref vocabulary (-08) and attach (-05) drafts are still working-group drafts past
their August 2026 target. TDMRep is a W3C Community Group spec relevant to the EU text-and-data-mining opt-out, with no
evidence that AI crawlers read it. RSL 1.0 has publisher and infrastructure backing but no confirmed AI-company
adoption. What assistants do honour today: robots.txt product tokens, Google's snippet controls, Bing's NOARCHIVE,
NOCACHE and data-snippet, and, as it rolls out, Google's Search Console AI opt-out.

### Cited Findings
- [Proven] Cloudflare's Content Signals Policy (2025-09-24) defines three signals. `search` covers building an index and showing links and short excerpts, excluding "AI-generated search summaries". `ai-input` covers RAG and grounding. `ai-train` covers training and fine-tuning. Each is yes or no; leaving one out expresses no preference. The syntax is `Content-Signal: search=yes, ai-train=no` in robots.txt. Cloudflare frames restrictions as "express reservations of rights under Article 4" of EU Directive 2019/790. It names **no** AI company that has agreed to honour the signals and acknowledges "some companies might simply ignore them". — [Cloudflare blog](https://blog.cloudflare.com/content-signals-policy/)
- [Proven] In 2026 Cloudflare added `use=reference` style levels and says "robots.txt signals are preferences, not enforced blocks" (2026-07-01). — [Cloudflare blog](https://blog.cloudflare.com/content-independence-day-ai-options/)
- [Proven] IETF aipref: `draft-ietf-aipref-vocab-08` (2026-09-13) and `draft-ietf-aipref-attach-05` (2026-08-18) are working-group documents aimed at Proposed Standard, with a milestone of August 2026. Datatracker shows no IESG state, so they are not yet RFCs (fetched 2026-10-22). A search snippet saying attach "expired at -04" is outdated. — [IETF Datatracker, aipref](https://datatracker.ietf.org/wg/aipref/documents/)
- [Reported: law-firm commentary on the EU GPAI Code of Practice, July 2025] The Code's copyright chapter asks signatories to honour robots.txt and "other appropriate machine-readable protocols" for text-and-data-mining opt-outs, and to publish information about their crawlers. — [Taylor Wessing, 2025-07-11](https://www.taylorwessing.com/en/insights-and-events/insights/2025/07/update-ai-act); [Paul Weiss](https://www.paulweiss.com/insights/client-memos/eu-commission-publishes-its-code-of-practice-for-general-purpose-ai-what-you-need-to-know)
- [Reported] Meta publicly declined to sign the Code. — [CASRAI guide](https://casrai.org/guides/eu-ai-act-gpai-code-of-practice)
- [Reported] The European Commission consulted on rights-reservation protocols, including TDMRep, with a deadline of 2026-01-09. — [STM](https://stm-assoc.org/eu-commission-seeks-views-on-protocols-for-tdm-rights-reservation-expression/)
- [Reported: search-result summary of secondary legal blogs, not re-read] Germany's Hamburg court of appeal (OLG Hamburg, December 2025) is described as holding that natural-language opt-outs are not enough and must be machine-readable, such as robots.txt or TDMRep. In December 2025 a US court reportedly treated robots.txt as a preference rather than an enforceable access control. — [Xictron](https://www.xictron.com/en/blog/ai-crawler-control-tdm-opt-out-2026/); [Blck Alpaca](https://blckalpaca.at/en/knowledge-base/seo-geo/technical-seo/robotstxt-and-ai-eu-legal-situation-and-tdm-opt-out)
- [Reported] RSL ("Really Simple Licensing") reached 1.0 in December 2025 with more than 1,500 media organisations and Cloudflare, Akamai, Creative Commons and IAB Tech Lab behind it. It extends robots.txt with licence terms: free with attribution, pay per crawl, pay per inference, or subscription. AI-company compliance remains open. — [Media Copilot](https://mediacopilot.ai/rsl-licensing-standard-hits-1-0-gains-support-from-1500-publishers/); [TechTarget](https://www.techtarget.com/it-strategy/feature/What-CIOs-need-to-know-about-the-RSL-protocol)
- [Proven] Controls the assistants do document: Google's `nosnippet`, `data-nosnippet`, `max-snippet` and `noindex` for AI features ([Google AI features](https://developers.google.com/search/docs/appearance/ai-features)); Bing's NOARCHIVE, NOCACHE and `data-snippet` for Copilot ([SEJ, 2026-02-27](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/), Reported); and every vendor's robots.txt tokens (question 2).
- [Proven, observed 2026-10-22] Mercaditos serves `/llms.txt` (200, text/plain, 2.7 KB), which is a discovery file rather than a use signal; Google says such files are not needed for its AI features. Mercaditos sets no Content-Signal. `/.well-known/tdmrep.json` returns a 200 **HTML** page (a soft 404) instead of a 404. — [mercaditos.app/llms.txt](https://mercaditos.app/llms.txt); [Google AI features](https://developers.google.com/search/docs/appearance/ai-features)

### Inferences
- For two sites that want to **be** the source (Mercaditos, The Cultural Club), restrictive use signals add nothing to
  reach. If any are added, an explicit `Content-Signal: search=yes, ai-input=yes` (with `ai-train` set by policy)
  states permission without reducing it. The effect on any assistant today is unproven (**Speculative**).
- Returning HTML with HTTP 200 for `/.well-known/*` paths is a small risk. A TDMRep- or policy-aware parser expects
  JSON or a 404 and may misread an HTML 200. A real 404 for unknown well-known paths is the clean answer (Inference).
- Place and event sites need nothing special here beyond the generic case. Their gains are in access, rendering,
  freshness and locale URLs (questions 3–5).

### Gaps
- I found no statement from Google, OpenAI, Anthropic, Perplexity, Microsoft, Apple or Meta that they read Content-Signal, aipref or TDMRep signals.
- I found no confirmed AI-company adoption of RSL, and the RSL HTTP or licence-header details were not researched.
- The current IESG and last-call state of the aipref drafts was not visible on Datatracker.
- Whether EU enforcement (the AI Act copyright duties and fines from August 2026) has changed crawler behaviour in practice is undocumented in what I found.
