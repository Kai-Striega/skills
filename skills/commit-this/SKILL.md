---
name: commit-this
description: Draft a commit message for the staged changes, get the user's approval, then create a signed commit. Use when the user asks to "commit this", "commit these changes", "make a commit", or "commit it". Operates on staged changes only and never stages files. Adds a Claude co-author trailer only when Claude helped write the staged changes, and falls back to an unsigned commit (with the user's permission) if signing fails.
---

# Commit this

A skill for turning the staged changes into a signed commit. It drafts a message, gets the user's sign-off, and then makes the commit. It commits; it never stages.

## The point

"Commit this" should be one safe action. The user always sees and approves the message before anything is written to history, the commit is signed by default, and Claude's authorship is recorded honestly. This skill is the orchestration layer: it leans on `draft-commit-message` for the message itself and adds the commit mechanics around it.

## Step one: staged changes only

Check what is staged with `git diff --cached --quiet` (it exits non-zero when something is staged). If nothing is staged, do not commit and do not draft. Gently tell the user there is nothing staged and ask them to stage what they want included, for example with `git add <paths>`, then re-invoke.

**Never stage files yourself.** This skill does not run `git add`, `git add -A`, `git commit -a`, or anything else that changes the index. Staging is the user's decision because it defines the boundary of the commit. This skill changes history, not what is staged.

## Step two: draft the message

Draft the message by following the **`draft-commit-message`** skill. Defer to it entirely for the message body: Conventional Commits format, length proportional to the complexity of the change, a human voice, and the hard constraint of no en or em dashes. Do not restate those rules here; follow that skill so the two stay in sync.

The drafted body carries no trailers (that skill forbids them). Trailers, if any, are added in the next step.

## Step three: add a Claude authorship trailer, but only if earned

If Claude authored or modified some of the staged content during this session, append a trailer after the message body, separated by a blank line:

```
Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
```

Use the current model's identity in the trailer. Add it **only** when Claude genuinely contributed to the staged changes. If the user wrote everything themselves and Claude only ran the commit, add no trailer. This is a matter of honest attribution, judged from what Claude actually did in the session, not from anything in git.

## Step four: get explicit approval

Present the complete message, body plus any trailer, in a single fenced code block, and wait for the user to approve it. If they ask for changes, revise and present it again. **Do not commit until the user has approved.** Approval is the gate; nothing reaches history without it.

## Step five: commit, signed

Once approved, create a signed commit:

```
git commit -S -m "<message>"
```

Commit on the current branch. This skill does not switch or create branches; branch choice, like staging, stays with the user.

## Step six: fallback if signing fails

If the signed commit fails (no signing key configured, a gpg error, and so on), do not silently fall back. Tell the user what went wrong and ask whether they want an unsigned commit instead. Only if they say yes, commit without signing:

```
git commit -m "<message>"
```

If they decline, make no commit and leave everything staged exactly as it was. The user can fix their signing setup and try again.

## Step seven: report

After the commit, confirm the result: the short commit hash and whether it was signed or unsigned. Keep it to a line.

## Example flow

Staged change is a Claude-written bug fix. The skill drafts via `draft-commit-message`, adds the trailer because Claude wrote the fix, and presents:

```
fix: stop the cache from serving expired entries

The TTL check compared against the write time instead of the current
time, so entries were treated as fresh forever once written. Compare
against now so expiry actually takes effect.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
```

The user approves, the skill runs `git commit -S`, and reports back:

> Committed as a1b2c3d, signed.

If signing had failed, it would instead ask whether to commit unsigned before doing anything.
