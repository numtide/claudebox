{
  description = "Sandboxed environment for Claude Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      nixpkgs.config.allowUnfree = true;
    }
    // {
      packages =
        inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ]
          (
            system:
            let
              pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
              claudebox = pkgs.callPackage ./package.nix { };
            in
            {
              inherit claudebox;
              default = claudebox;
            }
          );
    };
}
