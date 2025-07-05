# nix-overlays

Collection of reusable Nix overlays and package definitions for external projects.

## Available Overlays

- **uv**: Python package manager and installer (version 0.6.0)

## Usage

### With Flakes

You can use these overlays in your flake-based projects in several ways:

#### Using specific overlays

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

#### Using all overlays together

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

#### Directly using packages

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

### Without Flakes

For traditional Nix usage without flakes:

```nix
# In your configuration.nix or shell.nix
let
  nix-overlays = builtins.fetchTarball {
    url = "https://github.com/softinio/nix-overlays/archive/main.tar.gz";
  };
  overlays = import "${nix-overlays}/default.nix" { };
in
{
  nixpkgs.overlays = [
    overlays.default  # or overlays.uv for specific overlay
  ];
}
```
