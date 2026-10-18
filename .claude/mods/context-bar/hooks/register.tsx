import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { BarData } from '../types'
import { compact, pctColor, segments, shortModel, shortName } from './segments'

const data = atom({ plugin: 'context-bar', key: 'data' } as const, null)
const effort = atom({ plugin: 'context-bar', key: 'effort' } as const, null)
const model = atom({ plugin: 'context-bar', key: 'model' } as const, null)
const isShown = atom({ plugin: 'context-bar', key: 'isShown' } as const, true)

async function refresh($: EngineInterface) {
  try {
    const { context } = await $.session.usage({ breakdown: 'summary' })
    const b = context.breakdown
    if (!b) return
    const next: BarData = {
      rows: b.categories.map(c => ({ name: c.name, tokens: c.tokens, color: c.color, kind: c.kind })),
      max: b.rawMaxTokens,
      total: b.totalTokens,
      percentage: b.percentage,
    }
    await update($, data, () => next)
  } catch {
    // no session bound yet; the next event retries
  }
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'context-bar',
      description: 'Toggle the context window bar above the prompt',
    })
    void refresh($)
    return next(e)
  })

  on('command.run', { command: 'context-bar' }, async $ => {
    const now = !(await read($, isShown))
    await update($, isShown, () => now)
    if (now) await refresh($)
    return { text: `Context bar ${now ? 'on' : 'off'}.` }
  })

  on('prompt.submit', async ($, e, next) => {
    const out = await next(e)
    void refresh($)
    return out
  })

  // The model and effort of the main loop's latest request; it is not readable anywhere else.
  on('turn.step', async function* ($, e, next) {
    if (e.agentId === undefined) {
      const level = e.effort === undefined ? null : String(e.effort)
      await update($, effort, () => level)
      await update($, model, () => e.model)
    }
    return yield* next(e)
  })

  on('turn.complete', async ($, e, next) => {
    await refresh($)
    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const d = await read($, data)
    if (e.props.hasSurvey || d === null || !(await read($, isShown))) return next(e)

    const { Box, Text } = $.ui.resolve(e)
    const level = await read($, effort)
    const stepModel = await read($, model)
    const tag = `${[shortModel(stepModel || d.model || ''), level].filter(Boolean).join(' · ')}`
    const label = `${Math.round(d.percentage)}% `
    const width = Math.max(10, (e.viewport?.columns ?? 80) - 8 - label.length)
    const segs = segments(d.rows, d.max, width)

    return (
      <Box flexDirection="column">
        <Text wrap="truncate">
          <Text bold color={pctColor(d.percentage)}>{label}</Text>
          {segs.map(s => (
            <Text key={s.name} color={s.color}>
              {(s.kind === 'free' ? '░' : s.kind === 'buffer' ? '▒' : '█').repeat(s.cells)}
            </Text>
          ))}
        </Text>
        <Text wrap="truncate">
          {segs
            .filter(s => s.kind !== 'buffer')
            .map(s => (
              <Text key={s.name} color={s.color}>
                {'■ '}
                <Text dimColor>{`${shortName(s.name)} ${compact(s.tokens)}  `}</Text>
              </Text>
            ))}
        </Text>
        {tag !== '' && <Text dimColor>{tag}</Text>}
      </Box>
    )
  })
}
