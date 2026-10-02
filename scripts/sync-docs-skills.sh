#!/usr/bin/env bash
# Mirror the code-writing skills from fishaudio/docs (.mintlify/skills), their
# source of truth, which docs.fish.audio also serves to `npx skills add`.
set -euo pipefail

cd "$(dirname "$0")/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

git clone --quiet --depth 1 --filter=blob:none --sparse https://github.com/fishaudio/docs "$tmp"
git -C "$tmp" sparse-checkout set .mintlify/skills

for skill in fish-audio-sdk fish-audio-api; do
  rm -rf "plugins/fish-audio/skills/$skill"
  cp -R "$tmp/.mintlify/skills/$skill" "plugins/fish-audio/skills/$skill"
done
