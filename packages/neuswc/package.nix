{
  lib,
  stdenv,
  fetchFromSourcehut,

  bmake,
  pkg-config,
  wayland-scanner,

  libxcb-wm,
  libinput,
  neuwld,
  wayland,
  libdrm,
  fontconfig,
  pixman,
  libxkbcommon,
  wayland-protocols,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neuswc";
  version = "0-unstable-2026-02-28";
  _commit = "d7a9eda640d4b4d96f6158266099d3c3fe8e5673";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuswc";
    rev = finalAttrs._commit;
    hash = "sha256-2y7nKZKKWQaxJSuz5ia4VIcR4ibsAt/M6oqDy5jRpg4=";
  };

  nativeBuildInputs = [
    bmake
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    libxcb-wm
    libinput
    neuwld
    wayland
    wayland-protocols
    libdrm
    fontconfig
    pixman
    libxkbcommon
  ];

  preInstall = ''
    sed -i 's/install -m 4755/install -m 755/g' Makefile
  '';
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Fork of swc with more features";
    homepage = "https://git.sr.ht/~shrub900/neuswc";
    license = lib.licenses.mit;
    mainProgram = "swc-launch";
  };
})
