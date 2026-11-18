{
  lib,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "";
  version = "";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.gitTracked ../.;
  };

  vendorHash = lib.fakeHash;

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.LICENSE;
  };
})
