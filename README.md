# Typst document environment

Nix flake template for Typst documents. The dev shell provides Typst, the tinymist language server, and `nixfmt`, `deadnix`, and `statix` for Nix files. Pre-commit hooks for the Nix tools are enabled and installed by the shell hook. The flake is built with [purr](https://github.com/nixcafe/purr) and uses [git-hooks.nix](https://github.com/cachix/git-hooks.nix).

Part of the [develop-templates](https://github.com/nixcafe/develop-templates) collection.

## Quick start

Create the project files in the current directory:

```bash
nix flake init -t "github:nixcafe/develop-templates#typst" --refresh
```

Register the collection once to use the shorter name:

```bash
nix registry add beans "github:nixcafe/develop-templates"
nix flake init -t beans#typst
```

With [cattery-modules](https://github.com/nixcafe/cattery-modules), `beans` is already registered.

You can also create a repository from the template repository:

```bash
gh repo create my-typst-project --template nixcafe-develop/typst --clone
```

Enter the dev shell:

```bash
nix develop
```

If direnv is installed, `direnv allow` loads the shell when you enter the directory. The template includes an `.envrc` that calls `use flake`.

The template does not include a `flake.lock`. The first `nix develop` resolves the inputs and writes one.

## Build the document

```bash
typst compile main.typ
```

To rebuild on changes:

```bash
typst watch main.typ
```

Both commands write `main.pdf`, which is listed in `.gitignore`.

## What's included

| Tool | Purpose |
|------|---------|
| `typst` | Typst compiler |
| `tinymist` | LSP server with completion, diagnostics, and preview |
| `nixfmt` | Nix formatter |
| `deadnix` | Finds dead code in Nix files |
| `statix` | Nix linter |

The sample `main.typ` shows headings, math, lists, a code block, and a table.

The pre-commit hooks for `nixfmt`, `deadnix`, and `statix` are enabled in `develop/checks/git-hooks/default.nix`. The shell hook installs them when you enter the dev shell.

The flake also sets `allowUnfree = true` and uses `pkgs.nixfmt` as the formatter, so `nix fmt` formats the Nix files.

## Useful commands

```bash
nix develop              # enter the dev shell
direnv allow             # load the shell through direnv
typst compile main.typ   # build main.pdf
typst watch main.typ     # rebuild on changes
nix fmt                  # format Nix files with nixfmt
```

## Customizing

### Add packages

`develop/shells/default/default.nix` contains the package list. Add tools as needed:

```nix
packages = with pkgs; [
  typst
  tinymist
  typstfmt       # formatter
  nixfmt
  deadnix
  statix
];
```

Run `direnv allow` or `nix develop` to reload the shell after changing the list.

### Pre-commit hooks

`develop/checks/git-hooks/default.nix` enables three hooks:

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

Set `enable = false` to skip a hook, or add entries from [git-hooks.nix](https://github.com/cachix/git-hooks.nix).

## Project structure

```
.
├── flake.nix                          # Flake entry point
├── main.typ                           # Sample Typst document
├── develop/
│   ├── checks/
│   │   └── git-hooks/
│   │       └── default.nix            # Pre-commit hook definitions
│   └── shells/
│       └── default/
│           └── default.nix            # Dev shell packages and shell hook
├── statix.toml                        # statix configuration
├── .envrc                             # direnv: use flake
└── .gitignore
```
