{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wren-cli";
  version = "0.4.0-unstable-2022-04-22";
  _commit = "18553636618a4d33f10af9b5ab";

  src = fetchFromGitHub {
    owner = "wren-lang";
    repo = "wren-cli";
    rev = finalAttrs._commit;
    hash = "sha256-UqGdIsLoSh5bTxf7AvPBh+abSPylKMlMbDw+j0IclKM=";
  };

  preBuild = ''
    cd projects/make
  '';
  installPhase = ''
    runHook preInstall
    install -D -m 755 ../../bin/wren_cli $out/bin/wren_cli
    runHook postInstall
  '';

  meta = {
    description = "Command line tool for the Wren programming language";
    homepage = "https://github.com/wren-lang/wren-cli";
    mainProgram = "wren_cli";
    license = lib.licenses.mit;
  };
})
