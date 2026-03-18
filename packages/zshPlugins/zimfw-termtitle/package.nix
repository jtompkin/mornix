{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zimfw-termtitle";
  version = "0-unstable-2026-02-20";
  _commit = "b0de7783181804d21cc73fbb109fb89e8b021327";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "termtitle";
    rev = finalAttrs._commit;
    hash = "sha256-KKoxwKQV9kJJCTkFKu3I1g27TONkoWB4oIwxHSolVoM=";
  };
  installPhase = ''
    install -D init.zsh $out/zimfw-termtitle.plugin.zsh
  '';
  meta = {
    description = "Sets a custom terminal title for zsh";
    homepage = "https://github.com/zimfw/termtitle";
    license = lib.licenses.mit;
  };
})
