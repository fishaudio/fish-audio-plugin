# Fish Audio

Turn text into lifelike speech, find and clone voices, transcribe recordings, and produce multi-speaker audiobooks and podcasts with your [Fish Audio](https://fish.audio) account, without leaving the conversation. The same connector also generates images and video.

## Use it

Connect the Fish Audio connector when you install the plugin and sign in with your Fish Audio account. Then ask in plain language:

- "Read this paragraph aloud in a warm narrator voice."
- "Find a calm Japanese female voice and say this line with it."
- "Clone my voice from this recording."
- "Transcribe this interview."
- "Turn this short story into an audiobook with a different voice for each character."

Generated audio plays inline where the app supports it, and you always get a permanent link. In Claude Code and Codex, the agent can save the file into your project.

The plugin also includes two skills for developers: `fish-audio-sdk` for code that uses the official Python and JavaScript SDKs, and `fish-audio-api` for raw REST and WebSocket calls.

## Credits

Generating speech, transcribing, and generating images, video, or Studio audio spend credits from your Fish Audio plan. Searching voices, editing Studio projects, cloning a voice, and price estimates are free. For larger jobs the assistant shows the cost and waits for your approval before spending.

## Data

The plugin sends the text, audio, and prompts you ask it to process to Fish Audio at `api.fish.audio`, under the account you signed in with. Voices you clone and Studio projects you create are saved to that account. Uploaded files are deleted after 7 days. See the [privacy policy](https://fish.audio/privacy/) and [terms of service](https://fish.audio/terms/).

## Support

[fish.audio/support](https://fish.audio/support/) · [Documentation](https://docs.fish.audio)
