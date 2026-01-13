{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zimfw-termtitle";
  version = "2026-01-05";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "termtitle";
    rev = "8b5969a3225cf42c7934e265d589f943b1d7d623";
    hash = "sha256-QKdvVt+5XEpzFyEoLA3ohIin5vfTQ18lGC7Yk+2e2zk=";
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
