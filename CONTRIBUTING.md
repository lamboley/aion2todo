# Contributing to Aion2Todo

Thanks for taking the time to contribute to Aion2Todo!

Please review and follow the [Code of Conduct](CODE_OF_CONDUCT.md).

This is a small project maintained by one person. Issues and pull requests are
welcome.

## Code Convention

**Bash:**

- [Style guide](https://google.github.io/styleguide/shellguide.html)
- Know and avoid [BashPitfalls](https://mywiki.wooledge.org/BashPitfalls)

**Go:**

- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Effective Go](https://golang.org/doc/effective_go.html)
- Know and avoid [Go landmines](https://gist.github.com/lavalamp/4bd23295a9f32706a48f)
- [Go's commenting conventions](http://blog.golang.org/godoc-documenting-go-code)
- Avoid general utility packages.
- All filenames should be lowercase.
- All source files and directories should use underscores, not dashes.

### Opening PRs and organizing commits

PRs should generally address only 1 issue at a time. If you need to fix two bugs, open two separate PRs. This will keep the scope of your pull requests smaller and allow them to be reviewed and merged more quickly.

When possible, fill out as much detail in the pull request template as is reasonable. Most important is to reference the GitHub issue that you are addressing with the PR.

Generally, pull requests should consist of a single logical commit.

As the issue and the PR already include all the required information, commit messages are normally empty. The title of the commit should summarize in a few words what the commit is trying to do.

## Linting

There are CI check for linting the code, you'll need to run the following command before opening a pull request:

- `make lint` must pass without errors

## License

By contributing, you agree that your contributions will be licensed under the [Apache License 2.0](LICENSE), the same license that covers this project.
