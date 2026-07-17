# Nix Flake · Typst Dev Template

> purr · git-hooks · typst · reproducible · nix-flake

Nix flake template for Typst document authoring — a reproducible, declarative dev shell with Nix formatters, linters, and git pre-commit hooks. Bootstrapped via [purr](https://github.com/nixcafe/purr), enforcing code quality on every commit.

Part of the [develop-templates](https://github.com/nixcafe/develop-templates) collection (`nix flake init`-ready).

## What's Inside

| Tool | Purpose |
|------|---------|
| `nixfmt-rfc-style` | Nix formatter |
| `deadnix` | Remove dead Nix code |
| `statix` | Nix linter |

- **Dev shell** — `develop/shells/default/` ships `nixfmt-rfc-style`, `deadnix`, and `statix` in `$PATH`. No Typst packages are configured out of the box — you bring your own.
- **Git hooks** — `develop/checks/git-hooks/` runs `nixfmt-rfc-style`, `deadnix`, and `statix` on every commit. The shell hook auto-installs them when you enter the dev shell.
- **direnv** — `.envrc` calls `use flake` for auto-loading the dev shell on `cd`.

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

## Customizing

### Add Typst

Edit `develop/shells/default/default.nix` and add the Typst packages your project needs:

```nix
{
  inputs,
  pkgs,
  system,
  ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixfmt-rfc-style
    deadnix
    statix
    typst
    typstfmt
  ];

  shellHook = ''
    ${inputs.self.checks.${system}.git-hooks.shellHook}
  '';
  buildInputs = inputs.self.checks.${system}.git-hooks.enabledPackages;
}
```

Then run `direnv allow` (or `nix develop`) to reload.

### Pre-commit Hooks

Edit `develop/checks/git-hooks/default.nix` to enable, disable, or add hooks:

```nix
{ inputs, system, ... }:
inputs.git-hooks.lib.${system}.run {
  src = ../../..;

  hooks = {
    nixfmt-rfc-style.enable = true;
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
