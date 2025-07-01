{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "goclacker";
  version = "1.4.3";
  src = fetchFromGitHub {
    owner = "jtompkin";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-MTz1IngcQv42VglROQ9TOijlZHLbPGvjXmcI7rp9bUY=";
  };
  vendorHash = "sha256-rELkSYwqfMFX++w6e7/7suzPaB91GhbqFsLaYCeeIm4=";
  meta = {
    description = "Command line reverse Polish notation calculator";
    homepage = "https://github.com/jtompkin/goclacker";
    changelog = "https://github.com/jtompkin/goclacker/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = finalAttrs.pname;
  };
})
