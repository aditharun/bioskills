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
RASolute302 daraxonrasib
pembrolizumab KEYNOTE-859
```

If for whatever reason the above does not work, simply prepend "nct". I find that if you are pasting an NCT ID then there is no need to prepend "nct" but if you are using the search it is best to type nct before hand. 

```
nct RASolute302 daraxonrasib
nct pembrolizumab KEYNOTE-859
``` 


## Install

Requires macOS (uses `open`), `jq`, and Claude Code.

```bash
git clone https://github.com/<your-username>/bioskills.git ~/Documents/GitHub/bioskills
cd ~/Documents/GitHub/bioskills
./install.sh
```


## Uninstall

```bash
rm ~/.claude/skills/nct
# Then manually remove the UserPromptSubmit hook from ~/.claude/settings.json
# (look for the command containing "clinicaltrials.gov/study")
```


