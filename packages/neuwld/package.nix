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
  version = "0-unstable-2026-08-13";
  _commit = "554f827cadfdfcc276c709dbffa3b2b04c70cf7c";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = finalAttrs._commit;
    hash = "sha256-KAK4/TpNekaonN0yxi4/5mRdZL1uxYdGmwl41FRH5wU=";
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
