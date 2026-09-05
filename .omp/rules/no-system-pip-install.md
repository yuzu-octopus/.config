---
name: no-system-pip-install
description: "Never install Python packages into the system/site-packages via pip — use uv or project-local tooling instead"
condition: "\bpip3?\s+install\b"
scope: "tool:bash"
---

Always install Python dependencies into the project-local environment (e.g., `uv pip install`, `bun add`, or a project venv). Never use `pip3 install --break-system-packages` or any `pip install` against system Python — it pollutes system packages and requires `--break-system-packages` on macOS with Homebrew Python, which risks breaking the system Python environment. Use `uv` (`uv add`, `uv pip install`, `uv run --with`) instead.