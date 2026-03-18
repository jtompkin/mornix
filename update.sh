#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
mapfile -d '' update_to_head < <(find packages -type f -name package.nix -print0 | xargs -0 grep -Zl _commit || true)
n=${#update_to_head[@]}
for ((i = 0; i < n; i++)); do
    pkg_path="${update_to_head[i]}"
    pkg="$(echo "${pkg_path}" | awk -F'/' '{print $(NF-1)}')"
    read -r -N 1 -p "[$((i + 1))/${n}] Updating ${pkg}... Commit changes? (Y/n/[s]kip) " choice
    echo
    if [[ "${choice}" == s ]]; then
        continue
    fi
    commit_args=(--commit)
    if [[ "${choice}" == n ]]; then
        commit_args=(--write-commit-message ".update-msgs/${pkg}")
    fi
    nix-update --flake --build --version=branch "$@" "${commit_args[@]}" "${pkg}"
done
# vim: filetype=bash
