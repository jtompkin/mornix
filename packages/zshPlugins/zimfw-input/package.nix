{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zimfw-input";
  version = "0-unstable-2026-01-05";
  _commit = "0f7efb3f659e1d68743a6c2c06c962ba9e05ae66";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "input";
    rev = finalAttrs._commit;
    hash = "sha256-Ng4cVmzOrTk7uiW64QAGCXG2wmN+63mUlRv9x93g/90=";
  };
  installPhase = ''
    install -D init.zsh $out/zimfw-input.plugin.zsh
  '';
  meta = {
    description = " Applies correct bindkeys for input events in zsh";
    homepage = "https://github.com/zimfw/input";
    license = lib.licenses.mit;
  };
})
