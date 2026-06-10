#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROOFS_DIR="$ROOT_DIR/proofs"

mkdir -p "$PROOFS_DIR"

for family_dir in "$ROOT_DIR"/fonts/*; do
  [[ -d "$family_dir" ]] || continue
  family_key="$(basename "$family_dir")"
  css_path="../fonts/$family_key/css/$family_key.css"
  html_path="$PROOFS_DIR/$family_key.html"
  case "$family_key" in
    kappa-text)
      family_name="Kappa Text"
      ;;
    kappa-mark)
      family_name="Kappa Mark"
      ;;
    kappa-mono)
      family_name="Kappa Mono"
      ;;
    kappa-spin)
      family_name="Kappa Spin"
      ;;
    kappa-form)
      family_name="Kappa Form"
      ;;
    *)
      family_name="$family_key"
      ;;
  esac

  cat > "$html_path" <<HTML
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${family_key} proof</title>
    <link rel="stylesheet" href="$css_path">
    <style>
      body {
        margin: 0;
        padding: 40px;
        font-family: system-ui, sans-serif;
        background: #f7f4ef;
        color: #1f1b16;
      }
      main {
        max-width: 960px;
        margin: 0 auto;
      }
      section {
        margin: 0 0 36px;
        padding: 24px;
        background: rgba(255, 255, 255, 0.9);
        border: 1px solid #d4cabd;
      }
      h1, h2 {
        margin: 0 0 16px;
      }
      .sample-xl {
        font-size: 52px;
        line-height: 1.1;
        font-family: '${family_name}', sans-serif;
      }
      .sample-md {
        font-size: 24px;
        line-height: 1.4;
        font-family: '${family_name}', sans-serif;
      }
      .sample-sm {
        font-size: 16px;
        line-height: 1.6;
        font-family: '${family_name}', sans-serif;
      }
      .mono-grid {
        white-space: pre-wrap;
      }
      .focus-grid {
        display: grid;
        gap: 16px;
      }
      .focus-card {
        padding: 16px;
        border: 1px solid #d4cabd;
        background: #fcfaf7;
      }
      .focus-label {
        margin: 0 0 8px;
        font: 600 12px/1.4 system-ui, sans-serif;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: #6f6254;
      }
    </style>
  </head>
  <body>
    <main>
      <h1>${family_key}</h1>
      <section>
        <h2>Display</h2>
        <div class="sample-xl">Sphinx of black quartz, judge my vow.</div>
      </section>
      <section>
        <h2>Paragraph</h2>
        <div class="sample-md">Kappa Type alpha proof. The first milestone validates naming, licensing, packaging, and basic rendering before any manual glyph redesign begins.</div>
      </section>
      <section>
        <h2>Character Set</h2>
        <div class="sample-sm mono-grid">ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
0123456789
! ? &amp; @ # $ % * ( ) [ ] { } / \\ - _ + = : ; , .</div>
      </section>
HTML

  if [[ "$family_key" == "kappa-mark" ]]; then
    cat >> "$html_path" <<HTML
      <section>
        <h2>Frozen Design Focus</h2>
        <div class="sample-sm">Kappa Mark is visually frozen for now. Use this section to inspect future changes before approving any design edits.</div>
        <div class="focus-grid">
          <div class="focus-card">
            <div class="focus-label">Lowercase Watchlist</div>
            <div class="sample-xl">q y z</div>
            <div class="sample-md">quartz lazy zigzag cozy query</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Uppercase Watchlist</div>
            <div class="sample-xl">G I Z</div>
            <div class="sample-md">GIZMO ZIG IONIC GALA ZINC</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Numeral Watchlist</div>
            <div class="sample-xl">3 7</div>
            <div class="sample-md">3377 73.37 7/3 3,773</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Kerning Snapshot</div>
            <div class="sample-md">TA VA WA YA FA LT LY AV AW AY To Yo</div>
          </div>
        </div>
      </section>
HTML
  fi

  if [[ "$family_key" == "kappa-text" ]]; then
    cat >> "$html_path" <<HTML
      <section>
        <h2>Reading Review Focus</h2>
        <div class="sample-sm">Kappa Text should stay non-visual during source adoption. Use this section to compare reading texture, punctuation, and style mapping before approving the baseline.</div>
        <div class="focus-grid">
          <div class="focus-card">
            <div class="focus-label">Reading Texture</div>
            <div class="sample-md">In the quiet archive, the editor compared every line for rhythm, weight, contrast, and the subtle steadiness that makes long reading feel natural.</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Italic Contrast</div>
            <div class="sample-md"><em>The italic should feel related, not decorative, and it should keep pace with the regular in long-form reading.</em></div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Bold Mapping</div>
            <div class="sample-md"><strong>Bold text must look clearly stronger than regular without collapsing counters or darkening the paragraph texture too aggressively.</strong></div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Punctuation And Figures</div>
            <div class="sample-md">“Quoted text,” commas, periods, semicolons, em dashes, and 1234567890 should all read evenly in editorial copy.</div>
          </div>
        </div>
      </section>
HTML
  fi

  if [[ "$family_key" == "kappa-mono" ]]; then
    cat >> "$html_path" <<HTML
      <section>
        <h2>Frozen Source Focus</h2>
        <div class="sample-sm">Kappa Mono source adoption should remain non-visual for now. Use this section to compare against Commit Mono before approving any design edits.</div>
        <div class="focus-grid">
          <div class="focus-card">
            <div class="focus-label">Ambiguous Glyphs</div>
            <div class="sample-xl">0 O o 1 l I |</div>
            <div class="sample-md mono-grid">O0O0  101I  Il1|  oO0o</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Deferred Redesign Watchlist</div>
            <div class="sample-xl">0 3 g</div>
            <div class="sample-md mono-grid">0033  g g g  30g  go3  g303</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Coding Punctuation</div>
            <div class="sample-xl">{ } [ ] ( ) &lt; &gt;</div>
            <div class="sample-md mono-grid">() {} [] &lt;&gt;  =&gt;  -&gt;  ==  !=  &lt;=  &gt;=</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Slashes And Quotes</div>
            <div class="sample-xl">/ \\ ' "</div>
            <div class="sample-md mono-grid">path/to/file  C:\\Code\\KM  code  'x'  "y"</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Code Sample</div>
            <div class="sample-sm mono-grid">if (value == 0) {
    return list[i] != map["key"];
}
const arrow = (x) =&gt; x &gt;= 7 ? "ok" : "no";</div>
          </div>
        </div>
      </section>
HTML
  fi

  if [[ "$family_key" == "kappa-form" ]]; then
    cat >> "$html_path" <<HTML
      <section>
        <h2>Review Focus</h2>
        <div class="sample-sm">Kappa Form should stay visually faithful to the imported Open Sans baseline for now. Use this section to compare size, color, text texture, and weight mapping before freezing the family.</div>
        <div class="focus-grid">
          <div class="focus-card">
            <div class="focus-label">Reading Texture</div>
            <div class="sample-md">Open civic forms, dense dashboards, and neutral interface copy all depend on even rhythm, calm spacing, and predictable paragraph color.</div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Weight Range</div>
            <div class="sample-md">Light Regular SemiBold Bold ExtraBold</div>
            <div class="sample-md"><span style="font-weight:300">Light sample text.</span> <span style="font-weight:400">Regular sample text.</span> <span style="font-weight:600">SemiBold sample text.</span></div>
            <div class="sample-md"><span style="font-weight:700">Bold sample text.</span> <span style="font-weight:800">ExtraBold sample text.</span></div>
          </div>
          <div class="focus-card">
            <div class="focus-label">Italic Review</div>
            <div class="sample-md"><em>Italic text should remain steady, usable, and consistent with the upright family across editorial and interface contexts.</em></div>
          </div>
          <div class="focus-card">
            <div class="focus-label">UI And Numbers</div>
            <div class="sample-md">Save Draft  Cancel  Continue  0123456789  10:45  v2.1.7  48px  73%</div>
          </div>
        </div>
      </section>
HTML
  fi

  cat >> "$html_path" <<HTML
    </main>
  </body>
</html>
HTML
done
