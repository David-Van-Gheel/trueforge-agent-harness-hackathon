# Git workflow for this TrueForge export

## First time: connect this repository to GitHub

1. Create a **private**, empty GitHub repository (do not add a README or .gitignore there).
2. From this folder, run:

```bash
git remote add origin https://github.com/YOUR-USERNAME/trueforge-agents.git
git push -u origin main
```

## After editing or re-exporting TrueForge data

```bash
git status
git diff
git add agents exports docs
git commit -m "Describe the TrueForge change"
git push
```

## Safety rules

- Do not add `db/trueforge.sqlite`; it is intentionally ignored because live databases can contain credentials and chat data.
- Review `git diff --cached` before every commit.
- Keep the GitHub repository private, especially if you choose to keep session exports.

## Current version

The initial commit includes the `job-search-helper` update that adds clear, concise progress reports for multi-step work.
