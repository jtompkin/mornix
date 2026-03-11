{
  lib,
  stdenv,
  fetchFromSourcehut,

  pkg-config,
  wayland-scanner,

  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "swall";
  version = "0-unstable-2026-02-21";
  _commit = "fed1981e7f739a38193f9b3b32398ca75d2e7d29";

  src = fetchFromSourcehut {
    owner = "~uint";
    repo = "swall";
    rev = finalAttrs._commit;
    hash = "sha256-mdOTTTA/mwP/GNbiEWiX0QMZEiseLAMuecUFwMyqOsw=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    wayland
  ];

  preBuild = ''
    sed -i 's/-fcolor-diagnostics/-fdiagnostics-color/g' Makefile
  '';

  installPhase = ''
    install -D -m 755 swall $out/bin/swall
  '';

  meta = {
    description = "Wallpaper setter for neuswc";
    homepage = "https://git.sr.ht/~uint/swall";
    license = lib.licenses.isc;
    mainProgram = "swall";
  };
})
