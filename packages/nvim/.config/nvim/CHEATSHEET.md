# nvim cheatsheet

Leader is `<Space>`. Press `<Space>` alone and wait — **which-key** shows every
continuation. That menu is the real cheatsheet; this file is the shortlist.

## Coming from Cursor

| Cursor | here |
|---|---|
| `Cmd+P` file open | `<leader><space>` |
| `Cmd+Shift+F` project search | `<leader>/` |
| `Cmd+Shift+P` commands | `<leader>fc` / `:` |
| `Cmd+D` next occurrence | `<C-n>` |
| `Cmd+B` sidebar | `<leader>e` |
| `Cmd+\` split | `<C-w>v` (vert) `<C-w>s` (horiz) |
| `F2` rename symbol | `<leader>cr` |
| `Cmd+.` quick fix | `<leader>ca` |
| Cmd+click definition | `gd` |
| Cursor chat | `<leader>ac` |
| `Cmd+Z` | `u` (and `<leader>U` for the tree) |

## Moving

| key | does |
|---|---|
| `s` + 2 chars | **flash** — jump anywhere on screen. Learn this first. |
| `<leader><space>` | find file in project root |
| `<leader>ff` / `<leader>fF` | find file (root / cwd) |
| `<leader>/` | live grep the project |
| `<leader>,` | switch buffer |
| `<leader>fr` | recent files |
| `<S-h>` / `<S-l>` | previous / next buffer |
| `<C-h/j/k/l>` | move between splits |
| `<C-o>` / `<C-i>` | jump back / forward |

## Harpoon — the 4 files you're actually working on

| key | does |
|---|---|
| `<leader>H` | pin current file |
| `<leader>h` | open the pin menu (edit it like a buffer) |
| `<leader>1` … `<leader>9` | jump straight to pin N |

Fuzzy find is for *discovery*. Harpoon is for the loop you're in right now.

## Code / LSP

| key | does |
|---|---|
| `gd` `gr` `gI` `gy` | definition / references / implementation / type def |
| `K` | hover docs (twice to enter the float) |
| `<leader>ca` | code action |
| `<leader>cr` | rename symbol |
| `<leader>cf` | format |
| `]d` / `[d` | next / prev diagnostic |
| `<leader>xx` | diagnostics list (trouble) |
| `<leader>ss` | jump to symbol in file |
| `<leader>sr` | project-wide search & replace (grug-far) |

## Editing

| key | does |
|---|---|
| `gcc` / `gc` (visual) | comment line / selection |
| `ysiw"` | surround word with `"` |
| `cs"'` | change surrounding `"` to `'` |
| `ds(` | delete surrounding `(` |
| `ciw` `ci"` `cit` | change in word / quotes / tag |
| `<leader>m` | split/join a block across lines |
| `gaip=` | align paragraph on `=` |
| `<A-j>` / `<A-k>` | move line down / up |
| `<leader>p` | yank history |
| `<leader>U` | undo tree |

## Multi-cursor

| key | does |
|---|---|
| `<C-n>` | add cursor at next match (Cmd+D) |
| `<M-n>` | add cursor at previous match |
| `<C-p>` | skip this match, go to next |
| `<leader>A` | cursor on every match |
| `<M-Up>` / `<M-Down>` | add cursor above / below |
| `<esc>` | clear extra cursors |

## Git

| key | does |
|---|---|
| `<leader>gg` | lazygit (floating) |
| `<leader>gd` | diffview: working tree |
| `<leader>gm` | diffview: everything since merge-base |
| `<leader>gD` | this file's history |
| `]h` / `[h` | next / prev hunk |
| `<leader>ghs` / `<leader>ghr` | stage / reset hunk |
| `<leader>gb` | blame line |

## Claude Code

| key | does |
|---|---|
| `<leader>ac` | toggle Claude |
| `<leader>af` | focus Claude |
| `<leader>ar` / `<leader>aC` | resume / continue session |
| `<leader>ab` | add current buffer to context |
| `<leader>as` | send visual selection (or file, from neo-tree) |
| `<leader>aa` / `<leader>ad` | accept / deny the proposed diff |

## Housekeeping

| key | does |
|---|---|
| `<leader>l` | Lazy (plugin manager) |
| `<leader>cm` | Mason (LSP/tool installer) |
| `<leader>qs` | restore session for this directory |
| `<leader>bd` | close buffer |
| `<leader>ur` | clear search highlight / redraw |

## In the shell

On the source Mac, `vim` and `vi` open nvim, with junegunn's git pickers:
`CTRL-G` then `CTRL-B` branches · `CTRL-F` files · `CTRL-H` hashes ·
`CTRL-T` tags · `CTRL-R` remotes · `CTRL-S` stashes.

Those shell aliases and pickers are not installed by the Neovim package.

## If something breaks

- `:checkhealth` — the first thing to run
- `:Lazy` — plugin status, `U` updates everything
- `:LazyExtras` — toggle language packs and features
- Config lives in `~/.config/nvim/lua/`; nothing here is generated, edit freely
