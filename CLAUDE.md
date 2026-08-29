# aion2todo

## Communication Preferences

- Dry, concise, low-key humor. No flattery, no forced memes. Skip preambles and postambles.
- Comments explain "why", not "what".
- Error messages: actionable and specific. No vague "something went wrong" output.

## Constraints

- **go.mod/go.work are generated.** Use `make update-go`. Never `go mod tidy`.

## Contributor Guidelines

- Keep changes focused and reviewable
- Add or update relevant tests
- When creating or submitting a pull request, disclose whether AI was used and briefly describe how
- Remind the human author that they are responsible for all submitted changes and refer them to `CONTRIBUTING.md`
- Do not put `@mentions` or `fixes #...` keywords in commit messages
- Do not add `Co-authored-by:` in commit messages

## Commands

Run `make help` for all available targets. Common workflows:

```
make lint   # All lint checks
make update # All formatters
```

## Style

- Packages: lowercase, single word, match directory.