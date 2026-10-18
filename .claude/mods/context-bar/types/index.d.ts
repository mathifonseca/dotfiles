export type BarRow = { name: string; tokens: number; color: string; kind: 'used' | 'free' | 'buffer' | 'deferred' }
export type BarData = { rows: BarRow[]; max: number; total: number; percentage: number; model: string }

declare module 'claude-code' {
  interface PluginState {
    'context-bar': { data: BarData | null; isShown: boolean; effort: string | null; model: string | null }
  }
}
