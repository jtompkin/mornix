{
  lib,
  stdenv,
  fetchFromSourcehut,

  pkg-config,
  versionCheckHook,

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
  pname = "mojito";
  version = "0-unstable-2026-03-07";
  _commit = "0b4307cb252b55e7f423c10882e6f5eba855d083";

  src = fetchFromSourcehut {
    owner = "~dlm";
    repo = "mojito";
    rev = finalAttrs._commit;
    hash = "sha256-FQGjB4u1XIsbErcO2RlR6IU10wi6tlRecjS56gERWjs=";
  };

  doInstallCheck = true;
  versionCheckProgramArg = "-h";
  preVersionCheck = ''
    version=mojito
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeBuildInputs = [
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

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Featherweight, lime-scented (and somewhat alcoholic) bar for Wayland";
    homepage = "https://git.sr.ht/~dlm/mojito";
    license = lib.licenses.isc;
  };
})
