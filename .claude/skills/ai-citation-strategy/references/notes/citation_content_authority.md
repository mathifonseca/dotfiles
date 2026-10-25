# Citation, content and authority: how AI assistants choose the sources they cite

Compiled 2026-10-22. Evidence labels on every finding:
**[Proven]**: the platform's own documentation (this proves what the platform *says*, not that the system behaves that way), or a measured study with a stated method. Each one says whether it is peer-reviewed or a preprint.
**[Reported]**: industry data with known limits (vendor or tracker studies, often selling the tool used).
**[Claimed]**: an assertion without data, or a figure whose method I could not see.
**[Speculative]**: my inference or an unconfirmed explanation.
Dates are publication dates. "FLAG" marks anything likely to be stale: in this field, shares and behaviours have moved by tens of points within a single month (see Q2).

## Q1. What do academic studies show? GEO (Aggarwal et al., KDD 2024) and its follow-ups, replications and critiques

### Takeaway
The "GEO boosts visibility up to 40%" result is real only inside its lab setup: a page already sitting in a fixed five-document context, scored by an LLM-based metric. Larger replications (C-SEO Bench, NeurIPS 2025; SAGEO 2026; E-GEO 2025) find that most fixed "GEO tricks" are null or negative and shrink as more sites adopt them. A July 2026 critical survey of about 45 studies rates topical relevance and position as the dependable levers, and gives low confidence that any white-hat content tactic durably raises organic citations across engines.

### Cited Findings

