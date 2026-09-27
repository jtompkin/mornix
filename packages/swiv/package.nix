{
  lib,
  stdenv,
  fetchFromSourcehut,

  pkg-config,
  wayland-scanner,

  pixman,
  wayland,
  neuwld,
  fontconfig,
  libxkbcommon,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "swiv";
  version = "0-unstable-2026-05-29";
  _commit = "17ec70c4c763588bdfc824a59ce81fa38b54764b";

  src = fetchFromSourcehut {
    owner = "~pfr";
    repo = "swiv";
    rev = finalAttrs._commit;
    hash = "sha256-IW8GuNAY4eJbOWIVyARROb4l4qSRndMpwzZnGaof1pU=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    pixman
    libxkbcommon
    wayland
    neuwld
    fontconfig
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple wayland image viewer";
    license = lib.licenses.isc;
    homepage = "https://git.sr.ht/~pfr/swiv";
    mainProgram = "swiv";
  };
})
