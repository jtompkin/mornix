{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  perl,
  infernal,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tRNAscan-se";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "UCSC-LoweLab";
    repo = "tRNAscan-SE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vQ17yLQPn4iZVY4jAD8W2J/CNOkP80T4NwcVyu+5CZc=";
  };

  nativeBuildInputs = [
    perl
    makeWrapper
  ];

  buildFlags = [ "CFLAGS=-std=c17" ];
  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    ln -s -t $out/bin ${infernal}/bin/*
    wrapProgram $out/bin/tRNAscan-SE \
      --prefix PATH : ${lib.makeBinPath [ perl ]}
  '';

  meta = {
    description = "A program for detection of tRNA genes";
    homepage = "https://github.com/UCSC-LoweLab/tRNAscan-SE";
    license = lib.licenses.gpl3;
  };
})
