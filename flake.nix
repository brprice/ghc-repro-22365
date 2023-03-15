{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
    deps = [pkgs.cabal-install (pkgs.haskell.packages.ghc925.ghcWithPackages (ps: [ps.async]))];
    runScript = pkgs.writeShellApplication {
        name = "bugloop";
        runtimeInputs = deps;
        text = ''
          cabal clean
          cabal build bug
          bug=$(cabal list-bin bug)
          i=1
          while :; do
            echo $i
            $bug
            ((i++))
          done
        '';
        };
  in {
    devShell.x86_64-linux = pkgs.mkShell {
      packages = deps;
    };
    apps.x86_64-linux.default = {
      type = "app";
      program = "${runScript}/bin/bugloop" ;
      };
  };
}
