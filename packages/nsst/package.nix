{
  lib,
  stdenv,
  fetchFromGitHub,

  ncurses,
  pkg-config,
  wayland-scanner,

  fontconfig,
  freetype,
  libxcb,
  libxcb-cursor,
  libxcb-util,
  libxkbcommon,
  wayland,
  wayland-protocols,

  # Backend support
  withWayland ? true,
  withX11 ? true,
}:
assert (withWayland || withX11);
stdenv.mkDerivation (finalAttrs: {
  pname = "nsst";
  version = "2.5.4-unstable-2026-05-22";
  commit = "948d2d409710a2e8d94ff9c911c0a8e06e2ee087";

  src = fetchFromGitHub {
    owner = "summaryInfo";
    repo = "nsst";
    rev = finalAttrs.commit;
    hash = "sha256-4+u/vxEmOMkTYnGl75fhzsf+NNriTOvZDRxOHi/e2ag=";
  };
  patches = [ ./fix_sharedir.patch ];

  outputs = [
    "out"
    "terminfo"
  ];
  setOutputFlags = false;

  nativeBuildInputs = [
    ncurses
    pkg-config
  ]
  ++ lib.optional withWayland wayland-scanner;
  buildInputs = [
    freetype
    fontconfig
    libxkbcommon
  ]
  ++ lib.optionals withX11 [
    libxcb
    libxcb-cursor
    libxcb-util
  ]
  ++ lib.optionals withWayland [
    wayland
    wayland-protocols
    wayland-scanner
  ];
  strictDeps = true;

  makeFlags = [ "PKGCONFIG=${stdenv.cc.targetPrefix}pkg-config" ];

  configureFlags =
    [ ]
    ++ (if withWayland then [ "--enable-wayland-shm" ] else [ "--disable-wayland" ])
    ++ lib.optional (!withX11) "--disable-x11";

  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Not so simple terminal for X11/Wayland";
    homepage = "https://github.com/summaryInfo/nsst";
    license = lib.licenses.bsd2;
  };
})
