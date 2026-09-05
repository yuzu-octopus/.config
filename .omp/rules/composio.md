---
name: composio
description: "Composio MCP: 4-step dynamic-catalog workflow (SEARCH_TOOLS → schemas → MULTI_EXECUTE → connections), connected-toolkit capabilities, and do-not-use list. READ before any composio tool call"
---

### Composio workflow
Composio is a dynamic tool catalog: `COMPOSIO_SEARCH_TOOLS` returns only the 4-6 tools relevant to the use case, so never enumerate or dump the full tool list and never hardcode tool slugs. Discover per task, then execute.

1. `COMPOSIO_SEARCH_TOOLS` — split independent actions into separate `queries` (one per app/action, include hidden prerequisites like "get Linear issue" before "update Linear issue"). First call of a workflow: `session: {generate_id: true}`; reuse the returned `session.id` in every later meta call. Review the returned `recommended_plan_steps` and `known_pitfalls` before executing anything.
2. `COMPOSIO_GET_TOOL_SCHEMAS` — load the full input schema for any tool returned with `schemaRef` instead of an inline schema. Never guess or invent tool slugs; only use slugs the search returned.
3. `COMPOSIO_MULTI_EXECUTE_TOOL` — batch logically independent calls (up to 50 parallel) with exact schema field names. Pass `session_id`, a `current_step` label, and `sync_response_to_workbench: true` when a response may be large. Paginate until `nextPageToken`/`next_cursor` is exhausted — partial results are bugs (Drive bulk ops can 429; back off).
4. No active connection for a toolkit → `COMPOSIO_MANAGE_CONNECTIONS` (show the auth link, set an alias), then `COMPOSIO_WAIT_FOR_CONNECTIONS`. Never run a toolkit tool without an active connection.

### Composio capabilities (connected toolkits)
Summary of what each connected toolkit can do — exact slugs come from `COMPOSIO_SEARCH_TOOLS` at runtime.

| Toolkit | Capabilities |
|---|---|
| GitHub | Repos: metadata, list (paginate, max 100/page), file/dir content (base64), trees, repo search; orgs; plus full PR/issue/commit/Actions surface — discover per use case |
| Gmail | Profile, labels (internal `Label_` IDs from `GMAIL_LIST_LABELS` — display names silently fail), search/fetch emails (query filters, `ids_only`, max 500/page, not sorted by recency — sort client-side), fetch by message ID, threads, drafts, send, people/contact search |
| Google Drive | `FIND_FILE` with full Drive query syntax (name/mimeType/date ranges/`'X' in parents`/`'email' in owners`/fullText), quota/about, move, copy, permissions (single, batch, list, update, get), metadata update (PATCH semantics — move = `add_parents` + `remove_parents`), shared drives |
| Notion | Search pages/databases (paginate `next_cursor`/`has_more`), fetch page/database/block metadata, query databases, page content as markdown, users |
| Google Classroom | Courses (list/get), rosters (teachers, students, student groups), coursework (list/get by state), student submissions (list by state, reclaim) |
| Tavily, Exa, Firecrawl | Connected (web-research toolkits: search, extract, crawl, research) but DO-NOT-USE — mcp-pool is the only sanctioned web-research route (see do-not-use) |
| Slack, X, Google Sheets/Calendar, etc. | Not connected — require `COMPOSIO_MANAGE_CONNECTIONS` + auth before use |

### Composio do-not-use
- **Web research: Tavily, Exa, Firecrawl are CONNECTED as Composio toolkits** (`TAVILY_MCP_*`, `EXA_*`, `FIRECRAWL_*` — search, extract, crawl, research, agents). Never call them via Composio: the mcp-pool server is the only sanctioned route for web search/scrape/research.
- `COMPOSIO_REMOTE_BASH_TOOL` / `COMPOSIO_REMOTE_WORKBENCH` — only for large response payloads saved to remote files; `eval` and local tools come first.