---
name: git-init-commits
description: "Always run git init on a new project and make atomic commits with clear messages"
condition: ["git init", "git commit -m"]
scope: "tool:bash"
---

Every new project MUST start with `git init` (or equivalent for monorepos). Each change set should be one atomic commit with a clear, conventional-commit message (feat:, fix:, chore:, docs:). Never leave work uncommitted or bundle unrelated concerns into one giant commit. If the repo is already initialized, verify `.gitignore` is in place before the first commit, and ensure each commit passes tests/CI.