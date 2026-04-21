{
  lib,
  stdenv,
  fetchFromGitHub,

  ant,
  jdk,
  stripJavaArchivesHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jloda";
  version = "unstable";
  _commit = "27ec9d8cccf7ecfa64a64a30ad2c6a6243406a2f";

  src = fetchFromGitHub {
    owner = "husonlab";
    repo = "jloda";
    rev = finalAttrs._commit;
    hash = "sha256-dO5d3akJmw5oxFuffwWncFdnJ7Ver6yLTCaLVvHMBkE=";
  };

  jdkWithJavaFX = jdk.override { enableJavaFX = true; };

  nativeBuildInputs = [
    ant
    stripJavaArchivesHook

    finalAttrs.jdkWithJavaFX
  ];
  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    substituteInPlace antbuild/build.xml \
      --replace-fail '../../jloda/' '../' \
      --replace-fail '<fileset dir="''${jfxDir}"  includes="*.jar"/>' ""

    cd antbuild && ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 644 jloda.jar $out/share/java/jloda.jar
    install -D -m 644 ../jars/VectorGraphics2D-0.13.jar $out/share/java/VectorGraphics2D-0.13.jar
    cp -R modules $out/share/java

    runHook postInstall
  '';

  meta = {
    description = "Java library of data structures and algorithms";
    homepage = "https://github.com/husonlab/jloda";
    license = lib.licenses.gpl3Only;
  };
})
