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
  version = "0-unstable-2026-03-12";
  _commit = "1039dce08fc9bc1c8f03394e6a07f755deb5da0a";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = finalAttrs._commit;
    hash = "sha256-gfPeK2H/FtXKiOYrRxY/kQDBs2SyrY78R5blpii5nfM=";
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
