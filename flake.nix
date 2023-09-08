{
  description = "Nix Flake template using the 'nixpkgs-unstable' branch and 'flake-utils'";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              sqlite = super.sqlite.overrideAttrs (oldAttrs: {
                configureFlags = oldAttrs.configureFlags ++ ["--enable-dynamic-extensions"];
              });
            })
          ];
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            sqlite
            coreutils
            moreutils
            jq
            alejandra
          ];
        };
      }
    );
}
