---
applyTo: "**/*.ts,**/*.tsx"
---

# TypeScript Instructions

- **No `any` types** — use `unknown` and narrow, or define proper types
- Use **`zod`** for runtime validation of API responses and env vars
- Use **React Query (`@tanstack/react-query`)** for server state in React apps
- Use **`axios`** or native `fetch` with typed wrappers — not raw untyped calls
- Use **Tailwind CSS** for styling — avoid inline styles
- Organise React apps as: `components/`, `hooks/`, `services/`, `types/`, `pages/`
- Use **environment variables** via `import.meta.env` (Vite) or `process.env` (Node)
- Prefer **named exports** over default exports for better refactoring
- Use **`@azure/openai`** for Azure OpenAI calls in Node.js
- Always handle loading and error states in React components
