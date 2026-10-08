{
  stdenv,
  fetchFromSourcehut,

  bmake,
  pkg-config,

  expat,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "freeway";
  version = "0-unstable-2026-02-09";
  _commit = "562b1710346337be0ef12f56a7306f907811577d";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "freeway";
    rev = finalAttrs._commit;
    hash = "sha256-dtD6n4a9i9Chc2NSX3E+HLw/sWfHgnJ9H0Z8DqRwIzY=";
  };

  nativeBuildInputs = [
    bmake
    pkg-config
  ];
  buildInputs = [
    expat
  ];

  makeFlags = [
    "PREFIX=$(out)"
    # install makes dangling symlinks without these
    "SERVER_SOVERSION=0"
    "CLIENT_SOVERSION=0"
    "SERVER_LIB=libwayland-server.so.$(SERVER_SOVERSION)"
    "CLIENT_LIB=libwayland-client.so.$(CLIENT_SOVERSION)"
  ];

  meta = {
    description = "Simpler libwayland";
    homepage = "https://git.sr.ht/~shrub900/freeway";
  };
})
