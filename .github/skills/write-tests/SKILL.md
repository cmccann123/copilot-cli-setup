---
name: write-tests
description: Use this skill when asked to write tests, add test coverage, generate test stubs, or test a function or file. Supports pytest (Python) and jest/vitest (TypeScript/JavaScript).
---

## When to Use
Use when the user asks to:
- "write tests for this"
- "add test coverage"
- "generate test stubs"
- "test this function/file/module"

## Process

1. **Identify the test framework** based on the project:
   - Python → `pytest` with `pytest-asyncio` for async functions
   - TypeScript/JS → `vitest` (preferred) or `jest`

2. **Scan the target file** for:
   - All public functions and methods
   - Edge cases: empty inputs, null/None, large inputs, error paths
   - Any async operations (need async test wrappers)

3. **Generate tests that cover:**
   - Happy path (expected inputs → expected outputs)
   - Edge cases (empty, None/null, boundary values)
   - Error cases (invalid inputs, expected exceptions)
   - Any async behaviour

4. **File placement:**
   - Python: `tests/test_<filename>.py`
   - TypeScript: `<filename>.test.ts` alongside the source file

## Python Test Template
```python
import pytest
from <module> import <function>

def test_<function>_happy_path():
    result = <function>(<valid_input>)
    assert result == <expected>

def test_<function>_empty_input():
    with pytest.raises(<ExpectedException>):
        <function>(<empty_input>)

@pytest.mark.asyncio
async def test_<async_function>():
    result = await <async_function>(<input>)
    assert result is not None
```

## TypeScript Test Template
```typescript
import { describe, it, expect } from 'vitest'
import { <function> } from './<module>'

describe('<function>', () => {
  it('returns expected output for valid input', () => {
    expect(<function>(<input>)).toEqual(<expected>)
  })

  it('throws on invalid input', () => {
    expect(() => <function>(null)).toThrow()
  })
})
```

## Rules
- Never mock what you don't have to
- One assertion per test where possible
- Test names should read as sentences: `it('returns null when user not found')`
- Always test the error path — happy path alone is not enough
