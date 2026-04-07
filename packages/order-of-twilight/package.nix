{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  love,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "order-of-twilight";
  version = "unstable";
  _commit = "ea936e076a88a11b8dbb2ce9aac322c993b647c7";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = "orderoftwilight";
    rev = finalAttrs._commit;
    hash = "sha256-IfHh5EItfX8Cmxj4l1roAIig56zXOhBiSWl9LrROHjI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${lib.getExe love} $out/bin/order-of-twilight \
      --append-flag ${finalAttrs.src}

    runHook postInstall
  '';

  meta = {
    description = "Puzzle platformer with muscle memory";
    homepage = "https://github.com/Stabyourself/orderoftwilight";
    license = lib.licenses.mit;
    mainProgram = "order-of-twilight";
  };
})
