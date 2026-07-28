# Getting Started with ServiceLLM

This guide is for people who have never used a terminal or built a macOS app before. It walks you through every step, from opening a terminal to using ServiceLLM in any editor, on code in any language.

> 🇩🇪 Looking for German instructions? There isn't a translated version of this guide yet, but the commands below work the same regardless of language.

---

### macOS

ServiceLLM is a macOS-only app: it's built on Xcode's Command Line Tools and integrates via macOS System Services (NSServices), which don't exist on Windows or Linux.

#### 1. Open a terminal

1. Press **Cmd + Space** to open Spotlight.
2. Type **Terminal** and press **Enter**.
3. A window with a blinking cursor opens: that's your terminal. You'll type commands into it and press **Enter** to run them.

#### 2. Check your prerequisites

ServiceLLM needs Swift and the Xcode Command Line Tools. Check both:

```bash
swift --version
```

You should see something like `Swift version 5.9` or newer. macOS 14 (Sonoma) and later ship with a compatible Swift version already.

```bash
xcode-select -p
```

- **If this prints a path** (e.g. `/Library/Developer/CommandLineTools`), you're set; skip to step 3.
- **If it prints an error** like `xcode-select: error: unable to get active developer directory`, the Command Line Tools aren't installed yet.

To install them:

```bash
xcode-select --install
```

This opens a small installer window. It downloads Apple's compiler and build tools (the same ones Xcode uses) without requiring the full multi-gigabyte Xcode app. Click **Install**, accept the license, and wait for it to finish (a few minutes depending on your connection).

#### 3. Get the ServiceLLM code

You don't need Git for this. A plain ZIP download works fine:

1. Go to the [ServiceLLM GitHub page](https://github.com/9t29zhmwdh-coder/ServiceLLM).
2. Click the green **Code** button → **Download ZIP**.
3. Double-click the downloaded ZIP to extract it (Finder does this automatically), and move the resulting `ServiceLLM` folder somewhere you'll remember (e.g. your `Documents` folder).

**Alternative (if you have Git installed):**

```bash
git clone https://github.com/9t29zhmwdh-coder/ServiceLLM
```

#### 4. Build and install ServiceLLM

In your terminal, navigate into the folder (adjust the path to wherever you placed it):

```bash
cd Documents/ServiceLLM
make install
```

`make install` does everything for you: it compiles the Swift code, packages it into a `ServiceLLM.app` bundle, copies that app to `/Applications/`, and refreshes macOS's list of Services so ServiceLLM shows up in right-click menus. This can take a minute or two the first time.

#### 5. First launch

1. Open **Finder** → **Applications** → double-click **ServiceLLM.app**. A `</>` icon appears in your menu bar (top-right of the screen, near the clock).

   > <!-- TODO: Screenshot of the menu bar icon -->

2. Click the `</>` icon → **Settings** → choose your AI provider (a local option like **Ollama**, or a cloud option like **Claude**, and enter its API key if it needs one).
3. **Restart the app once** so the new Services entries become visible system-wide: click the menu bar icon → **Quit**, then reopen `ServiceLLM.app` from Applications.
4. Try it out: open Xcode (or any text editor), select some code, right-click → **Services** → **ServiceLLM: Explain**.

If you want ServiceLLM to be able to **paste its response directly back over your selection**, it needs Accessibility permission: go to **System Settings → Privacy & Security → Accessibility** and enable ServiceLLM there.

---

## Troubleshooting

| Problem | What's happening | Fix |
|---|---|---|
| `xcode-select: error: unable to get active developer directory` | Xcode Command Line Tools aren't installed | Run `xcode-select --install` in Terminal and complete the installer prompt |
| macOS says *"ServiceLLM.app can't be opened because Apple cannot check it for malicious software"* (Gatekeeper) | The app isn't notarized by Apple because you built it yourself from source, which is expected | Right-click **ServiceLLM.app** in Applications → **Open** → confirm **Open** in the dialog. You only need to do this once |
| **ServiceLLM doesn't appear under Services** in the right-click menu | macOS caches the list of available Services and doesn't always refresh it live | Quit and reopen ServiceLLM (Step 5.3 above); if it still doesn't show up, log out and back in, or restart your Mac |
| `make install` fails with a permissions error copying to `/Applications/` | Your user account may lack write access, or another app is locked | Make sure no other `ServiceLLM.app` window is open, then re-run `make install`; if it persists, manually drag the built `.app` from the project's `.build` output into `/Applications/` |

If you're still stuck, open an [issue on GitHub](https://github.com/9t29zhmwdh-coder/ServiceLLM/issues) with the exact error message you see.
