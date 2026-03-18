{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zimfw-environment";
  version = "0-unstable-2021-11-30";
  _commit = "d4bceaa3da89cd819843334dba1a5bf7dc137e14";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "environment";
    rev = finalAttrs._commit;
    hash = "sha256-B8Cki4uCcSce0xewZ91P9wCpA5+x/AlT1IwC+HVs6OI=";
  };
  installPhase = ''
    install -D init.zsh $out/zimfw-environment.plugin.zsh
  '';
  meta = {
    description = "Sets generic Zsh built-in environment options";
    homepage = "https://github.com/zimfw/environment";
    license = lib.licenses.mit;
  };
})
