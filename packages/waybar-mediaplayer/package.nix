{
  python3Packages,
  wrapGAppsHook3,
  gobject-introspection,
  fetchurl,

  playerctl,
}:
python3Packages.buildPythonApplication rec {
  pname = "waybar-mediaplayer";
  version = "1";
  pyproject = false;

  installPhase = ''
    install -Dm755 "${
      fetchurl {
        url = "https://raw.githubusercontent.com/Alexays/Waybar/41de8964f1e3278edf07902ad68ca5e01e7abeeb/resources/custom_modules/mediaplayer.py";
        hash = "sha256-BvQSMoJIFRW7NlBl35yC2ZuqdxiUghFTtbuNFDuGhso=";
      }
    }" "$out/bin/${pname}"
  '';
  dontUnpack = true;
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  pythonPath = with python3Packages; [
    pygobject3
  ];

  buildInputs = [ playerctl ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  meta = {
    mainProgram = pname;
  };
}
