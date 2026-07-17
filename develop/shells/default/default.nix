{
  inputs,
  pkgs,
  system,
  ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    typst
    tinymist
    nixfmt
    deadnix
    statix
  ];

  shellHook = ''
    ${inputs.self.checks.${system}.git-hooks.shellHook}
    echo "typst version: $(typst --version)"
  '';

  buildInputs = inputs.self.checks.${system}.git-hooks.enabledPackages;
}
