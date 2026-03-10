{
  lib,
  stdenv,
  fetchFromSourcehut,
  writeText,

  pkg-config,
  makeWrapper,

  fontconfig,
  freetype,
  libdrm,
  libxkbcommon,
  neuwld,
  openssl,
  pixman,
  plan9port,
  wayland,
  nerd-fonts,

  # Customization
  config,
  conf ? config.hack.conf or null,
  patches ? config.hack.patches or [ ],
  extraLibs ? config.hack.extraLibs or [ ],
  replaceFont ? conf == null,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hack";
  version = "2026-02-01";
  _commit = "346ada49eaa2fb47d81822c567fc5f0876163f80";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "hack";
    rev = finalAttrs._commit;
    hash = "sha256-+sTAfX5UeWoLbvjcDIcg4PGMdv6lWPgWyoKPZhMYq24=";
  };

  inherit patches;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    fontconfig
    freetype
    libdrm
    libxkbcommon
    neuwld
    openssl
    pixman
    plan9port
    wayland
  ]
  ++ extraLibs;

  configFile =
    if lib.isDerivation conf || builtins.isPath conf then
      conf
    else
      writeText "config.h" (toString conf);

  postPatch = ''
    ${lib.optionalString (conf != null) "cp ${finalAttrs.configFile} config.h"}
    ${lib.optionalString replaceFont ''
      substituteInPlace config.h \
        --replace-quiet \
          /usr/share/fonts/TTF/GoMonoNerdFont-Regular.ttf \
          ${nerd-fonts.go-mono}/share/fonts/truetype/NerdFonts/GoMono/GoMonoNerdFont-Regular.ttf
    ''}
    substituteInPlace Makefile \
      --replace-fail /usr/bin/hack '$(PREFIX)/bin/hack'
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "PLAN9=${plan9port}/plan9"
    "CC=cc"
  ];

  postInstall = ''
    wrapProgram $out/bin/hack \
      --prefix PATH : ${plan9port}/plan9/bin
  '';

  meta = {
    description = "Acme text editor for Wayland";
    homepage = "https://git.sr.ht/~shrub900/hack";
    license = lib.licenses.isc;
    mainProgram = "hack";
  };
})
