#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-$ROOT_DIR/tmp/diagram-codex}"
SVG_FILE="$OUT_DIR/codex-workflow-architecture.svg"
PNG_FILE="$OUT_DIR/codex-workflow-architecture@2x.png"

mkdir -p "$OUT_DIR"

cat > "$SVG_FILE" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 980 620">
  <defs>
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#1e293b" stroke-width="0.5"/>
    </pattern>
    <marker id="arrow-cyan" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#22d3ee"/>
    </marker>
    <marker id="arrow-emerald" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#34d399"/>
    </marker>
    <marker id="arrow-orange" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#fb923c"/>
    </marker>
    <style>
      @import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600;700&amp;display=swap');
      text { font-family: 'JetBrains Mono', 'Noto Sans SC', 'PingFang SC', sans-serif; }
      .title { fill: white; font-size: 16px; font-weight: 700; }
      .subtitle { fill: #94a3b8; font-size: 9px; }
      .label { fill: white; font-size: 11px; font-weight: 600; }
      .sub { fill: #94a3b8; font-size: 9px; }
      .small { fill: #cbd5e1; font-size: 8px; }
    </style>
  </defs>

  <rect width="100%" height="100%" fill="#0f172a"/>
  <rect width="100%" height="100%" fill="url(#grid)"/>

  <text x="30" y="36" class="title">Codex Reusable Workflow Architecture</text>
  <text x="30" y="54" class="subtitle">From one-off prompting to stable reusable execution assets</text>

  <rect x="250" y="96" width="620" height="420" rx="12" fill="none" stroke="#fbbf24" stroke-width="1" stroke-dasharray="8,4"/>
  <text x="264" y="114" fill="#fbbf24" font-size="9" font-weight="600">Reusable Workflow System</text>

  <line x1="170" y1="230" x2="250" y2="230" stroke="#22d3ee" stroke-width="2" marker-end="url(#arrow-cyan)"/>
  <line x1="410" y1="230" x2="500" y2="230" stroke="#34d399" stroke-width="2" marker-end="url(#arrow-emerald)"/>
  <line x1="660" y1="230" x2="760" y2="230" stroke="#fb923c" stroke-width="2" marker-end="url(#arrow-orange)"/>
  <line x1="820" y1="260" x2="820" y2="330" stroke="#34d399" stroke-width="2" marker-end="url(#arrow-emerald)"/>
  <line x1="580" y1="330" x2="580" y2="400" stroke="#34d399" stroke-width="2" marker-end="url(#arrow-emerald)"/>

  <text x="205" y="220" class="small">source request</text>
  <text x="454" y="220" class="small">codified task</text>
  <text x="707" y="220" class="small">repeatable execution</text>
  <text x="831" y="300" class="small">generated assets</text>
  <text x="591" y="375" class="small">validation loop</text>

  <rect x="30" y="190" width="140" height="70" rx="6" fill="#0f172a"/>
  <rect x="30" y="190" width="140" height="70" rx="6" fill="rgba(8,51,68,0.4)" stroke="#22d3ee" stroke-width="1.5"/>
  <text x="100" y="218" class="label" text-anchor="middle">Article / Prompt</text>
  <text x="100" y="238" class="sub" text-anchor="middle">user request</text>

  <rect x="250" y="190" width="160" height="70" rx="6" fill="#0f172a"/>
  <rect x="250" y="190" width="160" height="70" rx="6" fill="rgba(8,51,68,0.4)" stroke="#22d3ee" stroke-width="1.5"/>
  <text x="330" y="218" class="label" text-anchor="middle">Skill Layer</text>
  <text x="330" y="238" class="sub" text-anchor="middle">workflow intent</text>

  <rect x="500" y="190" width="160" height="70" rx="6" fill="#0f172a"/>
  <rect x="500" y="190" width="160" height="70" rx="6" fill="rgba(6,78,59,0.4)" stroke="#34d399" stroke-width="1.5"/>
  <text x="580" y="218" class="label" text-anchor="middle">Script Layer</text>
  <text x="580" y="238" class="sub" text-anchor="middle">saved prompt files</text>

  <rect x="760" y="190" width="120" height="70" rx="6" fill="#0f172a"/>
  <rect x="760" y="190" width="120" height="70" rx="6" fill="rgba(120,53,15,0.3)" stroke="#fbbf24" stroke-width="1.5"/>
  <text x="820" y="218" class="label" text-anchor="middle">Runner</text>
  <text x="820" y="238" class="sub" text-anchor="middle">bun / imagine</text>

  <rect x="730" y="330" width="180" height="110" rx="8" fill="#0f172a"/>
  <rect x="730" y="330" width="180" height="110" rx="8" fill="rgba(76,29,149,0.4)" stroke="#a78bfa" stroke-width="1.5"/>
  <text x="820" y="360" class="label" text-anchor="middle">Reusable Outputs</text>
  <text x="820" y="382" class="sub" text-anchor="middle">markdown / images / slides</text>
  <text x="820" y="404" class="sub" text-anchor="middle">stable artifacts</text>

  <rect x="490" y="400" width="180" height="70" rx="6" fill="#0f172a"/>
  <rect x="490" y="400" width="180" height="70" rx="6" fill="rgba(136,19,55,0.4)" stroke="#fb7185" stroke-width="1.5"/>
  <text x="580" y="428" class="label" text-anchor="middle">Validation</text>
  <text x="580" y="448" class="sub" text-anchor="middle">doctor + smoke tests</text>

  <rect x="30" y="520" width="200" height="64" rx="8" fill="#0f172a" stroke="#334155" stroke-width="1"/>
  <text x="46" y="542" fill="#cbd5e1" font-size="9" font-weight="600">Legend</text>
  <text x="46" y="560" class="small">Cyan: input / skill</text>
  <text x="46" y="574" class="small">Green: execution / verification</text>
</svg>
EOF

bun "$ROOT_DIR/skills/baoyu-diagram/scripts/main.ts" "$SVG_FILE"

echo "SVG: $SVG_FILE"
echo "PNG: $PNG_FILE"
ls -lh "$SVG_FILE" "$PNG_FILE"
