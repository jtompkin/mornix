{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zimfw-completion";
  version = "0-unstable-2026-03-27";
  _commit = "8d3e0f4e6272f4d3bad659eaa13929f9dd96f123";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "completion";
    rev = finalAttrs._commit;
    hash = "sha256-xBurErM7KMMDObN3zPwTSOvKqXl9FDZxGfxugwlX/fk=";
  };
  installPhase = ''
    install -D -t $out/share/zsh/site-functions functions/*
    cp init.zsh $out/zimfw-completion.plugin.zsh
  '';
  meta = {
    description = "Enables and configures smart and extensive tab completion for zsh";
    homepage = "https://github.com/zimfw/completion";
    license = lib.licenses.mit;
  };
})
