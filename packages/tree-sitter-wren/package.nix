{
  fetchFromGitHub,

  tree-sitter,
}:
tree-sitter.buildGrammar {
  language = "wren";
  version = "0-unstable-2026-02-28";
  src = fetchFromGitHub {
    owner = "jossephus";
    repo = "tree-sitter-wren";
    rev = "d408dd2fe143212608979ec9b0f5fbd2bc8dd2b3";
    hash = "sha256-ZFyrvrs44aqqjUJ9tCJ8P1XnbJXm4VSNQpWZJp2j3fM=";
  };
  generate = true;
}
