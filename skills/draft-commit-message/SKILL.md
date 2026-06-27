---
name: draft-commit-message
description: Draft a Conventional Commits message for the currently staged changes, sized to the complexity of the change, that reads like a human wrote it and contains no en or em dashes. Use when the user asks to draft, write, or suggest a commit message, or asks "what should I commit this as" or "commit message for this". The skill inspects staged changes only and never stages files or commits.
---

# Draft commit message

A skill for turning the staged changes into a single, well-formed commit message that the user can review and use. It drafts; it does not commit, and it never stages anything.

## The point

A good commit message is a small technical document. It says what changed in a form the next reader can scan (the Conventional Commits subject line), and, when the change is not self-evident, it says *why* the change was made. The length should track the change: a one-line fix gets one line; a subtle or far-reaching change earns a short body that justifies itself. The job here is to produce that message and nothing more, so the user stays in control of what actually gets committed.

## Scope: staged changes only

Look only at what is staged. Use:

- `git diff --cached --stat` for the shape of the change (which files, how much).
- `git diff --cached` for the actual content, so the message describes what really changed rather than what the filenames suggest.

Ignore unstaged and untracked files completely. They are not part of this commit, and mentioning them in the message would be wrong.

## If nothing is staged

Before drafting, check whether anything is staged (for example, `git diff --cached --quiet` exits non-zero when there are staged changes). If nothing is staged, do not invent a message. Gently tell the user there is nothing staged yet and ask them to stage what they want included, for example with `git add <paths>`, then re-invoke.

**Never stage files yourself.** This skill does not run `git add`, `git add -A`, `git commit -a`, or anything else that changes what is staged, under any circumstances. Staging is the user's decision because it defines the boundary of the commit.

## The format

Follow Conventional Commits:

```
type(optional scope): summary
```

- **Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`, `style`. Pick the one that matches the primary intent of the change.
- **Scope:** include it when it sharpens the message (the area or module touched), omit it when it would just be noise.
- **Summary:** imperative mood ("add", not "added" or "adds"), lowercase, no trailing period. Keep it short, aim for about 50 characters and treat ~72 as a hard ceiling.

## Length proportional to complexity

Match the message to the change:

- **Trivial or single-purpose change** (a typo, a version bump, a one-line fix): the subject line alone. No body. A body here is just padding.
- **Larger or non-obvious change:** add a body that explains the **why**, the reason the change is needed or the reason it took the shape it did. Do not narrate the diff line by line; the diff already says what changed. The body exists to capture what the diff cannot: intent, trade-offs, the constraint that forced an unusual approach.

Keep the body tight even when it is warranted. This is a technical document, so it should carry enough detail to justify the change and no more. Resist wordiness. Put a blank line between the subject and the body, and wrap body lines at about 72 characters.

## Human voice, no dashes

Write the way a careful engineer writes in a commit log. Plain, direct, specific. Avoid filler, marketing language, and AI throat-clearing like "This commit" or "In this change".

**Hard constraint: no en dashes (–) or em dashes (—) anywhere in the message.** This is non-negotiable. Use a regular hyphen, a comma, or two sentences instead. Check the whole message for these characters before presenting it.

## No trailers

Do not append `Co-Authored-By` or any other trailer or footer. Draft the human-readable message only. If the project's tooling needs trailers, the user adds them.

## Output

Present the finished message in a single fenced code block, with nothing dressing it up. Do not commit it, and do not offer to commit it; handing the user the message is where this skill ends.

If the staged changes look like several unrelated commits bundled together, say so briefly and suggest the user may want to split them, but still draft a message for what is currently staged.

## Examples

**Trivial change, subject only:**

```
docs: fix broken link in installation guide
```

**Non-obvious change, subject plus a why-focused body:**

```
fix: debounce search input to avoid request floods

Each keystroke fired a request, so a fast typer could queue dozens of
in-flight calls and the last one to return, not the last one sent, won
the race and clobbered the results list. Debouncing at 250ms collapses
a burst of keystrokes into one request and makes the response order
match the typing order.
```

Both examples use only regular hyphens and read like a person wrote them. That is the target.
