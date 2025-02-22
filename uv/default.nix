final: prev: {

  python313 = prev.python313.override {
    packageOverrides = python-final: python-prev: {
      uv =
        let
          version = "0.6.0";
          src = prev.fetchFromGitHub {
            owner = "astral-sh";
            repo = "uv";
            rev = "refs/tags/${version}";
            hash = "sha256-1D1/LY8nJI14nLghYI60a4CFmu8McUIUnxB7SeXPs1o=";
          };
        in
        python-prev.buildPythonPackage {
          pname = "uv";
          inherit version src;

          format = "pyproject";

          cargoBuildFlags = [
            "--package"
            "uv"
          ];

          dontUseCmakeConfigure = true;

          nativeBuildInputs = with prev; [
            installShellFiles
            pkg-config
            rustPlatform.cargoSetupHook
            rustPlatform.maturinBuildHook
            cmake
          ];

          postInstall =
            let
              uv = "${prev.stdenv.hostPlatform.emulator prev.buildPackages} $out/bin/uv";
            in
            prev.lib.optionalString (prev.stdenv.hostPlatform.emulatorAvailable prev.buildPackages) ''
              export HOME=$TMPDIR
              installShellCompletion --cmd uv \
                --bash <(${uv} --generate-shell-completion bash) \
                --fish <(${uv} --generate-shell-completion fish) \
                --zsh <(${uv} --generate-shell-completion zsh)
            '';

          doCheck = false;

          cargoDeps = prev.rustPlatform.fetchCargoVendor {
            inherit src;
            hash = "sha256-2XLkMk6IsWho/BlPr+uxfuliAsTDat+nY0h/MJN8sXU=";
          };
        };
    };
  };
}
