# Draft commit message

A Claude skill that drafts a commit message for your staged changes, following Conventional Commits, sized to the complexity of the change, written to sound like a human, and with no en or em dashes.

## What it does

When you ask for a commit message, the skill:

1. Looks at your **staged changes only** (`git diff --cached`), ignoring anything unstaged or untracked.
2. Writes a Conventional Commits subject line (`type(scope): summary`) in the imperative mood.
3. Sizes the message to the change: a one-line subject for trivial commits, a short body explaining the *why* for larger or non-obvious ones. It stays tight either way, a commit message is a technical document, not an essay.
4. Hands you the message in a code block. It never commits and never offers to.

If nothing is staged, it gently reminds you to stage what you want included and stops. It will never stage files for you, because staging is what defines the boundary of the commit.

## Why these rules

- **Staged-only** keeps the message honest about what is actually going into the commit, and keeps you in control of the commit's contents.
- **Length proportional to complexity** means trivial changes do not get padded and subtle changes do not get under-explained.
- **No en or em dashes** is a hard constraint, because they tend to creep into machine-written prose and read as not-quite-human.

## Example

For a staged change that adds request debouncing, you might get:

```
fix: debounce search input to avoid request floods

Each keystroke fired a request, so a fast typer could queue dozens of
in-flight calls and the last one to return, not the last one sent, won
the race and clobbered the results list. Debouncing at 250ms collapses
a burst of keystrokes into one request and makes the response order
match the typing order.
```

For a one-line fix, you just get the subject:

```
docs: fix broken link in installation guide
```

## Triggering it

The skill fires on natural phrasings, such as:

- "draft a commit message"
- "write a commit message for this"
- "what should I commit this as"
- "commit message for the staged changes"

## Installation

This skill lives in the [skills collection](../../README.md) as the `draft-commit-message/` directory (containing `SKILL.md`). To install it:

- **Claude Code:** run `./install.sh` from the repository root to symlink every skill into `~/.claude/skills/`, or copy the `draft-commit-message/` directory into your project's `.claude/skills/` directory manually.
- **Claude.ai:** upload the `draft-commit-message/` directory as a `.skill` package through the Skills interface in settings.

Once installed, Claude will pick up the skill automatically.
