{
  lib,
  stdenv,
  fetchFromSourcehut,

  bmake,
  pkg-config,
  wayland-scanner,

  fontconfig,
  libdrm,
  pixman,
  wayland,

  drmDrivers ? [
    "intel"
    "noveau"
  ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neuwld";
  version = "2026-02-25";
  _commit = "534372ea862c933f0e614a9dd77c5b44ddb18d10";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = finalAttrs._commit;
    hash = "sha256-fyCHP3rEeoUr+pWEebLaPW0bmgoVGlb7yzU281+yOSg=";
  };

  nativeBuildInputs = [
    bmake
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    fontconfig
    libdrm
    pixman
    wayland
  ];

  preBuild = ''
    makeFlagsArray+=(
      PREFIX="$out"
      DRM_DRIVERS="${lib.concatStringsSep " " drmDrivers}"
    )
  '';
  # installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A drawing library that targets Wayland";
    homepage = "https://git.sr.ht/~shrub900/neuwld";
    license = lib.licenses.mit;
  };
})
