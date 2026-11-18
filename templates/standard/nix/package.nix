{
  lib,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "";
  version = "";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.gitTracked ../.;
  };

  nativeBuildInputs = [

  ];
  buildInputs = [

  ];

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.LICENSE;
  };
})
