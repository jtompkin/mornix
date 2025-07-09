{
  lib,
  fetchFromGitHub,
  makeRustPlatform,
  fenix,
}:
let
  inherit (fenix.default) toolchain;
in
(makeRustPlatform {
  cargo = toolchain;
  rustc = toolchain;
}).buildRustPackage
  (finalAttrs: {
    pname = "msedit";
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "edit";
      tag = "v${finalAttrs.version}";
      hash = "sha256-G5U5ervW1NAQY/fnwOWv1FNuKcP+HYcAW5w87XHqgA8=";
    };
    cargoHash = "sha256-ceAaaR+N03Dq2MHYel4sHDbbYUOr/ZrtwqJwhaUbC2o=";
    meta = {
      description = "A simple editor for simple needs";
      homePage = "https://github.com/microsoft/edit";
      license = lib.licenses.mit;
      mainProgram = "edit";
    };
  })
