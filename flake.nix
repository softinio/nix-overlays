{
  description = "Nix Flake used for testing overlays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs allSystems;

      overlays = [ (import ./uv) ];
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = overlays;
        }
      );

    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          python = pkgs.python313;
        in
        {
          default = pkgs.mkShell {
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
    };
}
