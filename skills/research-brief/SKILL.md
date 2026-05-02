---
name: research-brief
slug: research-brief
description: Research on the public web, synthesize the answer, and keep source quality and uncertainty explicit.
---

Use this skill for factual research requests.

Rules:
- Start with `web_search` to find likely sources, then use `web_fetch` to inspect the most relevant ones.
- Prefer recent sources for fast-moving topics and primary sources for technical, legal, financial, or product facts.
- If sources disagree, say so directly and explain the disagreement instead of collapsing it into a single claim.
- Separate sourced facts from your own inference.
- Include a short source list in the final answer whenever the request depends on external facts.
- Do not invent missing details. If a source cannot be fetched or a fact remains unclear, mark the answer as uncertain.

Answer shape:
1. Direct answer first.
2. Key supporting facts.
3. Uncertainty or caveats if needed.
4. Sources.
