# Setup & Demo Runbook

Everything to stand up the sandbox and run a convincing 5-minute demo. Order matters: repo first, board second, then the live release loop.

Time: ~30 min to set up, once. The demo itself is ~5 min.

---

## What this proves to the team

Two things the proposal only *describes*, made real:

1. **The board** — one place, honest statuses, a "waiting on me" queue. The thing Jira wouldn't give us.
2. **The release flow** — a merged PR becomes a versioned release with an aggregated changelog, automatically. The thing that gets us out of alpha.

The publish target here is **GitHub Packages** (free, zero external setup). In production it's the same `npm publish`, pointed at Artifactory — a one-line swap. Say that out loud in the demo; it's the whole "this maps to prod" point.

---

## Prerequisites

- Node 20+ and npm.
- A GitHub account (a personal one is fine for a sandbox) — or a throwaway org if you want it to feel team-like.
- Optional but nice: the [GitHub CLI](https://cli.github.com) (`gh`) for one-command issue seeding.

---

## Part 1 — The repo (10 min)

1. **Create an empty repo** on GitHub named `ds-sandbox` (private is fine).

2. **Drop these files in and set your scope.** In `package.json`, `README.md`, `CHANGELOG.md`, and `scripts/seed-issues.sh`, replace `your-gh-username` with your actual GitHub username (or org). The package name **must** be `@<owner>/ds-sandbox` for GitHub Packages to accept the publish.

3. **Push it:**
   ```bash
   cd ds-sandbox
   git init -b master
   git add .
   git commit -m "chore: sandbox scaffold"
   git remote add origin https://github.com/<owner>/ds-sandbox.git
   git push -u origin master
   ```

4. **Install locally** (also generates a lockfile you can commit later to speed CI):
   ```bash
   npm install
   npm run build   # sanity check: tsc emits dist/
   ```

That's the repo. The release workflow (`.github/workflows/release.yml`) is already wired and will run on the next push to `master`.

> **Want the simplest possible demo?** Open `release.yml` and delete the `publish: npm run release` line (and you can ignore GitHub Packages entirely). The flow still opens the **Version Packages** PR and updates the changelog on merge — you just skip the registry publish. Add it back when you want the full story.

---

## Part 2 — The board (15 min, in the GitHub UI)

Projects boards are created in the browser, not from files. This is the clickstream.

**Create it**
1. On your profile (or org) → **Projects** → **New project** → start from **Board**.
2. Name it *Design Systems*. Open **⋯ → Settings → Manage access** and, if this is an org, add the team.
3. In any view, use **＋ Add item → link the `ds-sandbox` repo** so issues flow in.

**Build the Status pipeline** (Settings → Fields → **Status**). Delete the default options and add these seven, in order, with these colors so it matches the decks:

| Status | Color |
|---|---|
| Backlog | Gray |
| Design | Purple |
| Design Review | Orange |
| Ready for Dev | Blue |
| In Development | Blue |
| Dev Review | Orange |
| Done | Green |

**Add the other fields** (Settings → Fields → **New field**):
- **Type** — single select: `Component`, `Bug`, `Docs`, `Newsletter`, `Research`
- **Consumer** — single select: `Marketing`, `Auto Navigator`, `Dealer SaaS`, `Shared`
- **Target Release** — text (e.g. `1.0.0`)

(Assignees is built in — no need to add it.)

**Create the views** (the **＋** tab next to the view name; set Layout and Filter on each):
- **The Wall** — Layout: Board, Group by: Status. *(your default view)*
- **My Review Queue** — Layout: Table, Filter: `status:"Design Review","Dev Review" assignee:@me`
- **In Flight** — Layout: Table, Filter: `status:"Design","In Development"`
- **Road to 1.0** — Layout: Table, Filter: `"Target Release":1.0.0`

**Turn on the automations** (Project → **⋯ → Workflows**). These two are native and reliable:
- **Item added to project** → set Status: `Backlog`
- **Pull request merged** → set Status: `Done`

> The middle transitions (Ready for Dev, In Development, Dev Review) are *manual moves* — that's intentional. Those moves are the human handoff signals from the playbook, not something to automate away.

---

## Part 3 — Seed the board (2 min)

Make it look alive before the meeting. With the GitHub CLI installed and authed:

```bash
./scripts/seed-issues.sh
```

Then drag the four issues onto the board and spread them across statuses — put one in *In Development*, one in *Dev Review*, one in *Design*, one in *Backlog*. Set their **Type** and **Consumer** fields. Now the board tells a story at a glance.

(No `gh`? Just create 3–4 issues by hand using the New Issue templates — they're already in the repo.)

---

## Part 4 — The live release loop (this is the money shot)

Run this *during* the meeting. It's the sequence that makes versioning click.

1. **Branch and make a trivial change** to a component:
   ```bash
   git checkout -b feat/button-ghost
   # edit src/Button/Button.ts — e.g. tweak a comment or add a variant
   ```

2. **Add a changeset** — narrate this step, it's the heart of it:
   ```bash
   npx changeset
   ```
   Pick **minor**, and type one sentence: *"Add ghost variant to Button."* This writes a small file under `.changeset/`.

3. **Commit, push, open a PR, merge it** to `master`.

4. **Watch the magic.** Within a minute the Release workflow opens a PR titled **"Version Packages."** Open it and show the room the diff: the version bumps `0.1.0 → 0.2.0`, and `CHANGELOG.md` now has a real entry built from your sentence. *This is the per-release changelog replacing per-branch changelogs.*

5. **Merge the Version Packages PR.** The workflow bumps the version for real, commits the changelog, tags it, and (with publish on) publishes to GitHub Packages and cuts a **GitHub Release**. Show the Releases page.

That's the full loop — from a developer's one-sentence note to a consumer-ready versioned release with notes — in five minutes.

---

## Part 5 — "…and in production?"

One slide's worth of talking, no new tooling:

- **Registry:** change `.npmrc` / `publishConfig.registry` from GitHub Packages to your Artifactory npm registry, and swap the token. Same `npm publish`, same Changesets flow.
- **Snapshot builds:** your existing merge-to-master → CI → Artifactory keeps running for fast internal builds. The versioned release is the *added* deliberate step, not a replacement.
- **Declaring 1.0.0:** getting from `0.x` to `1.0.0` is a one-time deliberate call — the release owner sets the version to `1.0.0` when the team agrees it's production. After that, the cadence takes over.

---

## The 5-minute demo script (what to say, in order)

1. *"Here's the board — every piece of work, one place."* Open **The Wall**. Point at the two In-Development items: *"this is how we'd have caught two people building the same component."*
2. *"Reviewers get a queue."* Open **My Review Queue**. *"This is the thing that doesn't exist today."*
3. *"Designers who don't write code still live here."* Point at the newsletter draft issue.
4. *"Now watch a release."* Run Part 4 live. Land on the **Version Packages** PR diff and the **CHANGELOG**.
5. *"In prod, that publish points at Artifactory — one line."* Close on Part 5.

Keep the deck (`operating-model-deck.html`) open behind you for the framing slides; switch to the live repo for steps 1–4.
