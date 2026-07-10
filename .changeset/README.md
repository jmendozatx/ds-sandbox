# Changesets

This folder holds pending changes. Each `.md` file (except this one and `config.json`)
describes one change and its semver impact. They are aggregated into `CHANGELOG.md`
and a single version bump at release time — not per branch.

To add one: `npx changeset`, pick patch / minor / major, write one sentence.
