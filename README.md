# Local AI Ensemble Validation (LXV)

> [🇰🇷 한국어](README.ko.md)

This is a guide for an automation system that cross-validates code using three major AI models — **Claude, Codex, and Gemini** — in a local environment and produces **optimal ensemble** results.

## 1. Why This System Is Powerful (Core Philosophy)

When most people use AI, they open a chat window. But chat conversations are **volatile** — they disappear.
This system works by leaving behind **documents**, not conversations.

### 💡 "Triple Backup System"
1.  **Present (`plan_request.md`)**: The file containing your latest requirements
2.  **Past (`reports/`)**: All AI responses automatically saved by timestamp
3.  **Conclusion (`final_decision.md`)**: The finalized document combining multiple opinions

These three are managed automatically, so you never need to dig through chat history wondering **"What did it say earlier?"**.

---

## 2. Practical Guide: Building a News Aggregator

Follow this workflow. This is the process of completing a project specification together with AI.

### Step 1: Turn Your Questions into Files (`Spec/Plan` Phase)

Instead of a chat window, create a `plan_request.md` file at the project root and write your questions there.

**Example (`plan_request.md`)**:
```markdown
# Project Requirements: AI News Aggregator
- Tech Stack: Python, FastAPI, React
- Features: RSS feed collection, summarization, tagging

## Questions
Based on these requirements, create a detailed implementation plan (DB schema, API spec).
```
> **Advantage**: Saving as a file enables Git version control. You can keep refining your questions over time.

### Step 2: Summon the Big Three (`Cmd + Option + Shift + V`)

With the `plan_request.md` file open, press the keyboard shortcut.
Behind the scenes, **incredible things** happen invisibly:

1.  **Folder creation**: `ai-ensemble/reports/20260216_140000/` (current timestamp)
2.  **Prompt saved**: `prompt.txt` (your question is preserved)
3.  **Parallel execution**: Claude, Codex, and Gemini all start working simultaneously.
4.  **Report generated**: A `report.md` file is created and automatically opened in the editor.

### Step 3: Review the Results (`report.md`)

The auto-opened `report.md` shows opinions from three experts.

```markdown
# AI Code Review Report
**Date:** ...
**Prompt Hash:** `a1b2c3d4` (a fingerprint proving which question produced this result)

## claude (opus) Response
"I'd recommend a microservices architecture..."

## codex (gpt-5.3-codex) Response
"The implementation order should be 1. DB design, 2. API implementation..."

## gemini (0.26.0) Response
"Set up the data model like this..."
```
> **Tip**: Cherry-pick the parts you like. No need to copy-paste — the next step handles that.

### Step 4: Ensemble Synthesis (`Cmd + Option + E`)

Too many opinions to organize? It's time to call in the **Ensemble Lead** — Gemini.
With the `report.md` file open, press the keyboard shortcut `Cmd + Option + E`.

- **Result**: A `final_decision.md` file is created and opened.
- **Content**:
    > "I've synthesized Claude's architecture and Gemini's data model into a final proposal."

No more complex deliberation! The finalized document is in your hands.

### Step 5: Iterate Endlessly (Evolution)

It's not over. Copy the contents of `final_decision.md`, paste them into your original `plan_request.md`, and add **new questions**.

**Updated `plan_request.md`**:
```markdown
# Project Requirements: AI News Aggregator (v2)
... (confirmed specification content) ...

## Additional Questions (New)
Based on the confirmed plan, write the main.py code.
```
Go back to **Step 2** and run again.
By repeating this process, `plan_request.md` evolves from a simple questionnaire into a **complete project specification (Spec)**.

---

## 3. Project Structure

```
local-ai-ensemble/
├── 01-system-prompts/        # System prompt originals
│   ├── default_review.md     #   For code review
│   └── ensemble.md           #   For ensemble synthesis
├── 02-scripts/               # Execution scripts
│   ├── xv-local              #   Parallel execution of 3 AIs
│   └── xv-ensemble           #   Report ensemble
├── ai-ensemble/              # Runtime output (auto-generated)
│   ├── custom-prompts/       #   Customizable prompts
│   └── reports/              #   Reports by timestamp
├── install.sh                # Installation script
├── plan_request.md           # Question/requirement input file
└── README.md
```

---

## 4. Installation & Setup

### Supported Platforms
- **macOS** (Recommended)
- **Linux** (Ubuntu, CentOS, etc.)
- **Windows** (WSL - Windows Subsystem for Linux required)
  > Windows users must install WSL and run in a Linux environment. (PowerShell is not supported)

### Prerequisites
- `claude`, `codex`, `gemini` CLI tools must be installed.
- `python3` (for prompt template processing; falls back to default format if unavailable)

### Automatic Installation (Recommended)
Run the following command in your terminal to install the tools to `~/.local/bin`:

```bash
chmod +x install.sh
./install.sh
```

> **Note**: After installation, make sure `~/.local/bin` is included in your PATH.
> (It should appear when you run `echo $PATH`. If not, add it to `.zshrc` or `.bashrc`)

### Manual Installation
If automatic installation doesn't work, copy the files manually:
```bash
mkdir -p ~/.local/bin ~/.local/share/xv-ensemble/prompts
cp 02-scripts/xv-local 02-scripts/xv-ensemble ~/.local/bin/
cp 01-system-prompts/* ~/.local/share/xv-ensemble/prompts/
chmod +x ~/.local/bin/xv-local ~/.local/bin/xv-ensemble
```

### Editor Setup
Configure Tasks and keyboard shortcuts for your editor (VS Code, Antigravity IDE, etc.).

1. **Tasks**: Register tasks to run the scripts (e.g., `tasks.json`)
2. **Keybindings**: Map keyboard shortcuts (e.g., `keybindings.json`)

**Recommended Shortcuts**:
- `Cmd + Opt + V`: Validate staged changes (pre-commit check)
- `Cmd + Opt + Shift + V`: Validate/ask about current file (for planning/design)
- `Cmd + Opt + E`: Ensemble report (for reaching conclusions)

---

## 5. Advanced Tips

### Prompt Customization
Want to change the review or planning criteria?
- Edit `ai-ensemble/custom-prompts/review.md` (for review) or `ensemble.md` (for ensemble) directly.
- These files are automatically copied from `01-system-prompts/` on first run.
- To restore originals, delete the custom files and run again.

### Validator Integration
For higher code quality, you can auto-run linters and tests:
```bash
export LINT_CMD="flake8 ."
export TEST_CMD="pytest"
```

### AI Execution Timeout
You can adjust the AI model response timeout. (Default: 120 seconds)
```bash
export AI_TIMEOUT=300  # Change to 5 minutes
```

### Checking Error Logs
To diagnose why an AI didn't respond, check the `.err` files:
```bash
cat ai-ensemble/reports/YYYYMMDD_HHMMSS/claude.err
```
