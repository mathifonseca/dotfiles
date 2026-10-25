# Local and event questions in AI assistants: where the facts come from (researched 2026-10-22)

Evidence labels: **[Proven]** = the platform's own documentation, or a measured study with a stated method (academic, or a community spec). **[Reported]** = industry or vendor data with known limits, or news reporting. **[Claimed]** = an assertion without data. **[Speculative]** = my inference. Every source has a date, and "(may be outdated)" flags anything older than about six months or from before a known change. Several key pages could not be fetched (OpenAI help: 403; Search Engine Land: 403). Those are named in Gaps.

## 1. Where do the assistants get local business and event data, and which data partnerships are public?

### Takeaway
Each assistant leans on a different main source for place facts. Google's AI (AI Overviews, AI Mode, Gemini) uses Google Maps and Business Profile. ChatGPT now uses mostly Yelp (licensed in 2026), plus web search that reportedly includes Google results. Perplexity uses Yelp, Tripadvisor and MapQuest. Claude uses Brave Search, Copilot uses Bing, the new Siri uses Gemini models plus Apple Maps, and Meta AI uses Bing and Google search plus its own social data. Ticketed events now have their own pipes into ChatGPT and Google AI Mode (Ticketmaster, SeatGeek, StubHub), and these start in the US. Free, unticketed seasonal events such as Christmas markets have no dedicated feed into any assistant. Their facts come from map and listing records, or from web pages.

### Cited Findings

