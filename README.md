# browser-cli

Chrome browser automation from the command line using the DevTools Protocol.

## Installation

```bash
# From source
git clone https://github.com/xeb/browser-cli.git
cd browser-cli
make install

# Or directly with cargo
cargo install --git https://github.com/xeb/browser-cli.git
```

## Quick Start

```bash
# Start Chrome with remote debugging
browser start

# Navigate to a page
browser open https://example.com

# Get page content
browser page              # HTML
browser page --markdown   # Markdown

# Take a screenshot
browser screenshot shot.png
browser screenshot shot.png --full-page

# Execute JavaScript
browser script "document.title"

# Stop Chrome
browser stop
```

## Commands

### Browser Lifecycle

| Command | Description |
|---------|-------------|
| `browser start` | Start Chrome with remote debugging (port 9222) |
| `browser start --headless` | Start in headless mode |
| `browser stop` | Stop the running Chrome instance |
| `browser status` | Check if Chrome is available |

### Navigation

| Command | Description |
|---------|-------------|
| `browser open <url>` | Navigate to URL |
| `browser reload` | Reload current page |
| `browser reload --hard` | Hard reload (bypass cache) |
| `browser back` | Navigate back |
| `browser forward` | Navigate forward |

### Page Content

| Command | Description |
|---------|-------------|
| `browser page` | Get page HTML |
| `browser page --markdown` | Get page as Markdown |
| `browser save <file>` | Save HTML to file |
| `browser screenshot <file>` | Capture screenshot |
| `browser screenshot <file> --full-page` | Full page screenshot |
| `browser pdf <file>` | Save page as PDF |

### JavaScript

| Command | Description |
|---------|-------------|
| `browser script "<code>"` | Execute JavaScript |
| `browser script -f script.js` | Execute from file |

### Tabs

| Command | Description |
|---------|-------------|
| `browser tabs` | List open tabs |
| `browser tab new` | Open new tab |
| `browser tab new <url>` | Open new tab with URL |
| `browser tab close <id>` | Close tab by ID |

### DOM Interaction

| Command | Description |
|---------|-------------|
| `browser find <selector>` | Find element by CSS selector |
| `browser wait <selector>` | Wait for element to appear |
| `browser click <selector>` | Click element |
| `browser type <text>` | Type text |
| `browser type <text> --selector <sel>` | Type into specific element |
| `browser key <key>` | Press keyboard key (Enter, Tab, etc.) |

### Cookies

| Command | Description |
|---------|-------------|
| `browser cookies` | List all cookies |
| `browser cookie set <name> <value>` | Set a cookie |

### Credentials

Store and apply login credentials:

```bash
# Add a credential
browser cred add github --url "github.com/*" --username user --password pass

# List credentials
browser cred list

# Apply credential to current page (fills forms, injects cookies)
browser cred apply github

# Delete
browser cred delete github
```

### Sessions

Save and restore browser sessions:

```bash
# Save current cookies as a session
browser session save my-session

# List sessions
browser session list

# Load a session (restores cookies)
browser session load my-session

# Delete
browser session delete my-session
```

## Global Options

| Option | Default | Description |
|--------|---------|-------------|
| `--port` | 9222 | Chrome DevTools port |
| `--chrome` | auto | Path to Chrome executable |
| `--user-data-dir` | - | Chrome profile directory |
| `--json` | false | Force JSON output |
| `--timeout` | 30 | Page load timeout (seconds) |
| `--verbose` | false | Enable verbose logging |
| `--quiet` | false | Suppress non-essential output |

## Output Formats

By default, browser-cli uses human-readable output for TTY and JSON for pipes:

```bash
# Human readable
browser tabs

# JSON output (automatic when piping)
browser tabs | jq '.tabs[0].url'

# Force JSON
browser tabs --json
```

## Examples

### Login to a website

```bash
browser start
browser open https://example.com/login
browser type "username" --selector "input[name=username]"
browser type "password" --selector "input[type=password]"
browser click "button[type=submit]"
browser wait ".dashboard"
browser session save example-login
```

### Scrape page content

```bash
browser start
browser open https://news.ycombinator.com
browser page --markdown > hn.md
```

### Automate form submission

```bash
browser start
browser open https://example.com/form
browser type "John Doe" --selector "#name"
browser type "john@example.com" --selector "#email"
browser click "#submit"
browser screenshot confirmation.png
```

### Use with jq

```bash
# Get first tab URL
browser tabs --json | jq -r '.tabs[0].url'

# Get all cookie names
browser cookies --json | jq -r '.cookies[].name'
```

## Data Storage

browser-cli stores data in `~/.browser-cli/`:

- `browser.db` - SQLite database for credentials, sessions, and state

## Requirements

- Chrome, Chromium, or Chrome Canary
- Linux, macOS, or Windows

## License

MIT
