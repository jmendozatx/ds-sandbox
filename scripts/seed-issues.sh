#!/usr/bin/env bash
# Seed the sandbox with demo issues so the board looks alive.
# Requires the GitHub CLI (run `gh auth login` first) and a pushed repo.
set -euo pipefail

gh issue create --title "Emphasize Tabs component" --label "type: component" \
  --body "New component. Consumer: Marketing."
gh issue create --title "Warning badge fails AA contrast" --label "type: bug" \
  --body "Contrast below AA. Consumer: Dealer SaaS."
gh issue create --title "Q3 design-system newsletter" \
  --body "Non-code work — draft-issue example."
gh issue create --title "Data table: sortable header" --label "type: component" \
  --body "Consumer: Auto Navigator."

echo "Seeded 4 issues. Add them to your Project and set statuses to populate the board."
