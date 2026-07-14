# Git snapshots (agent autonomy)

Commit every stable, working state to git as a snapshot, so we always have a
known-good state to recover from. Whenever the code is in a working state
(builds, tests pass, feature works), make a commit before moving on to the
next change. If a change breaks the app, roll back to the last working commit
and continue from there instead of trying to undo changes from memory.

# Goal / loop evidence

When working under `/goal` or any agent loop: run the verification commands every
turn and paste full relevant output into the transcript. Never claim success
without fresh command evidence.
