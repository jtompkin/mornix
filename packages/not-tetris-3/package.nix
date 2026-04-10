{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  love,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "not-tetris-3";
  version = "0-unstable-2021-01-27";
  _commit = "438e0a565978d46e3829e906d53617ea1cc03295";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = "not-tetris-3";
    rev = finalAttrs._commit;
    hash = "sha256-/6aH1guJHrzbE9HvACjgKfntKd0KWUMlMn1zR4KeSBU=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${lib.getExe love} $out/bin/not-tetris-3 \
      --append-flag ${finalAttrs.src}

    runHook postInstall
  '';

  meta = {
    description = "Not tetris";
    homepage = "https://github.com/Stabyourself/not-tetris-3";
    license = lib.licenses.mit;
  };
})
