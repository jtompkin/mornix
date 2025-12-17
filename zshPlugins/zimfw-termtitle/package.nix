{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zimfw-termtitle";
  version = "2025-12-14";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "termtitle";
    rev = "96aff3e49bc0c8665b20226b06517a8ee7452914";
    hash = "sha256-OQEIL12nqruTZzWGMv7p2Lx1EADOv2dr71xAE2aHww4=";
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
