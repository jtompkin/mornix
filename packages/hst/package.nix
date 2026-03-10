{
  lib,
  stdenv,
  fetchFromSourcehut,
  writeText,

  pkg-config,
  wayland-scanner,
  ncurses,

  libdrm,
  wayland-protocols,
  freetype,
  fontconfig,
  wayland,
  libxkbcommon,
  neuwld,
  pixman,

  # Customization
  config,
  conf ? config.hst.conf or null,
  patches ? config.hst.patches or [ ],
  extraLibs ? config.hst.extraLibs or [ ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hst";
  version = "2026-02-03";
  _commit = "6187ef823d1fabe2139aed54dbb7a7e28c6d8ff4";

  src = fetchFromSourcehut {
    owner = "~dlm";
    repo = "hst";
    rev = finalAttrs._commit;
    hash = "sha256-9BOPmt7Yjz0YfOfK6tOhqKg0l+so3xsXoeSG+5qUF0g=";
  };

  outputs = [
    "out"
    "terminfo"
  ];

  inherit patches;

  configFile = lib.optionalString (conf != null) (writeText "config.def.h" conf);
  postPatch = lib.optionalString (conf != null) ''
    cp ${finalAttrs.configFile} config.def.h
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    ncurses
  ];
  buildInputs = [
    libdrm
    wayland-protocols
    freetype
    fontconfig
    wayland
    libxkbcommon
    neuwld
    pixman
  ]
  ++ extraLibs;

  strictDeps = true;

  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Fork of st-wl using neuwld";
    homepage = "https://git.sr.ht/~dlm/hst";
    license = lib.licenses.mit;
    mainProgram = "st-wl";
  };
})
