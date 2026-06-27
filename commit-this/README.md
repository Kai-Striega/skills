# Commit this

A Claude skill that drafts a commit message for your staged changes, gets your approval, and then creates a signed commit. It builds on the [draft-commit-message](../draft-commit-message/README.md) skill for the message itself and adds the commit mechanics around it.

## What it does

When you ask Claude to commit, the skill:

1. Looks at your **staged changes only**. If nothing is staged, it reminds you to stage what you want and stops. It never stages files for you.
2. Drafts the message by following the `draft-commit-message` skill (Conventional Commits, length matched to the change, human voice, no en or em dashes).
3. Adds a `Co-Authored-By: Claude ...` trailer, but only if Claude actually helped write the staged changes. If you wrote everything yourself, there is no trailer.
4. Shows you the full message and waits for your approval. Nothing is committed until you say yes.
5. Creates a **signed** commit (`git commit -S`).
6. If signing fails, it tells you why and asks whether to make an unsigned commit instead. It never falls back to unsigned silently.
7. Reports the commit hash and whether it was signed.

## Why these rules

- **Approval before committing** means you always see exactly what is going into history first.
- **Staged-only, never stages** keeps you in control of the commit's contents, the same boundary the draft-commit-message skill respects.
- **Signed by default, explicit unsigned fallback** keeps your commits verifiable without trapping you when a signing key is missing.
- **Trailer only when earned** keeps authorship honest.

## Triggering it

The skill fires on natural phrasings, such as:

- "commit this"
- "commit these changes"
- "make a commit"
- "commit it"

## Example

For a staged, Claude-written bug fix, you might be shown:

```
fix: stop the cache from serving expired entries

The TTL check compared against the write time instead of the current
time, so entries were treated as fresh forever once written. Compare
against now so expiry actually takes effect.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
```

After you approve, Claude runs `git commit -S` and reports back, for example "Committed as a1b2c3d, signed."

## Installation

This skill lives in the [skills collection](../README.md) as the `commit-this/` directory (containing `SKILL.md`). To install it:

- **Claude Code:** run `./install.sh` from the repository root to symlink every skill into `~/.claude/skills/`, or copy the `commit-this/` directory into your project's `.claude/skills/` directory manually.
- **Claude.ai:** upload the `commit-this/` directory as a `.skill` package through the Skills interface in settings.

Once installed, Claude will pick up the skill automatically. It works best alongside `draft-commit-message`, which it relies on for the message text.
