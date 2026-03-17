{
  lib,
  stdenv,
  fetchurl,

  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "infernal";
  version = "1.1.5";

  src = fetchurl {
    url = "http://eddylab.org/infernal/infernal-${finalAttrs.version}.tar.gz";
    hash = "sha256-rU3a4C+STKfIW8jEp5yfh1r435autyZwL6mFy+dSSX8=";
  };

  enableParallelBuilding = true;

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/cmsearch";
  versionCheckProgramArg = "-h";

  nativeInstallCheckInputs = [ versionCheckHook ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "RNA secondary structure/sequence profiles for homology search and alignment";
    homepage = "http://eddylab.org/infernal";
    license = lib.licenses.bsd3;
  };
})
