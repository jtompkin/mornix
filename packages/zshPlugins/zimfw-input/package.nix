{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zimfw-input";
  version = "0-unstable-2026-06-08";
  _commit = "bdec2b372f8bd16a072d30ebc447a22dad52cfb4";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "input";
    rev = finalAttrs._commit;
    hash = "sha256-/tWks6oFH6/LK8u9SxsZIJ9uAonJ2T6l91BflDwog80=";
  };
  installPhase = ''
    install -D init.zsh $out/zimfw-input.plugin.zsh
  '';
  meta = {
    description = "Applies correct bindkeys for input events in zsh";
    homepage = "https://github.com/zimfw/input";
    license = lib.licenses.mit;
  };
})
