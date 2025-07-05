# Nix overlays collection
{ ... }:
{
  # Main overlay that includes all sub-overlays
  default = final: prev: {
    # Add uv to python313 packages
    python313 = prev.python313.override {
      packageOverrides = pyFinal: pyPrev: {
        uv = pyFinal.callPackage ./pkgs/uv { };
      };
    };
  };

  # Individual overlays
  uv = final: prev: {
    python313 = prev.python313.override {
      packageOverrides = pyFinal: pyPrev: {
        uv = pyFinal.callPackage ./pkgs/uv { };
      };
    };
  };
}