{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  love_0_7,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "not-tetris-2";
  version = "2.0-unstable-2021-09-03";
  _commit = "62c05953341b74f601d7f0003529fab9764a166b";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = "nottetris2";
    rev = finalAttrs._commit;
    hash = "sha256-xqj0xx5I1FlODylHD/GnpvZ5Iz6Uqj370S2ybnzIuzQ=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${lib.getExe love_0_7} $out/bin/not-tetris \
      --append-flag ${finalAttrs.src}

    runHook postInstall
  '';

  meta = {
    description = "Not tetris";
    homepage = "https://github.com/Stabyourself/not-tetris-3";
    license = lib.licenses.wtfpl;
    mainProgram = "not-tetris";
  };
})
