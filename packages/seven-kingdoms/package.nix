{
  lib,
  stdenv,
  fetchgit,
  fetchzip,

  autoreconfHook,
  pkg-config,
  autoconf-archive,
  makeWrapper,

  openal,
  SDL2,
  enet,
  curl,

  withMultiplayer ? true,
  # Default music is unfree so not installed by default
  withMusic ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "seven-kingdoms";
  version = "2.15.7";

  src = fetchgit {
    url = "https://git.code.sf.net/p/skfans/7kaa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XnRBZjdioZIBbmhh/IK2NpqhB/yno08hkV05XBt+1b0=";
  };
  dataMusic =
    if withMusic then
      fetchzip {
        url = "https://www.7kfans.com/downloads/7kaa-music-${lib.versions.majorMinor finalAttrs.version}.tar.bz2";
        hash = "sha256-Bog7YMfVYzqmncwNIUFDUsVklz5P9Fs+tmt3MD1tD3o=";
        meta.license = lib.licenses.unfreeRedistributable;
      }
    else
      null;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    SDL2
    autoconf-archive
    autoreconfHook
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    SDL2
    enet
    openal
  ]
  ++ lib.optional withMultiplayer curl;
  strictDeps = true;

  preConfigure = ''
    configureFlagsArray+=(
      CXXFLAGS="-O2 -Wno-error=format-security"
      ${lib.optionalString (!withMultiplayer) "--disable-multiplayer --disable-curl"}
    )
  '';
  postInstall = ''
    ${lib.optionalString withMusic "ln -s -t $out/share/7kaa ${finalAttrs.dataMusic}/*"}
    wrapProgram $out/bin/7kaa \
      --set SKDATA $out/share/7kaa
  '';

  meta = {
    description = "Real-time game of epic strategy and empire building";
    homepage = "https://7kfans.com/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "7kaa";
  };
})
