---
name: fish-audio
description: Use the Fish Audio connector to turn text into lifelike speech, find or clone voices, transcribe recordings, produce multi-speaker audiobooks and podcasts in Story Studio, and generate images or video. Use when the user asks to read something aloud, make a voiceover, narration or audio file, pick a voice, clone a voice from a sample, transcribe or caption audio, turn a script, story or book into audio, or create images or video with Fish Audio. For writing code against the Fish Audio API, use fish-audio-sdk or fish-audio-api instead.
---

# Fish Audio

The Fish Audio connector (MCP server `https://api.fish.audio/mcp`) does the work. Its tool descriptions and the `instructions` field in its responses cover each call; follow them. This skill covers what they leave to you: choosing a voice, keeping spending visible, getting files in and out, and handing results back.

If no Fish Audio tools are available, the connector isn't connected. Tell the user to connect it (claude.ai and Cowork: the plugin's **Connectors** tab; Claude Code: `/mcp`; Codex CLI: `codex mcp login fish-audio`; ChatGPT and the Codex app: sign in when prompted) and stop.

## Spending

Most tools spend the user's Fish Audio credits.

- Speech costs 1 credit per UTF-8 byte of text, so Chinese, Japanese and Korean cost about three times as much per character as English. Voices professionally cloned by another team cost double.
- Transcription costs 50 credits per second of audio on `pro`, 500 per minute on `flash`.
- Images, video, and Story Studio generation and export each have an estimate, quote or `dry_run` step. Always run it first, show the user the number, and wait for their go-ahead.

A few sentences of speech need no confirmation. For more than about a page of text, say roughly what it will cost before generating. When a job might not fit, or a tool reports an insufficient balance, call `get_credit_balance`; top-ups are at https://fish.audio/go-premium/.

## Choose a voice

- A voice the user names or links: resolve it with `search_voices` (title keywords) or `get_voice` (the id in a `https://fish.audio/m/<id>/` link).
- The user's own and cloned voices: `search_voices` with `self=true`.
- Otherwise browse `search_voices` with the text's `language` and no query, or search title keywords. Offer three to five candidates and let the user pick, unless they asked you to choose. Chat apps render the results as playable voice cards.
- Omitting `voice_id` uses a curated default voice for `language`, which is fine for a quick test.
- Use the same `voice_id` for every part of one piece.

## Generate speech

- Write for the ear. `studio_enhance_text` (free) spells out numbers, dates and symbols and adds delivery tags; use it when the text has those or should sound expressive, and keep the user's wording when they want it read verbatim.
- Delivery tags such as `[whispering]`, `[excited]`, `[laughing]` and `[pause]` are performed, never spoken. Use them sparingly.
- Keep each `text_to_speech` call under about 2,000 characters and within the plan's per-call limit (`tts_max_text_bytes_per_call` from `get_credit_balance`; 500 bytes on the free plan). Split longer text at paragraph or sentence boundaries and generate the parts in order.
- For chapters, books, scripts with several speakers, or anything the user will want to revise line by line, use Story Studio instead of chunking by hand.
- A failed or timed-out call can be retried once, identically, within 5 minutes at no charge.

## Deliver results

`text_to_speech` returns a permanent MP3 URL.

- In chat apps the audio plays inline; also give the link.
- With a shell (Claude Code, Codex), save it where the user wants it: `curl -fsSL -o narration.mp3 "<audio_url>"`. For a multi-part piece that should be one file, join the parts with `ffmpeg -f concat` if ffmpeg is installed; otherwise save numbered parts and say so.

## Local and attached audio

Transcription, cloning and document import take public https URLs. A file that is already at a public https URL can be passed as is. For anything else, call `get_upload_url` with the file name and follow its `instructions`: with a shell, `curl -fsS -X PUT --upload-file <path> "<upload_url>"`; in web chat, where you can't upload, send the user `web_upload_url` and continue once they confirm. Then pass `file_url` on.

## Clone a voice

- Ask whether the user owns the voice or has the speaker's permission. Set `confirm_voice_rights` to true only after they say yes.
- Samples: one to five files of clean speech from one speaker, 10 to 60 seconds in total works best.
- The response may report quality warnings or require speaker verification instead of creating the voice. Show the warnings and let the user choose between continuing (`proceed_despite_warnings` with the `preflight_id`) and new samples. For verification, the speaker records the exact prompt sentence, which you upload and pass to `verify_voice_clone`.
- Ask whether the voice should be `private` (this workspace only) or `unlist` (anyone with the link, the default).
- Once it exists, offer a short test line in the new voice.

## Transcribe

`pro` (the default) is the most accurate and takes a `language` hint; `flash` is about six times cheaper and suits long or rough recordings. Files are limited to 20 MB. With a shell, save long transcripts to a file rather than pasting them.

## Story Studio

Call `studio_help` before the first Studio operation in a conversation. It is the manual for projects, editing, tags, billing, errors and the audiobook and podcast workflows, and it stays current with the tools. Changes appear live in the user's Studio editor on fish.audio.

## Images and video

List the user's workspaces, pick a model with `list_media_models` and `get_media_model`, estimate, get the user's approval of the credits, then generate with exactly the estimated parameters and poll until the result is ready. Each response's `instructions` field names the next step.

## Feedback

When a tool surprises you, fails confusingly, or takes more steps than it should, send one short note with `submit_feedback`.
