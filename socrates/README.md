# Socrates

A Claude skill that quizzes you on a conversation you just had — using the Socratic method — and only lets you declare yourself "done" once you've shown you actually understand the ideas, not just remember them.

## What it does

After a concept-heavy conversation with Claude (learning a new topic, prepping for an interview, reviewing notes), invoke Socrates and it will:

1. Pick out the 3–5 load-bearing concepts from the conversation.
2. Share that list with you and confirm it's the right material.
3. Walk you through a probing, question-led dialogue on each one — not "what is X?" but "how would X apply to [new case]?" and "what would break if X weren't true?"
4. Give you hints when you're stuck rather than the answer, and push back on hand-wavy answers.
5. At the end, give you an honest verdict — pass, partial, or didn't-finish — with a short debrief on which concepts were solid and which still need work.

The point is that understanding shows up in the ability to *use* an idea, and the only way to test that is to actually make you use it.

## Why Socratic?

You can't fake application from a definition. If you've only half-absorbed an idea, being asked to apply it to a new case will expose that quickly. Being asked to recite it back won't. Socrates is designed around this: short, probing questions, no waving you through when an answer is thin.

## Example session

> **You:** socrates me on this
>
> **Claude:** Okay — from our conversation, I'll probe you on four things: (1) why transformers use attention rather than recurrence, (2) what the query/key/value split is actually doing, (3) why positional encodings are needed at all, and (4) the difference between self-attention and cross-attention. Sound right?
>
> **You:** yeah let's go
>
> **Claude:** I'll be probing rather than asking for definitions — expect follow-ups. Ready? First one: suppose someone said "attention is basically just a weighted average." What would you say to them?
>
> **You:** I'd say that's true but it's missing the point — the weights aren't fixed, they're computed from the inputs themselves, so the network decides what to attend to based on content rather than position.
>
> **Claude:** Good. Now push on that — *how* does it decide, specifically?

…and so on. At the end you'll get a short debrief:

> You're solid on attention as content-based routing — your answer on the weighted-average framing was clean and you pinned down the Q/K/V roles without prompting. Positional encodings needed a nudge, but once you saw the "without them, the model can't tell order" framing you got the rest quickly. Cross-attention is still a bit fuzzy — you described the mechanics correctly but the "when would you use it vs. self-attention" question didn't quite land. Worth revisiting that one.
>
> **Verdict: passed, with a note to revisit cross-attention.**

## Installation

This skill lives in the [skills collection](../README.md) as the `socrates/` directory (containing `SKILL.md`). To install it:

- **Claude Code:** run `./install.sh` from the repository root to symlink every skill into `~/.claude/skills/`, or copy the `socrates/` directory into your project's `.claude/skills/` directory manually.
- **Claude.ai:** upload the `socrates/` directory as a `.skill` package through the Skills interface in settings.

Once installed, Claude will pick up the skill automatically. You don't need to configure anything — just ask to be quizzed.

## Triggering it

The skill is designed to fire on natural phrasings, not just explicit invocations. Things like:

- "socrates me"
- "quiz me on this"
- "make sure I got that"
- "test my understanding before I move on"
- "don't let me leave until I understand"

It also triggers when you mention studying or prepping for an exam or interview based on a conversation you've just had.

## Tuning

The main dial is how strict the gatekeeping should be. The skill as written errs slightly toward patience — a user who feels interrogated abandons the session, and a halfway-decent quiz is better than one you quit. If you find it too lenient (or too harsh) after a few sessions, the `Gatekeeping: when to pass` and `Adaptive Socratic style` sections of `SKILL.md` are the places to adjust.

## Contributing

Found that it over-passes or under-passes in a particular domain? Noticed it mishandling a certain kind of question? Open an issue with an example exchange — that's by far the most useful feedback. Pull requests that adjust the examples or the judging criteria are welcome.

## License

[BSD3](./LICENSE)
