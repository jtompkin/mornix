#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update -p fd -p ripgrep
pkgs_list="$(fd -t f -e nix package packages -X rg -l _commit)"
mapfile update_to_head <<<"${pkgs_list}"
n=${#update_to_head[@]}
for ((i=0; i<n; i++)); do
    pkg_path="${update_to_head[i]}"
    pkg="$(echo "${pkg_path}" | cut -d'/' -f2)"
    read -r -N 1 -p "[$((i + 1))/${n}] Updating ${pkg}... Commit changes? (Y/n) " choice
    echo
    commit_args=(--commit)
    if [[ "${choice}" == n ]]; then
        commit_args=(--write-commit-message ".update-msgs/${pkg}")
    fi
    nix-update --flake --build --version=branch "$@" "${commit_args[@]}" "${pkg}"
done
