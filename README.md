# ds-sandbox

A throwaway design-system package for **demoing the team operating model** live:
a GitHub Project board with honest statuses, and a Changesets release flow that
turns merged PRs into versioned releases with a real changelog.

Nothing here is production code — the component is a placeholder. The point is the
*process*: board → handoff → changeset → Version Packages PR → release.

**Start here:** [`SETUP.md`](./SETUP.md) — repo setup, the board clickstream, and a
5-minute demo script for the meeting.

In this sandbox the release publishes to **GitHub Packages**. In production, the same
`npm publish` flow points at Artifactory — a one-line registry swap.
