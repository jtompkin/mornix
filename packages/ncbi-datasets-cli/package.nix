{
  lib,
  stdenv,
  fetchzip,

  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ncbi-datasets-cli";
  version = "18.20.0";
  systemString =
    {
      x86_64-linux = "linux-amd64";
      x86_64-darwin = "darwin-amd64";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
    }
    .${stdenv.hostPlatform.system};

  src = fetchzip {
    url = "https://github.com/ncbi/datasets/releases/download/v${finalAttrs.version}/${finalAttrs.systemString}.cli.package.zip";
    hash = "sha256-QNoUoyHqOmNHIdvSJSu3op0TX9pSSFqTPQm11BwSNK0=";
    stripRoot = false;
  };

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/bin datasets dataformat 

    runHook postInstall
  '';

  meta = {
    description = "Easily gather data from across NCBI databases";
    homepage = "https://github.com/ncbi/datasets";
    license = lib.licenses.publicDomain;
    mainProgram = "datasets";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
