import type { BarRow } from '../types'

export type Segment = { name: string; tokens: number; color: string; kind: BarRow['kind']; cells: number }

const BY_NAME: [RegExp, string][] = [
  [/system prompt/i, '#818cf8'],
  [/system tools/i, '#38bdf8'],
  [/mcp/i, '#2dd4bf'],
  [/agent/i, '#a78bfa'],
  [/memory/i, '#fbbf24'],
  [/skill/i, '#fb923c'],
  [/message/i, '#f472b6'],
]
const SPARE = ['#a3e635', '#f87171', '#e879f9', '#22d3ee']

function paint(rows: readonly BarRow[]): BarRow[] {
  let spare = 0
  return rows.map(r => {
    if (r.kind === 'free') return { ...r, color: '#6b7280' }
    if (r.kind === 'buffer') return { ...r, color: '#9ca3af' }
    const hit = BY_NAME.find(([re]) => re.test(r.name))
    return { ...r, color: hit ? hit[1] : (SPARE[spare++ % SPARE.length] ?? '#a3e635') }
  })
}

// Largest-remainder split of `width` cells across the rows, so the bar always fills exactly.
export function segments(rows: readonly BarRow[], max: number, width: number): Segment[] {
  const live = paint(rows).filter(r => r.kind !== 'deferred' && r.tokens > 0)
  if (max <= 0 || width <= 0 || live.length === 0) return []

  const exact = live.map(r => (r.tokens / max) * width)
  const cells = exact.map(Math.floor)
  let left = width - cells.reduce((a, b) => a + b, 0)
  const order = exact
    .map((x, i) => ({ i, frac: x - Math.floor(x) }))
    .sort((a, b) => b.frac - a.frac)
  for (const { i } of order) {
    if (left <= 0) break
    cells[i] = (cells[i] ?? 0) + 1
    left -= 1
  }

  return live.map((r, i) => ({ ...r, cells: cells[i] ?? 0 })).filter(s => s.cells > 0)
}

export function compact(n: number): string {
  return n >= 1000 ? `${(n / 1000).toFixed(n >= 10000 ? 0 : 1)}k` : String(n)
}

// ANSI colors follow the terminal theme like the statusline; `warning` is the theme's orange step.
export function pctColor(percentage: number): string {
  if (percentage >= 90) return 'red'
  if (percentage >= 75) return 'warning'
  if (percentage >= 50) return 'yellow'
  return 'green'
}

export function shortModel(model: string): string {
  return model.replace(/^claude-/, '')
}

const SHORT: [RegExp, string][] = [
  [/system prompt/i, 'Prompt'],
  [/system tools/i, 'Tools'],
  [/mcp/i, 'MCP'],
  [/custom agents|agents/i, 'Agents'],
  [/memory/i, 'Memory'],
  [/skills/i, 'Skills'],
  [/messages/i, 'Msgs'],
  [/free/i, 'Free'],
]

export function shortName(name: string): string {
  return SHORT.find(([re]) => re.test(name))?.[1] ?? name
}
