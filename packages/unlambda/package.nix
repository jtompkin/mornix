{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unlambda";
  version = "2.0.0";

  src = fetchzip {
    url = "ftp://ftp.madore.org/pub/madore/unlambda/unlambda-${finalAttrs.version}.tar.gz";
    hash = "sha256-a8c8OjhpYVOK68R1TY3pS+cTUVY/lBJVHiwH+7TnYL4=";
  };

  buildPhase = ''
    runHook preBuild

    gcc -O3 -ansi -o unlambda c-refcnt/unlambda.c

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    install -D -m 755 unlambda $out/bin/unlambda

    runHook postInstall
  '';

  meta = {
    description = "Unlambda interpreter";
    homepage = "http://www.madore.org/~david/programs/unlambda";
    license = lib.licenses.gpl2Plus;
  };
})
