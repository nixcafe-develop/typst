# Nix Flake · Typst Dev Template

> typst · tinymist · purr · git-hooks

Nix flake template for Typst document authoring — a reproducible, declarative dev shell with Typst, tinymist LSP, Nix formatters, linters, and git pre-commit hooks. Bootstrapped via [purr](https://github.com/nixcafe/purr), enforcing code quality on every commit.

Part of the [develop-templates](https://github.com/nixcafe/develop-templates) collection (`nix flake init`-ready).

## Quick Start

```bash
nix flake init -t "github:nixcafe/develop-templates#typst" --refresh
```

To shorten, register an alias:
```bash
nix registry add beans "github:nixcafe/develop-templates"
nix flake init -t beans#typst
```

> **Tip**: With [cattery-modules](https://github.com/nixcafe/cattery-modules), `beans` is pre-registered.

```bash
gh repo create my-typst-project --template nixcafe/typst --clone
direnv allow
```

### Build Your Document

```bash
typst compile main.typ
# Or watch mode:
typst watch main.typ
```

## What's Inside

| Tool | Purpose |
|------|---------|
| `typst` | Typst document compiler |
| `tinymist` | LSP language server (completion, diagnostics, preview) |
| `nixfmt` | Nix formatter |
| `deadnix` | Remove dead Nix code |
| `statix` | Nix linter |

- **Dev shell** — `develop/shells/default/` ships `typst`, `tinymist`, `nixfmt`, `deadnix`, and `statix` in `$PATH`.
- **Git hooks** — `develop/checks/git-hooks/` runs `nixfmt`, `deadnix`, and `statix` on every commit. The shell hook auto-installs them when you enter the dev shell.
- **direnv** — `.envrc` calls `use flake` for auto-loading the dev shell on `cd`.
- **Sample** — `main.typ` is a minimal document showing math, lists, code blocks, and tables.

## Customizing

### Typst Packages

Typst and `tinymist` are pre-configured. Add extra tools as needed:

```nix
packages = with pkgs; [
  typst
  tinymist
  typstfmt       # formatter (optional)
  nixfmt
  deadnix
  statix
];
```

Then run `direnv allow` (or `nix develop`) to reload.

### Pre-commit Hooks

Edit `develop/checks/git-hooks/default.nix` to enable, disable, or add hooks:

```nix
{ inputs, system, ... }:
inputs.git-hooks.lib.${system}.run {
  src = ../../..;

  hooks = {
    nixfmt.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
```

All three hooks are enabled by default. Set `enable = false` to skip a hook, or add new entries from [git-hooks.nix](https://github.com/cachix/git-hooks.nix) modules.

## Project Structure

```
.
├── flake.nix                          # Flake entry point — purr drives everything
├── main.typ                           # Sample Typst document
├── develop/
│   ├── checks/
│   │   └── git-hooks/
│   │       └── default.nix            # Pre-commit hook definitions
│   └── shells/
│       └── default/
│           └── default.nix            # Dev shell packages + shellHook
├── statix.toml                        # Statix linter config
├── .envrc                             # direnv — auto-loads nix develop
└── .gitignore
```
