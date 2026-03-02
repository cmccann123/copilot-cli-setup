---
applyTo: "**/*.py"
---

# Python Instructions

- Use **type hints** on all function signatures
- Use **async/await** for I/O-bound operations (HTTP calls, DB queries, file I/O)
- Use **`httpx`** (not `requests`) for HTTP calls — it supports async
- Use **`pydantic`** for data validation and settings management
- Use **`python-dotenv`** to load environment variables in dev
- Use **`structlog`** or Python's built-in `logging` with structured output
- Use **`pytest`** for tests with `pytest-asyncio` for async tests
- Organise FastAPI apps as: `main.py`, `routers/`, `models/`, `services/`, `config.py`
- Use Azure SDK async clients where available (e.g. `AsyncAzureOpenAI`, `AsyncSearchClient`)
- Handle Azure SDK exceptions explicitly — catch `azure.core.exceptions.HttpResponseError`
