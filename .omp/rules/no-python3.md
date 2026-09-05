---
name: no-python3
description: "Never run python3 or pip/pip3 directly — use uv (uv run, uvx, uv tool) with Python 3.14 default"
condition: "\b(python3|pip3|pip)\b"
scope: "tool:bash"
---

Never run `python3` / `pip` / `pip3` directly — use `uv` (`uv run`, `uvx`, `uv tool`). Same job, faster, no global state. Default to Python 3.14 (`--python 3.14`, `requires-python = ">=3.14"`). `uv run python` and `uv run --with <pkg>` are fine (they route through uv). If there is a genuine reason to invoke a bare interpreter, ask the user first.