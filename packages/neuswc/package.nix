{
  lib,
  stdenv,
  fetchFromSourcehut,

  meson,
  ninja,
  pkg-config,
  wayland-scanner,

  fontconfig,
  libdrm,
  libinput,
  libxcb-wm,
  libxkbcommon,
  neuwld,
  pixman,
  wayland,
  wayland-protocols,
  xwayland,

  # Choices: libinput, evdev
  inputBackend ? "libinput",
  withXWayland ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neuswc";
  version = "0-unstable-2026-03-19";
  _commit = "8a2d575859ae683ed7dc695b31c3c1dfa104242a";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuswc";
    rev = finalAttrs._commit;
    hash = "sha256-MJNoodnZGys+jTHP6QMLC1xViyfskZN2473uXyd2pYQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    fontconfig
    libdrm
    libxcb-wm
    libxkbcommon
    neuwld
    pixman
    wayland
    wayland-protocols
  ]
  ++ lib.optional withXWayland xwayland
  ++ lib.optional (inputBackend == "libinput") libinput;

  mesonFlags = [
    "-Dxwayland=${if withXWayland then "enabled" else "disabled"}"
    "-Dinput=${inputBackend}"
  ];

  # TODO: remove once build system does this (maybe it already can I don't fucking know meson)
  postInstall = ''
    cp protocol/*.h $out/include 
    mkdir -p $out/share/swc
    cp ../protocol/*.xml $out/share/swc
  '';

  meta = {
    description = "Fork of swc with more features";
    homepage = "https://git.sr.ht/~shrub900/neuswc";
    license = lib.licenses.mit;
    mainProgram = "swc-launch";
  };
})
