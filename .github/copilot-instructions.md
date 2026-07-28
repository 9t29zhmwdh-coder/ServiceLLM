# Copilot Instructions for ServiceLLM
ServiceLLM is a macOS AI code assistant that hooks into the system Services menu, so it works with any programming language in any app, Xcode and VS Code included. Select code, right-click, choose Services, ServiceLLM sends the selection to your configured AI provider (Claude, OpenAI, Mistral, or a local model via Ollama/llama.cpp) and returns the result as a popup, clipboard copy, notification, or paste back.
## Code style
- Functions stay small and single-purpose, prefer under 20 lines
- Naming: verb+noun for functions, clear intent for variables, no x/temp/data
- Constants in UPPER_SNAKE_CASE
- Comments explain WHY, never WHAT
- No speculative abstractions
## Text and documentation
- Never use em-dash, en-dash, or a spaced hyphen as a sentence-break substitute, anywhere. Rephrase instead
- README.md and README.de.md must stay in sync
- Any functional change needs a CHANGELOG.md entry and follows semantic versioning
- No separate License badge in README (intentional convention)
## Git workflow
- Branch protection on main: no direct pushes, no force pushes, PR required
- Semantic commit messages: type(scope): description
- One commit = one logical change
## Security
- Never commit secrets/API keys/tokens
- Validate input at actual boundaries only
- Flag security regressions instead of working around them
## Before opening a PR
- Run tests/build, no PR with failing checks
- Keep diff scoped to the task
