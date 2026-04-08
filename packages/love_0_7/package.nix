{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
  versionCheckHook,

  SDL,
  devil,
  freetype,
  libGLU,
  libmng,
  libmodplug,
  libtiff,
  libvorbis,
  libx11,
  lua5_1,
  mpg123,
  openal,
  physfs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "love_0_7";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    rev = finalAttrs.version;
    hash = "sha256-fK7DmDtVgvPlotGnbYKhGFTfgp7C4xkhiG8WoJw17qU=";
  };

  patches = [ ./fix_gl.diff ];

  enableParallelBuilding = true;
  doInstallCheck = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    SDL
    devil
    freetype
    libGLU
    libmng
    libmodplug
    libtiff
    libvorbis
    libx11
    lua5_1
    mpg123
    openal
    physfs
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  strictDeps = true;

  postPatch = ''
    substituteInPlace platform/unix/gen-makefile \
      --replace-warn /usr/include/SDL ${lib.getInclude SDL}/include/SDL \
      --replace-warn /usr/include/AL ${lib.getInclude openal}/include/AL \
      --replace-warn /usr/include/freetype2 ${lib.getInclude freetype}/include/freetype2
  '';
  autoreconfPhase = ''
    patchShebangs --build platform/unix/automagic
    ./platform/unix/automagic
  '';
  preConfigure = ''
    configureFlagsArray+=(
      CFLAGS="-O2 -Wno-error=implicit-int"
    )
  '';

  meta = {
    description = "2D game framework for Lua";
    homepage = "https://love2d.org/";
    license = lib.licenses.free;
    mainProgram = "love";
  };
})
