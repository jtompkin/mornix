{
  stdenv,
  fetchFromSourcehut,

  pkg-config,
  wayland-scanner,

  pixman,
  wayland,
  neuwld,
  fontconfig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "swiv";
  version = "0-unstable-2026-02-08";
  _commit = "53948d6838123df4bb5840e13ebd4cfc4ec92e23";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "swiv";
    rev = finalAttrs._commit;
    hash = "sha256-z0a5b6yn6ti4oy63SpOZtbYziNOOYG0Z0Er64pvSlFw=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    pixman
    wayland
    neuwld
    fontconfig
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple wayland image viewer";
    homepage = "https://git.sr.ht/~shrub900/swiv";
    mainProgram = "swiv";
  };
})
