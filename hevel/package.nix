{
  lib,
  stdenv,
  fetchgit,
  writeText,

  bmake,
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
  version = "2026-03-07";
  _commit = "822c3bd12d603305cfe6b3ff95fa1ac85194d42b";

  src = fetchgit {
    url = "https://git.sr.ht/~dlm/hevel";
    rev = finalAttrs._commit;
    hash = "sha256-1N/xlRIPT/94OKEpxkAeAu7aLPPSLConJJcGchGHr/g=";
  };

  inherit patches;

  nativeBuildInputs = [
    bmake
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
    description = "A scrollable, floating window manager for Wayland";
    homepage = "https://git.sr.ht/~dlm/hevel";
    license = lib.licenses.mit;
    mainProgram = "hevel";
  };
})
