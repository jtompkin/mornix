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
  version = "0-unstable-2026-03-07";
  _commit = "235b7b62be7d7c9eefa011eac4a5b78ba7390f1c";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = finalAttrs._commit;
    hash = "sha256-0+rgWrefh19bBEmcqw0Lal1PHkendtCkQ2EIg+LHb74=";
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

  meta = {
    description = "Drawing library that targets Wayland";
    homepage = "https://git.sr.ht/~shrub900/neuwld";
    license = lib.licenses.mit;
  };
})
