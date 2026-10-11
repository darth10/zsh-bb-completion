# zsh-bb-completion

[![CI](https://github.com/darth10/zsh-bb-completion/actions/workflows/ci.yml/badge.svg)](https://github.com/darth10/zsh-bb-completion/actions/workflows/ci.yml)

Zsh completion for [Babashka](https://babashka.org) (`bb`) tasks and their subcommands.

```console
$ bb <Tab>
db      -- Database tools
danger  -- Writes a marker file
$ bb db <Tab>
backup   -- Back up a db
restore  -- Restore a db
$ bb db restore --<Tab>
--help
```

## What it completes

- Task names from `bb tasks`, with their docs, plus file names.
- Subcommands of tasks that use the `:cmd` key, at any depth.
- Long flags from the `Options:` section of a subcommand, after you type `-`.
- File names for task arguments.

## Requirements

- zsh
- `bb` 1.13.220 or later for `:cmd` subcommands. Task names complete with older versions.
- `awk`, `grep` and `tail`

## Install

### zinit

```zsh
zinit light darth10/zsh-bb-completion
```

zinit installs the `_bb` completion file. Run `zicompinit` (or `compinit`) after the plugin loads.

### antidote

Add this line to your plugins file:

```text
darth10/zsh-bb-completion
```

### Oh My Zsh

```zsh
git clone https://github.com/darth10/zsh-bb-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bb-completion
```

Add `zsh-bb-completion` to the `plugins` array in `~/.zshrc`.

### Manual

Clone the repo, and add it to `fpath` before `compinit`:

```zsh
fpath=(/path/to/zsh-bb-completion $fpath)
autoload -Uz compinit && compinit
```

## How it works

- At the first argument, the completion runs `bb tasks`.
- For later arguments, it reads `./bb.edn` and checks if the task has a `:cmd` key.
- If the task has a `:cmd` key, it runs `bb <task> [<command>...] --help` and reads the `Commands:` and `Options:` sections.
- If the task has no `:cmd` key, it completes file names only. A plain task can ignore `--help` and run, so the completion never calls it.

## Limits

- Each Tab starts one or more `bb` processes, so subcommand completion has a short delay.
- Subcommand completion reads `bb.edn` in the current directory only.
- If `bb.edn` uses reader tags that `clojure.edn` cannot read, subcommands fall back to file names.

## Tests

```sh
zsh -f tests/run.zsh
```

The tests run `_bb` against `tests/fixture/bb.edn` with stubbed completion functions.

## License

MIT
