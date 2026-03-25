{
  lib,
  stdenv,
  fetchgit,

  autoreconfHook,
  bison,
  flex,
  pkg-config,
  python3,

  glib,
  gtk2,

  withGtk ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gnubg";
  version = "2026-01-21";
  _commit = "92b5cae07d5ec9a13fb1e1f17fdec06afc1ee08d";

  src = fetchgit {
    url = "git://git.git.savannah.gnu.org/gnubg";
    rev = finalAttrs._commit;
    hash = "sha256-4VHn9OhvMjH+cWfQRZ325ITLnGIqEafFiqqiaFkJ/vE=";
  };

  enableParallelBuilding = true;

  postPatch = ''
    ${lib.optionalString withGtk "cp -v non-src/gnubg-stock-pixbufs.h ."}
  '';

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    python3
  ];
  buildInputs = [
    glib
  ]
  ++ lib.optional withGtk gtk2;
  strictDeps = true;

  meta = {
    description = "Play and analyze backgammon games and matches";
    homepage = "https://www.gnu.org/software/gnubg/";
    license = lib.licenses.gpl3Plus;
  };
})
