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

  withXWayland ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neuswc";
  version = "0-unstable-2026-09-04";
  _commit = "35d8564f9c4105df3e6f8f16ee323a55b3e027e6";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuswc";
    rev = finalAttrs._commit;
    hash = "sha256-ZMaqyXMsYnYjZkJr475RR6w2wlaJuK+QV94SRbaL2vc=";
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
    libinput
    libxcb-wm
    libxkbcommon
    neuwld
    pixman
    wayland
    wayland-protocols
  ]
  ++ lib.optional withXWayland xwayland;

  mesonFlags = [
    "-Dxwayland=${if withXWayland then "enabled" else "disabled"}"
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
