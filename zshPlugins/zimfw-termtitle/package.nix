{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zimfw-termtitle";
  version = "2026-0l-20";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "termtitle";
    rev = "b0de7783181804d21cc73fbb109fb89e8b021327";
    hash = "sha256-KKoxwKQV9kJJCTkFKu3I1g27TONkoWB4oIwxHSolVoM=";
  };
  installPhase = ''
    mkdir -p $out
    cp init.zsh $out/zimfw-termtitle.plugin.zsh
  '';
  meta = {
    description = "Sets a custom terminal title for zsh";
    homepage = "https://github.com/zimfw/termtitle";
    license = lib.licenses.mit;
  };
}
