{
  lib,
  stdenv,
  fetchzip,

  cmake,

  libpng,
  libjpeg,
  libtiff,
  lcms,
  libsquish,
  jasper,

  withJasper ? true,
  withJpeg ? true,
  withLcms ? true,
  withPng ? true,
  withSquish ? false,
  withTiff ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "devil";
  version = "1.8.0";

  src = fetchzip {
    url = "https://downloads.sourceforge.net/openil/DevIL-${finalAttrs.version}.tar.gz";
    hash = "sha256-ITGAEeZAtjTdyWJWrqQJo9EJNpXvmMTRj8sx9Y7cJvQ=";
  };
  sourceRoot = "${finalAttrs.src.name}/DevIL";

  patches =
    [ ]
    # Stolen from Arch package: https://gitlab.archlinux.org/archlinux/packaging/packages/devil/-/tree/main?ref_type=heads
    ++ lib.optional withJasper ./jasper.patch;

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [ ]
    ++ lib.optional withJasper jasper
    ++ lib.optional withJpeg libjpeg
    ++ lib.optional withLcms lcms
    ++ lib.optional withPng libpng
    ++ lib.optional withSquish libsquish
    ++ lib.optional withTiff libtiff;

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

  meta = {
    description = "Full featured cross-platform image library";
    homepage = "https://sourceforge.net/projects/openil/";
    license = lib.licenses.lgpl21Only;
  };
})
