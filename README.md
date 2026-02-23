# auntie

Chrome browser automation from the command line using the DevTools Protocol.

## Why "auntie"?

The name comes from William Gibson's novel *Agency*, where the AI persona "Eunice" has access to a set of autonomous AIs called "aunties." This tool is a companion to [eunice](https://github.com/xeb/eunice) - an agentic CLI runner - giving AI agents the ability to see and interact with the web.

## Installation

```bash
# One-liner install (recommended)
curl -sSf https://longrunningagents.com/auntie/install.sh | bash

# From source
git clone https://github.com/xeb/auntie.git
cd auntie
make install

# Or directly with cargo
cargo install --git https://github.com/xeb/auntie.git
```

## Quick Start

```bash
# Start Chrome with remote debugging
auntie start

# Navigate to a page
auntie open https://example.com

# Get page content
auntie page              # HTML
auntie page --markdown   # Markdown

# Take a screenshot
auntie screenshot shot.png
auntie screenshot shot.png --full-page

# Execute JavaScript
auntie script "document.title"

# Stop Chrome
auntie stop
```

## Commands

### Browser Lifecycle

| Command | Description |
|---------|-------------|
| `auntie start` | Start Chrome with remote debugging (port 9222) |
| `auntie start --headless` | Start in headless mode |
| `auntie stop` | Stop the running Chrome instance |
| `auntie status` | Check if Chrome is available |

### Navigation

| Command | Description |
|---------|-------------|
| `auntie open <url>` | Navigate to URL |
| `auntie reload` | Reload current page |
| `auntie reload --hard` | Hard reload (bypass cache) |
| `auntie back` | Navigate back |
| `auntie forward` | Navigate forward |

### Page Content

| Command | Description |
|---------|-------------|
| `auntie page` | Get page HTML |
| `auntie page --markdown` | Get page as Markdown |
| `auntie save <file>` | Save HTML to file |
| `auntie screenshot <file>` | Capture screenshot |
| `auntie screenshot <file> --full-page` | Full page screenshot |
| `auntie pdf <file>` | Save page as PDF |

### JavaScript

| Command | Description |
|---------|-------------|
| `auntie script "<code>"` | Execute JavaScript |
| `auntie script -f script.js` | Execute from file |

### Tabs

| Command | Description |
|---------|-------------|
| `auntie tabs` | List open tabs |
| `auntie tab new` | Open new tab |
| `auntie tab new <url>` | Open new tab with URL |
| `auntie tab close <id>` | Close tab by ID |

### DOM Interaction

| Command | Description |
|---------|-------------|
| `auntie find <selector>` | Find element by CSS selector |
| `auntie wait <selector>` | Wait for element to appear |
| `auntie click <selector>` | Click element |
| `auntie type <text>` | Type text |
| `auntie type <text> --selector <sel>` | Type into specific element |
| `auntie key <key>` | Press keyboard key (Enter, Tab, etc.) |

### Cookies

| Command | Description |
|---------|-------------|
| `auntie cookies` | List all cookies |
| `auntie cookie set <name> <value>` | Set a cookie |

### Credentials

Store and apply login credentials:

```bash
# Add a credential
auntie cred add github --url "github.com/*" --username user --password pass

# List credentials
auntie cred list

# Apply credential to current page (fills forms, injects cookies)
auntie cred apply github

# Delete
auntie cred delete github
```

### Sessions

Save and restore browser sessions:

```bash
# Save current cookies as a session
auntie session save my-session

# List sessions
auntie session list

# Load a session (restores cookies)
auntie session load my-session

# Delete
auntie session delete my-session
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

By default, auntie uses human-readable output for TTY and JSON for pipes:

```bash
# Human readable
auntie tabs

# JSON output (automatic when piping)
auntie tabs | jq '.tabs[0].url'

# Force JSON
auntie tabs --json
```

## Examples

### Login to a website

```bash
auntie start
auntie open https://example.com/login
auntie type "username" --selector "input[name=username]"
auntie type "password" --selector "input[type=password]"
auntie click "button[type=submit]"
auntie wait ".dashboard"
auntie session save example-login
```

### Scrape page content

```bash
auntie start
auntie open https://news.ycombinator.com
auntie page --markdown > hn.md
```

### Automate form submission

```bash
auntie start
auntie open https://example.com/form
auntie type "John Doe" --selector "#name"
auntie type "john@example.com" --selector "#email"
auntie click "#submit"
auntie screenshot confirmation.png
```

### Use with jq

```bash
# Get first tab URL
auntie tabs --json | jq -r '.tabs[0].url'

# Get all cookie names
auntie cookies --json | jq -r '.cookies[].name'
```

## Data Storage

auntie stores data in `~/.auntie/`:

- `auntie.db` - SQLite database for credentials, sessions, and state

## Requirements

- Chrome, Chromium, or Chrome Canary
- Linux, macOS, or Windows

## License

MIT
