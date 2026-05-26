{
  lib,
  stdenv,
  fetchFromGitHub,

  vlang,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "v-analyzer";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v-analyzer";
    rev = "d5f13c0736f0df3e337cee7c69f68c640587d84d";
    hash = "sha256-dxbHWrmoBJdErllcDMGGwoER2h+CbwA2irwF0RTeoAg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ vlang ];
  buildInputs = [ vlang ];

  preBuild = ''
    substituteInPlace build.vsh \
      --replace-fail "const is_nixos = os.exists('/etc/NIXOS')" 'const is_nixos = true'
  '';
  buildPhase = ''
    runHook preBuild

    export HOME=$TMP
    v build.vsh release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 bin/v-analyzer $out/bin/v-analyzer

    runHook postInstall
  '';

  meta = {
    description = "The vlang language server";
    homepage = "https://github.com/vlang/v-analyzer";
    license = lib.licenses.mit;
  };
})
