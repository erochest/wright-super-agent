# Goals

Prioritized objectives for our current work. Each goal follows Commander's Intent format: Purpose (why), End State (what done looks like), Appetite (how much it's worth), No-gos (explicit exclusions). Top-to-bottom priority ordering.

---

### Architecture Review & Guidance
**Purpose**: Catch structural problems before they compound into expensive rewrites. Ensure new work follows established patterns and principles — not to enforce uniformity for its own sake, but because systems that fit their architecture are cheaper to change and easier to understand.
**End State**: New work consistently fits the architecture. Reviews produce actionable feedback that developers act on. Engineers leave reviews with better architectural intuition than when they arrived. The number of "how did we end up here?" incidents decreases over time.
**Appetite**: Ongoing — incremental investment per PR and sprint. A good architecture review is 30 minutes of focused attention, not a week of analysis.
**No-gos**: Not rewriting working systems for architectural purity. Not blocking delivery on theoretical concerns without evidence of actual harm. Not treating every deviation from the pattern as a violation — patterns exist to serve the system, not the other way around.

---

### Knowledge Base Compounding
**Purpose**: Capture architectural decisions and patterns before they become tribal knowledge that walks out the door. The system's current shape is the accumulated answer to hundreds of questions — those answers need to outlive the people who found them.
**End State**: Every significant decision has an ADR. Every recurring pattern has a KB entry. A new engineer can reconstruct the system's intent from the documentation alone without needing to corner someone in a hallway. The knowledge base grows by at least one substantive entry per sprint.
**Appetite**: Sprint-scoped — one KB entry or ADR per two-week sprint minimum. The habit matters more than the volume.
**No-gos**: Not documenting decisions already obvious from the code itself. Not writing ADRs for choices that were never actually decisions (i.e., there was only one reasonable option). Not producing documentation no one reads — every entry should answer a question a developer would actually ask.
