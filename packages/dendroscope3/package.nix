{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  ant,
  jre,
  jdk,
  stripJavaArchivesHook,

  jloda,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dendroscope3";
  version = "unstable";
  _commit = "c2d35555003a9261120a1d3223fd00e3e180f46b";

  src = fetchFromGitHub {
    owner = "husonlab";
    repo = "dendroscope3";
    rev = finalAttrs._commit;
    hash = "sha256-VsCtuf6U8dfX/IOgSTQ5SYT1uj6AhHgE7kXHCOeBMtw=";
  };

  patches = [ ./remove_install_check.patch ];

  jdkWithJavaFX = jdk.override { enableJavaFX = true; };
  jreWithJavaFX = jre.override { enableJavaFX = true; };

  nativeBuildInputs = [
    ant
    makeWrapper
    stripJavaArchivesHook
    finalAttrs.jdkWithJavaFX
  ];
  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    substituteInPlace antbuild/build.xml \
      --replace-fail '../../dendroscope3/' '../' \
      --replace-fail '../../jloda/jars' '${jloda}/share/java' \
      --replace-fail '<fileset dir="''${jfxDir}"  includes="*.jar"/>' "" \
      --replace-fail '<ant antfile="''${jlodaAntDir}/build.xml" target="jar"/>' ""

    cd antbuild && ant -DjlodaAntDir='${jloda}/share/java/'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 644 dendroscope3.jar $out/share/java/dendroscope3.jar
    cp -R modules $out/share/java
    mkdir -p $out/bin
    makeWrapper ${finalAttrs.jreWithJavaFX}/bin/java $out/bin/dendroscope3 \
      --add-flag "-Xshare:off" \
      --add-flag "-server" \
      --add-flag "-Xmx1G" \
      --add-flag "-Duser.language=en" \
      --add-flag "-Duser.region=US" \
      --add-flag "--module-path=${jloda}/share/java" \
      --add-flag "--add-modules=jloda" \
      --add-flags "-cp $out/share/java/dendroscope3.jar" \
      --add-flag "dendroscope.main.Dendroscope"

    runHook postInstall
  '';

  meta = {
    description = "Program for analyzing and visualizing rooted phylogenetic trees and networks";
    homepage = "https://github.com/husonlab/dendroscope3";
    license = lib.licenses.gpl3Plus;
  };
})
