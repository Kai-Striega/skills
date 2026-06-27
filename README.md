# Skills

A personal collection of [Claude skills](https://docs.claude.com/en/docs/claude-code/skills). Each skill lives in its own directory containing a `SKILL.md` (plus an optional `README.md` and any supporting files).

## Installation

Run the install script from the repository root to symlink every skill into your Claude skills directory (`~/.claude/skills/`, or `$CLAUDE_CONFIG_DIR/skills` if set):

```sh
./install.sh           # link all skills
./install.sh --dry-run # show what would be linked, change nothing
```

Re-running is safe. It refreshes existing links and skips anything that isn't a skill. Once linked, Claude picks the skills up automatically.

## Skills

| Skill | Description |
| --- | --- |
| [socrates](./skills/socrates/README.md) | Quizzes you Socratically on a conversation you just had, and only lets you declare yourself "done" once you've shown you actually understand the ideas. |
| [draft-commit-message](./skills/draft-commit-message/README.md) | Drafts a Conventional Commits message for the staged changes, sized to the complexity of the change, with no em or en dashes. |
| [commit-this](./skills/commit-this/README.md) | Drafts a commit message (via draft-commit-message), gets your approval, then creates a signed commit of the staged changes, with an unsigned fallback and a Claude co-author trailer when Claude helped. |

## License

[BSD-3](./LICENSE)
