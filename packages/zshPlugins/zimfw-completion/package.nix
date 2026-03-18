{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zimfw-completion";
  version = "0-unstable-2026-01-05";
  _commit = "af1a52e700d9c3c1e2eb9b7d540dedd2a0154270";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "completion";
    rev = finalAttrs._commit;
    hash = "sha256-t56EEy19djSCaPxSi6w59qog7rxzD7bbFJkYD/PQ53E=";
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
