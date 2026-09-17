{
  lib,
  stdenv,
  fetchFromGitHub,

  zig_0_15,
}:
let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wren-lsp";
  version = "0.3.0-unstable-2026-06-11";
  _commit = "3ac4228e2565a0974082cb57d3b15568e743fe91";

  src = fetchFromGitHub {
    owner = "jossephus";
    repo = "wren-lsp";
    rev = finalAttrs._commit;
    hash = "sha256-A/3ffTjvLE9U9O7w87N0k0wsWL6ELDcwjRtPDvBnnDs=";
  };

  nativeBuildInputs = [
    zig
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-tMfArbqVNjHRRrJdBrln/9tCT40ZZPNJg27fIO9VUHw=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  meta = {
    description = "Lsp implementation for wren";
    homepage = "https://github.com/jossephus/wren-lsp";
    license = lib.licenses.mit;
  };
})
