{
  lib,
  stdenv,
  fetchFromSourcehut,

  pkg-config,
  wayland-scanner,

  fontconfig,
  libxkbcommon,
  neuswc,
  neuwld,
  pixman,
  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neumenu";
  version = "2026-02-26";
  _commit = "88d0bd8bb47a3bea4e806087b4be95af226d5bb3";

  src = fetchFromSourcehut {
    owner = "~uint";
    repo = "neumenu";
    rev = finalAttrs._commit;
    hash = "sha256-oASly6REP1EGV8jBROMZJR+Q8TrkVNKga4Yub37xjxo=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    fontconfig
    libxkbcommon
    neuwld
    pixman
    wayland
  ];

  makeFlags = [
    "SWCPROTO=${neuswc}/share/swc/swc.xml"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "An efficient dynamic menu for wayland";
    homepage = "https://git.sr.ht/~uint/neumenu";
    license = lib.licenses.mit;
    mainProgram = "neumenu";
  };
})
