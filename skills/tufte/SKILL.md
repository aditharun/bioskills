---
name: tufte
description: |
  Design or redesign a data visualization using Edward Tufte's principles
  from *The Visual Display of Quantitative Information*. Produces
  high-resolution, professionally presentable figures that maximize the
  data-ink ratio, minimize chartjunk, and use small multiples, direct
  labels, and muted palettes with saturated accents. Tool-agnostic —
  works with matplotlib, seaborn, plotnine, ggplot2, R base, D3, Vega-Lite,
  Observable Plot, Plotly, Excel, Illustrator, or any other renderer.
  Invoke when the user says "use the Tufte visualization suite", "Tufte
  this", "Tufte-style plot", "make this a Tufte chart", "design a plot"
  in a context where quality matters, or asks to redesign an existing
  figure for clarity, elegance, or publication.
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - AskUserQuestion
---

# tufte — design plots the Tufte way

## What this skill does

Guides the design or redesign of a statistical graphic against the
principles in `PRINCIPLES.md` (living in this same directory). The
output is a figure — code, image, or both — that is ready to show
professionally: publication, slide deck, report, dashboard.

**Read `PRINCIPLES.md` first.** Every design decision below traces
back to a numbered principle there. When in doubt, cite the principle.

## When to invoke

- **Explicit:** "use the Tufte visualization suite", "Tufte this",
  "Tufte-style", "make this look like Tufte".
- **Implicit:** the user asks to design or improve a chart and wants
  it to look elegant, publication-ready, professional, or
  presentation-quality.
- **Redesign:** the user shows an existing figure (screenshot, code,
  or file) and asks to make it better, cleaner, or more readable.

Do **not** silently apply this skill to every plot request. If the user
is doing exploratory data analysis and just wants a quick sanity-check
chart, ask before spending time on polish.

## Workflow

### Step 1 — Understand the argument

Before touching any tool, ask (or state your assumption and let the
user correct):

1. **What is the one sentence finding this chart should convey?**
   The title of the finished figure will be this sentence.
2. **Who is the audience?** (colleagues, executives, peer reviewers,
   general public, mixed) — this sets density and annotation load.
3. **Where will it be shown?** (paper figure, slide, dashboard, poster,
   web) — this sets aspect ratio, font size, and export format.
4. **What comparison is the reader supposed to make?** (across time,
   across groups, against a benchmark, distribution shape) — this
   sets the chart type.

If the user provides data or an existing chart, read/inspect it
before asking, so questions are grounded.

### Step 2 — Pick the chart type from the comparison

| Comparison the reader must make | Default chart |
|---|---|
| Trend over time, one series | Line, wide aspect (~golden ratio) |
| Trend over time, many series | Small multiples of lines, shared scale |
| Rank or magnitude across categories | Horizontal dot plot, sorted by value |
| Distribution of one variable | Strip plot with jitter, or histogram with hairline bars |
| Two continuous variables | Scatter, square aspect, with marginal ticks |
| Part-to-whole across groups | Stacked horizontal bar, or small multiples of pies (rarely — usually replace with dot plot) |
| Change between two states | Slope chart or dumbbell |
| Density across a grid (geo, time × category) | Small multiples heatmap, sequential palette |

**Never default to a pie chart.** Never default to a stacked bar with
>3 stacks. Never default to dual y-axes. Never default to 3-D.

### Step 3 — Apply the data-ink pass

For the code or figure you produce, remove or fade every one of these
unless there is a specific reason to keep it:

- Chart border and plot-area fill.
- Gridlines (or fade to ~10% grey hairlines).
- Legend (replace with direct end-of-line labels, colored to match).
- Axis lines beyond the data range (use range frames).
- Minor tick marks.
- Redundant value labels on bars *and* axes — pick one.
- Every color that isn't encoding a variable.
- Every decimal place beyond the reader's ability to act on it.

### Step 4 — Establish the visual hierarchy

Three layers, three weights:

- **Data** — darkest, most saturated, thickest strokes.
- **Direct labels and annotations** — medium weight, black or 40% grey.
- **Reference elements** (axes, gridlines, zero line) — lightest,
  ~20–30% grey, hairline.

If the eye lands on axes before data, invert the weights.

### Step 5 — Color

- **Grayscale first.** Draft in grayscale. Add color only where it
  encodes a variable or highlights a specific finding.