**Google (AI Overviews, AI Mode, Gemini)**
- [Proven] The Gemini API tool "Grounding with Google Maps" works like this: when a query has geographic intent, the model calls Maps. Maps returns places, reviews, photos, addresses and opening hours, and the answer cites Maps. Google says the Maps data covers "over 250 million places". The docs are current as of Oct 2026, and the launch date was not found. — [Google AI for Developers: Grounding with Google Maps](https://ai.google.dev/gemini-api/docs/maps-grounding); coverage at [The Decoder](https://the-decoder.com/google-brings-live-google-maps-data-to-its-gemini-models/)
- [Reported] In BrightLocal's study (published 2026-08-26), Google Business Profile accounted for about 67% of local-business citations in AI Overviews (108,018 of 161,094) and about 53% in AI Mode (455,123 of 861,263). The next sources were Yelp, Facebook, Tripadvisor, MapQuest (AIO) and OpenTable (AI Mode). The study covered 1,355 locations in the US, UK and Australia, with 5 prompts at 9 points each, 60,970 checks in total. I computed the percentages from BrightLocal's published counts. The platform subtotals (about 1.19M) do not add up to the stated total of 1,967,762 citations. — [BrightLocal, "AI directory sources", 2026-08-26](https://www.brightlocal.com/resources/ai-directory-sources/)
- [Reported] SOCi's 2026 Local Visibility Index (Jan 2026) is reported to describe Gemini as "grounded directly in Google Maps", with business-profile accuracy of 100% on Gemini against 68% on ChatGPT and Perplexity. These figures appear in secondary coverage but not in SOCi's own press release, so they are unverified. — [dev.to summary](https://dev.to/alifar/ai-local-recommendations-are-much-harder-to-win-than-google-maps-rankings-report-finds-2226); [Trustmary roundup](https://trustmary.com/ai-visibility/ai-search-visibility-2026-three-recent-reports/)
- [Reported] Agentic booking in AI Mode developed in three steps:
  - May 2025: announced with Ticketmaster, StubHub, Resy and Vagaro for event tickets, restaurants and local appointments. — [9to5Google, 2025-05-20](https://9to5google.com/2025/05/20/google-ai-mode-agent-research/)
  - Aug 2025: restaurant reservations (OpenTable, Resy, Tock and others) went live for US AI Ultra subscribers in Labs. — [Droid Life, 2025-08-22](https://www.droid-life.com/2025/08/22/ai-mode-reservations-link-sharing/)
  - Later (date unverified, probably late 2025): event tickets and beauty appointments were added, with Ticketmaster, StubHub, SeatGeek, Vivid Seats, Booksy, Fresha and Vagaro named. Reports agree it is US-only but disagree on who is eligible (Labs only, or paid tiers). Checkout stays on the partner's site. — [Tom's Guide](https://www.tomsguide.com/ai/googles-ai-mode-now-books-your-event-tickets-and-beauty-appointments-for-you); [YourStory](https://yourstory.com/ai-story/googles-ai-mode-adds-agentic-booking-for-tickets)
- [Reported] AI Mode itself expanded to more than 40 countries on 2025-10-08, including Germany and Spain, and German was among the new languages. Spanish had come earlier, in Sept 2025. This may be outdated, since the current country list was not checked. — [Thurrott](https://www.thurrott.com/a-i/328035/ai-mode-in-google-search-is-now-available-in-over-200-countries); [Trending Topics](https://www.trendingtopics.eu/google-ai-mode-launch-europe/); [onlinemarketing.de](https://onlinemarketing.de/technologie/google-ai-mode-weitere-sprache)

**ChatGPT (OpenAI)**
- [Reported] Yelp licenses reviews, ratings, photos and "other business details" to OpenAI, and ChatGPT shows them in answers to local questions. Yelp's branding and links appear, but OpenAI controls the presentation. The deal is non-exclusive, its financial terms were not disclosed, and a "Request a Quote" feature is coming. The countries covered and the go-live date were not specified. Yelp's CEO said: "If you want to answer local queries, you really need Yelp." — [Axios via Yahoo Finance, 2026-07-23](https://finance.yahoo.com/media-advertising/articles/exclusive-yelp-deal-pushes-local-130005436.html)
- [Reported] According to secondary coverage, Yelp first disclosed the deal in its February 2026 results. One source says an August 2026 extension added restaurant reservations and waitlists, and that claim is single-sourced and unverified. — [PinMeTo](https://www.pinmeto.com/news/chatgpt-yelp-reviews-ai-local-discovery-2026/); [Search Engine Land](https://searchengineland.com/openai-yelp-deal-483326) (returned 403 when fetched)
- [Reported] The same Axios piece says Yelp also supplies Apple Maps and Yahoo+, that it once licensed to Google, and that it is now suing Google over local search. — [Axios via Yahoo Finance, 2026-07-23](https://finance.yahoo.com/media-advertising/articles/exclusive-yelp-deal-pushes-local-130005436.html)
- [Reported] In BrightLocal's study, Yelp made up about 61% of ChatGPT's local citations (99,281 of 162,966) and "appeared as a source in 80% of all answers from ChatGPT". Tripadvisor (about 6.3%), OpenTable (about 5.6%) and BBB followed. For ChatGPT, "While Google Business Profile isn't a top source, Apple's version is" (apple.com, 600 citations). — [BrightLocal, 2026-08-26](https://www.brightlocal.com/resources/ai-directory-sources/)
- [Reported] Yext analysed 6.8M citations (published 2025-10-09) and found that OpenAI "leans on listings (48.7%)", while Gemini "favors websites (52.1%)". This may be outdated, since it predates the Yelp deal. — [Business Wire / Yext, 2025-10-09](https://www.businesswire.com/news/home/20251009106549/en/Yext-Research-86-of-AI-Citations-Come-from-Brand-Managed-Sources-Clarifying-How-Marketers-Can-Compete-in-the-AI-Search-Era)
- [Reported, anonymous sources] In Aug 2025, The Information reported that OpenAI used Google search results scraped through SerpApi to answer current-events questions about news, sports and markets. Meta, Apple and Perplexity were reportedly also SerpApi customers. Neither company confirmed this on the record. — [Slashdot summary of The Information, 2025-08-22](https://tech.slashdot.org/story/25/08/22/1442208/openai-is-challenging-google---while-using-its-search-data); [Search Engine Land](https://searchengineland.com/openai-chatgpt-serpapi-google-search-results-461226)
- [Reported] Ticketmaster launched an app inside ChatGPT in April 2026. Users invoke it with @Ticketmaster, ask about local concerts and events, get interactive listings, and buy on Ticketmaster. It was the second ticketing app in ChatGPT, after SeatGeek. — [Music Business Worldwide](https://www.musicbusinessworldwide.com/ticketmaster-launches-app-within-chatgpt-bringing-event-discovery-to-openais-chatbot/); [Ticketmaster Business blog](https://business.ticketmaster.com/ticketmaster-drives-a-new-era-of-ai-powered-event-discovery-with-app-in-chatgpt/)
- [Claimed] A vendor blog says Foursquare is ChatGPT's main local source, "appearing in roughly 70% of local recommendation queries", without describing a method. The 2026 measurements contradict it. Foursquare does not appear among BrightLocal's cited sources, and Steady Demand reports Yelp links on 95.83% of runs that showed ChatGPT business cards, against 0% for Foursquare (its method was not verified). — [MapAtlas (undated)](https://mapatlas.eu/blog/chatgpt-local-business-data-sources-foursquare); contradicted by [BrightLocal, 2026-08-26](https://www.brightlocal.com/resources/ai-directory-sources/) and [Steady Demand](https://www.steadydemand.com/?p=4927)

**Perplexity**
- [Reported] Perplexity licensed Yelp data through Yelp's Fusion program: maps, photos and review excerpts, mainly for restaurants. Perplexity said it would not train on that data. The date was not verified (about 2024) and the deal may be outdated. — [Maginative](https://www.maginative.com/article/perplexity-enhances-ai-search-engine-with-direct-yelp-data-integration/)
- [Reported] A Tripadvisor partnership was announced in Jan 2025. It brings hotel summaries, ratings and images, gives access to more than 1B reviews and 11M listings, and was planned to expand over three years to restaurants and Viator experiences. Whether that expansion launched was not verified. — [Engadget, Jan 2025](https://www.engadget.com/ai/perplexity-will-now-show-hotel-information-from-tripadvisor-202923788.html); [PhocusWire](https://www.phocuswire.com/tripadvisor-perplexity-ai-partnership)
- [Reported] Yext (Oct 2025) found that Perplexity "diversifies across MapQuest and TripAdvisor". BrightLocal's July 2025 multi-platform test found Yelp used in about a third of searches, with MapQuest frequently used by AI Mode and Perplexity. — [Business Wire / Yext, 2025-10-09](https://www.businesswire.com/news/home/20251009106549/en/Yext-Research-86-of-AI-Citations-Come-from-Brand-Managed-Sources-Clarifying-How-Marketers-Can-Compete-in-the-AI-Search-Era); [BrightLocal, Jul 2025](https://brightlocal.com/blog/ai-search-using-listings-sources)

**Claude (Anthropic)**
- [Reported] Anthropic's subprocessor list added Brave Search as of 2025-03-19. Simon Willison found that Claude's ten citations exactly matched Brave's results for the same query, and that its tool definition contained a `BraveSearchParams` parameter. This may be outdated (Mar 2025). Brave also powers Mistral's Le Chat. — [Simon Willison, 2025-03-21](https://simonwillison.net/2025/Mar/21/anthropic-use-brave/); [TechCrunch, 2025-03-21](https://techcrunch.com/2025/03/21/anthropic-appears-to-be-using-brave-to-power-web-searches-for-its-claude-chatbot/)

**Microsoft Copilot**
- [Claimed] SEO vendors say "a verified Bing Places listing controls how a location appears in Bing Search, Bing Maps and Microsoft Copilot results". No Microsoft documentation was found. — [PinMeTo](https://www.pinmeto.com/knowledge-hub/bing-partnership/)
- [Reported] Whitespark tested 153 Bing Places queries and found the review sources shown were mostly Facebook, then Yelp, then Tripadvisor. The sample is small and US-only, and the date was not verified. — [Whitespark](https://whitespark.ca/blog/want-to-rank-in-chatgpt-focus-on-these-review-sites-new-research/)

**Siri / Apple Intelligence**
- [Reported] Apple unveiled a rebuilt Siri at WWDC 2026 (June 2026) that "can pull up-to-date web information". PCMag reports it runs on Google's Gemini models. An updated Applebot page says the answers "may include links to sources". Earlier reports had targeted iOS 26.4 in spring 2026 for this "World Knowledge Answers" feature. — [Let's Data Science (republishing SEJ)](https://letsdatascience.com/news/apple-launches-gemini-powered-siri-raises-search-questions-3c3c18b2); [iPhoneSoft, 2026-01-14](https://iphonesoft.fr/2026/01/14/siri-dope-gemini-7-nouveautes-printemps-ios-26-4)
- [Proven] On 2026-10-22, businessconnect.apple.com redirected to business.apple.com, now named "Apple Business". There businesses "Claim your location on Maps" and control logo, hours, images and "Custom Actions" for reservations and appointments, and "Feature and service availability varies by country and region". The fetched page does not mention Siri, events, or seasonal places. — [Apple Business](https://business.apple.com/)
- [Reported] Apple Maps place cards are "predominantly supplied by Yelp, although TripAdvisor, Wikipedia, and other sources" are also used (undated, likely 2023, may be outdated). Foursquare was added as an Apple Maps provider in 2015 (outdated). — [MacStories](https://www.macstories.net/news/apple-launches-a-new-program-allowing-business-owners-to-manage-their-place-cards-in-maps-and-other-apps/); [Search Engine Land, 2015](https://searchengineland.com/foursquare-joins-apple-maps-data-sources-as-company-builds-out-ecosystem-236173)

**Meta AI**
- [Reported, may be outdated] Meta AI's real-time answers came from "search promotion partnerships" with Google and Bing (Apr 2024). Since Jan 2025 Meta AI can use Facebook and Instagram profile data, such as home location, to suggest things like "tickets for that weekend's country music show at your local arena" (US and Canada first). — [TechCrunch, 2024-04-26](https://techcrunch.com/2024/04/26/meta-ai-tested-doesnt-quite-justify-its-own-existence-but-free-is-free); [AIN, 2025-01-28](https://en.ain.ua/2025/01/28/meta-will-use-facebook-and-instagram-user-data)
- [Reported] Facebook Business pages are also a listing source for other assistants: 2.23% of all citations in the BrightLocal study, used by 93% of the businesses measured, and about 4% of citations in AI Overviews and AI Mode. — [BrightLocal, 2026-08-26](https://www.brightlocal.com/resources/ai-directory-sources/)

**Event platforms, tourism boards, Wikipedia/Wikidata**
- [Proven] Google's event search experience takes events from third-party publishers. Its docs tell site owners to first check whether their event publisher is already in the experience, and if so to "stop reading here". — [Google Search Central, Event structured data, updated 2026-09-08](https://developers.google.com/search/docs/appearance/structured-data/event)
- [Reported] In Nov 2025, fact-checkers checking the status of German Christmas markets used tourism-board and city sources as ground truth. Those included the German National Tourist Board's finder ("more than 2,900 'market' events"), the tourism offices of Stuttgart, Nuremberg and Baden-Württemberg, and official market sites. — [Annie Lab (HKU Journalism), 2025-11-14](https://annielab.org/2025/11/14/analysis-most-german-christmas-markets-to-open-as-planned-in-2025/)

### Inferences
- [Speculative] The supply chain has five layers. Each fails differently, and a niche site can influence each one differently:
  1. **The model's built-in knowledge.** It is stale by design, and it is the source of last-year's-dates errors.
  2. **Place-of-record platforms.** Google Maps and Business Profile for Google, Yelp for ChatGPT, and Yelp/Tripadvisor/Apple for Apple and Perplexity. They hold hours and the open or closed status.
  3. **Ticketing partners.** Ticketmaster, SeatGeek and StubHub, in ChatGPT apps and AI Mode agents. They hold dates and prices for ticketed events only.
  4. **Web search indexes.** Google (directly or through SerpApi), Bing (Copilot, Meta), Brave (Claude).
  5. **First-party and editorial pages.** Organizers, city and tourism sites, aggregators, Reddit.
- [Speculative] A free Christmas market sells no tickets, so layer 3 does not apply to Mercaditos. It applies to The Cultural Club wherever Barcelona events are sold through Ticketmaster or similar partners. Mercaditos's main levers are layers 2 and 5.
- [Speculative] ChatGPT's local answers depend heavily on Yelp, and Google's on Business Profile. For a market with no Yelp page and a thin or user-generated Google Maps entry, the assistant has to fall back to web pages, which is where a niche site can become the source. All the measurements are from the US, UK and Australia, so Yelp's weight in Germany and Spain is unknown.

### Gaps
- OpenAI's help page "ChatGPT search" (help.openai.com/en/articles/9237897) returned 403, so the providers and maps or data partners OpenAI officially names could not be verified.
- No official Microsoft list of Copilot's local data sources, and no Bing Places documentation linking it to Copilot, was found.
- Whether the new Siri (WWDC 2026) is available in Germany and Spain, and which local sources it uses, was not verified.
- No public AI data partnership was found for Eventbrite, Meetup, Resident Advisor, Songkick or Facebook Events. Of the ticketing platforms, only Ticketmaster and SeatGeek (ChatGPT apps) and the AI Mode agent partners were found.
- No public partnership between an AI company and a tourism board was found.
- I found no evidence for or against assistants using Wikidata or OpenStreetMap, or open place datasets such as Overture and Foursquare OS Places, for local or event facts. I did not research this further.

## 2. How do assistants handle time-sensitive facts (this year's dates, seasonal hours, cancellations, prices), which failure modes are documented, and do engines prefer sources with explicit current-year dates?

### Takeaway
No assistant documents how it handles this year's dates for recurring events. What exists are documented failures and freshness studies:
- **Documented failures:** the wrong current year (Google AI Overviews, May 2025 and Jan 2026), a wrong closing time (Mount Misen), invented places (the "Sacred Canyon of Humantay"), a market recommended on a day it was closed (Liverpool), false cancellations repeated by chatbots (German Christmas markets, 2025), and AI-generated fake markets (Buckingham Palace, 2025).
- **Freshness preference:** measured studies show that LLM rerankers and AI assistants favour content with newer dates. That rewards a page that states current dates, and it also rewards a page that fakes freshness.
- **Missing:** no study tested whether stating the current year explicitly raises citation.

### Cited Findings
- [Reported] In May 2025, Google's AI Overview answered "is it 2025?" with "No, it is not 2025. The current year is 2024". After Google's fix, TechRadar still got the wrong answer about 1 time in 10. In Jan 2026 an AI Overview said 2026 was "next year", implying the current year was 2025. — [Android Authority, May 2025](https://www.androidauthority.com/google-search-ai-overview-doesnt-know-the-year-3561764/); [TechRadar](https://www.techradar.com/computing/search-engines/google-ai-overview-thinks-its-still-2024-sometimes); [Storyboard18, Jan 2026](https://storyboard18.com/digital/google-ai-overview-wrongly-states-2026-is-next-year-elon-musk-reponds-87134.htm)
- [Reported] A BBC story (Sept/Oct 2025) described two cases. ChatGPT gave a couple a last-ropeway time on Mount Misen in Japan that was wrong, and they were stranded at the summit. Tourists in Peru set off for a "Sacred Canyon of Humantay" that does not exist; a local guide said the name combined two other places. These reached me through secondary outlets and the AI Incident Database, and are listed there as "reportedly". — [Kursiv, 2025-10-03](https://kz.kursiv.media/en/2025-10-03/engk-tank-planning-a-trip-dont-rely-on-ai-alone/); [AI Incident Database #1636](https://incidentdatabase.ai/cite/1636)
- [Reported, anecdote] A writer let ChatGPT plan a Liverpool Christmas. It suggested the Winter Arts Market at St George's Hall on Christmas Eve, but "this market isn't open on Christmas Eve. It's only open for one weekend at the start of December". The writer concluded that most of the advice was "either outdated or inaccurate, leading to it suggesting the wrong dates for activities". The article date was not verified. — [EM360Tech](https://em360tech.com/tech-article/chatgpt-plan-holidays)
- [Reported, documented fact-check] From mid-October 2025, posts claimed that Germany had cancelled many Christmas markets over security costs. The claim traced back to a 14 Oct article by Duna Press. Baidu's AI search summary repeated it, citing a Weibo post, and Grok gave information consistent with the Duna Press article. Tourism offices in Stuttgart, Rheinfelden and Nuremberg, and the Baden-Württemberg state office, confirmed that their markets would go ahead: "There is no credible evidence to support claims" of widespread cancellations. One real cancellation, Overath, was reported by Bild on 2025-11-09. — [Annie Lab, 2025-11-14](https://annielab.org/2025/11/14/analysis-most-german-christmas-markets-to-open-as-planned-in-2025/)
- [Reported] In Nov 2025, AI-generated images advertised a "first ever" Christmas market at Buckingham Palace, said to run "from November 14 to Jan 5 2026". It did not exist, and the Royal Collection Trust confirmed there would be no market. Visitors travelled to the palace for it. The posts circulated in Thai, Portuguese, Arabic and Armenian, among other languages. This was AI-made content that misled people, not a chatbot answer. — [CP24 (AFP), 2025-11-21](https://www.cp24.com/news/2025/11/21/tourists-baffled-by-ai-buckingham-palace-christmas-market); [Time Out London, Nov 2025](https://www.timeout.com/london/news/why-are-londoners-falling-for-a-fake-christmas-market-outside-buckingham-palace-111925)
- [Proven, measured academic study] Researchers added artificial publication dates to TREC Deep Learning passages and tested seven LLM rerankers, which "promoted" the newer-dated passages:
  - the mean year of the top 10 moved forward by up to 4.78 years;
  - single items moved by up to 95 ranks;
  - pairwise preferences between equally relevant passages flipped in up to 25% of cases;
  - larger models reduced the effect but did not remove it.

  This is a lab setting, not a production assistant. — [Fang et al., arXiv 2509.11353, 2025-09-14](https://arxiv.org/abs/2509.11353v1)
- [Reported, measured, vendor] Ahrefs analysed about 17M citations from ChatGPT, Perplexity, Gemini, Copilot and AI Overviews against Google organic results. Pages cited by AI assistants averaged 1,064 days old, against 1,432 for organic results ("25.7% fresher"). ChatGPT cited the newest pages, and AI Overviews were closest to organic. Age was approximated from when Ahrefs' crawler first saw a page or its last-updated date. — [Ahrefs, 2025-07-28](https://ahrefs.com/blog/do-ai-assistants-prefer-to-cite-fresh-content/)
- [Proven] Google's Event markup has fields for changed plans. `eventStatus` takes `EventScheduled`, `EventCancelled`, `EventPostponed` or `EventRescheduled`, and `previousStartDate` records a rescheduled date. For a cancellation, "keep all values as the same as they were before the cancelation". For a postponement, "Keep the original date in the startDate of the event until you know when the event will take place". The fetched version did not list `EventMovedOnline` or `eventAttendanceMode`. — [Google Search Central, Event, updated 2026-09-08](https://developers.google.com/search/docs/appearance/structured-data/event)
- [Proven] On Google's side, opening hours come from the Maps record: Maps grounding returns "places, reviews, photos, addresses, opening hours". — [Google AI for Developers](https://ai.google.dev/gemini-api/docs/maps-grounding)
- [Reported] Business data on AI platforms was reported 68% accurate on ChatGPT and Perplexity, against 100% on Gemini (SOCi, Jan 2026; secondary source only, see Q1). — [dev.to summary](https://dev.to/alifar/ai-local-recommendations-are-much-harder-to-win-than-google-maps-rankings-report-finds-2226)
- [Proven, community spec] OpenStreetMap's German Christmas-market tags record holiday exceptions explicitly. Example (Lübeck): `xmas:day_date=2016-11-28/2016-12-23`, `xmas:opening_hours=Mo-Sa 11:00-22:00;Su 11:00-21:00`, `xmas:note=24.12 11:00-14:00, 25./26.12. closed`. The page recommends re-checking the data every October or November and adding `xmas:lastcheck=yyyy-mm-dd`. The wiki page was last edited 2024-03-30. — [OSM Wiki DE:Key:xmas:feature](https://wiki.openstreetmap.org/wiki/DE:Key:xmas:feature)
- [Proven] A proposal to add holiday selectors such as `PH(Christmas)` to `opening_hours` was rejected, so there is no standard syntax for named holidays. — [OSM Wiki, Proposal: Opening hours holiday select](https://wiki.openstreetmap.org/wiki/Proposal:Opening_hours_holiday_select)
- [Proven] Google Business Profile allows seasonal businesses ("like an ice-skating rink only open in winter months"). [Reported] Whitespark's reading of Google's guidance: set regular hours during the season and mark the business "temporarily closed" off-season. — [Google Business Profile eligibility guidelines (©2026)](https://support.google.com/business/answer/13763036); [Whitespark](https://whitespark.ca/blog/are-seasonal-businesses-eligible-for-a-google-business-profile/)

### Inferences
- [Speculative] Each failure mode comes from a different layer of the supply chain (Q1), so each needs a different fix:
  - **Model memory.** The wrong year and last year's dates come from what the model learned in training. The fix is retrievable pages that state this year's dates.
  - **Stale listings.** Wrong hours come from out-of-date listings. The fix is getting the Maps, Yelp or Apple records corrected.
  - **False web content.** Fake markets and false cancellations come from bad pages. The fix is an authoritative, current page that contradicts them, in the language of the misinformation (the Germany claim spread mainly in English, Annie Lab).
- [Speculative] Recurring annual events are unusually exposed. Last year's page has the same name, venue and topic, so it scores as relevant, and it only loses if the engine notices the dates. Recency bias (arXiv 2509.11353; Ahrefs) helps a page that clearly states 2026 dates. It also means a page that says "2026" before organisers confirm anything will be believed, so a premature "2026" page is a risk.
- [Speculative] Questions like "Which markets are open on 26 December?" need opening hours for each day, including the 24, 25, 26 and 31 December exceptions. Most sources give a season range and a generic weekly schedule. A page that states those days, with "closed" stated explicitly and a "verified on" date, fills a gap that listings and organiser pages often leave. The OSM `xmas:note` pattern shows the shape such a field takes.
- [Speculative] "Not announced yet" is itself a fact worth stating explicitly. Without it, assistants fill the gap with last year's dates. This supports Mercaditos's W2 "honest model" direction.

### Gaps
- No study was found that measures whether an explicit current year in a page's title, body or markup raises citation in assistants. The evidence is indirect: date-injection rerankers and freshness of citations.
- No systematic measurement of how often assistants get event dates or seasonal hours wrong was found; the evidence is anecdotes plus the SOCi accuracy figure.
- No platform documentation explains how assistants tell apart the editions of a recurring event across years.
- Prices: no studies or documented failures about event or entry prices in AI answers were found.

## 3. What do studies of travel, tourism, local and event queries show about which sources get cited?

### Takeaway
For local businesses, listings dominate the top of the citations: Google Business Profile in Google's AI, Yelp in ChatGPT. Business websites make up the long tail and lead on unbranded factual questions. Reddit is small for local queries but large in ChatGPT's social citations. In travel, Tripadvisor and Reddit are reported as dominant, and AI Overviews often cite domains outside Google's organic top 10. No study isolates event or "what's on" queries. Almost all the data is from US, UK or Australian vendors, and those vendors sell listings or visibility products.

### Cited Findings
- [Reported, measured, vendor] BrightLocal (2026-08-26; US, UK, Australia; AIO, AI Mode, ChatGPT):
  - "Google Business Profile makes up 28.5% of all citations", but its own table says 28.63%;
  - "Yelp makes up 8.53% of all citations", but the table says 9.53%;
  - "Around 93% of the domains cited were individual business websites";
  - for restaurants, four sources make 80% of citations: Google Business Profile 45.2%, Yelp 21.8%, Tripadvisor 7%, OpenTable 6.6%;
  - Hospitality & Travel was only 1.12% of the locations measured;
  - Expedia, Wanderlog, Eater and Time Out appear in the overall list of cited sources.

  — [BrightLocal, 2026-08-26](https://www.brightlocal.com/resources/ai-directory-sources/)
- [Reported, vendor] Yext (2025-10-09; 6.8M citations across ChatGPT, Gemini and Perplexity; per a secondary source, location-specific prompts, 1.6M queries per model, Jul 1 to Aug 31, 2025):
  - first-party websites 44%, listings 42%, reviews and social 8%;
  - Reddit and forums about 2% once location and intent are applied;
  - "For unbranded objective queries … first-party websites and local pages made up nearly 60% of citations", while branded or subjective queries leaned on listings and reviews.

  Yext sells listings management, which is a conflict of interest. — [Business Wire / Yext, 2025-10-09](https://www.businesswire.com/news/home/20251009106549/en/Yext-Research-86-of-AI-Citations-Come-from-Brand-Managed-Sources-Clarifying-How-Marketers-Can-Compete-in-the-AI-Search-Era); [Yext press release](https://yext.com/about/news-media/ai-citations-release); method detail from [Webtonic](https://www.webtonic.io/blog/pest-control-generative-engine-optimization-aeo-statistics)
- [Reported, vendor] SOCi's 2026 Local Visibility Index (2026-01-28; more than 350,000 locations of 2,751 multi-location brands) found that "ChatGPT recommends just 1.2% of brand locations", against 35.9% appearing in Google's local 3-Pack. Secondary coverage gives Gemini 11% and Perplexity 7.4%. Locations that ChatGPT recommended averaged 4.3 stars, and assistants "synthesize signals across Google Maps, Yelp, Facebook, and brand websites". — [SOCi press release, 2026-01-28](http://www.soci.ai/news/in-ai-driven-discovery-few-brands-are-chosen-most-disappear/); [Trustmary roundup](https://trustmary.com/ai-visibility/ai-search-visibility-2026-three-recent-reports/)
- [Reported, vendor] SEOZoom analysed about 75,000 Italian travel queries (Jun 2025 to Apr 2026). More than half of the citations in tourism AI Overviews came from domains that are not in Google's organic top 10. — [SEOZoom](https://www.seozoom.com/?p=34853)
- [Reported, vendor] Gradial found Tripadvisor the most- or second-most-cited domain in nearly every hotel-chain report it ran. In cruises, cruisecritic.com was the most-cited domain in six of seven cruise-line reports. The date was not verified. — [Gradial](https://gradial.com/blog/travel-hospitality-geo-industry-research)
- [Claimed] One analysis says the top 5 sources supply about 58% of travel answers, Reddit and Tripadvisor about 28%, and "national and city tourism boards" about 12%. Its method is not described. — [Everything PR](https://everything-pr.com/who-controls-ai-answers-in-travel)
- [Reported, measured, vendor] Profound (2026-04-21; 3.25B citations, 7 models, 14 countries, March 2026) found that Reddit makes up 51–76% of ChatGPT's social citations in every country it measured, including 69% in Germany. ChatGPT's share of social citations falls from about 10% in English to 3–5% in non-English markets. — [Profound, 2026-04-21](https://tryprofound.com/blog/how-query-language-reshapes-ai-citations)
- [Reported, survey] An IMG survey (2026-03-24) found 33% of respondents likely to use AI tools to plan 2026 travel. Of those, 75% expected to use them for recommendations and only 13% for booking. — [IMG via AAP, 2026-03-24](https://www.aap.com.au/aapreleases/cision20260324ae17026)
- [Reported] Consumer surveys disagree. A BrightLocal survey as cited by Steady Demand says 45% of consumers use AI for local recommendations (n=1,002). BrightLocal's own page says 58% have used AI to find or get a recommendation for a local business (n=1,164). The two are not reconciled. — [Steady Demand index](https://www.steadydemand.com/?p=4964); [BrightLocal](https://www.brightlocal.com/local-seo-tools/local-ai-visibility)

### Inferences
- [Speculative] For objective, unbranded questions such as "when does the Gendarmenmarkt market open", the data (Yext, BrightLocal) favours first-party and official pages: organisers, berlin.de, visitBerlin, Barcelona city sites. An aggregator gets cited when it supplies something those pages lack: completeness across markets, cross-market comparison ("open on 26 Dec"), day-level detail, or English and Spanish versions of German or Catalan facts.
- [Speculative] Tripadvisor matters most where an assistant treats a market as an attraction, and Reddit matters for "is it worth it" questions in English on ChatGPT. Neither is a source a niche site controls.
- [Speculative] The SEOZoom finding (AI Overview citations often come from outside the organic top 10) means a small, specific site does not need to rank in the top 10 to be cited. The citation goes to the page that answers the exact question.

### Gaps
- No study was found on event or "what's on this weekend" queries, or on seasonal events specifically.
- None of the local studies measured Germany or Spain. BrightLocal covered the US, UK and Australia, and the others were US-weighted or did not say.
- Nearly all the data comes from vendors that sell listings, reputation or AI-visibility products.

## 4. What can an independent events or places site do to feed this chain?

### Takeaway
A niche site can feed the chain in six places:
1. **Its own pages, with markup.** Make them the best current record, with Event and Place markup. Google's event search experience is live in Germany (German) and Spain (Spanish) per docs updated 2026-09-08.
2. **Listings it does not own.** It cannot verify Google Business Profiles for markets it does not run. It can suggest edits, and add missing seasonal places that reopen in the same location (Google Maps allows this).
3. **OpenStreetMap.** Tag markets with the `xmas:*` scheme. It costs little, but there is no evidence it reaches assistants.
4. **Wikidata.** Create items for notable markets or festivals.
5. **Ticketing partners.** Use them for ticketed events (Barcelona), not for free markets.
6. **Organisers and tourism boards.** Work with the sources that hold the ground truth.

### Cited Findings
- [Proven] Google's Event structured data docs (updated 2026-09-08) cover the following:
  - **Regions and languages:** Australia (English), Brazil (Portuguese), Canada (English), Germany (German), India (English), Latin America (Spanish), Spain (Spanish), UK (English), US (English).
  - **Required properties:** `location` (Place), `location.address`, `name`, `startDate`.
  - **Recommended properties:** `description`, `endDate`, `eventStatus`, `image`, `location.name`, `offers` (with `availability`, `price`, `priceCurrency`, `validFrom`, `url`), `organizer`, `performer`, `previousStartDate`.
  - **Multi-day events:** "specify both the start and end dates of the event".
  - **Several performances:** "add a separate Event element for each performance".
  - **Don'ts:** "Don't mark business hours as events", "Don't mark coupons or vouchers as events", "Don't add short-term discounts or purchase opportunities".
  - **Other routes:** check whether a third-party event publisher is already in the experience; use CMS plugins; use the Data Highlighter.

  — [Google Search Central, Event](https://developers.google.com/search/docs/appearance/structured-data/event)
- [Reported] Event is not among the structured-data types Google retired recently. In June 2025 Google dropped seven types: Book Actions, Course Info, Claim Review, Estimated Salary, Learning Video, Special Announcement and Vehicle Listing. FAQ rich results were retired on 2026-05-07. — [PPC Land, Jun 2025](https://ppc.land/google-deprecates-seven-structured-data-types-to-simplify-search-results/); [TechWyse, 2026](https://www.techwyse.com/news/ai-search/google-faq-rich-results-deprecated-2026)
- [Proven] Google Business Profile rules:
  - "Only business owners or authorized representatives may verify and manage their business information on a Business Profile."
  - Representatives must "Never claim a Business Profile without express consent from the business owner".
  - Seasonal businesses must "display permanent signage at their location year-round".
  - Ineligible: "An ongoing service, class, or meeting at a location that you don't own or have the authority to represent."

  — [Google Business Profile eligibility and ownership guidelines (©2026)](https://support.google.com/business/answer/13763036)
- [Proven] Google Maps does not allow "Temporary, one-time events" or "Seasonal/recurring businesses without a permanent location". It does allow "Seasonal businesses that re-open in the same location". Users can add missing places publicly. — [Google Maps Help: Places you can't add to the map](https://support.google.com/maps/answer/2642650); [Google contribution policy: Business & place eligibility](https://support.google.com/contributionpolicy/answer/12473822)
- [Proven] Apple Business (formerly Business Connect) lets businesses claim their location on Maps and control logo, hours, images and Custom Actions. The fetched page names no events feature, and availability varies by country. — [Apple Business, observed 2026-10-22](https://business.apple.com/)
- [Proven, community spec] OSM Christmas-market tagging:
  - **The tags:** `xmas:feature=market` with `xmas:name`, `xmas:location`, `xmas:opening_hours`, `xmas:url`, `xmas:note`, `xmas:description`, `xmas:fee`, `xmas:operator`, `xmas:day_date` and `xmas:lastcheck`.
  - **Apps that use them:** OsmAnd (a Christmas category in search) and OpenStreetBrowser. XmasMap and OpenSantaMap have been unreachable since June 2021.
  - **Open question:** whether to use the prefix. A JOSM ticket argues for plain `opening_hours=Nov 26-Dec 26 Mo-Su 11:00-22:00`, keeping only `xmas:feature` prefixed.

  — [OSM Wiki DE:Key:xmas:feature, last edited 2024-03-30](https://wiki.openstreetmap.org/wiki/DE:Key:xmas:feature); [JOSM ticket 13972](https://josm.openstreetmap.de/ticket/13972); [OSM community thread](https://community.openstreetmap.org/t/xmasmap-so-gehts-weiter/77261)
- [Proven] A Wikidata item is acceptable if it meets one of three tests:
  - it has "at least one valid sitelink" to Wikipedia or a sister project; or
  - it "refers to an instance of a clearly identifiable conceptual or material entity" that can be described using "serious and publicly available references"; or
  - it "fulfills a structural need".

  The separate exclusion criteria page was not fetched. — [Wikidata:Notability](https://www.wikidata.org/wiki/Wikidata:Notability)
- [Reported] Ticketing gets into assistants through partner integrations: Ticketmaster and SeatGeek as ChatGPT apps (2026), and Ticketmaster, StubHub, SeatGeek and Vivid Seats in AI Mode's US agent. — sources in Q1: [Music Business Worldwide](https://www.musicbusinessworldwide.com/ticketmaster-launches-app-within-chatgpt-bringing-event-discovery-to-openais-chatbot/); [Tom's Guide](https://www.tomsguide.com/ai/googles-ai-mode-now-books-your-event-tickets-and-beauty-appointments-for-you)
- [Reported] BrightLocal recommends that businesses claim and maintain Google Business Profile and Yelp, get listed on general and industry directories, and make their own website "clearly describe" the business, locations and services. — [BrightLocal, 2026-08-26](https://www.brightlocal.com/resources/ai-directory-sources/)
- [Claimed] A calendar vendor argues that "when no single source is authoritative, the organization that publishes the most complete, current calendar wins the attention". — [Seeker.io](https://seeker.io/blog/what-is-a-community-events-calendar/)

### Inferences

**Where places and events sites need something different from generic content sites** [Speculative]:
- **Facts expire on a calendar.** A generic article goes stale slowly; a market page is wrong on a known date. Mark every fact with its year, a "verified on" date, and a state: announced, not announced, cancelled, or postponed. Use the matching `eventStatus` in markup.
- **The authoritative record lives on platforms the site does not own** (Google Maps, Yelp, Apple). Generic sites only compete on content. A places site also has to keep those third-party records correct.
- **Negative facts carry the answer.** "Closed 25 Dec" or "not open Mondays" decides the user's plan, yet most sources leave it implicit.
- **Markup rules differ.** Event markup has strict eligibility: no business hours as events, and a separate Event for each performance. A market open for weeks sits at the edge of these rules. Mark the season as one multi-day Event with `startDate`/`endDate`, not one Event per opening day, and put daily hours in the visible text. This is an interpretation, because Google's docs do not address multi-week markets.
- **The question is often a comparison across many places** ("which markets are open on 26 Dec"). No single organiser page can answer it, which is the opening for an aggregator.

**For Mercaditos (Berlin Christmas markets)** [Speculative]:
- Publish season dates, and opening times for each day including 24/25/26/31 Dec, in German, English and Spanish, with Event plus Place markup. Germany (German) is a supported event-experience region. English and Spanish pages about German events may not qualify for that experience, but they still serve AI retrieval (see Q6).
- Do not try to claim Google Business Profiles for markets Mercaditos does not run; that is prohibited. Instead:
  - suggest edits to existing Maps entries, especially special hours for the holidays;
  - add missing markets only if they "re-open in the same location";
  - encourage organisers to claim their profiles and set special hours.
- Optionally add OSM `xmas:*` tags. This is a public good with uncertain AI benefit.
- Create Wikidata items only for markets with "serious and publicly available references", for example ones with press coverage or a Wikipedia article.

**For The Cultural Club (Barcelona events)** [Speculative]:
- Use Event markup with `eventStatus`, `offers` and `performer` on Spanish pages. Spain (Spanish) is listed; Catalan is not.
- For ticketed events, link to the ticketing partner's event page so that assistants with ticketing apps and the site agree on dates and prices.

### Gaps
- Not verified: Google Business Profile event posts as an input to AI answers, and whether AI Overviews or AI Mode read Event structured data at all. Another researcher covers machine-readable data.
- Which third-party event publishers feed Google's event experience (Eventbrite and others) is not listed on the fetched page.
- Bing Places' rules for third-party edits, and whether Apple Business has any events feature, were not verified.
- Whether Catalan-language pages are eligible for Google's event experience: Catalan is not in the listed regions and languages, and it was not tested.
- Wikidata's exclusion criteria (for promotional or business items) were not fetched.

## 5. Are there examples of niche event or venue sites that became the cited source in assistants for their niche, and what did they do?

### Takeaway
No documented case was found of a niche event or venue site that became the source assistants cite for its niche. The closest evidence is category-level. Cruise Critic, an enthusiast reviews community, is reported as the most-cited domain for cruise lines. OpenTable, Time Out, Eater and Wanderlog appear among cited local sources. First-party and official sites dominate factual local questions. The case studies that do exist for events calendars measure traffic, not AI citations.

### Cited Findings
- [Reported, vendor] cruisecritic.com was the most-cited domain in six of seven cruise-line reports, and Tripadvisor led for hotel chains. — [Gradial](https://gradial.com/blog/travel-hospitality-geo-industry-research)
- [Reported] OpenTable shows up as a category platform for restaurants: about 1.5% of AI Mode and about 5.6% of ChatGPT citations, and 6.6% of restaurant citations. Time Out, Eater, Wanderlog and Expedia appear in the overall cited list. — [BrightLocal, 2026-08-26](https://www.brightlocal.com/resources/ai-directory-sources/)
- [Reported] Two events-calendar case studies report growth but do not break out AI referrals. A publisher's calendar drew more than 16,000 event pageviews in its first two months. A destination organisation's community-events calendar was built on Localist. — [Leaky Paywall / Salem Reporter](https://leakypaywall.com/local-calendar-drives-engagement/); [Concept3D / Explore Gwinnett](https://concept3d.com/use-cases/case-studies/explore-gwinnett/)
- [Reported] When AI tools repeated a false claim about cancelled German markets (2025), the correcting sources were official tourism offices, city market sites and the national tourist board's finder, not aggregators. — [Annie Lab, 2025-11-14](https://annielab.org/2025/11/14/analysis-most-german-christmas-markets-to-open-as-planned-in-2025/)

### Inferences
- [Speculative] The category winners (Cruise Critic, Tripadvisor, OpenTable, Yelp) share three traits:
  - structured coverage across their whole category, rather than single articles;
  - a stable page for each entity (each ship, venue or restaurant) that is updated continuously;
  - user-generated or first-hand evidence that the official site does not have.

  For a niche events site, the analogue is one durable URL per market or venue, with the current edition's facts updated in place and an archive of past editions. A new URL each year would split the signals.
- [Speculative] In a city niche, the competitors for citation are official sources (berlin.de, visitBerlin, the German National Tourist Board finder, organiser sites) more than other aggregators. To win, the site has to be more complete, more current or more readable than those sources, especially in languages they do not cover.

### Gaps
- No case study, server-log analysis or vendor report was found that shows a niche events or venue site gaining citations or referrals from ChatGPT, Perplexity, Gemini or AI Overviews. This should be measured directly (another researcher covers measurement).
- It is unknown which sources assistants currently cite for "Berlin Christmas markets 2026" or "Barcelona this weekend". A live prompt test was out of scope for this research method.

## 6. Languages: how do assistants handle a question in English about a German or Spanish city whose best sources are in German, Catalan or Spanish, and does publishing the same facts in several languages help?

### Takeaway
The language of the query strongly predicts the language of the sources cited. For non-English prompts, Google AI Overviews cite local-language pages about 85% of the time, ChatGPT about 70%, and Grok about 52%. Academic work finds that English queries pull English sources, sometimes at the cost of relevance. So an English question about Berlin or Barcelona is likely to be answered from English pages if good ones exist, and an English page carrying the facts from official German or Catalan sources is valuable. Vendor data, mainly from a translation vendor, says translated sites gain citations in both languages. No independent study confirms this, and Catalan was not studied at all.

### Cited Findings
- [Reported, measured, vendor] Temso (last updated 2026-04-20) analysed 7,058,891 citations from more than 350,000 responses, in 7 prompt languages, 12 countries and 47 industries, in early 2026. It measured the share of citations whose page language matched the prompt language:

  | Platform | All non-English prompts | German | Spanish |
  |---|---|---|---|
  | Google AI Overviews | 85.4% | 89.8% | 83.4% |
  | Copilot | 76.7% | 75.9% | 83.5% |
  | ChatGPT | 70.2% | 66.0% | 74.6% |
  | Grok | 51.7% | 49.3% | 55.3% |

  AI Mode, Perplexity, Gemini and Claude were not measured, and neither was Catalan. English queries about non-English places were not tested. — [Temso, "Lost in Translation"](https://www.temso.ai/data/-Lost-in-Translation-How-AI-Models-Handle-Local-Language-Sources)
- [Proven, academic, open-weight models] The "Linguistic Nepotism" study (Ki et al.; arXiv Sept 2025; ICML 2026 poster) tested six open-weight models in eight languages. Models "preferentially cite English sources when queries are in English". The bias is stronger for lower-resource languages and for documents in the middle of the context, and models sometimes cite irrelevant English documents over relevant non-English ones. The setup relies on machine translation, and production assistants were not tested. — [arXiv 2509.13930](https://arxiv.org/abs/2509.13930); [ICML 2026 poster](https://icml.cc/virtual/2026/poster/64557)
- [Proven, academic] A 49-language multilingual RAG benchmark found a more mixed picture. Earlier studies on high-resource languages found a preference for query-language and English documents, but "more nuances exist" across 49 languages, and lower-resource languages showed an in-language preference. — [arXiv 2410.01171](https://arxiv.org/pdf/2410.01171)
- [Reported, vendor with a conflict of interest] Weglot (a translation vendor; updated 2026-08-10) reported:
  - for localised Mexico queries, 96% of AI Overview citations and 93% of AI Mode citations were Spanish sources;
  - Spanish queries run from US locations got about 32% Spanish sources, against about 63% through a Mexico City VPN, so the searcher's location also shifts source language;
  - translated sites got "24% more total citations per query", and translation raised visibility for English queries "by up to 327%".

  Some of Weglot's percentages do not follow from its own raw counts: 17,094 against 2,810 is called a "431% gap" but is about 508%. Its explanation that translation signals authority is labelled a hypothesis. — [Weglot](https://www.weglot.com/blog/ai-search-and-language)
- [Reported, measured, vendor] Profound (2026-04-21; 3.25B citations; March 2026) found that "query language matters more than geography" for which social platforms get cited. Reddit, which is English-first, dominates ChatGPT's social citations everywhere, and social citations shrink in non-English markets. This covers social citations only. — [Profound](https://tryprofound.com/blog/how-query-language-reshapes-ai-citations)
- [Reported, preprint, health domain, not fetched] A multi-platform audit found that non-English queries surfaced fewer sources than English ones (mean 9.2 against 12.3). — [arXiv 2609.00319](https://arxiv.org/pdf/2609.00319)
- [Reported] Misinformation about European Christmas markets spreads in English and other languages, while the corrections stay local. The false German cancellation claim spread mainly in English on X and Instagram, but the official corrections were in German from German tourism offices. The Buckingham Palace fake circulated in Thai, Portuguese, Arabic and Armenian. — [Annie Lab, 2025-11-14](https://annielab.org/2025/11/14/analysis-most-german-christmas-markets-to-open-as-planned-in-2025/); [CP24, 2025-11-21](https://www.cp24.com/news/2025/11/21/tourists-baffled-by-ai-buckingham-palace-christmas-market)
- [Proven] Google's event search experience is listed for Germany (German) and Spain (Spanish). It is not listed for German or Spanish in English, nor for Catalan. — [Google Search Central, Event, 2026-09-08](https://developers.google.com/search/docs/appearance/structured-data/event)

### Inferences
- [Speculative] An English question about Berlin Christmas markets will mostly be answered from English pages: AI Overviews about 85% "same language", ChatGPT about 70%, plus the English bias found in the academic work. The official German sources (berlin.de, organiser sites) are then under-cited, even when they are the best record. An accurate, current English page is therefore valuable for this question. The same applies to Spanish-speaking tourists, and to Barcelona, where the official sources are often in Catalan.
- [Speculative] Publishing the same facts in German, English and Spanish probably helps in two ways:
  - each version can be retrieved for queries in its own language;
  - the versions agree with one another, which counts against stray wrong pages.

  The only direct measurement (Weglot) is vendor data with arithmetic problems, so this is likely but not proven. The versions must stay in sync: a stale translation is a source of wrong dates.
- [Speculative] Catalan for The Cultural Club: no study covers it, and Google's event experience does not list it. A reasonable hedge is Catalan for local users plus Spanish and English for retrieval and tourists. This is untested.
- [Speculative] Location shifts source language too: Weglot's US against Mexico City VPN test. A tourist physically in Berlin asking in English may get a different source mix from a trip-planner abroad. Both audiences matter for Mercaditos (see project memory: tourists in the city now, and trip planners).

### Gaps
- No study tested English queries about non-English places, which is the exact Mercaditos and The Cultural Club scenario.
- No data exists on Catalan, or on whether AI Mode, Perplexity, Gemini or Claude favour sources in the query's language.
- No independent, non-vendor test was found of whether multilingual versions of the same site increase citations. The only data is Weglot's, and Weglot sells translation.
- How hreflang or localised URLs are treated by AI retrieval specifically, as opposed to classic search, was not found. Another researcher covers crawling and machine-readable data.
