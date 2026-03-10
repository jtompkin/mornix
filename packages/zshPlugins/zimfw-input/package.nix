{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zimfw-input";
  version = "2026-01-05";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "input";
    rev = "0f7efb3f659e1d68743a6c2c06c962ba9e05ae66";
    hash = "sha256-Ng4cVmzOrTk7uiW64QAGCXG2wmN+63mUlRv9x93g/90=";
  };
  installPhase = ''
    mkdir -p $out
    cp init.zsh $out/zimfw-input.plugin.zsh
  '';
  meta = {
    description = " Applies correct bindkeys for input events in zsh";
    homepage = "https://github.com/zimfw/input";
    license = lib.licenses.mit;
  };
}