- **Muted field, saturated accent.** Background off-white or #FAFAFA.
  Non-focal series in grey (#BBB or #999). Focal series in one
  saturated hue.
- **Palettes:** categorical → Okabe–Ito or ColorBrewer Set2.
  Sequential → viridis or ColorBrewer single-hue.
  Diverging → ColorBrewer RdBu or BrBG through a neutral midpoint.
- **Never rainbow/jet for quantitative data.**
- **Colorblind check:** confirm the palette works for deuteranopia.
  Simulators: viz.a11y.com, Coblis, or the `colorspace` R package.

### Step 6 — Typography

- **One typeface** for the whole figure. Prefer a humanist sans
  (Inter, Source Sans, Fira Sans, IBM Plex Sans) or, for scientific
  publication, a serif (ETBembo, Charter, Source Serif, or the
  journal's required face).
- **Sizes:** title ~1.2× body, axis labels = body, tick labels = body
  × 0.9, annotations = body × 0.85. Never smaller than 7pt at final
  display size.
- **Title is the finding**, not the topic. Left-aligned, one line if
  possible.
- **Subtitle** for context (units, time range, n, geography).
- **Caption/footnote** for source and methodology, small, at bottom.

### Step 7 — Small multiples when comparing ≥3 groups

If the comparison is across ≥3 categories, default to small multiples:

- Same chart type, same axes, same scale across all panels.
- Sorted by a meaningful order (effect size, time, geography) — never
  alphabetical unless alphabetical *is* the story.
- 3–8 panels per row is typical; ≤ ~20 panels total for a print figure.
- Panel titles are the category name only; don't repeat "chart of X for
  Y" for every panel.

### Step 8 — Export at professional quality

**Vector when possible, raster when necessary.**

- Print / paper figure: PDF or SVG, fonts embedded. Never PNG.
- Slide deck: SVG or PNG at ≥ 200 DPI at final display size.
- Web: SVG for line/scatter/small-multiples; PNG or WebP at 2× DPR
  for dense heatmaps.
- Dashboard: whatever the platform accepts, but design at the actual
  display size, not zoomed.

**Reference export settings per tool** (use as defaults; adjust to
context):

- **matplotlib:** `plt.savefig(..., dpi=300, bbox_inches='tight',
  format='pdf')`. Use `matplotlib.rcParams['pdf.fonttype'] = 42` to
  embed TrueType fonts.
- **ggplot2:** `ggsave(..., width=W, height=H, units='in', dpi=300,
  device=cairo_pdf)` for PDF with embedded fonts.
- **Observable Plot / D3:** export as SVG; if rasterizing, render at
  2× the display size then downscale.
- **Plotly:** `fig.write_image(..., format='pdf', width=..., height=...,
  scale=2)`; requires `kaleido`.
- **Vega-Lite:** `vl-convert` to SVG or PDF.

### Step 9 — Verify against the checklist

Before declaring done, run the checklist in `PRINCIPLES.md` §11.
If any item fails, revise. Small edits are cheap; shipped bad figures
are not.

## Redesign mode

When the user provides an existing figure to improve:

1. **Diagnose.** List every violation of the principles in
   `PRINCIPLES.md`, referencing the section number. Be specific:
   "gridlines are dominant (§3, §8)", not "gridlines are bad".
2. **Prioritize.** Which fixes give the biggest gain per unit effort?
   Usually: kill chartjunk, then rework the palette, then relabel.
3. **Redraw.** Produce the improved version. If code is available,
   modify it in place. If only an image is available, reproduce the
   chart with plausible data in the user's preferred tool and note
   that the data is illustrative.
4. **Show side-by-side.** Before/after helps the user learn the
   principles by seeing them applied.

## Tool-agnostic — but be opinionated

The user may not specify a tool. Ask once ("what tool do you want
this in?") and default sensibly if they don't answer:

- Python user, tabular data → matplotlib + a thin custom style.
- R user → ggplot2 with a stripped-down theme (`theme_minimal()` as
  a starting point, then remove more).
- JS user, web target → Observable Plot for speed, D3 for full control.
- No preference, one-off image → matplotlib (widely available).
- No preference, publication → whatever the venue expects; usually
  PDF from ggplot2 or matplotlib.

## Style presets to reach for

If the target tool has a built-in Tufte-adjacent style, start there
and then still remove more:

- **matplotlib:** start with `plt.style.use('seaborn-v0_8-whitegrid')`
  then remove the grid, spines, and background.
- **ggplot2:** `theme_minimal(base_family="Inter") +
  theme(panel.grid.minor=element_blank(), panel.grid.major=element_line(size=0.2, color="grey90"))`.
  Or use the `ggthemes::theme_tufte()` package as a stronger starting point.
- **Observable Plot:** already close to Tufte defaults; mostly just
  disable the frame and grid.

Never accept a preset as-is. Presets are a floor, not a ceiling.

## What to hand back to the user

- The final figure (image file path or inline preview if the harness
  supports it).
- The code that produced it (in a code block, editable).
- A short "what I did and why" list, citing the principle numbers
  from `PRINCIPLES.md`.
- Any assumption you made about the data, audience, or medium that
  the user should confirm.

## What to refuse

- Making a chart *worse* than the principles suggest (e.g. adding
  chartjunk on request) — push back, explain the cost, and only
  comply if the user insists after being warned.
- Claiming a chart is "Tufte-approved" if you skipped the checklist.
