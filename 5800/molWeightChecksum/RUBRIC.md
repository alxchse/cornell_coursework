# PS1 grading rubric

Every problem set in CHEME 4800/5800 is worth the same maximum score: `4`. A problem set without discussion questions can still earn a `4`; students are responsible only for the requirements that actually appear in that problem set.

PS1 contains `33` public checks. A check that is not reached because an earlier error stops a test suite counts as a failed check.

| Score | PS1 condition |
|:---:|---|
| `0` | Something was submitted, but the grading harness could not execute any checks or `0` of the `33` checks passed. |
| `1` | The tests ran and `1–16` of the `33` checks passed. |
| `2` | The tests ran and `17–32` of the `33` checks passed. |
| `3` | All `33` checks passed, but at least one applicable completion requirement below was missing or not acceptable. |
| `4` | All `33` checks passed and every applicable completion requirement below was accepted. |

## Official test procedure

The output from `check_submission.jl` is feedback, not the official grade. For grading, the instructor copies the student's entire submitted `src` directory into a clean copy of the tagged assignment release and runs the instructor-owned tests, checker, and data. Student changes to tests, data, or `check_submission.jl` are ignored. This procedure keeps the same grading target for every student and every revision.

## Completion review

To earn a `4` on PS1, the submission must meet all of these requirements:

- All requested types and functions are implemented with the interfaces described in `README.md`.
- Public types and functions document their purpose, inputs, outputs, and relevant errors.
- Any private helper function has a concise contract, and non-obvious logic has useful comments.
- No unresolved starter `TODO`, placeholder error, or knowingly incomplete task remains in the submitted solution.

PS1 has no discussion questions, so no discussion response is required. On a future problem set that includes discussion questions, the responses will be reviewed for a relevant, internally consistent, good-faith explanation. They do not need to match a single model answer, but an omitted, nonsensical, or unrelated response does not satisfy the completion requirement.

If all tests pass but completion review is still needed, the result is recorded as **pending review**, not as a provisional score of `3`. The final score becomes `4` when all applicable requirements are accepted; it becomes `3` only when at least one requirement is actually found incomplete or unacceptable.
