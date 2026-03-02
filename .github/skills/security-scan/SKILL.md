---
name: security-scan
description: Use this skill when asked to check for security issues, scan for hardcoded secrets, audit authentication, or review code for vulnerabilities. Checks for hardcoded secrets, exposed endpoints, missing auth, and insecure patterns.
---

## When to Use
Use when the user asks to:
- "check for security issues"
- "scan for secrets"
- "is this secure"
- "security review"
- "check for hardcoded credentials"

## Process

Scan the codebase for the following, in priority order:

### 🔴 Critical — Fix Immediately

**1. Hardcoded secrets**
Look for patterns like:
```
api_key = "sk-..."
password = "mysecret"
connection_string = "Server=...;Password=..."
token = "ghp_..."
AZURE_CLIENT_SECRET = "abc123"
```
Any string that looks like a key, password, token, or connection string hardcoded in source.

**2. Secrets in git history**
Check if `.env` is in `.gitignore`. If not, flag immediately.

**3. Debug endpoints exposed in production**
```python
app.include_router(debug_router)  # with no auth guard
```

### 🟡 High — Fix Before Production

**4. Missing authentication on routes**
Any HTTP endpoint that modifies data (`POST`, `PUT`, `DELETE`, `PATCH`) with no auth middleware.

**5. SQL injection risk**
String interpolation in queries:
```python
f"SELECT * FROM users WHERE id = {user_id}"  # dangerous
```

**6. CORS too permissive**
```python
allow_origins=["*"]  # dangerous in production
```

**7. Missing HTTPS enforcement**
Any redirect or URL construction using `http://` for non-localhost.

### 🔵 Improvements

**8. Dependency versions unpinned**
`requirements.txt` with `package>=1.0` instead of `package==1.2.3`

**9. Error messages leaking internals**
```python
return {"error": str(e)}  # may expose stack traces or internal paths
```

## Output Format

For each issue found:
- **Severity:** Critical / High / Improvement
- **File and line**
- **Issue:** what the problem is
- **Fix:** exactly what to change

If nothing is found, say so explicitly.
