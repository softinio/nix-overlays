# nix-overlays

Collection of Nix overlays and package definitions.

## Available Overlays

- **uv**: Python package manager and installer (version 0.6.0)

## Usage

You can use these overlays in your flake-based projects in several ways:

### Using specific overlays

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-overlays.url = "github:softinio/nix-overlays";
  };

  outputs = { self, nixpkgs, nix-overlays }: {
    # Example for NixOS configuration
    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            nix-overlays.overlays.uv
          ];
        })
      ];
    };
  };
}
```

### Using all overlays together

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-overlays.url = "github:softinio/nix-overlays";
  };

  outputs = { self, nixpkgs, nix-overlays }: {
    # Example for NixOS configuration
    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            nix-overlays.overlays.default
          ];
        })
      ];
    };
  };
}
```

### Directly using packages

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-overlays.url = "github:softinio/nix-overlays";
  };

  outputs = { self, nixpkgs, nix-overlays }:
  let
    system = "x86_64-linux"; # or your preferred system
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Example for accessing a package directly
    packages.${system}.default = nix-overlays.packages.${system}.uv;
  };
}
```
