{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  love,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "text-based-sokoban";
  version = "unstable";
  _commit = "4f189c943fea28fdf68e69ca1b8b60c63f4fc105";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = "text-based-sokoban";
    rev = finalAttrs._commit;
    hash = "sha256-c3zIj6JeV7d1j6s/JHLFFF+vggKJzPyPmLp+BMnScWQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${lib.getExe love} $out/bin/text-based-sokoban \
      --append-flag ${finalAttrs.src}

    runHook postInstall
  '';

  meta = {
    description = "Text-based box-pushing game";
    homepage = "https://github.com/Stabyourself/text-based-sokoban";
    license = lib.licenses.mit;
  };
})
