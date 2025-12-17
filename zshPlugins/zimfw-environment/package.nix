{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zimfw-environment";
  version = "2021-11-30";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "environment";
    rev = "d4bceaa3da89cd819843334dba1a5bf7dc137e14";
    hash = "sha256-B8Cki4uCcSce0xewZ91P9wCpA5+x/AlT1IwC+HVs6OI=";
  };
  installPhase = ''
    mkdir -p $out
    cp init.zsh $out/zimfw-environment.plugin.zsh
  '';
  meta = {
    description = "Sets generic Zsh built-in environment options";
    homepage = "https://github.com/zimfw/environment";
    license = lib.licenses.mit;
  };
}
