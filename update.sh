#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update -p fd -p ripgrep
update_to_head=$(fd -t f package.nix packages -X rg -l _commit)
n=$(echo $update_to_head | wc -w)
i=1
for pkg_path in $update_to_head; do
    pkg="$(echo $pkg_path | cut -d'/' -f2)"
    read -N 1 -p "[$i/$n] Updating $pkg... Commit changes? (Y/n) " choice
    echo
    commit_arg="--commit"
    if [[ "$choice" == n ]]; then
        commit_arg="--write-commit-message .update-msgs/"$pkg""
    fi
    nix-update --flake --build --version=branch $@ $commit_arg "$pkg"
    i=$(( i + 1 ))
done
echo "Done updating packages to HEAD"
