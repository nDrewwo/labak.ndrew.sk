---
title: "Content Structure"
date: 2025-12-23
description: ""
authors:
  - "ndrew"
series: ["Standards"]
tags: ["Content"]
series_order: 5
---

## Purpose
Guidance and recommended structure for: **Labs**, **Theory**, **Blog posts**, and **Projects**. The goal is to keep consistency across front matter, section ordering, and asset management so content is predictable and easy to reuse.

## General front matter recommendations
Use consistent front matter keys to enable listing, filtering and series generation.

Recommended keys (common):

```yaml
title: "Clear and concise title"
date: 2025-11-12
authors: ["ndrew"]
tags: ["network","routing"]
series: ["Labs"]
description: "Short summary used in listings and previews"
```

Extra helpful keys per content type are documented below.

---

## Labs
Purpose: hands-on exercises with clear verification and teardown steps. Labs should be runnable and include assets and topology diagrams.

Front matter (recommended):

```yaml
title: "LAB-0001 Static Routing"
date: 2025-11-12
authors: ["ndrew"]
tags: ["routing","lab"]
series: ["Labs"]
```

Suggested sections (order):
- **Goal** — one-sentence learning objective 
- **Topology Diagram** — include/embed optimized `.svg` (editable source in assets)
- **Equipment & Versions** — list devices, OS, images
- **Prerequisites** — required knowledge & resources
- **Setup** — quick provisioning steps (commands, scripts)
- **Configuration** — exact configuration snippets and files
- **Verification / Expected Results** — commands and expected outputs
- **Troubleshooting** — known pitfalls and fixes
- **Cleanup** — how to revert the environment
- **References & Assets** — links to assets and external references

---

## Theory
Purpose: concise conceptual explanations and references for core topics.

Front matter (recommended):

```yaml
title: "Understanding OSPF"
date: 2025-10-01
authors: ["ndrew"]
tags: ["routing","theory"]
series: ["Theory"]
description: "Core concepts of OSPF and when to use it"
draft: false
```

Suggested sections (order):
- **Goal / Summary** — what the reader should learn
- **Background / Motivation** — why topic matters
- **Core Concepts** — definitions, diagrams, short examples
- **Examples / Illustrations** — small, focused examples
- **Exercises / Questions** (optional) — for self-check
- **Further Reading / References**

Notes:
- Keep theory pages concise and link to labs and projects where practical.

---

## Blog posts
Purpose: time-sensitive updates, announcements or reflections.

Front matter (recommended):

```yaml
title: "New Year Roadmap"
date: 2026-01-01
authors: ["ndrew"]
tags: ["announcement"]
description: "What to expect this year"
```

Suggested sections (order):
- **Intro / TL;DR** — short hook and summary
- **Body** — split into logical subsections and screenshots where helpful
- **Conclusion / Call to action** — next steps for the reader
- **How to reproduce / run locally** (if relevant)

Notes:
- Use readable, conversational language. Keep posts scannable with short paragraphs and headings.
---

## Projects
Purpose: share author-driven discoveries and insights. Project pages should explain the problem explored, the author's approach and experiments, the key discoveries and their implications. Reproducible artifacts are optional — the primary goal is to document findings, context, and recommendations so readers can learn from the author's work.

Front matter (recommended):

```yaml
title: "PROJECT-2025-network-simulator"
date: 2025-09-12
authors: ["ndrew"]
tags: ["project","simulator"]
description: "Short project summary for listings"
```

Suggested sections (order):
- **Problem Statement** — what the project explored and why it was chosen ✅
- **Context & Motivation** — who is affected, constraints, and why it matters
- **Audience & Prerequisites** — what the reader should know to understand the findings
- **Approach / Process** — experiments, data sources, and methods used
- **Key Findings / Discoveries** — the author's results, evidence and interpretation
- **Implications & Recommendations** — practical takeaways and suggested actions
- **Supporting Artifacts (optional)** — links to datasets, configs, prototypes, or demos (if available)
- **Limitations & Open Questions** — what remains unknown and suggested next steps
- **Contributors & License** — contributors and project license

Notes:
- Projects are primarily narrative and discovery-focused; reproduction details are optional and should be included only when they aid understanding.
- Use `findings` and `recommendations` front matter keys to surface summaries in listings or search.
- Link to related labs, theory pages, external repositories, and any artifacts when helpful.
---