# bioskills

[Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills for biotech / clinical research workflows.

## Skills

### `nct` — open a ClinicalTrials.gov trial in your browser

Two ways to use it:

**1. Paste an NCT ID** (handled by a `UserPromptSubmit` hook — fires before Claude is even invoked, so it's instant and uses zero tokens):

```
NCT04267848
nct04267848
04267848
```

Each of the above opens `https://clinicaltrials.gov/study/NCT04267848` in your default browser.

**2. Search by trial name and/or drug** (handled by the skill — Claude calls the [ClinicalTrials.gov v2 API](https://clinicaltrials.gov/data-api/api) and opens the top match, or asks you to pick if results are ambiguous):

```
SUCCESSOR-1 mezigdomide
KEYNOTE-189
pembrolizumab NSCLC first line
```

## Install

Requires macOS (uses `open`), `jq`, and Claude Code.

```bash
git clone https://github.com/<your-username>/bioskills.git ~/Documents/GitHub/bioskills
cd ~/Documents/GitHub/bioskills
./install.sh
```

The installer:

1. Symlinks `~/.claude/skills/nct` → `skills/nct/` in this repo (so edits in the repo are live).
2. Merges the `UserPromptSubmit` hook from `hooks/nct-hook-snippet.json` into `~/.claude/settings.json`. Existing settings are preserved.

Open `/hooks` in Claude Code (or restart) once after installing to activate the hook.

## Uninstall

```bash
rm ~/.claude/skills/nct
# Then manually remove the UserPromptSubmit hook from ~/.claude/settings.json
# (look for the command containing "clinicaltrials.gov/study")
```

## Security notes

- The CT.gov v2 API is fully public — no API key, no auth, no credentials anywhere in this repo.
- The hook only triggers on prompts matching `^\s*(NCT)?\d{8}\s*$` — it does not read or transmit any other prompts.
- Your `~/.claude/settings.json` is never tracked by this repo (only the hook fragment is).
