# Tufte's Principles — Distilled

Source: Edward R. Tufte, *The Visual Display of Quantitative Information*
(Graphics Press, 2nd ed. 2001). This is a working distillation for the
`tufte` skill — not a summary of the whole book, but the operational
principles a designer needs at the moment of making a chart.

---

## 0. The premise

> "Graphical excellence is that which gives to the viewer the greatest
> number of ideas in the shortest time with the least ink in the smallest
> space." — Tufte

A statistical graphic is an **argument**. Its job is to make a comparison
visible so quickly that the reader sees the point before they finish
reading the title. Everything below serves that end.

---

## 1. Graphical excellence — the definition

Excellent graphics:

- Show the **data**, above all else.
- Induce the viewer to think about the **substance**, not the methodology,
  the design, or the software.
- Present many numbers in a small space.
- Make large data sets **coherent** — reveal structure across scales
  (from broad overview to fine detail).
- Encourage the eye to compare different pieces of data.
- Reveal data at several **layers** of detail, from broad overview to
  fine structure.
- Serve a reasonably clear purpose: description, exploration, tabulation,
  or decoration (the last is rarely justified).
- Are closely **integrated** with the statistical and verbal descriptions
  of the data set.

*Test it:* If a reader can look at your chart for five seconds and state
the point in one sentence, you have graphical excellence. If they cannot,
you have decoration.

---

## 2. Graphical integrity — do not lie

Tufte's core measure:

> **Lie Factor** = (size of effect shown in graphic) / (size of effect in data).
> A Lie Factor > 1.05 or < 0.95 means the graphic distorts.

Rules:

1. **The representation of numbers, as physically measured on the surface
   of the graphic itself, should be directly proportional to the numerical
   quantities represented.**
2. **Clear, detailed, and thorough labeling** should defeat graphical
   distortion and ambiguity. Write out explanations of the data on the
   graphic itself. Label important events in the data.
3. **Show data variation, not design variation.** Do not use a fancier
   design just to make the graphic "look interesting."
4. **In time-series displays of money, deflated and standardized units
   are nearly always better than nominal units.**
5. **The number of information-carrying (variable) dimensions depicted
   should not exceed the number of dimensions in the data.** (No 3-D
   pie charts. No area to encode a single number.)
6. **Graphics must not quote data out of context.** Show enough
   surrounding data (before, after, comparators) for the viewer to
   judge the effect.

---

## 3. Maximize the data-ink ratio

**Data-ink** = the non-erasable core of a graphic, the ink that changes
if the numbers change.

> **Data-ink ratio** = data-ink / total ink used to print the graphic.

Five principles, in order:

1. **Above all else, show the data.**
2. **Maximize the data-ink ratio.** Every mark on the page should carry
   information; if it does not, it is a candidate for erasure.
3. **Erase non-data-ink.** Redundant grids, tick marks, boxes, drop
   shadows, gradient fills, background colors — remove them.
4. **Erase redundant data-ink.** If a bar's height already encodes the
   value, the number printed on top is redundant unless precision
   matters. Pick one.
5. **Revise and edit.** Draw the graphic. Then remove things. Then draw
   again. Graphics improve through subtraction.

Concrete moves this implies:

- Kill the chart border. Kill the plot-area fill.
- Kill gridlines, or make them so light they recede (10% grey, hairline).
- Kill or lighten every axis line that isn't doing work.
- No 3-D unless there are three data dimensions.
- No legend if a direct label on the line/point will do.
- No color if grayscale carries the same information.

---

## 4. Erase chartjunk

Chartjunk = decoration that does not carry data:

- **Moiré vibration** — dense hatching, cross-hatching, dot patterns
  that shimmer. Replace with flat light grey.
- **The grid** as a prominent design element — grids should be
  suppressed, at most a faint reference.
- **The duck** — a graphic so overwrought with decoration that the
  design has swallowed the data. Named after Tufte's example of a
  building shaped like a duck.

If the ink can be removed without changing the reader's understanding
of the data, it is chartjunk.

---

## 5. Data density and small multiples

**Data density** = number of entries in data matrix / area of graphic.
Tufte's principle: most published statistical graphics have absurdly low
data density. Do not be afraid of many points, many series, many panels.

**Small multiples** — the same graphic, small, repeated with one variable
changed. They are the most powerful design in the book:

- A grid of the same chart type across categories, time slices, groups.
- Shared axes, shared scale, shared colors — so the eye compares only
  the changing dimension.
- Uniform design across panels: same aspect ratio, same font, same
  reference lines.
- Sort panels in a meaningful order (by effect size, by time, by
  geography) — never alphabetical unless alphabetical *is* the story.

Small multiples let the viewer compare across ~20 panels at a glance.
They defeat the temptation to overload one panel with color and legend.

---

## 6. Multifunctioning graphical elements

One mark should do multiple jobs where possible:

- **Data-based labels.** Label the line at its right end with its name
  and value; the label doubles as legend and endpoint marker.
