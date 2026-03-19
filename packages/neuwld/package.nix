{
  lib,
  stdenv,
  fetchFromSourcehut,

  doxygen,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,

  fontconfig,
  libdrm,
  pixman,
  wayland,

  # Choices: auto, intel, nouveau
  drmDrivers ? [
    "auto"
  ],
  buildDocumentation ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neuwld";
  version = "0-unstable-2026-03-18";
  _commit = "6446a28168045efffa8ccd3de0b6eb3599fb5339";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = finalAttrs._commit;
    hash = "sha256-rP03qodS9zUKJ6WPxPlu/sn+yRWc6jssa10mVPEjodc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ]
  ++ lib.optional buildDocumentation doxygen;
  buildInputs = [
    fontconfig
    libdrm
    pixman
    wayland
  ];

  mesonFlags = [
    "-Ddoxygen=${if buildDocumentation then "enabled" else "disabled"}"
    "-Ddrivers=${lib.concatStringsSep "," drmDrivers}"
    "-Ddefault_library=both"
  ];

  meta = {
    description = "Drawing library that targets Wayland";
    homepage = "https://git.sr.ht/~shrub900/neuwld";
    license = lib.licenses.mit;
  };
})