#### The original GEO paper
- **[Proven: peer-reviewed, lab setting]** Aggarwal et al., "GEO: Generative Engine Optimization" (arXiv Nov 2023; KDD Aug 2024).
  - **Setup:** GEO-bench has 10,000 queries. For each query, the top 5 Google results go to GPT-3.5-turbo. One source is rewritten with one of nine strategies and compared with its original. Visibility is measured as Position-Adjusted Word Count (pawc) and an LLM-judged "Subjective Impression".
  - **Results** (pawc / Subjective Impression, against a 19.3 / 19.3 baseline):
    - Quotation Addition: 27.2 / 24.7
    - Statistics Addition: 25.2 / 23.7
    - Fluency: 24.7 / 21.9
    - Cite Sources: 24.6 / 21.9
    - Keyword Stuffing: 17.7 / 20.2, below baseline on pawc.
  - Sources: [GEO paper, arXiv 2311.09735](https://arxiv.org/abs/2311.09735), re-tabulated in [Martinez, "Optimizing Visibility in Generative Engines: A Critical Survey of GEO (2023–2026)", arXiv 2607.14035, 15 Jul 2026](https://arxiv.org/html/2607.14035v1).
- **[Proven: re-analysis]** The "up to 40%" headline is pawc rising from 19.3 to 27.2 (about 41% relative), on one metric under one configuration. The survey lists "GEO increases visibility by 40%" as "**Rejected as a general claim**" — [Martinez survey, Jul 2026](https://arxiv.org/html/2607.14035v1)
- **[Proven: peer-reviewed, lab setting]** The gains are zero-sum and favour low-ranked sources. Under Cite Sources, the 5th-placed source gained 115.1% while the 1st lost 30.3% — [Martinez survey, Jul 2026](https://arxiv.org/html/2607.14035v1)
- **[Proven: peer-reviewed, weak external test]** The "real engine" test on Perplexity used 200 examples, with texts *uploaded as files rather than retrieved*. Gains were up to 22% on pawc and 37% on Subjective Impression — [Martinez survey, Jul 2026](https://arxiv.org/html/2607.14035v1)
- **[Proven: critique]** The survey's objections to GEO's validity:
  - The source is already in a fixed five-document context, so retrieval is never tested.
  - No user study shows that earlier citations get more attention.
  - The judge is an LLM from the same family.
  - Added statistics and references face no truthfulness check.
  - No clicks, traffic or purchases are observed.
  - The engine is a snapshot.

  Source: [Martinez survey, Jul 2026](https://arxiv.org/html/2607.14035v1)

#### Replications, follow-ups and critiques (2024–2026)
- **[Proven: peer-reviewed]** C-SEO Bench (Puerto et al., arXiv Jun 2025; NeurIPS 2025 Datasets & Benchmarks).
  - **Scale:** about 1,900 queries, 6 domains, 2 tasks (question answering and product recommendation), 16,360 documents.
  - **Effect:** only 3 of 54 method–domain combinations were significantly positive, and none in question answering. The later version says the methods "frequently have a negative impact on document ranking".
  - **What beats it:** "traditional SEO strategies, those aiming to improve the ranking of the source in the LLM context, are significantly more effective".
  - **Adoption:** gains decrease as more actors adopt C-SEO, a "congested and zero-sum" problem.
  - Sources: [arXiv 2506.11097](https://arxiv.org/abs/2506.11097), [NeurIPS 2025 poster](https://neurips.cc/virtual/2025/poster/121465), [Martinez survey](https://arxiv.org/html/2607.14035v1).
- **[Proven: preprint]** E-GEO (Bagga et al., arXiv Nov 2025, e-commerce): 10 of 15 initial heuristics were neutral or negative, and systematically optimized rewrites did better. The authors call current GEO practice "largely heuristic" — [E-GEO, arXiv 2511.20867](https://arxiv.org/pdf/2511.20867); [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: preprint]** SAGEO Arena (Kim et al. 2026, arXiv 2602.12187) tested the full pipeline (retrieval, then reranking, then citation) over 171,003 documents and 2,700 queries. Body-only optimization lowered presence at each stage: top-20 by about 9%, top-10 after reranking by 16%, final citation by 6%. The survey cites this as evidence that citation-oriented rewrites can **hurt retrieval upstream** — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: preprint, SIGIR 2026]** Vishwakarma, Kumar & Jamidar, "What Gets Cited: Competitive GEO in AI Answer Engines" (arXiv 25 May 2026). Method: 252,000 controlled two-document trials, 6 LLMs, 18 content factors, brands anonymized, order counterbalanced, mixed-effects models.
  - "topical relevance and list position are the biggest drivers of being cited first"
  - "Including explicit price information and a recent timestamp also helps consistently"
  - completeness and trust cues give smaller gains
  - "formatting-only edits have little impact"

  Source: [arXiv 2605.25517](https://arxiv.org/abs/2605.25517). Per-factor effect sizes are not in the abstract.
- **[Proven: peer-reviewed]** Wan, Wallace & Klein, "What evidence do language models find convincing?" (ACL 2024, ConflictingQA): models favour documents relevant to the question over credibility cues such as scientific references or a neutral tone — [Martinez survey summary](https://arxiv.org/html/2607.14035v1); DOI 10.18653/v1/2024.acl-long.403
- **[Proven: peer-reviewed]** AutoGEO (Wu et al. 2026), a learned rewriting method: +35.99% average improvement, but conditional on five already-retrieved documents (still in-context only) — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: peer-reviewed/preprint]** Manipulation works in-context:
  - Indirect prompt injection raised a target about 3 ranks on the Perplexity Sonar API (Pfrommer et al., EMNLP 2024).
  - The recommendation rate for a fictitious camera rose from 34.0% to 59.4% (Nestaas et al., ICLR 2025).
  - Strategic text sequences worked in a fictitious catalog (Kumar & Lakkaraju 2024, arXiv 2404.07981).
  - On the defence side, GRADA cuts attack success by up to about 80%.

  Source: [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: preprint, observational]** Chen, Wang, Chen & Koudas (University of Toronto), "Generative Engine Optimization: How to Dominate AI Search" (arXiv 10 Sep 2025) report a "systematic and overwhelming bias towards Earned media" in AI search (numbers in Q4). The survey classes it as observational and industry-supported — [arXiv 2509.08919](https://arxiv.org/abs/2509.08919); [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: survey confidence table]** The survey rates the field's claims in five tiers ([Martinez survey, Jul 2026](https://arxiv.org/html/2607.14035v1)):
  - **High confidence:**
    - a document already in the context can causally change its rank or citation (says nothing about organic retrieval)
    - query–document relevance and position in the context are major determinants
    - commercial engines differ and vary over time
    - retrieved documents are an attack surface
  - **Moderate confidence:**
    - extractable evidence and suitable structure often help, depending on intent, engine and factuality
    - learned or optimized methods beat fixed heuristics
    - competition erodes gains
  - **Low confidence:** a white-hat intervention durably improves organic discoverability across engines.
  - **Very low confidence:** citation scores predict clicks, conversions or revenue.
  - **Rejected as a general claim:** "GEO increases visibility by 40%".
- **[Proven: survey recommendations]** ([Martinez survey](https://arxiv.org/html/2607.14035v1))
  - Make pages relevant, comprehensive, verifiable, clearly structured and technically retrievable.
  - Add "relevant, verifiable, dated, and properly attributed evidence". Do not simply "add numbers": fabricated statistics may raise reuse while degrading accuracy.
  - Avoid keyword stuffing (null or negative across benchmarks).
  - Do not treat fluency or an authoritative tone as evidence.
  - Keep pages free of hidden model-directed instructions.
- **[Claimed]** A marketing site says the Aggarwal paper suffered a "replication collapse" at NeurIPS 2025 and KDD 2026. The NeurIPS part matches C-SEO Bench. I could not verify a KDD 2026 replication — [Hobo Web](https://www.hobo-web.co.uk/what-is-generative-engine-optimization-geo-a-geo-first-framework-debunked/)

### Inferences
- **[Speculative]** The research supports two levers. The first is being *retrieved at all*, which is ordinary search ranking in each engine's underlying index; C-SEO found that improving a source's rank beats rewriting it. The second is precise topical relevance to the question asked. "Add quotes/stats" tricks are second-order, measured mostly in-context, and shrink with adoption.
- **[Speculative]** The one controlled result that touches time-sensitive pages applies directly to market and event pages: explicit prices and a recent timestamp help consistently (Vishwakarma 2026). For Mercaditos that means the entry fee (free / paid / ticket) and a clear "updated" date. For The Cultural Club it means ticket prices and an update date on event pages.
- **[Speculative]** Every benchmark is English-centric and built on product or general-QA queries. Nothing in this literature tests local places, dated events or German/Spanish content, so transfer to Mercaditos and The Cultural Club is unproven.

### Gaps
- No academic study tests local, places, event or seasonal (Christmas-market-type) queries, or multilingual DE/ES/CA content.
- Vishwakarma's per-factor effect sizes (for example, how much a timestamp helps) are in the full paper, which I did not read; I have only the abstract.
- I read Kirsten, Grossman, Schulte, Sharma and others only through the survey's summaries, not the primary papers.
- I could not verify the "KDD 2026 replication" claim.

## Q2. What do large industry datasets show about cited sources, overlap with organic rankings, and differences between engines?

### Takeaway
The trackers agree on direction but not on magnitude.
- **Concentration:** assistants concentrate citations on a few third-party platforms: Wikipedia and Reddit for ChatGPT; Reddit, YouTube, Quora and LinkedIn for Google AI Overviews; Reddit plus review sites for Perplexity. Those shares swing by tens of points after unannounced model or pipeline changes (Sep 2025, May 2026).
- **Decoupling from rankings:** Google AI Overview citations have come loose from the top 10. Ahrefs found 76% overlap in Jul 2025 and about 38% in early 2026 (with a changed parser). Academic audits put more than half of cited domains outside the top 10.
- **Instability:** answers are unstable between runs. A repeated prompt almost never yields the same list.

### Cited Findings

#### Source shares (Reddit, Wikipedia, YouTube, news, brand sites)
- **[Reported]** Profound, "AI Platform Citation Patterns" (5 Jun 2025, updated Aug 2025): 680M citations from ChatGPT, Google AI Overviews and Perplexity, Aug 2024 – Jun 2025; query mix not disclosed. No brand sites appear in any top-10 list. FLAG: predates the Sep 2025 shift — [Profound](https://www.tryprofound.com/blog/ai-platform-citation-patterns)

  | Platform | Share of all citations | Share within the platform's top-10 sources |
  |---|---|---|
  | ChatGPT | Wikipedia 7.8%, Reddit 1.8%, Forbes 1.1%, G2 1.1% | Wikipedia 47.9%, Reddit 11.3% |
  | AI Overviews | Reddit 2.2%, YouTube 1.9%, Quora 1.5%, LinkedIn 1.3% | Reddit 21.0%, YouTube 18.8%, Quora 14.3%, LinkedIn 13.0%, Wikipedia 5.7% |
  | Perplexity | Reddit 6.6%, YouTube 2.0%, Gartner 1.0%, Yelp 0.8%, TripAdvisor 0.6% | Reddit 46.7%, YouTube 13.9%, Yelp 5.8%, TripAdvisor 4.1% |

- **[Reported]** Semrush, "The Most-Cited Domains in AI: A 3-Month Study" (10 Nov 2025): more than 230,000 prompts and 100M citations, weekly from 14 Jul to 12 Oct 2025, covering ChatGPT search, AI Mode and Perplexity. The metric appears to be the share of responses citing a domain. Prompt composition is not disclosed. Semrush sells AI-visibility tools — [Semrush](https://www.semrush.com/blog/most-cited-domains-ai/)
  - **ChatGPT, Reddit:** cited in about 60% of responses in early Aug 2025, down to about 10% by mid-Sep.
  - **ChatGPT, Wikipedia:** about 55% of responses, down to under 20%.
  - **Timing:** the drop coincided with Google removing the `num=100` parameter around 11 Sep 2025. The cause is unproven; a Semrush analyst doubts that was the sole cause.
  - **ChatGPT gainers after the drop:** PR Newswire, Forbes (roughly doubled) and Medium.
  - **AI Mode:** the most stable mix, favouring Google-owned properties (Google, Google Blog). LinkedIn appears in about 15% of responses. YouTube, Reddit and Facebook are growing.
  - **Wikipedia on other engines:** about 2–3% on AI Mode and 0.8% on Perplexity, both stable.
- **[Reported]** SISTRIX data via Search Engine Journal (2 Jun 2026): 3.8M German-language ChatGPT responses, comparing four days before and after a 22–23 May 2026 model change (GPT-5.5). German market only, vendor tool, correlation only — [SEJ](https://www.searchenginejournal.com/chatgpt-citations-changed-after-gpt-5-5-sistrix-data-shows/577694/)
  - **Volatility:** daily citation-pattern change jumped from the usual 1–2% to 47%.
  - **Sources per answer:** fell from 30.9 to 28.4.
  - **Reddit:** +59%, already the top domain.
  - **German publishers:** welt.de +99%, faz.net +124%.
  - **Map sources:** openstreetmap.org +83%, mapbox.com +83%.
  - **International aggregators:** Tripadvisor −53%, Expedia −60%, Rome2rio −60%.
  - **Global platforms:** Wikipedia −14%, YouTube −18%, google.com −22%.
- **[Reported]** Ahrefs, summarized in a sponsored SEJ post (18 Aug 2026), from 1.4M ChatGPT prompts: 88.46% of ChatGPT citations came from the general search index. News was 12.01%, Reddit 1.93%, YouTube 0.51% and academia 0.40%. The categories add up to more than 100%, so they overlap — [SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)
- **[Reported]** Ahrefs (about Feb/Mar 2026): YouTube is now the single most-cited domain in AI Overviews. Of AI Overview–cited pages that do not rank in the top 100, 18.2% are YouTube URLs — [Ahrefs](https://ahrefs.com/blog/ai-overview-citations-top-10/) via [SEJ coverage](https://www.searchenginejournal.com/google-ai-overview-citations-from-top-ranking-pages-drop-sharply/568637/)
- **[Reported]** Seer Interactive (24 Jul 2026), covering four brands' non-branded prompts: the author estimates owned (brand) content is about 2% of what gets cited — [Seer](https://www.seerinteractive.com/insights/study-content-recencys-impact-on-ai-visibility-in-2026)
- **Conflict:** "Reddit's share of ChatGPT citations" ranges from 1.8% (Profound 2025, share of all citations) through 1.93% (Ahrefs) to about 60% then 10% (Semrush 2025, share of responses). The trackers use different metrics, periods and prompt sets, so their numbers are not comparable.

#### Overlap between AI citations and top organic rankings
- **[Reported]** Ahrefs (21 Jul 2025): 1.9M citations from 1M AI Overviews, counting the top 3 citations in each. 76.10% ranked in the top 10, 9.50% at positions 11–100 and 14.40% beyond 100. FLAG: superseded — [Ahrefs](https://ahrefs.com/blog/search-rankings-ai-citations/)
- **[Reported]** Ahrefs update (about late Feb/Mar 2026): 863K SERPs and 4M AI Overview URLs.
  - 37.9% of cited pages were in the top 10 (37.1% counting organic listings only), 31.2% at positions 11–100 and 31.0% beyond 100.
  - Ahrefs says its parsing improved, so the two datasets are **not directly comparable**.
  - It points to query fan-out as a driver; Google has not confirmed this.
  - BrightEdge, using a different dataset, reports about 17%.

  Sources: [Ahrefs](https://ahrefs.com/blog/ai-overview-citations-top-10/); [SEJ coverage](https://www.searchenginejournal.com/google-ai-overview-citations-from-top-ranking-pages-drop-sharply/568637/)
- **[Reported]** seoClarity via Search Engine Land, 36,000 keywords: at least one AI Overview–cited source matched a top-10 organic result 99.5% of the time. This is a per-answer "any match" metric, not per citation. FLAG: probably 2024 (date not verified) and outdated — [Search Engine Land](https://searchengineland.com/google-ai-overviews-organic-results-overlap-99-445374)
- **[Proven: preprint]** Kirsten et al. (Ruhr-Universität Bochum and MPI-SWS), "Characterizing Web Search in The Age of Generative AI" (arXiv 13 Oct 2025, revised 31 May 2026), 4,706 queries.
  - 53% of AI Overview–cited domains are outside the organic top 10, and 27% are outside the top 100.
  - Page overlap across two months is 18% for AI Overviews versus 45% for organic results.
  - At temperature zero, repeated runs change 9–28% of decisions.

  Sources: [arXiv 2510.11560](https://arxiv.org/abs/2510.11560); [Martinez survey](https://arxiv.org/html/2607.14035v1); [t3n](https://t3n.de/news/ki-suche-statt-google-forscher-chatbots-hinterherhinken-1713796/)
- **[Proven: peer-reviewed, IMC 2026]** Xu, Iqbal & Montgomery, "Measuring Google AI Overviews" (arXiv 13 May 2026, v2 1 Oct 2026): 55,393 trending queries, 13 Mar – 21 Apr 2026. Nearly 30% of cited domains do not appear in the co-displayed first-page results — [arXiv 2605.14021](https://arxiv.org/abs/2605.14021)
- **[Proven: forthcoming]** Grossman et al. 2026: 11,500 queries. URL-level Jaccard similarity between organic Google, AI Overviews and Gemini is only 0.11–0.18 — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: preprint]** Toronto study (Sep 2025), GPT versus Google domain overlap:
  - **Product categories:** 20–50% overlap in the top 10. Laptops 41%, smartphones 20%, electric cars over 50%.
  - **Local-service categories:** home cleaning 20.6%, roofing 17.1%, tax preparation 15.4%, dentists 11.9%, auto repair 2.5%, IT support 0.1%.

  Source: [arXiv 2509.08919](https://arxiv.org/html/2509.08919)
- **[Reported]** Claude's search runs on Brave.
  - Anthropic added Brave Search to its subprocessor list on 19 Mar 2025, and Simon Willison replicated the behaviour.
  - A commercial GEO firm tested 1,481 matched queries over 10 weeks in summer 2026: 87.8% of the URLs Claude retrieved were in Brave's top 10, against 45.6% in Google's top 10.
  - Profound re-ran its own test on about 400 queries and got 79.2%.

  Vendor data. Sources: [CompleteSEO](https://completeseo.com/claude-web-search-runs-on-brave/); [Xponent21](https://xponent21.com/insights/claude-web-search-brave-turbopuffer/)

#### Engine-to-engine overlap, stability and activation
- **[Proven]** Cross-engine overlap is low. In Li & Sinnamon 2024, only 26% of the 355 unique domains in 672 Bing and Perplexity responses were cited by both — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Claimed]** Unverified competitor figures: 11% domain overlap between ChatGPT and Perplexity, and 21.87 citations per Perplexity response against 7.92 for ChatGPT — [llmpulse](https://llmpulse.ai/blog/glossary/platform-citation-patterns-in-ai/)
- **[Reported]** SparkToro with Gumshoe (published about Jan/Feb 2026; data Nov–Dec 2025): 12 prompts run 60–100 times each on ChatGPT, Claude and Google's AI (about 2,961 runs).
  - The chance of an identical brand list was under 1 in 100, and about 1 in 1,000 in the same order.
  - Claude was slightly more repeatable.
  - How often a brand appeared was more stable than its rank, so the authors suggest visibility percentage as the metric.
  - Not peer-reviewed.

  Sources: [SEJ](https://www.searchenginejournal.com/ai-recommendations-change-with-nearly-every-query-sparktoro/566242); [Search Engine Land](https://searchengineland.com/ai-recommendation-lists-rarely-repeat-study-468076)
- **[Reported]** Ahrefs tracked 43,000 keywords for a month, checking each AI Overview 16+ times. Wording changed 70% of the time, brands 46% and cited sources 45.5%, while meaning stayed similar (cosine similarity 0.95) — [SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)
- **[Proven: forthcoming]** Schulte et al. 2026: daily source-level Jaccard of about 0.34–0.42, and 57.8% of repeated ChatGPT runs did not trigger web search. The survey suggests 7–8 repetitions per prompt as a minimum — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: peer-reviewed]** AI Overviews appeared on 13.7% of 55,393 trending queries, rising to 64.7% for question-form queries — [Xu et al., arXiv 2605.14021](https://arxiv.org/abs/2605.14021)
- **[Reported]** SparkToro (8–9 Jun 2026), Jan–Apr 2026 data: AI Overviews appeared on over 20% of Google searches, AI Mode handled 0.34% of searches, and 68.01% of searches ended with zero clicks — [SparkToro](https://sparktoro.com/blog/in-2026-less-than-one-third-of-google-searches-still-send-a-click/), via [Something Inc review](https://somethinginc.com/blog/2026-ai-citation-data-review/)
- **[Reported, secondary]** Profound data (22 Jul 2026): Claude invoked live web search for only 36.6% of tested prompts — [CompleteSEO / Xponent21 summaries](https://completeseo.com/claude-web-search-runs-on-brave/)
- **[Reported]** Kevin Indig, Growth Intelligence Brief #21 (10 Jul 2026): about 6.0M AI mentions per week. Over eight weeks, AI Overview mentions fell 3.2%, AI Mode rose 22.5% and ChatGPT fell 28.4% — [Growth Memo](https://www.growth-memo.com/p/growth-intelligence-brief-21)
- **[Reported]** Traffic context from Ahrefs Web Analytics (76,000 sites, Dec 2025): Google sent about 190 times more traffic than ChatGPT (39.98% versus 0.21% of site traffic) — [SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)

#### Per-engine snapshot (as of Oct 2026, from the sources above)
- **ChatGPT**
  - **Retrieval:** citations come mostly from the general search index (88.46%, [Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)). OpenAI says it "leverages third-party search providers, as well as content provided directly by our partners" (2024 launch material, quote via secondary; see Q6).
  - **Volatility:** the most volatile source mix, shown by the Sep 2025 Reddit/Wikipedia collapse ([Semrush](https://www.semrush.com/blog/most-cited-domains-ai/)) and the May 2026 GPT-5.5 shift ([SISTRIX/SEJ](https://www.searchenginejournal.com/chatgpt-citations-changed-after-gpt-5-5-sistrix-data-shows/577694/)).
  - **Freshness:** the most freshness-biased engine in 2025 ([Ahrefs](https://ahrefs.com/blog/do-ai-assistants-prefer-to-cite-fresh-content/)).
  - **Search activation:** often answers without searching (57.8% of repeated runs; [survey](https://arxiv.org/html/2607.14035v1)).
- **Google AI Overviews**
  - **Retrieval:** from Google's index through core ranking systems ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)).
  - **Ranking overlap:** about 38% top-10 overlap ([Ahrefs](https://ahrefs.com/blog/ai-overview-citations-top-10/)).
  - **Cited domains:** YouTube is the top cited domain. Reddit, Quora and LinkedIn are heavy in its top 10 ([Profound](https://www.tryprofound.com/blog/ai-platform-citation-patterns)).
  - **Freshness:** the least freshness-biased engine ([Ahrefs](https://ahrefs.com/blog/do-ai-assistants-prefer-to-cite-fresh-content/)).
  - **Source quality:** cites more credible domains than the co-displayed first page ([Xu et al.](https://arxiv.org/abs/2605.14021)).
- **Google AI Mode**
  - **Sources:** favours Google-owned properties and LinkedIn (about 15% of responses), plus growing YouTube and Reddit; the most stable top-domain mix ([Semrush](https://www.semrush.com/blog/most-cited-domains-ai/)).
  - **Usage:** small share of searches (0.34%) but fast-growing mentions (+22.5% in 8 weeks) ([Something Inc review](https://somethinginc.com/blog/2026-ai-citation-data-review/)).
- **Gemini**
  - **Freshness:** the most recency-biased in Seer's 2026 sample, with 78% of cited pages updated within a year ([Seer](https://www.seerinteractive.com/insights/study-content-recencys-impact-on-ai-visibility-in-2026)).
  - **Sourcing quality:** the worst sourcing in the EBU/BBC study, with significant issues in 76% of responses ([journalism.co.uk](https://www.journalism.co.uk/nearly-half-of-ai-generated-answers-contain-an-error-ebu-bbc-report/)).
  - **Overlap with Google:** URL Jaccard with organic Google and AI Overviews of only 0.11–0.18 ([survey](https://arxiv.org/html/2607.14035v1)).
- **Perplexity**
  - **Sources:** Reddit-heavy (46.7% top-10 share), with Yelp and TripAdvisor in its top 10 ([Profound](https://www.tryprofound.com/blog/ai-platform-citation-patterns)).
  - **Freshness:** the least recency-biased of the three engines in Seer's sample (65%) ([Seer](https://www.seerinteractive.com/insights/study-content-recencys-impact-on-ai-visibility-in-2026)).
  - **Accuracy:** answered 37% of Tow Center queries wrongly, reported as the best of the eight tools tested, against Grok 3 at 94% ([Fortune](https://fortune.com/2025/03/18/ai-search-engines-confidently-wrong-citing-sources-columbia-study)).
- **Copilot**
  - **Retrieval:** grounded in Bing. The Bing AI Performance report shows citations and "grounding queries" ([Search Engine Land](https://searchengineland.com/bing-webmaster-tools-testing-new-ai-performance-report-468039)).
  - **Freshness:** cited pages averaged 1,056 days since publication, against 1,416 for organic results ([Ahrefs](https://ahrefs.com/blog/do-ai-assistants-prefer-to-cite-fresh-content/)).
- **Claude**
  - **Retrieval:** Brave index (79–88% of retrieved URLs are in Brave's top 10, vendor tests).
  - **Search activation:** searches on only about 37% of prompts (secondary).
  - **Stability:** the most stable across languages ([Toronto](https://arxiv.org/html/2509.08919)) and slightly more repeatable lists ([SparkToro coverage](https://www.searchenginejournal.com/ai-recommendations-change-with-nearly-every-query-sparktoro/566242)).

### Inferences
- **[Speculative]** Each engine's gate is a different index: Google for AI Overviews, AI Mode and Gemini; Bing for Copilot and largely ChatGPT; Brave for Claude. Being well indexed and ranking in all three for the sub-questions people ask is the prerequisite. Ranking top-10 for the exact head query is no longer required in AI Overviews. Pages that rank for the sub-questions a query fans out into (for example "are Berlin Christmas markets open on 24 December?") can be pulled in, but that mechanism is unconfirmed.
- **[Speculative]** In German-language ChatGPT after GPT-5.5, local publishers and map sources gained while international travel aggregators (Tripadvisor, Expedia) lost. That is a possible opening for a German-language local specialist like Mercaditos. It is one market and one vendor, and the next model change could reverse it.
- **[Speculative]** For places and things-to-do queries, Perplexity leans on Reddit and review platforms (Yelp, TripAdvisor). Presence there matters more for Perplexity than for ChatGPT or Google.
- **[Speculative]** Because answers churn (45.5% of AI Overview sources swap within a month; under 1% identical lists), any single check of "are we cited?" is noise. Measurement belongs to another researcher, but these notes should not report single-run results as findings.

### Gaps
- I found no public dataset of citation sources for Christmas-market, festival or "things to do in Barcelona/Berlin" queries specifically.
- Data on the Gemini app and Copilot source shares is thin, and data on Claude comes only from vendors.
- Profound, Semrush and Ahrefs do not disclose prompt composition, so their figures cannot be reconciled.
- I did not read the Ahrefs 38% study's methodology section directly; I have its title page plus secondary coverage. BrightEdge's 17% figure is second-hand.

## Q3. Which content traits correlate with being cited, and which correlations come from measured studies rather than opinion?

### Takeaway
Measured evidence supports these traits:
- precise topical relevance;
- answers placed early on the page (ChatGPT);
- recently *updated* pages and explicit recent timestamps;
- explicit concrete facts such as prices.

Evidence is weak, null or negative for:
- formatting-only changes;
- adding schema markup (a causal test found no lift);
- keyword stuffing;
- generic "add statistics and quotes" outside the lab.

The effects of length, tables and unique first-party data rest on opinion or platform statements, not measurement.

### Cited Findings

#### Answering early (first lines)
- **[Reported]** Kevin Indig, Growth Memo (16 Feb 2026): 1.2M search results, 18,012 verified ChatGPT citations.
  - About 44.2% came from the first 30% of a page's text, about 31% from the middle and about 25% from the final third (the "ski ramp").
  - Within paragraphs, citations came more often from the middle (about 53%).
  - Newsletter study, partly paywalled; sample descriptions vary between write-ups.

  Sources: [Growth Memo](https://www.growth-memo.com/i/188121887/3-entity-richness); [Scalevise summary](https://scalevise.com/resources/llm-citation-study-front-load-content/); [marketing4ecommerce](https://marketing4ecommerce.net/en/ai-focuses-on-the-first-part-of-your-content/)
- **[Claimed]** A separate, unnamed study reportedly found 74.8% of AI Mode and Gemini citations in the first half of a page and 46.1% in the first 30%. No primary source — [marketing4ecommerce](https://marketing4ecommerce.net/en/ai-focuses-on-the-first-part-of-your-content/)
- **[Proven: platform doc, via secondary]** Bing's rewritten Webmaster Guidelines (Feb 2026) advise stating facts directly, using clear and consistent entity names, focusing each URL on one topic, and placing essential information near the top. Single-topic pages are described as more likely to be selected for grounding — [SEJ, 27 Feb 2026](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/)
- **[Proven: platform doc]** Google says the opposite on structure (May 2026): "There's no requirement to break your content into tiny pieces for AI to better understand it" and "You don't need to write in a specific way just for generative AI search" — [Google AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)

#### Explicit dates, "last updated" and freshness
- **[Reported]** Ahrefs (28 Jul 2025): about 17M cited URLs (16.975M) from ChatGPT, Perplexity, Gemini, Copilot and AI Overviews, compared with organic Google.
  - AI-assistant citations averaged 1,064 days since publication against 1,432 for organic results (25.7% "fresher").
  - Since last update: 909 days against 1,047 (13.1%).
  - Google AI Overviews were the *least* freshness-biased.
  - The average cited page is still about 2.9 years old: "AI assistants still prefer citing long-lived content".
  - The article cites Google's John Mueller warning against changing publish dates without real edits.
  - The source contains internal number inconsistencies.

  Source: [Ahrefs](https://ahrefs.com/blog/do-ai-assistants-prefer-to-cite-fresh-content/)
- **[Reported]** Seer Interactive (24 Jul 2026): 7,683 dated pages and 47,097 citations, Mar–Jun 2026, ChatGPT, Gemini and Perplexity, four brands. Dates were read from schema, sitemaps and headers; a *visible* date was not tested — [Seer](https://www.seerinteractive.com/insights/study-content-recencys-impact-on-ai-visibility-in-2026)
  - **Recency of updates:** 75% of cited pages were updated within a year and 88% within two years. Only 42% were *published* within a year.
  - **Old URLs, fresh updates:** 27–28% of "fresh" pages were first published more than two years earlier, then updated.
  - **By engine:** Gemini 78%, ChatGPT 73%, Perplexity 65% updated within a year.
  - **By content type:** marketplaces 78%, news/editorial 45%.
  - **Persistence:** pages cited in only one month had a median update age of 0.16 years, against 0.47 years for pages cited in all four months.
- **[Proven: preprint, SIGIR 2026]** A recent timestamp consistently helps a source get cited first in controlled trials — [Vishwakarma et al., arXiv 2605.25517](https://arxiv.org/abs/2605.25517)
- **[Proven: survey]** Recency helps time-sensitive queries, not necessarily stable definitions — [Martinez survey](https://arxiv.org/html/2607.14035v1)

#### Statistics, quotations and citing sources
- **[Proven: in-context only]** GEO found quotations (+41% relative pawc), statistics (+31%) and citing sources (+27%) help when the page is already in the context — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: peer-reviewed]** C-SEO Bench found most rewrite methods ineffective at scale, with 3 of 54 combinations positive — [arXiv 2506.11097](https://arxiv.org/abs/2506.11097)
- **[Proven: preprint]** Explicit price information consistently helps — [Vishwakarma et al.](https://arxiv.org/abs/2605.25517)

#### Tables, lists, page structure and schema
- **[Proven: preprint]** "Formatting-only edits have little impact" — [Vishwakarma et al.](https://arxiv.org/abs/2605.25517)
- **[Proven: preprint]** In SAGEO, structural fields can help *retrieval* without the same effect at reranking or citation. Yu et al. 2026 (arXiv 2603.29979) report structural-feature gains across six engines, with limited validation. The survey rates structure as "moderate and heterogeneous" — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Reported, strongest industry design]** Ahrefs schema test (11 May 2026) — [Ahrefs](https://ahrefs.com/blog/schema-ai-citations/)
  - **Correlation:** across 6M URLs, cited pages were "almost three times more likely" to carry JSON-LD.
  - **Causal test:** matched difference-in-differences on 1,885 pages that added JSON-LD between Aug 2025 and Mar 2026, against 4,000 control pages, 30 days before and after:
    - ChatGPT +2.2%, not distinguishable from zero.
    - AI Mode +2.4%, not distinguishable from zero.
    - AI Overviews −4.6%, statistically significant but unexplained.
  - **Conclusion:** schema's prevalence on cited pages "likely reflects broader SEO quality".
  - **Limits:** a 30-day window, and all pages already had 100+ AI Overview citations.
- **[Proven: platform docs, conflicting]**
  - Google: "Structured data isn't required for generative AI search, and there's no special schema.org markup you need to add", though still recommended for rich results ([Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)).
  - Microsoft recommends FAQ, HowTo, Product and Review schema, clear H1–H3 headings, and short sections on one idea each ([Microsoft Advertising blog, Oct 2025](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers), via [Search Engine World](https://www.searchengineworld.com/microsoft-shares-exact-signals-ai-uses-to-choose-content-for-search-answers)).
- **[Reported]** Page type: Glen Allsopp (Ahrefs), 750 ChatGPT prompts. "Best X" list posts were 43.8% of cited page types — [SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)

#### Length
- **[Reported, secondary only]** Kevin Indig in Search Engine Journal (14 Apr 2026): "Shorter, Focused Content Wins in ChatGPT". Covering fewer subtopics can beat exhaustive guides. I saw only an auto-generated aggregator summary — [aggregator](https://www.theatdb.com/news/shorter-focused-content-wins-in-chatgpt-via-sejournal-kevinindig)
- **[Proven: platform docs]** Google says there is no ideal page length ([Previsible summary](https://previsible.com/seo-ai-news/google-published-its-first-guide-to-ai-search-optimization/)). Bing favours one topic per URL ([SEJ](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/)).

#### Unique and first-party data
- **[Proven: platform statement, no data]** Google asks for original, "non-commodity" content that is "helpful, reliable, and people-first" with unique expert or experienced perspectives. It warns against content that "simply restates information already available elsewhere" — [Google AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)
- **[Proven: preprint, recommendation]** The Toronto authors recommend engineering content "for machine scannability and justification" — [arXiv 2509.08919](https://arxiv.org/abs/2509.08919)

#### Relevance versus style
- **[Proven]** Relevance and context position dominate (Vishwakarma 2026; Wan et al. 2024; rated high confidence by the survey). Keyword stuffing is null or negative: 17.7 against a 19.3 baseline in GEO — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Reported]** Ahrefs server logs from 137,000 sites (scope borderline; machine-readable files belong to another researcher): 28% had published llms.txt, and 97% of those files were never read. Of the reads that did happen, 77% came from non-AI bots. Google says llms.txt is unnecessary — [SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/); [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)

### Inferences
- **[Speculative, evidence-informed]** For market and event pages, put the answer facts in the first lines of plain text: this year's dates, daily hours, closed days (24 and 25 December), entry fee, address and transport. Then add depth. The ski-ramp effect (ChatGPT) and Bing's "essential information near the top" point the same way, and Google says this does no harm.
- **[Speculative]** Update the *same URL* each season rather than minting a new one per year. In Seer's data, more than a quarter of "fresh" cited pages were old URLs that had been updated. Old URLs also keep their accumulated links and mentions. Show a real "updated / checked on" date that matches the structured `dateModified`, and change it only with real edits; Google warns against date-bumping.
- **[Speculative]** For The Cultural Club, events expire fast. Seer's "spike" pages (cited only one month, median update age about 2 months) fit short-lived event pages. A dated event page has to be fresh at the moment of the query, and evergreen hub pages (for example "Barcelona cultural agenda this weekend") carry the persistent citations.
- **[Speculative]** "Best Christmas markets in Berlin 2026"-style list pages match the most-cited page type for recommendation prompts (43.8% in Allsopp's sample). Being cited is not the same as being *recommended*, though (see Q4, Lily Ray).
- **[Speculative]** Do not expect schema alone to lift AI citations; Ahrefs' causal test found no lift. Its value for Google event rich results is another researcher's scope.

### Gaps
- No study isolates a *visible* "last checked / verified on" line from structured dates.
- No study isolates tables against prose.
- Evidence on length is only a newsletter summary plus platform statements.
- No measured study isolates unique first-party data as a citation factor.
- No content-trait study covers German, Spanish or Catalan pages.

## Q4. Off-site signals: brand mentions, links, Wikipedia and Wikidata, reviews, forums, press, official tourism or city sites. How much do they matter, and to which engine?

### Takeaway
- **Mentions over links:** off-site presence correlates with AI visibility far more than link metrics. Branded web mentions and YouTube mentions correlate at about 0.66–0.74 with brand mentions in AI answers, against about 0.19–0.33 for backlinks and Domain Rating (Ahrefs, correlational, brands with DR above 40).
- **Earned media:** AI search over-weights third-party "earned" media relative to Google (Toronto, 2025).
- **Big platforms are volatile:** Reddit, Wikipedia and YouTube are the most-cited domains, but their shares swing by engine and by month.
- **Missing evidence:** I found no measured evidence for Wikidata and nothing reliable for official tourism or city sites.
- **Platform stance:** Google and Bing both warn that manufactured mentions do not help, and Bing treats engineered citation bait as abuse.

### Cited Findings
- **[Reported, correlational]** Ahrefs (May 2025): 75,000 brands with DR above 40, matched against AI Overview mentions in Brand Radar (about 26% had zero mentions). The strongest correlates were all off-site: branded web mentions 0.664, branded anchors 0.527, branded search volume 0.392 — [Ahrefs](https://ahrefs.com/blog/ai-overview-brand-correlation/)
- **[Reported, correlational]** Ahrefs update summarized in Aug 2026: about 75,000 brands across ChatGPT, AI Mode and AI Overviews.

  | Signal | Correlation |
  |---|---|
  | YouTube mentions | about 0.735–0.740 |
  | Branded web mentions | 0.656–0.709 |
  | Domain Rating | 0.266–0.326 |
  | Backlink count | 0.191–0.244 |

  Source: [SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)
- **[Proven: preprint]** Toronto (Sep 2025): 1,000 consumer-ranking prompts in the US and Canada, automotive, consumer electronics and software. Shares are Brand / Social / Earned — [arXiv 2509.08919](https://arxiv.org/html/2509.08919)

  | Source type | GPT-based AI search | Google |
  |---|---|---|
  | Earned media | 69.1–92.1% | 31.8–54.1% |
  | Social | 0–0.3% | 10.9–23.1% |
  | Brand-owned | 18.1–30.9% | 22.8–53.8% |

  The authors advise building third-party earned-media authority and countering "big brand bias" if you are a niche player.

  **Conflict:** "social ≈ 0" contrasts with Reddit's large share in other trackers. Query type (product rankings), interface and timing may explain it; that explanation is [Speculative].
- **[Proven: per survey]** Niche entities are known but not surfaced. Sharma 2026: ChatGPT recognizes 99.4% of 112 startups when they are named, but surfaces them in only 3.32% of open discovery queries. For Perplexity the figures are 94.3% and 8.29% — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Reported] Wikipedia**
  - 47.9% of ChatGPT's top-10 source share and 7.8% of all its citations (2025; [Profound](https://www.tryprofound.com/blog/ai-platform-citation-patterns)).
  - Fell from about 55% to under 20% of ChatGPT responses in Sep 2025, while staying stable at about 2–3% on AI Mode and 0.8% on Perplexity ([Semrush](https://www.semrush.com/blog/most-cited-domains-ai/)).
  - −14% in German ChatGPT after GPT-5.5 ([SISTRIX/SEJ](https://www.searchenginejournal.com/chatgpt-citations-changed-after-gpt-5-5-sistrix-data-shows/577694/)).
- **[Claimed]** "Companies with an established Wikipedia presence achieve up to 7x higher AI visibility": no method, one case study — [Search Atlas](https://searchatlas.com/blog/how-to-use-wikipedia-to-improve-ai-visibility/)
- **[Gap]** Wikidata: the search found no study at all, vendor or academic, that isolates the effect of Wikidata.
- **[Reported] Reddit**
  - Top-10 share of 46.7% on Perplexity, 21.0% on AI Overviews and 11.3% on ChatGPT (2025; [Profound](https://www.tryprofound.com/blog/ai-platform-citation-patterns)).
  - On ChatGPT, fell from about 60% to about 10% of responses in Sep 2025 ([Semrush](https://www.semrush.com/blog/most-cited-domains-ai/)), then rose 59% after GPT-5.5 in May 2026 in German ChatGPT ([SISTRIX/SEJ](https://www.searchenginejournal.com/chatgpt-citations-changed-after-gpt-5-5-sistrix-data-shows/577694/)).
  - In Google's *organic* May 2026 core update, forums and Q&A including Reddit lost visibility (−24% UK, −12% US), while canonical reference brands gained (+24% UK, +10% US). This is organic data, which matters because AI Overviews and AI Mode retrieve from the same index ([Aleyda Solis, 3 Jun 2026](https://www.aleydasolis.com/en/ai-search/google-may-2026-core-update-analysis-intent-market-fit-and-source-type-drove-the-biggest-visibility-shifts/)).
- **[Reported] YouTube** is now the most-cited domain in AI Overviews ([Ahrefs](https://ahrefs.com/blog/ai-overview-citations-top-10/)), and YouTube mentions are the strongest correlate of brand visibility ([SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)).
- **[Reported] Reviews**
  - Feefo, 250 travel queries across ChatGPT, Gemini and Perplexity: 71% of travel responses used first-party customer reviews. Perplexity used them most; about half of ChatGPT's responses used none. Date not verified ([CMSWire](https://www.cmswire.com/the-wire/customer-reviews-power-two-thirds-of-ai-travel-recommendations/)).
  - Yelp and TripAdvisor were in Perplexity's top 10 in 2025 ([Profound](https://www.tryprofound.com/blog/ai-platform-citation-patterns)).
  - TripAdvisor fell 53% in German ChatGPT after GPT-5.5 ([SISTRIX/SEJ](https://www.searchenginejournal.com/chatgpt-citations-changed-after-gpt-5-5-sistrix-data-shows/577694/)).
- **[Reported] Press and wire coverage:** PR Newswire and Forbes were among the biggest ChatGPT gainers after Sep 2025; Forbes roughly doubled — [Semrush](https://www.semrush.com/blog/most-cited-domains-ai/)
- **[Reported] Self-published "best X" lists get cited, but the publisher is not recommended**
  - Lily Ray (Amsive, 17 Jun 2026), 100 B2B "best [category]" queries in AI Overviews, Apr–Jun 2026: self-promotional listicles were cited 323 times in 80 AI Overviews. In 69% of cases (224), the listicle's own brand was *not* the one recommended ([Lily Ray](https://lilyraynyc.substack.com/p/why-calling-yourself-the-best-could)).
  - Ahrefs (Makosiewicz) tracked 34 self-promotional lists and 9,886 answers across ChatGPT, Gemini, Perplexity and Copilot, and rated "publish a best list featuring your brand and AI will recommend you" as a myth. In one Ahrefs event example, AI recommended a competitor's event in 43% of answers ([SEJ / Ahrefs](https://www.searchenginejournal.com/ai-search-myths-debunked-ahrefs-spa/584393/)).
- **[Claimed] Official tourism and city sites:** national and city tourism boards supply about 12% of travel answers, and "structured data and platform presence" predict citation share better than brand authority. No method or research body is named — [Everything PR](https://everything-pr.com/who-controls-ai-answers-in-travel)
- **[Reported]** In German ChatGPT after GPT-5.5, openstreetmap.org and mapbox.com rose 83% — [SISTRIX/SEJ](https://www.searchenginejournal.com/chatgpt-citations-changed-after-gpt-5-5-sistrix-data-shows/577694/)
- **[Proven: platform doc]** Google says seeking inauthentic "mentions" across the web "isn't as helpful as it might seem". Its generative AI features "can show what's being said about products and services across the web". Business Profile and Merchant Center "can help your products and services to be visible in both AI responses and other Google Search results" — [Google AI optimization guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide)
- **[Proven: platform doc, via secondary]** Bing renamed keyword stuffing to "Keyword Stuffing and Artificially Engineered Language", covering content designed to trigger citations or AI responses. It added a section titled "Prompt Injection and AI Manipulation" — [SEJ](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/)

### Inferences
- **[Speculative]** For a small specialist site, the route to being *the* cited source is to become what the cited platforms cite: official city lists, local press, YouTube vlogs and forum threads. Earned mentions correlate with AI visibility about three times as strongly as backlinks.
  - For Mercaditos this means: berlin.de and visitBerlin listings or links, Berlin and German press (Tagesspiegel, Berliner Zeitung), English expat media, and organic mentions in r/berlin or r/germany threads.
  - For The Cultural Club: Barcelona city-council and Time Out–type outlets.
- **[Speculative]** The plausible hook for earned media is unique first-party data that journalists can quote, for example a dated "2026 Berlin Christmas market price index" or "markets missing from the official list". No study measures this path directly.
- **[Speculative]** Manufactured Reddit posts or self-placed mentions are explicitly discounted by Google and classed as abuse by Bing; they also break Reddit's own rules. Any off-site work has to be genuine.
- **[Speculative]** Wikipedia: a new niche site will not get its own article. Being a cited reference on relevant articles (for example a city's "Christmas markets" article) is the realistic Wikipedia route, but I found no evidence of its effect on AI citations.
- **[Speculative]** The off-site authority studies cover brands with DR above 40 and product categories. They may not transfer to small, new, local or seasonal sites.

### Gaps
- Wikidata: no measured evidence at all.
- Official tourism and city sites: only an unsourced 12% claim.
- No study separates the weight of off-site signals per engine beyond correlations.
- No study on small or new sites; the Ahrefs sample is DR above 40.
- Review platforms for events (rather than hotels) are not studied.

## Q5. Trust and accuracy: do assistants prefer sources that show provenance, down-rank outdated or contradictory information, or pick specialist sources for factual, time-sensitive questions?

### Takeaway
- **Credibility and recency:** assistants tend to cite more credible domains than average search results (AI Overviews, Xu 2026) and lean toward recently updated pages.
- **No reward for provenance cues:** controlled studies find models weigh relevance over credibility cues. "Trust cues" give only small gains, while a *recent timestamp* helps consistently. A "checked on" date probably works as a recency signal, not as provenance.
- **Frequent errors:** engines often get sourcing wrong. Tow Center found more than 60% of queries answered wrongly; the EBU/BBC study found 45% of answers had a significant issue, 31% with sourcing problems. They also cite syndicated copies.
- **No demotion evidence:** no study shows engines systematically down-rank outdated or contradictory event information.

### Cited Findings
- **[Proven: peer-reviewed, IMC 2026]** Xu et al. (55,393 queries, Mar–Apr 2026) — [arXiv 2605.14021](https://arxiv.org/abs/2605.14021)
  - AI Overview–cited domains are more credible than the co-displayed first-page results.
  - 11.0% of 98,020 atomic claims were unsupported by the cited pages, with omission the dominant failure.
  - Source quality and claim fidelity are "largely independent".
- **[Proven: peer-reviewed, EACL 2026]** Vykopal et al.: credible-source shares in chat assistants' web search range from 71.4% to 86.3%, depending on assistant and topic — [Martinez survey](https://arxiv.org/html/2607.14035v1); DOI 10.18653/v1/2026.eacl-long.115
- **[Proven: peer-reviewed]** Liu et al. 2023 (EMNLP Findings), four engines: 51.5% of sentences were fully supported and 74.5% of citations supported their claim. FLAG: 2023 engines — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: per survey]** Allaham & Diakopoulos 2026: about 16% of 19,154 pages retrieved by assistants were labelled AI-generated, and 27.1% of URLs could not be scraped — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: peer-reviewed]** When evidence conflicts, models go with relevance over credibility cues such as references or a neutral tone — Wan et al., ACL 2024, via [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: preprint]** Trust cues give "smaller gains", while "a recent timestamp also helps consistently" — [Vishwakarma et al.](https://arxiv.org/abs/2605.25517)
- **[Proven: in-context]** GEO's "Cite Sources" (24.6 against 19.3 pawc) and "Quotation Addition" (27.2) raise visibility once the page is in the context — [Martinez survey](https://arxiv.org/html/2607.14035v1)
- **[Proven: measured study]** Tow Center / Columbia Journalism Review (Mar 2025) — [CJR](https://www.cjr.org/tow_center/we-compared-eight-ai-search-engines-theyre-all-bad-at-citing-news.php); [Fortune](https://fortune.com/2025/03/18/ai-search-engines-confidently-wrong-citing-sources-columbia-study)
  - **Method:** eight AI search tools, including ChatGPT Search, Perplexity, Gemini and Copilot, were given excerpts from 200 articles by 20 publishers and asked for the headline, publisher, date and URL.
  - **Error rates:** more than 60% of queries answered wrongly overall; Perplexity 37%, Grok 3 94%. Premium tools were more confidently wrong.
  - **Behaviour:** the tools fabricated links and **cited syndicated or copied versions** of articles. Some ignored robots.txt.
  - FLAG: early 2025 products.
- **[Proven: measured study]** EBU/BBC "News Integrity in AI Assistants" (Oct 2025): 22 public-service media organizations, 18 countries, 14 languages; ChatGPT, Copilot, Gemini and Perplexity — [EBU](https://www.ebu.ch/research/open/report/news-integrity-in-ai-assistants); [journalism.co.uk](https://www.journalism.co.uk/nearly-half-of-ai-generated-answers-contain-an-error-ebu-bbc-report/)
  - 45% of answers had at least one significant issue.
  - Sourcing problems were the largest category at 31%, then accuracy at about 20%.
  - Gemini was worst at 76%, mostly for sourcing.
  - Sample size is reported as both 2,709 and "more than 3,000" responses.
- **[Reported]** Freshness preference (see Q3): AI-cited pages are fresher than organic results ([Ahrefs](https://ahrefs.com/blog/do-ai-assistants-prefer-to-cite-fresh-content/)), and 75% of cited pages were updated within a year ([Seer](https://www.seerinteractive.com/insights/study-content-recencys-impact-on-ai-visibility-in-2026)). Neither study tests whether *stale* pages are actively demoted.
- **[Reported]** Locale-specific shift: after GPT-5.5, German-language ChatGPT cited more German publishers and fewer international aggregators — [SISTRIX/SEJ](https://www.searchenginejournal.com/chatgpt-citations-changed-after-gpt-5-5-sistrix-data-shows/577694/). This suggests sensitivity to local sources, but it does not test a preference for "specialist" sources.
- **[Proven: preprint]** The Toronto authors flag a "big brand bias" that niche players must counter — [arXiv 2509.08919](https://arxiv.org/abs/2509.08919)
- **[Proven: platform doc, via secondary]** Microsoft advises keeping content "current and consistent with authoritative sources" — [Search Engine World on Microsoft's Oct 2025 post](https://www.searchengineworld.com/microsoft-shares-exact-signals-ai-uses-to-choose-content-for-search-answers)

### Inferences
- **[Speculative]** A visible "checked on 2026-11-10 with the organiser" line probably helps mainly as a recency signal (the timestamp effect) and as a human trust cue. No evidence shows models reward provenance text itself. The defensible design is a real, specific date plus a named source for each fact (organiser site, berlin.de), because the survey's best-supported advice is "verifiable, dated, properly attributed evidence".
- **[Speculative]** Microsoft's "consistent with authoritative sources" and the omission-dominant failure in Xu 2026 suggest that when Mercaditos disagrees with berlin.de (for example on a market's dates), engines may drop the claim or prefer the official source. Where Mercaditos knows better, it should say why and cite the organiser explicitly.
- **[Speculative]** Engines cite syndicated copies (Tow Center), so scrapers that copy Mercaditos or The Cultural Club listings could be credited instead. Being first-published, canonical and clearly dated is the only lever suggested, and I found no evidence on how engines resolve duplicates.
- **[Speculative]** Dates and timeliness are where assistants fail most (Tow Center, EBU/BBC). For dated events that is an opportunity for a source that is visibly current, but nothing shows engines *detect* staleness. A wrong but well-ranked page from last year may still be cited.

### Gaps
- No study tests whether engines down-rank outdated or contradictory information about events or places.
- No study tests "checked on" or "verified" provenance lines.
- No study tests whether specialist sources beat generalist ones for time-sensitive local facts; only indirect SISTRIX data exists.
- No accuracy audit covers event or places questions; existing audits are news-focused.

## Q6. What do the platforms themselves say? (Google, OpenAI, Perplexity, Microsoft, plus Anthropic and Gemini)

### Takeaway
Google's position is "no special optimization".
- **Mechanism:** AI Overviews and AI Mode are retrieval-augmented generation over the normal Search index, using core ranking and spam systems.
- **Recipe:** being indexed and snippet-eligible, plus original, non-commodity, people-first content.
- **Unnecessary, per Google:** llms.txt, chunking, AI-specific rewriting, special schema and manufactured mentions.

Microsoft and Bing are the only platform giving concrete structural advice: sections, headings, facts near the top, one topic per URL, schema. Bing now names GEO and treats engineered citation bait and prompt injection as abuse.

OpenAI documents only access (OAI-SearchBot) and referral tracking. Perplexity documents revenue programmes but no selection criteria. Anthropic publishes nothing for publishers.

### Cited Findings
- **[Proven: platform doc]** Google, "AI features and your website" (living document): a page "must be indexed and eligible to be shown in Google Search with a snippet"; there are no additional technical requirements; standard SEO practices apply; AI Overviews show only when judged additive — [Google Search Central](https://developers.google.com/search/docs/appearance/ai-features)
- **[Proven: platform doc]** Google, "Optimizing your website for generative AI features on Google Search" (published 15 May 2026; last updated 10 Jul 2026) — [Google](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide); see also [Previsible](https://previsible.com/seo-ai-news/google-published-its-first-guide-to-ai-search-optimization/)
  - **Retrieval:** "relying on our core Search ranking systems to retrieve relevant, up-to-date web pages from our Search index".
  - **Query fan-out:** defined as "A set of concurrent, related queries generated by the model to request more information".
  - **Content:** original, "non-commodity", "helpful, reliable, and people-first" content; high-quality images and video; crawlability; good page experience. Merchant Center and Business Profile help products and local businesses appear.
  - **Not needed:**
    - "You don't need to create new machine readable files, AI text files, markup, or Markdown"
    - no chunking
    - no AI-specific writing
    - inauthentic mentions "isn't as helpful as it might seem"
    - no special schema.org markup
  - **Framing:** "From Google Search's perspective, optimizing for generative AI search is optimizing for the search experience". Previsible also reports Google's added emphasis on making critical content available without JavaScript rendering.
  - **Not covered:** the guide does **not** discuss events, places, dates, freshness or time-sensitive content.
- **[Proven: platform doc, wording via search snippets]** OpenAI, "Publishers and Developers – FAQ" (help.openai.com; date unknown; direct fetch blocked with 403) — [OpenAI Help](https://help.openai.com/en/articles/12627856-publishers-and-developers-faq); [third-party guide](https://alicelabs.ai/en/insights/how-to-get-cited-by-chatgpt)
  - Any public website can appear in ChatGPT search; allow OAI-SearchBot to be eligible for summaries and snippets.
  - A disallowed page can still appear as a bare link and title. Use `noindex` to prevent that, and the crawler must be allowed to read the tag.
  - ChatGPT adds `utm_source=chatgpt.com` to referral links.
  - GPTBot is a separate crawler used for training.
  - Third-party guides quote: "Placement is not guaranteed."
- **[Proven: platform statement, quote via secondary]** OpenAI's 2024 search launch material says search "leverages third-party search providers, as well as content provided directly by our partners"; its help docs name Bing as the provider. I could not verify whether the quote is from the Jul 2024 SearchGPT prototype post or the Oct 2024 ChatGPT search launch post (openai.com returned 403) — [OpenAI, SearchGPT prototype, Jul 2024](https://openai.com/index/searchgpt-prototype/); [secondary summary](https://webiano.digital/inside-the-source-choices-behind-chatgpt-search-results/)
- **[Reported]** OpenAI publishes no ranking or source-selection criteria — [Webiano](https://webiano.digital/inside-the-source-choices-behind-chatgpt-search-results/); [alicelabs](https://alicelabs.ai/en/insights/how-to-get-cited-by-chatgpt)
- **[Reported, secondary] Perplexity** — [getcoai](https://getcoai.com/news/perplexity-launches-5-monthly-comet-plus-sharing-80-revenue-with-publishers); [llmpulse](https://llmpulse.ai/blog/perplexity-publishers-program/)
  - **Publishers' Program (Jul 2024):** a share of ad revenue when a publisher's content is cited in an answer that shows an ad. Launch partners: TIME, Der Spiegel, Fortune, Entrepreneur, The Texas Tribune and WordPress.com. 15 more outlets joined in Dec 2024.
  - **Comet Plus (Aug 2025):** $5 a month, 80% of revenue to publishers, $42.5M initial pool. Launch partners include the Washington Post, Le Monde and Condé Nast.
  - **Other:** several publishers have sued Perplexity.
  - FLAG: 2026 status not found.
- **[Claimed]** Vendors quote Perplexity documentation as prioritizing "authoritative, timely, and relevant sources". I could not find or verify the official page — [llmpulse](https://llmpulse.ai/blog/how-perplexity-works/)
- **[Proven: platform doc, content via secondary]** Microsoft Advertising, "Optimizing Your Content for Inclusion in AI Search Answers" (Oct 2025) — [Microsoft](https://about.ads.microsoft.com/en/blog/post/october-2025/optimizing-your-content-for-inclusion-in-ai-search-answers); [Search Engine World](https://www.searchengineworld.com/microsoft-shares-exact-signals-ai-uses-to-choose-content-for-search-answers)
  - AI systems evaluate content in smaller sections, judged on clarity, structure and how directly they answer intent.
  - **Do:** descriptive H1–H3 headings and Q&A format; short single-idea sections; FAQ, HowTo, Product and Review schema; direct, factual language; alt text; current content consistent with authoritative sources.
  - **Avoid:** long unstructured blocks; key information hidden in tabs, scripts or images; vague or promotional language; blocking Bingbot; outdated canonical tags and metadata.
  - "No formula guarantees inclusion."
- **[Proven: platform doc, via secondary]** Bing Webmaster Guidelines rewrite (reported 27 Feb 2026) — [SEJ](https://www.searchenginejournal.com/bing-adds-geo-to-official-guidelines-expands-ai-abuse-definitions/568442/)
  - **Scope:** now covers Copilot and grounding results.
  - **GEO:** names "Generative Engine Optimization", defined as eligibility for grounding and reference, with no guaranteed citations.
  - **Advice:** state facts directly; use consistent entity names; one topic per URL; essential information near the top.
  - **Meta directives:** NOARCHIVE blocks use in Copilot; NOCACHE limits Copilot to URL, title and snippet.
  - **New abuse classes:** "Artificially Engineered Language" (content built to trigger citations), "Prompt Injection and AI Manipulation", and large-scale content generated without editorial review.
- **[Reported]** The Bing Webmaster Tools AI Performance report (public preview from Feb 2026) shows total citations, average cited pages, and the "grounding queries" (the internal rewrites of user prompts) per page. The data is sampled, has no click data, and no API yet — [Search Engine Land](https://searchengineland.com/bing-webmaster-tools-testing-new-ai-performance-report-468039); [Search Influence](https://www.searchinfluence.com/blog/bing-ai-performance-report-copilot-citations/)
- **[Reported]** Anthropic (Claude): I found no publisher guidance. Brave Search was added to Anthropic's subprocessor list on 19 Mar 2025, and one firm claims a second search provider is listed too — [Xponent21](https://xponent21.com/insights/claude-web-search-brave-turbopuffer/)
- **[Gap]** Google Gemini app: I found no separate publisher guidance beyond Google Search's.

### Inferences
- **[Speculative] Where the platforms agree:**
  - be indexable in each engine's underlying index (Google, Bing, Brave);
  - be relevant and original;
  - state facts plainly;
  - do not manipulate.
- **[Speculative] Where they disagree:**
  - **Structure:** Bing advises section-level, single-topic, facts-first pages; Google says this is unnecessary but does not penalize it.
  - **Schema:** Microsoft recommends it; Google says it is not needed for AI; the Ahrefs causal test found no citation lift.

  Following Bing's structure advice is low-cost and harmless for Google.
- **[Speculative]** Google points local entities to Business Profile, and Christmas markets or cultural events are often not "businesses" with a profile. Event-specific Google features are another researcher's topic, but Google's AI guide is silent on events, so the generic rules are all there is.
- **[Speculative]** Treat every platform statement as policy, not mechanism. None of them discloses selection weights, and the measured data (Q2) shows behaviour shifting without announcement.

### Gaps
- No Anthropic or Gemini-app publisher guidance exists that I could find.
- No official Perplexity documentation on how sources are chosen.
- I could not fetch OpenAI's FAQ verbatim (403).
- I read Microsoft's October 2025 post and the Bing guideline changes only through secondary coverage.