- **Stem-and-leaf plots.** Digits are both the number and the bar height.
- **Range-frame axes.** Draw axis lines only over the actual range of
  the data — the axis line itself shows the min and max.
- **Dot-dash plot.** Marginal ticks on the axes show the marginal
  distribution of each variable.

Every element pulls double duty. Every erasure that doesn't lose meaning
is a win.

---

## 7. Color

Tufte's rules (drawn from *Envisioning Information* but consistent here):

1. **The natural colors of the world are muted.** Backgrounds should be
   light grey or off-white, never pure white for large fills and never
   saturated. Foreground marks against muted backgrounds pop without
   effort.
2. **To highlight, use color sparingly.** One or two saturated hues
   against a muted field. If everything is highlighted, nothing is.
3. **Use color to encode a variable, not to decorate.** Categorical
   distinctions → distinct hues. Ordered/quantitative → a sequential
   ramp (single hue, varying lightness) or diverging ramp (two hues
   through a neutral midpoint).
4. **Never use rainbow (jet) for quantitative data** — it is not
   perceptually uniform and misleads the eye about magnitude.
5. **Test for colorblindness.** Avoid red/green as the only encoding.
   Prefer palettes like ColorBrewer, viridis, or Okabe–Ito.
6. **Grayscale first.** If the chart works in grayscale, color is
   an enhancement, not a crutch.

---

## 8. Layering and separation

When multiple types of information coexist on one graphic (data, labels,
reference lines, annotations), use **visual hierarchy**:

- Data marks: darkest, most saturated.
- Direct labels / annotations: medium weight.
- Reference lines, axes, gridlines: lightest — they must recede.
- Trend lines: distinct from raw data (dashed, or muted color).
- If two layers of data compete for foreground, use scale, weight, or
  color to establish which is figure and which is ground.

---

## 9. Words, numbers, pictures — together

Tufte insists on the **integration of text and graphic**:

- Titles should state the finding, not the topic.
  Bad: *"Revenue by quarter"*. Good: *"Revenue grew 40% in Q3, driven
  by enterprise renewals."*
- Explanatory annotations live on the chart, next to what they explain,
  not in a caption block or footnote.
- Units, sample size, and time range should be visible on the graphic.
- Source and n= should be present but small.
- If a paragraph of text explains the chart, put it beside the chart,
  not on the previous page.

---

## 10. Aspect ratio and shape

- Time series should generally be **wider than tall** (~golden ratio,
  or the "banking to 45°" heuristic: choose an aspect ratio such that
  the average absolute slope of line segments approaches 45°). This
  makes rate-of-change legible.
- Scatterplots without a natural time axis often work best square.
- Small multiples: choose a shape that lets ~4–8 panels fit across the
  reader's line of sight without shrinking below legibility.

---

## 11. The Tufte checklist — before you ship a figure

Read this before every chart leaves your hands.

**Substance**
- [ ] Can the reader state the finding in one sentence within 5 seconds?
- [ ] Is the title the *finding*, not the topic?
- [ ] Are units, sample size, time range, and source visible?

**Integrity**
- [ ] Lie Factor between 0.95 and 1.05?
- [ ] Do axes start at zero when the scale of the bars/areas implies it
      (bar charts always; line charts only when zero is meaningful)?
- [ ] Are dimensions in the graphic ≤ dimensions in the data?
- [ ] Is the data shown in context (comparison group, time before/after)?

**Data-ink**
- [ ] Removed chart border?
- [ ] Removed plot-area fill?
- [ ] Removed or lightened gridlines to a faint reference?
- [ ] Erased redundant legend where direct labels work?
- [ ] Erased 3-D, drop shadows, gradients, moiré patterns?
- [ ] Every remaining mark carries information?

**Color**
- [ ] Muted background, saturated foreground only where highlighting?
- [ ] Palette is colorblind-safe (test in grayscale and simulator)?
- [ ] No rainbow/jet for quantitative data?

**Typography and labels**
- [ ] Same typeface throughout the figure?
- [ ] Direct labels on lines/points instead of legends where possible?
- [ ] Annotations placed *at* the thing they explain?
- [ ] Numbers formatted with appropriate precision (no 6 decimal places)?

**Layout**
- [ ] Aspect ratio matches the story (wide for time, square for scatter)?
- [ ] Small multiples used for comparison across ≥3 categories?
- [ ] Panels sorted in a meaningful order?

**Output**
- [ ] Vector format (PDF/SVG) for anything that will be printed or
      zoomed; PNG at ≥300 DPI otherwise?
- [ ] Fonts embedded?
- [ ] Legible at final display size (test at actual size, not zoomed)?

---

## 12. What Tufte would delete

The fastest way to improve almost any chart:

1. Delete the chart border.
2. Delete the plot-area background fill.
3. Delete the legend; label directly.
4. Delete the gridlines, or fade them to 10% grey.
5. Delete every axis tick that isn't a labeled value.
6. Delete every third decimal place.
7. Delete color that isn't encoding anything.
8. Delete the shadow.
9. Delete the 3-D.
10. Delete the icon in the corner.

Then look at what remains. That's the chart.
