# vim-setup + teampowers

Personal dev environment: Vim configuration and **teampowers**, a Claude Code agent team skills framework.

## Structure

```
vim/
  .vimrc                        Vim configuration (Vundle, plugins, keybindings)

.claude-plugin/
  marketplace.json              Plugin marketplace manifest

plugins/
  teampowers/
    .claude-plugin/plugin.json  Plugin manifest
    skills/
    using-teampowers/           Entry point — how the framework works
    communication-mesh/         Agent-to-agent messaging network topology
    team-driven-development/    Full team pipeline orchestration
    executing-plans/            Batch execution with checkpoints
    brainstorming/              Structured design exploration
    writing-plans/              Implementation plan creation
    scout/                      Codebase reconnaissance agent (1-N)
    dev/                        Implementation agent (1-N)
    tester/                     TDD and validation agent (singleton)
    reviewer/                   Two-stage code review agent (singleton)
    ci/                         Build/test/lint pipeline agent (singleton)
    ad-hoc-agents/              Dynamic domain specialist creation (0-N)
    test-driven-development/    TDD methodology
    systematic-debugging/       Methodical bug diagnosis
    verification-before-completion/  Quality gates
    finishing-a-development-branch/  Branch finalization
    using-git-worktrees/        Isolated workspace setup
    writing-skills/             How to create new skills

install.sh                      Setup script
```

## Teampowers

An agent skills framework for Claude Code that organizes development around a specialized team communicating in a mesh network.

### The Team

**Dynamic (scale as needed):**

| Agent | Scale | Role |
|-------|-------|------|
| **Scout** | 1-N | Explores codebase, maps architecture, gathers context |
| **Dev** | 1-N | Writes production code per task spec |
| **Ad Hoc** | 0-N | Domain specialists created on demand (SQL, API, Infra, etc.) |

**Singleton:**

| Agent | Role |
|-------|------|
| **Lead** | Coordinates tasks, resolves conflicts, reports to human |
| **Tester** | Writes tests before impl (TDD), validates after |
| **Reviewer** | Two-stage review: spec compliance then code quality |
| **CI** | Runs full build/test/lint pipeline |

### Communication Mesh

Agents talk directly to each other — not hub-and-spoke through the lead:

```
Lead assigns → Scout explores → Scout hands context to Dev
Dev implements → Dev signals Tester → Tester validates
Dev → Reviewer reviews → Reviewer signals CI
CI runs pipeline → CI reports to Lead (and Dev on failure)
```

### Workflow

`Brainstorm → Plan → Scout → Execute (parallel mesh) → Review → CI → Checkpoint → Repeat`

### Install as Claude Code plugin

```bash
claude plugin install /path/to/vim-setup/plugins/teampowers
```

## Vim Setup

### Quick start

```bash
./install.sh
```

### Manual setup

1. Clone into `~/.vim`:
   ```
   git clone https://github.com/johnhanks1/vim-setup.git ~/.vim
   ```

2. Symlink `.vimrc`:
   ```
   ln -s ~/.vim/vim/.vimrc ~/.vimrc
   ```

3. Install Vundle:
   ```
   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
   ```

4. Install plugins:
   ```
   vim +PluginInstall +qall
   ```
