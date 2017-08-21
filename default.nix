with import <nixpkgs> {};

let py = python27.withPackages (pkgs: with pkgs; [
  # These are for spacemacs python layer. To get spacemacs with the
  # correct PATH. run nix-shell, then launch Emacs inside this
  # nix-shell.
  virtualenv
  flake8
  # See, https://nixos.org/nixpkgs/manual/#how-to-override-a-python-package
  ipython.override (self: super: { ignoreCollisions = true; })
  jedi.override (self: super: { doCheck = false; })
]);
in stdenv.mkDerivation {
  name = "py-env";
  buildInputs = [ py libffi openssl ];
  shellHook = ''
  '';
}
