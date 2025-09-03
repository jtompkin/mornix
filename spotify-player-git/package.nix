{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cmake,
  installShellFiles,
  writableTmpDirAsHomeHook,

  # deps for audio backends
  alsa-lib,
  libpulseaudio,
  portaudio,
  libjack2,
  SDL2,
  gst_all_1,
  dbus,
  fontconfig,
  libsixel,

  # build options
  withStreaming ? true,
  withDaemon ? true,
  withAudioBackend ? "rodio", # alsa, pulseaudio, rodio, portaudio, jackaudio, rodiojack, sdl
  withMediaControl ? true,
  withImage ? true,
  withNotify ? true,
  withSixel ? true,
  withFuzzy ? true,
  stdenv,
  makeBinaryWrapper,

  # passthru
  nix-update-script,
}:

assert lib.assertOneOf "withAudioBackend" withAudioBackend [
  ""
  "alsa"
  "pulseaudio"
  "rodio"
  "portaudio"
  "jackaudio"
  "rodiojack"
  "sdl"
  "gstreamer"
];

rustPlatform.buildRustPackage rec {
  pname = "spotify-player-git";
  version = "77af13b48b2a03e61fef1cffea899929057551dc";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = "spotify-player";
    rev = version;
    hash = "sha256-hU1VVM4PfjUx6ckjwpdcrIIiInfB/B4+Dhb4dc9juaE=";
  };

  cargoHash = "sha256-YarKRApcQHom3AQIirqGdmUOuy5B+BRehLijvF/GRPc=";

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
    installShellFiles
    # Tries to access $HOME when installing shell files, and on Darwin
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = [
    openssl
    dbus
    fontconfig
  ]
  ++ lib.optionals withSixel [ libsixel ]
  ++ lib.optionals (withAudioBackend == "alsa") [ alsa-lib ]
  ++ lib.optionals (withAudioBackend == "pulseaudio") [ libpulseaudio ]
  ++ lib.optionals (withAudioBackend == "rodio" && stdenv.hostPlatform.isLinux) [ alsa-lib ]
  ++ lib.optionals (withAudioBackend == "portaudio") [ portaudio ]
  ++ lib.optionals (withAudioBackend == "jackaudio") [ libjack2 ]
  ++ lib.optionals (withAudioBackend == "rodiojack") [
    alsa-lib
    libjack2
  ]
  ++ lib.optionals (withAudioBackend == "sdl") [ SDL2 ]
  ++ lib.optionals (withAudioBackend == "gstreamer") [
    gst_all_1.gstreamer
    gst_all_1.gst-devtools
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  buildNoDefaultFeatures = true;

  buildFeatures =
    [ ]
    ++ lib.optionals (withAudioBackend != "") [ "${withAudioBackend}-backend" ]
    ++ lib.optionals withMediaControl [ "media-control" ]
    ++ lib.optionals withImage [ "image" ]
    ++ lib.optionals withDaemon [ "daemon" ]
    ++ lib.optionals withNotify [ "notify" ]
    ++ lib.optionals withStreaming [ "streaming" ]
    ++ lib.optionals withSixel [ "sixel" ]
    ++ lib.optionals withFuzzy [ "fzf" ];

  postInstall =
    let
      inherit (lib.strings) optionalString;
    in
    # sixel-sys is dynamically linked to libsixel
    optionalString (stdenv.hostPlatform.isDarwin && withSixel) ''
      wrapProgram $out/bin/spotify_player \
        --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsixel ]}"
    ''
    + optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd spotify_player \
        --bash <($out/bin/spotify_player generate bash) \
        --fish <($out/bin/spotify_player generate fish) \
         --zsh <($out/bin/spotify_player generate zsh)
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal spotify player that has feature parity with the official client";
    homepage = "https://github.com/aome510/spotify-player";
    mainProgram = "spotify_player";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dit7ya
      xyven1
      _71zenith
      caperren
    ];
  };
}
