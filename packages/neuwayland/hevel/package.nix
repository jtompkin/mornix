{
  lib,
  stdenv,
  fetchFromSourcehut,
  writeText,

  pkg-config,
  wayland-scanner,

  fontconfig,
  libdrm,
  libinput,
  libxcb-wm,
  libxkbcommon,
  neuswc,
  neuwld,
  pixman,
  wayland,

  # customization
  config,
  conf ? config.hevel.conf or null,
  patches ? config.hevel.patches or [ ],
  extraLibs ? config.hevel.extraLibs or [ ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hevel";
  version = "0-unstable-2026-03-15";
  _commit = "cce195a2176163f099ed95c9bf7020033bdbbac9";

  src = fetchFromSourcehut {
    owner = "~dlm";
    repo = "hevel";
    rev = finalAttrs._commit;
    hash = "sha256-9B180ebZzOtv9eEICVpYSo558T0/UYEVELFztPzOX4o=";
  };

  inherit patches;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
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
  ]
  ++ extraLibs;

  installFlags = [ "PREFIX=$(out)" ];

  configFile =
    if lib.isDerivation conf || builtins.isPath conf then
      conf
    else
      writeText "config.h" (toString conf);
  postPatch = lib.optionalString (conf != null) ''
    cp ${finalAttrs.configFile} config.h
  '';

  meta = {
    description = "Scrollable, floating window manager for Wayland";
    homepage = "https://git.sr.ht/~dlm/hevel";
    license = lib.licenses.mit;
    mainProgram = "hevel";
  };
})
