{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {
    devShell.x86_64-linux = pkgs.mkShell {
      packages = [pkgs.cabal-install (pkgs.haskell.packages.ghc902.ghcWithPackages (ps: [ps.async]))];
    };
  };
}
