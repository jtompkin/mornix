{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zimfw-completion";
  version = "2025-07-24";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "completion";
    rev = "efc94ced311dd181835ccfd3f08ecb422c8465b2";
    hash = "sha256-8V3c3lFEyfJZuWNifMY+6Lw4qCXtBsX4I6ClLlCivSE=";
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
}
