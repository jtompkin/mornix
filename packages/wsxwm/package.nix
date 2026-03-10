{
  lib,
  stdenv,
  fetchFromSourcehut,

  bmake,
  pkg-config,

  fontconfig,
  libdrm,
  libinput,
  libxcb-wm,
  libxkbcommon,
  neuswc,
  neuwld,
  pixman,
  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wsxwm";
  version = "2026-02-21";
  _commit = "f5f3c1f53b77d41ab0b0aefabb64e86881b5705d";

  src = fetchFromSourcehut {
    owner = "~uint";
    repo = "wsxwm";
    rev = finalAttrs._commit;
    hash = "sha256-xXyRdFU/HYgbs9drGnqAh4mz4BgtcYfc6VJX8SvXFD4=";
  };

  nativeBuildInputs = [
    bmake
    pkg-config
  ];
  buildInputs = [
    fontconfig
    libdrm
    libinput
    libxcb-wm
    libxkbcommon
    neuswc
    neuwld
    pixman
    wayland
  ];

  installPhase = ''
    install -D -m 755 wsxwm $out/bin/wsxwm
  '';

  meta = {
    description = "Way Sexier Window Manager";
    homepage = "https://git.sr.ht/~uint/wsxwm";
    license = lib.licenses.isc;
    mainProgram = "wsxwm";
  };
})
