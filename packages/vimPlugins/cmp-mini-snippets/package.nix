{
  fetchFromGitHub,
  vimPlugins,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "cmp-mini-snippets";
  version = "2025-01-26";
  src = fetchFromGitHub {
    owner = "abeldekat";
    repo = "cmp-mini-snippets";
    rev = "582aea215ce2e65b880e0d23585c20863fbb7604";
    hash = "sha256-gSvhxrjz6PZBgqbb4eBAwWEWSdefM4qL3nb75qGPaFA=";
  };
  nativeBuildInputs = [
    vimPlugins.nvim-cmp
  ];
  meta.homepage = "https://github.com/abeldekat/cmp-mini-snippets";
}
