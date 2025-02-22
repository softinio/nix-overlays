{
  description = "Nix Flake used for testing overlays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    {
      # Expose each overlay individually
      overlays = {
        default = nixpkgs.lib.composeManyExtensions [ self.overlays.uv ];
        uv = final: prev: {
          python313 = prev.python313.override {
            packageOverrides = pyFinal: pyPrev: {
              uv = pyFinal.callPackage ./pkgs/uv/default.nix { };
            };
          };
        };
      };
    } // 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
        python = pkgs.python313;
      in
      {
        # Expose packages
        packages = {
          default = python.pkgs.uv;
          uv = python.pkgs.uv;
        };
        
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Make sure we get the overlaid version directly
            python
            python.pkgs.uv # This will use the overlaid version
            pkgs.git
          ];
          shellHook = ''
            export PATH="${python}/bin:${python.pkgs.uv}/bin:$PATH"
          '';
        };
      }
    );
}
