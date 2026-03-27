#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
help() {
    cat <<EOF
Usage: $0 [OPTIONS]...

Options:
    --commit        Always commit updates, do not prompt
    --no-commit     Never commit updates, write mesasges to file, do not prompt
    --stable        Target only stable packages for update,
                        default is to target unstable
    --no-build      Do not build packages after updating
    --extra-args    Stop parsing arguments, pass all further arguemnts to nix-update
    --help          Show this help message and exit
EOF
    exit
}
SHOW_PROMPT=1
TARGET=unstable
version_args=("--version=branch")
build_args=("--build")
while [[ $# -gt 0 ]]; do
    case "$1" in
    --commit)
        choice=y
        SHOW_PROMPT=0
        shift
        ;;
    --no-commit)
        choice=n
        SHOW_PROMPT=0
        shift
        ;;
    --stable)
        TARGET=stable
        version_args=("--version=stable")
        shift
        ;;
    --no-build)
        build_args=()
        shift
        ;;
    --extra-args)
        shift
        break
        ;;
    -h | --help)
        help
        ;;
    *)
        echo "Bad argument: $1"
        echo "Use --extra-args to pass args to nix-update"
        exit 1
        ;;
    esac
done
if [[ "${TARGET}" == unstable ]]; then
    mapfile -d '' to_update < <(find packages -type f -name package.nix -print0 | xargs -0 grep -Zl '[^_]version = ".*unstable.*"' || true)
else
    mapfile -d '' to_update < <(find packages -type f -name package.nix -print0 | xargs -0 grep -EZl '[^_]version = "[0-9]+\.[0-9]+\.[0-9]+"' || true)
fi
n=${#to_update[@]}
for ((i = 0; i < n; i++)); do
    pkg_path="${to_update[i]}"
    pkg="$(echo "${pkg_path}" | awk -F'/' '{print $(NF-1)}')"
    if [[ "${SHOW_PROMPT}" -eq 0 ]]; then
        echo "[$((i + 1))/${n}] Updating ${pkg}..."
    else
        read -r -N 1 -p "[$((i + 1))/${n}] Updating ${pkg}... Commit changes? (Y/n/[s]kip) " choice
        echo
    fi
    if [[ "${choice}" == s ]]; then
        continue
    fi
    commit_args=(--commit)
    if [[ "${choice}" == n ]]; then
        commit_args=(--write-commit-message ".update-msgs/${pkg}")
    fi
    (
        set -x
        nix-update --flake "${build_args[@]}" "${version_args[@]}" "${commit_args[@]}" "$@" "${pkg}"
    )
done
# vim: filetype=bash
