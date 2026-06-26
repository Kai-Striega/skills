# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is a **collection of Claude skills**, not an application. There is no build, no test suite, and no runtime code. The repository holds one directory per skill, each containing its own `SKILL.md` (plus an optional `README.md` and any supporting files), a root `README.md` indexing them, an `install.sh`, and a `LICENSE` (BSD-3).

Currently the only skill is **socrates** (`socrates/`), which makes Claude quiz the user Socratically on a preceding conversation and gatekeep "done" until the user demonstrates real understanding (application of ideas, not recall). It is invoked by natural phrasings like "socrates me", "quiz me on this", or "don't let me leave until I understand."

## The structure that matters

Each skill is a self-contained directory; the `SKILL.md` inside it is the product. Conventions to follow when adding or editing a skill:

- **The directory name must match the skill's `name:` frontmatter** — `install.sh` and the harness key off the directory name.
- **The `description:` frontmatter controls *when* the skill fires** and is the only thing the harness uses to decide activation, so edit it carefully.
- **A `SKILL.md` body is the behavioral spec** Claude follows at runtime, and any **examples in it are normative, not decorative** — keep prose and examples in sync, since a change to the rules that contradicts an example will confuse the skill at runtime.

`install.sh` symlinks every directory containing a `SKILL.md` into `~/.claude/skills/` (or `$CLAUDE_CONFIG_DIR/skills`). It is idempotent and skips directories without a `SKILL.md`, so adding a new skill is just: create `<name>/SKILL.md`, add a row to the root `README.md` table, and re-run `install.sh`.

## Editing guidance (socrates example)

When changing a skill's behavior, find its calibration "dials" rather than rewriting wholesale. For socrates, those are in `socrates/SKILL.md`:

- **`Gatekeeping: when to pass`** and **`Adaptive Socratic style`** — how strict the pass/fail bar is, and how quickly to offer hints vs. hold the line. The skill is deliberately tuned slightly toward patience (a user who feels interrogated abandons the session). Preserve that bias unless explicitly asked to make it stricter.
- The **`Example exchanges`** and **`The final summary`** sections encode the desired *shape* of output by demonstration. Per `socrates/README.md`, these examples and the judging criteria are the primary place to adjust behavior — keep them concrete and consistent with the prose they illustrate.
