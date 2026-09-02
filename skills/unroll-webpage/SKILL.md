---
name: unroll-webpage
description: |
  Download a web article (primarily Substack posts, but tolerant of any
  article-shaped page) and convert it into a Microsoft Word .docx file with
  Times New Roman 12pt body text, preserving headings, bold/italic runs,
  lists, blockquotes, and embedded images.

  TRIGGERS — invoke whenever the user's message matches any of these patterns
  (case-insensitive, URL can appear anywhere in the message):
    - `unroll-webpage <url>`
    - `<url> unroll-webpage`
    - `unroll <url>`
    - `<url> unroll`
  A "url" is any http/https URL. If the user includes extra chatter alongside
  a matching trigger, still invoke — extract the URL and run.

  Also invoke on natural-language equivalents like "unroll this into a word
  doc", "convert this substack to docx", "make a word doc of this article",
  provided a URL is present in the message.
allowed-tools:
  - Bash
  - Read
---

# unroll-webpage — article URL to .docx

## What it does

Runs `unroll.sh <url> [--out PATH]`, which bootstraps a per-skill Python venv
(first run only, ~15s) and then executes `convert.py`. The output is a `.docx`
with Times New Roman 12pt body, headings, inline bold/italic, lists,
blockquotes, and embedded images downloaded from the source page.

## How to invoke

1. **Extract the URL** from the user's message. Ignore trigger words
   (`unroll`, `unroll-webpage`) and any surrounding prose. If there are
   multiple URLs, ask which one; otherwise proceed silently.

2. **Pick an output location.** Default to the user's current working
   directory. If cwd looks unsuitable (e.g. home directory, a repo root the
   user isn't actively working in), prefer `~/Downloads/`. If the user names
   a specific path or folder, use that.

3. **Run the wrapper:**

   ```bash
   ~/.claude/skills/unroll-webpage/unroll.sh "<url>" --out "<output-dir-or-file>"
   ```

   The script prints the final `.docx` path on success. Report that path back
   to the user in one line. Do not paraphrase the article's content.

4. **On failure**, read the stderr output. Common causes:
   - Paywalled post — only the free preview will be captured. Mention this.
   - Non-Substack page with unusual markup — the article-body selectors in
     `convert.py` (`find_article`) may need extending. Offer to look.
   - Network / DNS errors — surface the error and stop.

## Notes

- The wrapper is idempotent. It creates `.venv/` inside the skill directory
  and reinstalls deps only when `requirements.txt` changes.
- Dependencies: `requests`, `beautifulsoup4`, `python-docx`, `Pillow`.
  System `python3` (>= 3.9) must be available.
- Output filename defaults to a slug derived from the article title, e.g.
  `how-to-build-a-cancer-vaccine.docx`.
- Body style is Times New Roman 12pt on the Normal style. Title is 18pt bold,
  subtitle 13pt italic. Images are embedded at up to 6 inches wide.
- If the user asks to convert many URLs, loop the wrapper — one invocation
  per URL — rather than trying to batch inside the script.
