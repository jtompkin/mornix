{
  lib,
  stdenv,
  fetchzip,

  cmake,

  libpng,
  libjpeg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "devil";
  version = "1.8.0";

  src = fetchzip {
    url = "https://downloads.sourceforge.net/openil/DevIL-${finalAttrs.version}.tar.gz";
    hash = "sha256-ITGAEeZAtjTdyWJWrqQJo9EJNpXvmMTRj8sx9Y7cJvQ=";
  };
  sourceRoot = "${finalAttrs.src.name}/DevIL";

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libpng
    libjpeg
  ];

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

  meta = {
    description = "Full featured cross-platform image library";
    homepage = "https://sourceforge.net/projects/openil/";
    license = lib.licenses.lgpl21Only;
  };
})
