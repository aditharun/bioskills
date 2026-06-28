---
name: nct
description: |
  Open a ClinicalTrials.gov study page in the default browser. Three triggers:
  (1) AUTO-TRIGGER on bare ID: if the user's entire message matches
  `^\s*(NCT)?\d{8}\s*$` (e.g. `NCT04267848`, `nct04267848`, or just `04267848`),
  invoke immediately without asking. (2) EXPLICIT `nct` PREFIX: if the user's
  message starts with `nct ` (case-insensitive) followed by any free-form text
  (e.g. `nct RASolute303 daraxonrasib`, `nct KEYNOTE-189`), always invoke this
  skill — strip the `nct ` prefix and use the remainder as the API query. This
  is the escape hatch for trial code names or drug names Claude wouldn't
  otherwise recognize as a trial reference. (3) NAME LOOKUP: if the user gives
  a trial name and/or drug (e.g. `SUCCESSOR-1 mezigdomide`, `KEYNOTE-189`,
  `pembrolizumab NSCLC first line`), query the ClinicalTrials.gov v2 API to
  resolve the NCT ID, then open it. Also use when the user pastes an NCT ID in
  a longer message and asks to view, open, or look up the trial.
allowed-tools:
  - Bash
  - AskUserQuestion
---

# nct — open ClinicalTrials.gov trial in browser

## Mode A — bare NCT ID

If the user's input is just an NCT ID (with or without the `NCT` prefix, optional surrounding whitespace), normalize and open it directly. **Note:** a `UserPromptSubmit` hook (see `hooks/nct-hook-snippet.json` in the bioskills repo) catches this case before Claude is invoked. The skill still needs to handle it as a fallback in case the hook isn't installed.

```bash
open "https://clinicaltrials.gov/study/NCT<8digits>"
```

## Mode B — trial name and/or drug name

The user gives free-form text like `SUCCESSOR-1 mezigdomide`, `KEYNOTE-189`, or `pembrolizumab pancreatic cancer`. This also covers the explicit `nct <query>` prefix form (e.g. `nct RASolute303 daraxonrasib`) — strip the leading `nct ` and treat the remainder as the query. The prefix form is the escape hatch for obscure trial code names or drug names where Claude wouldn't otherwise recognize the input as a trial reference; when present, always invoke this skill.

Steps:

1. **Query the API.** ClinicalTrials.gov v2 is public, no auth required. Build the query:

   ```bash
   curl -s --get \
     --data-urlencode "query.term=<full user input>" \
     --data-urlencode "fields=NCTId,BriefTitle,OverallStatus,Phase,LeadSponsorName" \
     --data-urlencode "pageSize=5" \
     "https://clinicaltrials.gov/api/v2/studies"
   ```

   `query.term` is a broad full-text search across title, intervention, condition, sponsor, etc. — usually the right call because users mix trial names with drugs/conditions freely.

   For more precision when the user clearly separates trial name from drug, you may also use `query.titles=<trial name>` and `query.intr=<drug>` instead. Use judgment.

2. **Parse the response.** Extract top results:

   ```bash
   jq -r '.studies[] | {
     nct: .protocolSection.identificationModule.nctId,
     title: .protocolSection.identificationModule.briefTitle,
     status: .protocolSection.statusModule.overallStatus,
     phase: (.protocolSection.designModule.phases // [] | join("/")),
     sponsor: .protocolSection.sponsorCollaboratorsModule.leadSponsor.name
   }'
   ```

3. **Decide:**
   - **0 results.** Tell the user no matches and stop. Suggest they double-check spelling or provide more context.
   - **1 result, or top result is an unambiguous match** (e.g. user said `SUCCESSOR-1 mezigdomide` and top result title contains both `SUCCESSOR-1` semantics and `mezigdomide`): open it directly.
   - **Multiple plausible results.** Use AskUserQuestion to show the top 3 (label = `NCT_ID — short title`, description = `Phase X · Status · Sponsor`). Add an "Other" option implicitly (the tool adds it). Open the selected one. Do NOT just pick top-1 silently when ambiguous — users care about trial selection.

4. **Open** with `open "https://clinicaltrials.gov/study/NCT<id>"` and confirm the URL in one line.

## Notes

- `open` is the macOS command for launching the default browser. On Linux equivalents would be `xdg-open`; this skill targets macOS.
- The canonical URL pattern is `https://clinicaltrials.gov/study/NCTxxxxxxxx`.
- The CT.gov v2 API requires no API key. There are no credentials anywhere in this skill.
- If `curl` or `jq` is missing, tell the user — both should be available on macOS by default (jq via Homebrew if not).
