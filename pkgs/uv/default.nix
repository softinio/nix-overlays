{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  installShellFiles,
  pkg-config,
  cmake,
}:

let
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = "refs/tags/${version}";
    hash = "sha256-1D1/LY8nJI14nLghYI60a4CFmu8McUIUnxB7SeXPs1o=";
  };
in
buildPythonPackage rec {
  pname = "uv";
  inherit version src;

  format = "pyproject";

  cargoBuildFlags = [
    "--package"
    "uv"
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cmake
  ];

  postInstall = ''
    # Only set HOME if not already defined
    [ -z "$HOME" ] && export HOME=$TMPDIR
    
    installShellCompletion --cmd uv \
      --bash <($out/bin/uv --generate-shell-completion bash) \
      --fish <($out/bin/uv --generate-shell-completion fish) \
      --zsh <($out/bin/uv --generate-shell-completion zsh)
  '';

  doCheck = false;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-2XLkMk6IsWho/BlPr+uxfuliAsTDat+nY0h/MJN8sXU=";
  };
}
