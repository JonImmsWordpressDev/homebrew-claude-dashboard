# Homebrew tap for claude-dashboard

Claude Dashboard is a local web page that shows everything Claude Code is doing on your Mac: every running session, whether one is waiting for your answer and what it asked, what each session changed, and what it cost. It reads the files Claude Code already writes and never modifies them.

Install:

```bash
brew tap jonimmswordpressdev/claude-dashboard
brew trust jonimmswordpressdev/claude-dashboard
brew install claude-dashboard
brew services start claude-dashboard
```

Then open http://127.0.0.1:4517.

Upgrade to a new release:

```bash
brew update && brew upgrade claude-dashboard
brew services restart claude-dashboard
```

Main repo and full docs: https://github.com/JonImmsWordpressDev/claude-dashboard
Release notes: https://github.com/JonImmsWordpressDev/claude-dashboard/releases
