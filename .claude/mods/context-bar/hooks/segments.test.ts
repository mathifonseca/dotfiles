import { test, expect } from 'claude-code/testing'
import { pctColor, shortName, shortModel, segments } from './segments'

test('cells fill the width exactly and skip deferred rows', () => {
  const s = segments(
    [
      { name: 'a', tokens: 100, color: 'x', kind: 'used' },
      { name: 'b', tokens: 50, color: 'y', kind: 'used' },
      { name: 'c', tokens: 850, color: 'z', kind: 'free' },
      { name: 'd', tokens: 999, color: 'w', kind: 'deferred' },
    ],
    1000,
    33,
  )
  expect(s.map(x => x.name)).toEqual(['a', 'b', 'c'])
  expect(s.reduce((n, x) => n + x.cells, 0)).toBe(33)
})

test('percentage color climbs with usage', () => {
  const c = [10, 50, 75, 90].map(pctColor)
  expect(new Set(c).size).toBe(4)
})

test('model name drops the claude- prefix', () => {
  expect(shortModel('claude-opus-5-5')).toBe('opus-5-5')
  expect(shortModel('Opus 5.5')).toBe('Opus 5.5')
})

test('legend names are shortened, unknown ones kept', () => {
  expect(shortName('System tools')).toBe('Tools')
  expect(shortName('Memory files')).toBe('Memory')
  expect(shortName('Something new')).toBe('Something new')
})
