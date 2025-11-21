{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-treesitter-main";
  version = "2025-11-19";
  src = fetchFromGitHub {
    owner = "nvim-treesitter";
    repo = "nvim-treesitter";
    rev = "bb83a676128d95c865e40ba71376d883bdadec14";
    hash = "";
  };
  meta.homepage = "https://github.com/abeldekat/cmp-mini-snippets";
}
