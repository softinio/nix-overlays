{
  description = "Collection of reusable Nix overlays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      # Import overlays from default.nix
      overlaySet = import ./default.nix { };
    in
    {
      # Expose overlays for external use
      overlays = {
        # Main overlay that includes all packages
        default = overlaySet.default;
        
        # Individual overlays
        uv = overlaySet.uv;
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
