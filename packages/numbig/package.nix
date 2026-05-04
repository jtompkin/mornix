{
  lib,
  stdenv,
  fetchFromCodeberg,

  versionCheckHook,

  libzahl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "numbig";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "jtompkin";
    repo = "numbig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SEKFG9bZ+Wrd3AlSTvSbbmPo5CM41npMT2mef7ltVO4=";
  };

  buildInputs = [ libzahl ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "RPN big int calculator";
    homepage = "https://codeberg.org/jtompkin/numbig";
    license = lib.licenses.mit;
    mainProgram = "numbig";
  };
})
