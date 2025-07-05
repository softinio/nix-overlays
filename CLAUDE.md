# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of reusable Nix overlays designed for external projects. The repository uses Nix flakes to expose overlays that can be consumed by other Nix-based projects.

## Architecture

### Overlay Structure

1. **Package definitions**: Located in `pkgs/<package-name>/default.nix`
2. **Overlay exports**: Defined in `default.nix` at the root
3. **Flake exposure**: Handled by `flake.nix` which imports from `default.nix`

### Adding New Overlays

To add a new package overlay:
1. Create `pkgs/<package-name>/default.nix` with the package definition
2. Add the overlay to `default.nix`:
   ```nix
   <package-name> = final: prev: {
     python313 = prev.python313.override {
       packageOverrides = pyFinal: pyPrev: {
         <package-name> = pyFinal.callPackage ./pkgs/<package-name> { };
       };
     };
   };
   ```
3. Update README.md to document the new package

## Common Commands

```bash
# Enter development shell
nix develop

# Build a specific package
nix build .#<package-name>

# Update flake dependencies
nix flake update

# Show available outputs
nix flake show

# Check flake metadata
nix flake metadata
```

## Key Patterns

- Overlays target specific Python versions (currently Python 3.13) using `packageOverrides`
- Packages requiring Rust compilation use `rustPlatform` and `buildPythonPackage`
- Shell completions should be generated and installed in `postInstall`
- Each package must be self-contained in its own directory under `pkgs/`

## Testing

When modifying packages:
1. Test the build: `nix build .#<package-name>`
2. Test in dev shell: `nix develop` then verify the package works
3. Ensure shell completions generate correctly
4. Verify the overlay works when imported by external projects