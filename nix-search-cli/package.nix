/*
  Parts of build recipe stolen fron: https://github.com/peterldowns/nix-search-cli/blob/main/flake.nix
  See LICENSE file in this directory
  This is copied here so as to not require their flake as another input,
  but still provide the package for a Home Manager module.
*/
{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "nix-search";
  version = "2025-11-03";
  src = fetchFromGitHub {
    owner = "peterldowns";
    repo = "nix-search-cli";
    rev = "ab0d5156c1e3b383c250ff273639cd3dea6de2d9";
    hash = "sha256-NGL9jj4y16+d0Es7aK1oxqAimZn7sdJDAxVkcY3CTcg=";
  };
  vendorHash = "sha256-VlJ2OuHOTqIJeGUm2NbBiz33i8QTxaZnnm0JkVGkw1U=";
  GOWORK = "off";
  modRoot = ".";
  subPackages = [ "cmd/nix-search" ];
  ldflags = [
    "-X main.Version=${lib.fileContents "${finalAttrs.src}/VERSION"}"
    "-X main.Commit=${builtins.substring 0 7 finalAttrs.src.rev}"
  ];
  doCheck = false;
})
