# Fish Audio plugin for Claude and Codex

The Fish Audio plugin brings [Fish Audio](https://fish.audio) speech generation, voice cloning, transcription and Story Studio into Claude (claude.ai, Cowork, Claude Code) and OpenAI Codex / ChatGPT. It bundles:

- the Fish Audio connector, the remote MCP server at `https://api.fish.audio/mcp` (OAuth sign-in, no API key)
- the `fish-audio` skill, which teaches the agent the workflows around the connector's tools
- the `fish-audio-sdk` and `fish-audio-api` skills for writing code against Fish Audio

See [plugins/fish-audio/README.md](plugins/fish-audio/README.md) for what it does and what data it sends.

## Install

**Claude Code**

```text
/plugin marketplace add fishaudio/fish-audio-plugin
/plugin install fish-audio@fish-audio
```

The first tool call opens a browser to sign in to Fish Audio.

**claude.ai and Cowork**

Go to **Customize > Plugins > Add > Add marketplace**, enter `fishaudio/fish-audio-plugin`, install **Fish Audio**, then connect it from the plugin's **Connectors** tab.

**Codex**

```bash
codex plugin marketplace add fishaudio/fish-audio-plugin
codex plugin add fish-audio@fish-audio
codex mcp login fish-audio
```

In the Codex app, install **Fish Audio** from the plugin list and sign in when prompted.

## Layout

```text
.claude-plugin/marketplace.json     Claude marketplace
.agents/plugins/marketplace.json    Codex marketplace
plugins/fish-audio/
  .claude-plugin/plugin.json        Claude manifest
  .codex-plugin/plugin.json         Codex / ChatGPT manifest and listing metadata
  .mcp.json                         Fish Audio connector, shared by both
  skills/                           shared by both
  assets/                           Codex / ChatGPT listing icons
scripts/sync-docs-skills.sh         refresh fish-audio-sdk and fish-audio-api
```

`skills/fish-audio-sdk` and `skills/fish-audio-api` are mirrored from [fishaudio/docs](https://github.com/fishaudio/docs/tree/main/.mintlify/skills); edit them there. The `Sync docs skills` workflow checks daily and opens a pull request that mirrors any change and bumps the plugin version; run `scripts/sync-docs-skills.sh` to sync by hand.

## Develop

```bash
claude plugin validate plugins/fish-audio
claude --plugin-dir plugins/fish-audio
```

Bump `version` in both manifests on every release.
