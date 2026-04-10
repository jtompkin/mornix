{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  gettext,

  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,

  boost183,
  libGLU,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "violetland";
  version = "0.5-unstable-2022-11-05";
  _commit = "a03bd44ae591475fc7da5a31cf7383c38d1a9b18";

  src = fetchFromGitHub {
    owner = "ooxi";
    repo = "violetland";
    rev = finalAttrs._commit;
    fetchSubmodules = true;
    hash = "sha256-YmKxzXCKfjzcsGjcVfxNhac3ZCljt5pRRhCrENQzxkk=";
  };

  nativeBuildInputs = [
    cmake
    gettext
  ];
  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    SDL_ttf
    boost183
    libGLU
  ];
  strictDeps = true;

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn '-std=c++98' '-std=c++11'
  '';

  meta = {
    description = "Shoot monsters";
    homepage = "https://violetland.github.io/";
    license = lib.licenses.gpl3Plus;
  };
})
